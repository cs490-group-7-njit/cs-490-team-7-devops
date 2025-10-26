-- ========================
-- Mock Data for Beautiful Hair Database by DevOps team Group 7.
-- ========================

-- ========================
-- USERS
-- ========================
INSERT INTO `users` (`user_id`, `name`, `email`, `role`) VALUES
-- Admins
(1, 'Ada Admin', 'ada.admin@example.com', 'admin'),
(2, 'Barry Admin', 'barry.admin@example.com', 'admin'),
(3, 'Charlie Admin', 'charlie.admin@example.com', 'admin'),
(4, 'Diana Admin', 'diana.admin@example.com', 'admin'),
(5, 'Edward Admin', 'edward.admin@example.com', 'admin'),
-- Vendors
(6, 'Vicky Vendor', 'vicky.vendor@example.com', 'vendor'),
(7, 'Victor Vendor', 'victor.vendor@example.com', 'vendor'),
(8, 'Valerie Vendor', 'valerie.vendor@example.com', 'vendor'),
(9, 'Vincent Vendor', 'vincent.vendor@example.com', 'vendor'),
(10, 'Vanessa Vendor', 'vanessa.vendor@example.com', 'vendor'),
-- Clients
(11, 'Carl Client', 'carl.client@example.com', 'client'),
(12, 'Catherine Client', 'catherine.client@example.com', 'client'),
(13, 'Chris Client', 'chris.client@example.com', 'client'),
(14, 'Christina Client', 'christina.client@example.com', 'client'),
(15, 'Cody Client', 'cody.client@example.com', 'client'),
(16, 'Chelsea Client', 'chelsea.client@example.com', 'client'),
(17, 'Connor Client', 'connor.client@example.com', 'client'),
(18, 'Chloe Client', 'chloe.client@example.com', 'client'),
(19, 'Caleb Client', 'caleb.client@example.com', 'client'),
(20, 'Claire Client', 'claire.client@example.com', 'client');

-- ========================
-- AUTH_ACCOUNTS
-- ========================
INSERT INTO `auth_accounts` (`user_id`, `password_hash`) VALUES
(1, '5f4dcc3b5aa765d61d8327deb882cf99'),
(2, '5f4dcc3b5aa765d61d8327deb882cf99'),
(3, '5f4dcc3b5aa765d61d8327deb882cf99'),
(4, '5f4dcc3b5aa765d61d8327deb882cf99'),
(5, '5f4dcc3b5aa765d61d8327deb882cf99'),
(6, '5f4dcc3b5aa765d61d8327deb882cf99'),
(7, '5f4dcc3b5aa765d61d8327deb882cf99'),
(8, '5f4dcc3b5aa765d61d8327deb882cf99'),
(9, '5f4dcc3b5aa765d61d8327deb882cf99'),
(10, '5f4dcc3b5aa765d61d8327deb882cf99'),
(11, '5f4dcc3b5aa765d61d8327deb882cf99'),
(12, '5f4dcc3b5aa765d61d8327deb882cf99'),
(13, '5f4dcc3b5aa765d61d8327deb882cf99'),
(14, '5f4dcc3b5aa765d61d8327deb882cf99'),
(15, '5f4dcc3b5aa765d61d8327deb882cf99'),
(16, '5f4dcc3b5aa765d61d8327deb882cf99'),
(17, '5f4dcc3b5aa765d61d8327deb882cf99'),
(18, '5f4dcc3b5aa765d61d8327deb882cf99'),
(19, '5f4dcc3b5aa765d61d8327deb882cf99'),
(20, '5f4dcc3b5aa765d61d8327deb882cf99');

-- ========================
-- SALONS
-- ========================
INSERT INTO `salons` (`salon_id`, `vendor_id`, `name`, `address_line1`, `city`, `state`, `postal_code`, `phone`, `is_published`, `verification_status`) VALUES
(1, 6, 'The Cutting Edge', '123 Shear St', 'New York', 'NY', '10001', '212-555-0101', 1, 'approved'),
(2, 7, 'Curl Up & Dye', '456 Style Ave', 'Brooklyn', 'NY', '11201', '718-555-0102', 1, 'approved'),
(3, 8, 'Hairitage', '789 Brush Blvd', 'New York', 'NY', '10002', '212-555-0103', 1, 'pending'),
(4, 9, 'The Mane Event', '101 Comb Ct', 'Queens', 'NY', '11101', '718-555-0104', 0, 'approved'),
(5, 10, 'Shear Luck', '212 Dryer Dr', 'New York', 'NY', '10003', '212-555-0105', 1, 'rejected');

-- ========================
-- STAFF
-- ========================
INSERT INTO `staff` (`staff_id`, `salon_id`, `user_id`, `title`) VALUES
(1, 1, 6, 'Owner / Senior Stylist'),
(2, 2, 7, 'Owner / Colorist'),
(3, 3, 8, 'Owner / Barber'),
(4, 4, 9, 'Owner / Stylist'),
(5, 5, 10, 'Owner / Barber'),
(6, 1, 11, 'Junior Stylist'),
(7, 1, 12, 'Barber');

-- ========================
-- SCHEDULES
-- ========================
INSERT INTO `schedules` (`staff_id`, `day_of_week`, `start_time`, `end_time`) VALUES
(1, 1, '09:00:00', '17:00:00'), -- Staff 1, Monday
(1, 2, '09:00:00', '17:00:00'), -- Staff 1, Tuesday
(1, 3, '09:00:00', '17:00:00'), -- Staff 1, Wednesday
(1, 4, '09:00:00', '17:00:00'), -- Staff 1, Thursday
(1, 5, '09:00:00', '17:00:00'), -- Staff 1, Friday
(2, 1, '10:00:00', '18:00:00'), -- Staff 2, Monday
(2, 2, '10:00:00', '18:00:00'); -- Staff 2, Tuesday

-- ========================
-- TIME_BLOCKS
-- ========================
INSERT INTO `time_blocks` (`staff_id`, `starts_at`, `ends_at`, `reason`) VALUES
(1, '2025-10-20 12:00:00', '2025-10-20 13:00:00', 'Lunch Break'),
(1, '2025-10-21 12:00:00', '2025-10-21 13:00:00', 'Lunch Break');

-- ========================
-- SERVICES
-- ========================
INSERT INTO `services` (`service_id`, `salon_id`, `name`, `description`, `price_cents`, `duration_minutes`) VALUES
(1, 1, 'Men''s Haircut', 'Classic men''s haircut and style.', 3000, 30),
(2, 1, 'Beard Trim', 'Shape and trim your beard.', 1500, 15),
(3, 2, 'Women''s Haircut', 'Shampoo, cut, and blow-dry.', 6000, 60),
(4, 2, 'Full Color', 'Single-process hair color.', 8000, 90),
(5, 3, 'Hot Shave', 'Classic hot towel and straight razor shave.', 4000, 45),
(6, 3, 'Buzz Cut', 'Single-guard all over.', 2000, 15),
(7, 4, 'Blowout', 'Shampoo and professional blowout.', 4500, 45),
(8, 5, 'Kids Cut', 'Haircut for children 10 and under.', 2500, 30);

-- ========================
-- PRODUCTS
-- ========================
INSERT INTO `products` (`product_id`, `salon_id`, `name`, `description`, `price_cents`, `stock_quantity`) VALUES
(1, 1, 'Styling Gel', 'Strong hold styling gel.', 1800, 50),
(2, 1, 'Beard Oil', 'Nourishing oil for beards.', 2200, 30),
(3, 2, 'Volumizing Shampoo', 'Adds volume and shine.', 2500, 40),
(4, 2, 'Hair Spray', 'Flexible hold hair spray.', 1600, 60);

-- ========================
-- APPOINTMENTS
-- ========================
INSERT INTO `appointments` (`appointment_id`, `salon_id`, `staff_id`, `service_id`, `client_id`, `starts_at`, `ends_at`, `status`, `notes`) VALUES
(1, 1, 1, 1, 13, '2025-10-20 10:00:00', '2025-10-20 10:30:00', 'completed', 'Client wants a #2 on the sides.'),
(2, 1, 6, 1, 14, '2025-10-20 11:00:00', '2025-10-20 11:30:00', 'completed', 'First time client.'),
(3, 2, 2, 3, 15, '2025-10-21 13:00:00', '2025-10-21 14:00:00', 'completed', NULL),
(4, 1, 1, 2, 13, '2025-10-27 10:00:00', '2025-10-27 10:15:00', 'booked', 'Just a quick trim.'),
(5, 2, 2, 4, 16, '2025-10-28 14:00:00', '2025-10-28 15:30:00', 'booked', NULL),
(6, 3, 3, 5, 17, '2025-10-29 11:00:00', '2025-10-29 11:45:00', 'booked', NULL),
(7, 1, 6, 1, 18, '2025-10-22 09:00:00', '2025-10-22 09:30:00', 'cancelled', 'Client rescheduled.');

-- ========================
-- REVIEWS
-- ========================
INSERT INTO `reviews` (`review_id`, `salon_id`, `client_id`, `appointment_id`, `rating`, `review_text`) VALUES
(1, 1, 13, 1, 5, 'Great haircut, very professional!'),
(2, 1, 14, 2, 4, 'Good service, but the wait was a bit long.'),
(3, 2, 15, 3, 5, 'Loved my haircut! Catherine is the best.');

-- ========================
-- REVIEW_REPLIES
-- ========================
INSERT INTO `review_replies` (`reply_id`, `review_id`, `user_id`, `reply_text`) VALUES
(1, 1, 6, 'Thank you so much! Glad you enjoyed it.'),
(2, 2, 6, 'Apologies for the wait, we were short-staffed. We appreciate the feedback!');

-- ========================
-- LOYALTY_PROGRAMS
-- ========================
INSERT INTO `loyalty_programs` (`program_id`, `salon_id`, `points_per_dollar`, `reward_description`, `is_active`) VALUES
(1, 1, 10, '1000 points for a free Beard Trim', 1),
(2, 2, 5, '5000 points for 50% off Full Color', 1);

-- ========================
-- CLIENT_LOYALTY
-- ========================
INSERT INTO `client_loyalty` (`salon_id`, `client_id`, `points_balance`) VALUES
(1, 13, 300), -- Based on appointment 1 (service price 3000 cents -> $30 * 10)
(1, 14, 300), -- Based on appointment 2 (service price 3000 cents -> $30 * 10)
(2, 15, 300); -- Based on appointment 3 (service price 6000 cents -> $60 * 5)

-- ========================
-- AUDIT_LOG
-- ========================
INSERT INTO `audit_log` (`user_id`, `action`, `table_name`, `record_id`, `details`) VALUES
(1, 'UPDATE', 'salons', 3, '{"before": {"verification_status": "pending"}, "after": {"verification_status": "approved"}}'),
(6, 'INSERT', 'services', 1, '{"new_data": {"name": "Men''s Haircut", "price_cents": 3000}}'),
(2, 'DELETE', 'reviews', 4, '{"deleted_data": {"rating": 1, "review_text": "Spam comment removed."}}');