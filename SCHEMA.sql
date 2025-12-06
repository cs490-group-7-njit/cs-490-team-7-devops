-- drop and create the database
DROP DATABASE IF EXISTS salonhub;
CREATE DATABASE salonhub DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE salonhub;

-- Users, Stores basic user info and role, nothing sensitive here, timestamps included
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  role ENUM('client','vendor','admin','barber') NOT NULL DEFAULT 'client',
  phone VARCHAR(30),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Auth_accounts, Login data for each user, password hash and last login, kept separate from users
-- NOTE: password_hash uses werkzeug.security format (pbkdf2 or scrypt)
-- pbkdf2 hashes are ~103 chars, scrypt hashes are ~162 chars. Using VARCHAR(500) to be safe.
CREATE TABLE auth_accounts (
  user_id INT PRIMARY KEY,
  password_hash VARCHAR(500) NOT NULL,
  last_login_at DATETIME NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_auth_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Salons, Vendor owned salons, address and contact, publish flag, timestamps
-- Added verification_status to support admin verification UC 3.4
CREATE TABLE salons (
  salon_id INT AUTO_INCREMENT PRIMARY KEY,
  vendor_id INT NOT NULL,
  name VARCHAR(150) NOT NULL,
  description TEXT,
  business_type VARCHAR(100),
  address_line1 VARCHAR(150),
  address_line2 VARCHAR(150),
  city VARCHAR(100),
  state VARCHAR(100),
  postal_code VARCHAR(20),
  phone VARCHAR(30),
  is_published TINYINT(1) NOT NULL DEFAULT 0,
  verification_status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  delay_notifications_data JSON DEFAULT NULL,
  social_media_data JSON DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_salons_vendor
    FOREIGN KEY (vendor_id) REFERENCES users(user_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Staff, Links users (barbers) to a salon, supports multi-staff salons for UC 1.6
CREATE TABLE staff (
  staff_id INT AUTO_INCREMENT PRIMARY KEY,
  salon_id INT NOT NULL,
  user_id INT NOT NULL,
  title VARCHAR(100), -- e.g., 'Senior Stylist'
  schedule JSON DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_staff_salon
    FOREIGN KEY (salon_id) REFERENCES salons(salon_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_staff_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Schedules, Defines the general weekly availability for a staff member for UC 1.6
CREATE TABLE schedules (
  schedule_id INT AUTO_INCREMENT PRIMARY KEY,
  staff_id INT NOT NULL,
  day_of_week TINYINT NOT NULL, -- 0=Sunday, 1=Monday, etc.
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_schedules_staff
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Time_blocks, Blocks off specific time slots for a staff member, e.g., for breaks or holidays for UC 1.14
CREATE TABLE time_blocks (
  block_id INT AUTO_INCREMENT PRIMARY KEY,
  staff_id INT NOT NULL,
  starts_at DATETIME NOT NULL,
  ends_at DATETIME NOT NULL,
  reason VARCHAR(255),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_blocks_staff
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Services, Services offered by a salon, price and duration, one row per service
CREATE TABLE services (
  service_id INT AUTO_INCREMENT PRIMARY KEY,
  salon_id INT NOT NULL,
  name VARCHAR(150) NOT NULL,
  description TEXT,
  price_cents INT NOT NULL,
  duration_minutes INT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_services_salon
    FOREIGN KEY (salon_id) REFERENCES salons(salon_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Products, For the online shop, includes inventory tracking for UC 1.20
CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  salon_id INT NOT NULL,
  name VARCHAR(150) NOT NULL,
  description TEXT,
  price_cents INT NOT NULL,
  stock_quantity INT NOT NULL DEFAULT 0,
  category VARCHAR(100),
  is_available TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_products_salon
    FOREIGN KEY (salon_id) REFERENCES salons(salon_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Appointments, Bookings linking a staff member, service and client for UC 2.3
-- Added staff_id to link appointment to a specific barber
CREATE TABLE appointments (
  appointment_id INT AUTO_INCREMENT PRIMARY KEY,
  salon_id INT NOT NULL,
  staff_id INT NOT NULL,
  service_id INT NOT NULL,
  client_id INT NOT NULL,
  starts_at DATETIME NOT NULL,
  ends_at DATETIME NOT NULL,
  status ENUM('booked','completed','cancelled','no-show') NOT NULL DEFAULT 'booked',
  notes TEXT, -- For appointment memos UC 1.12
  image_data JSON,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_appt_salon
    FOREIGN KEY (salon_id) REFERENCES salons(salon_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_appt_staff
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_appt_service
    FOREIGN KEY (service_id) REFERENCES services(service_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_appt_client
    FOREIGN KEY (client_id) REFERENCES users(user_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Reviews, Client reviews for salons, rating one to five and optional text
CREATE TABLE reviews (
  review_id INT AUTO_INCREMENT PRIMARY KEY,
  salon_id INT NOT NULL,
  client_id INT NOT NULL,
  rating TINYINT NOT NULL,
  comment TEXT,
  vendor_reply TEXT NULL,
  vendor_reply_at DATETIME NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_reviews_salon
    FOREIGN KEY (salon_id) REFERENCES salons(salon_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_reviews_client
    FOREIGN KEY (client_id) REFERENCES users(user_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Review_replies, Allows vendors to reply to a client review for UC 1.11
CREATE TABLE review_replies (
  reply_id INT AUTO_INCREMENT PRIMARY KEY,
  review_id INT NOT NULL,
  user_id INT NOT NULL, -- The vendor/user who replied
  reply_text TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_replies_review
    FOREIGN KEY (review_id) REFERENCES reviews(review_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_replies_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Loyalty_programs, Defines the loyalty program rules for a salon for UC 1.8
CREATE TABLE loyalty_programs (
  program_id INT AUTO_INCREMENT PRIMARY KEY,
  salon_id INT NOT NULL UNIQUE,
  points_per_dollar INT NOT NULL DEFAULT 1,
  reward_description VARCHAR(255),
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_loyalty_salon
    FOREIGN KEY (salon_id) REFERENCES salons(salon_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Client_loyalty, Tracks the loyalty points for each client at a specific salon for UC 2.11
CREATE TABLE client_loyalty (
  client_loyalty_id INT AUTO_INCREMENT PRIMARY KEY,
  salon_id INT NOT NULL,
  client_id INT NOT NULL,
  points_balance INT NOT NULL DEFAULT 0,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_clientloyalty_salon
    FOREIGN KEY (salon_id) REFERENCES salons(salon_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_clientloyalty_client
    FOREIGN KEY (client_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Favorite_salons, Association table for user favorite salons (many-to-many) for UC 2.20
CREATE TABLE favorite_salons (
  user_id INT NOT NULL,
  salon_id INT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, salon_id),
  CONSTRAINT fk_favorite_salons_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_favorite_salons_salon
    FOREIGN KEY (salon_id) REFERENCES salons(salon_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Payment_methods, Stores fake credit card information for clients (UC 2.18)
CREATE TABLE payment_methods (
  payment_method_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  card_holder_name VARCHAR(255) NOT NULL,
  card_number_last_four VARCHAR(4) NOT NULL,
  card_brand VARCHAR(50) NOT NULL,
  expiry_month TINYINT NOT NULL,
  expiry_year INT NOT NULL,
  is_default BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_payment_methods_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Transactions, Records payment transactions for appointments (UC 2.19)
CREATE TABLE transactions (
  transaction_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  appointment_id INT NOT NULL,
  payment_method_id INT,
  amount_cents INT NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'completed',
  transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_transactions_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_transactions_appointment
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_transactions_payment_method
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(payment_method_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Audit_log, Generic table to track important events (INSERT, UPDATE, DELETE) across other tables
CREATE TABLE audit_log (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  action ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
  table_name VARCHAR(100) NOT NULL,
  record_id INT NOT NULL,
  details JSON, -- Store before/after values as a JSON object
  changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_audit_log_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Staff_ratings, Allows clients to rate individual staff members (UC 2.16)
CREATE TABLE staff_ratings (
  rating_id INT AUTO_INCREMENT PRIMARY KEY,
  staff_id INT NOT NULL,
  client_id INT NOT NULL,
  rating TINYINT NOT NULL,
  comment TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_staff_ratings_staff
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_staff_ratings_client
    FOREIGN KEY (client_id) REFERENCES users(user_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Notifications (UC 2.5)
CREATE TABLE notifications (
  notification_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  appointment_id INT,
  title VARCHAR(200) NOT NULL,
  message TEXT NOT NULL,
  notification_type ENUM('appointment_confirmed', 'appointment_cancelled', 'appointment_rescheduled', 'appointment_completed', 'appointment_delayed', 'message_received', 'discount_alert', 'loyalty_points_earned', 'loyalty_redeemed') NOT NULL,
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_notifications_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_notifications_appointment
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Messages (UC 2.7)
CREATE TABLE messages (
  message_id INT AUTO_INCREMENT PRIMARY KEY,
  sender_id INT NOT NULL,
  recipient_id INT NOT NULL,
  salon_id INT,
  subject VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_messages_sender
    FOREIGN KEY (sender_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_messages_recipient
    FOREIGN KEY (recipient_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_messages_salon
    FOREIGN KEY (salon_id) REFERENCES salons(salon_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Appointment Memos (UC 1.12)
CREATE TABLE appointment_memos (
  memo_id INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT NOT NULL,
  vendor_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_memos_appointment
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_memos_vendor
    FOREIGN KEY (vendor_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Loyalty Redemptions (UC 2.13)
CREATE TABLE loyalty_redemptions (
  redemption_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  points_redeemed INT NOT NULL,
  discount_code VARCHAR(50) NOT NULL UNIQUE,
  discount_value_cents INT NOT NULL,
  is_used BOOLEAN NOT NULL DEFAULT FALSE,
  redeemed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  used_at TIMESTAMP,
  expires_at TIMESTAMP NOT NULL,
  CONSTRAINT fk_redemptions_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Discount Alerts (UC 2.14)
CREATE TABLE discount_alerts (
  alert_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  salon_id INT,
  discount_percentage INT NOT NULL,
  discount_cents INT NOT NULL,
  description TEXT NOT NULL,
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  is_dismissed BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP NOT NULL,
  CONSTRAINT fk_alerts_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_alerts_salon
    FOREIGN KEY (salon_id) REFERENCES salons(salon_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Product Purchases (UC 2.15)
CREATE TABLE product_purchases (
  purchase_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  unit_price_cents INT NOT NULL,
  total_price_cents INT NOT NULL,
  order_status ENUM('pending', 'confirmed', 'shipped', 'delivered', 'cancelled') NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_purchases_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_purchases_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Service Images (UC 1.17)
CREATE TABLE service_images (
  image_id INT AUTO_INCREMENT PRIMARY KEY,
  service_id INT NOT NULL,
  image_type ENUM('before', 'after') NOT NULL,
  image_url VARCHAR(500) NOT NULL,
  title VARCHAR(200),
  description TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_images_service
    FOREIGN KEY (service_id) REFERENCES services(service_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Promotions (UC 1.18)
CREATE TABLE promotions (
  promotion_id INT AUTO_INCREMENT PRIMARY KEY,
  salon_id INT NOT NULL,
  vendor_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  discount_percent INT,
  discount_amount_cents INT,
  target_customers VARCHAR(50) DEFAULT 'all',
  start_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_promotions_salon
    FOREIGN KEY (salon_id) REFERENCES salons(salon_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_promotions_vendor
    FOREIGN KEY (vendor_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Delay Notifications (UC 1.19)
CREATE TABLE delay_notifications (
  notification_id INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT NOT NULL,
  staff_id INT NOT NULL,
  delay_minutes INT NOT NULL,
  reason VARCHAR(500),
  sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_delay_notifications_appointment
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_delay_notifications_staff
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Shop Products (UC 1.20)
CREATE TABLE shop_products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  salon_id INT NOT NULL,
  vendor_id INT NOT NULL,
  name VARCHAR(200) NOT NULL,
  description TEXT,
  price_cents INT NOT NULL,
  stock_quantity INT NOT NULL DEFAULT 0,
  image_url VARCHAR(500),
  category VARCHAR(100),
  is_available BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_shop_products_salon
    FOREIGN KEY (salon_id) REFERENCES salons(salon_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_shop_products_vendor
    FOREIGN KEY (vendor_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Social Media Links (UC 1.22)
CREATE TABLE social_media_links (
  link_id INT AUTO_INCREMENT PRIMARY KEY,
  staff_id INT NOT NULL,
  platform VARCHAR(50) NOT NULL,
  url VARCHAR(500) NOT NULL,
  handle VARCHAR(100),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_social_media_staff
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
-- Appointment Images - Before/After service transformation photos (UC 2.17, UC 1.8)
CREATE TABLE appointment_images (
  image_id INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT NOT NULL,
  image_type ENUM('before', 'after', 'other') NOT NULL,
  image_url VARCHAR(500) NOT NULL,
  s3_key VARCHAR(500),
  description LONGTEXT,
  uploaded_by_id INT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_appointment_images_appointment
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_appointment_images_uploader
    FOREIGN KEY (uploaded_by_id) REFERENCES users(user_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  INDEX idx_appointment (appointment_id),
  INDEX idx_type (image_type),
  INDEX idx_created (created_at)
) ENGINE=InnoDB;

-- Salon Images - Gallery photos and before/after transformations for salon display (UC 1.X)
CREATE TABLE salon_images (
  image_id INT AUTO_INCREMENT PRIMARY KEY,
  salon_id INT NOT NULL,
  image_type ENUM('before', 'after', 'gallery') NOT NULL DEFAULT 'gallery',
  image_url VARCHAR(500) NOT NULL,
  s3_key VARCHAR(500),
  description TEXT,
  uploaded_by_id INT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_salon_images_salon
    FOREIGN KEY (salon_id) REFERENCES salons(salon_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_salon_images_uploader
    FOREIGN KEY (uploaded_by_id) REFERENCES users(user_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  INDEX idx_salon (salon_id),
  INDEX idx_type (image_type),
  INDEX idx_created (created_at)
) ENGINE=InnoDB;
