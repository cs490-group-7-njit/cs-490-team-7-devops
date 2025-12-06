-- Create salon_images table if it doesn't exist
CREATE TABLE IF NOT EXISTS salon_images (
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
