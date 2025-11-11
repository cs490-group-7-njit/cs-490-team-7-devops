-- ========================
-- Mock Data for Beautiful Hair Database by DevOps team Group 7.
-- Comprehensive dataset with all tables fully populated.
-- ========================

-- ========================
-- USERS
-- ========================
INSERT INTO `users` (`user_id`, `name`, `email`, `role`, `phone`) VALUES
-- Admins
(1, 'Ada Admin', 'ada.admin@example.com', 'admin', '555-0001'),
(2, 'Barry Admin', 'barry.admin@example.com', 'admin', '555-0002'),
(3, 'Charlie Admin', 'charlie.admin@example.com', 'admin', '555-0003'),
(4, 'Diana Admin', 'diana.admin@example.com', 'admin', '555-0004'),
(5, 'Edward Admin', 'edward.admin@example.com', 'admin', '555-0005'),
-- Vendors
(6, 'Vicky Vendor', 'vicky.vendor@example.com', 'vendor', '212-555-6101'),
(7, 'Victor Vendor', 'victor.vendor@example.com', 'vendor', '718-555-6102'),
(8, 'Valerie Vendor', 'valerie.vendor@example.com', 'vendor', '212-555-6103'),
(9, 'Vincent Vendor', 'vincent.vendor@example.com', 'vendor', '718-555-6104'),
(10, 'Vanessa Vendor', 'vanessa.vendor@example.com', 'vendor', '212-555-6105'),
(11, 'Veronica Vendor', 'veronica.vendor@example.com', 'vendor', '917-555-6106'),
-- Clients
(12, 'Carl Client', 'carl.client@example.com', 'client', '212-555-1101'),
(13, 'Catherine Client', 'catherine.client@example.com', 'client', '718-555-1102'),
(14, 'Chris Client', 'chris.client@example.com', 'client', '212-555-1103'),
(15, 'Christina Client', 'christina.client@example.com', 'client', '718-555-1104'),
(16, 'Cody Client', 'cody.client@example.com', 'client', '212-555-1105'),
(17, 'Chelsea Client', 'chelsea.client@example.com', 'client', '718-555-1106'),
(18, 'Connor Client', 'connor.client@example.com', 'client', '212-555-1107'),
(19, 'Chloe Client', 'chloe.client@example.com', 'client', '718-555-1108'),
(20, 'Caleb Client', 'caleb.client@example.com', 'client', '212-555-1109'),
(21, 'Claire Client', 'claire.client@example.com', 'client', '718-555-1110'),
(22, 'Daniel Client', 'daniel.client@example.com', 'client', '212-555-1111'),
(23, 'Danielle Client', 'danielle.client@example.com', 'client', '718-555-1112'),
(24, 'Derek Client', 'derek.client@example.com', 'client', '212-555-1113'),
(25, 'Destiny Client', 'destiny.client@example.com', 'client', '718-555-1114'),
(26, 'Ethan Client', 'ethan.client@example.com', 'client', '212-555-1115'),
(27, 'Eva Client', 'eva.client@example.com', 'client', '718-555-1116'),
(28, 'Evan Client', 'evan.client@example.com', 'client', '212-555-1117'),
(29, 'Evelyn Client', 'evelyn.client@example.com', 'client', '718-555-1118'),
(30, 'Franklin Client', 'franklin.client@example.com', 'client', '212-555-1119'),
(31, 'Fiona Client', 'fiona.client@example.com', 'client', '718-555-1120');

-- ========================
-- AUTH_ACCOUNTS (password_hash = MD5('manager') for all test users)
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
(20, '5f4dcc3b5aa765d61d8327deb882cf99'),
(21, '5f4dcc3b5aa765d61d8327deb882cf99'),
(22, '5f4dcc3b5aa765d61d8327deb882cf99'),
(23, '5f4dcc3b5aa765d61d8327deb882cf99'),
(24, '5f4dcc3b5aa765d61d8327deb882cf99'),
(25, '5f4dcc3b5aa765d61d8327deb882cf99'),
(26, '5f4dcc3b5aa765d61d8327deb882cf99'),
(27, '5f4dcc3b5aa765d61d8327deb882cf99'),
(28, '5f4dcc3b5aa765d61d8327deb882cf99'),
(29, '5f4dcc3b5aa765d61d8327deb882cf99'),
(30, '5f4dcc3b5aa765d61d8327deb882cf99'),
(31, '5f4dcc3b5aa765d61d8327deb882cf99');

-- ========================
-- SALONS
-- ========================
INSERT INTO `salons` (`salon_id`, `vendor_id`, `name`, `description`, `business_type`, `address_line1`, `address_line2`, `city`, `state`, `postal_code`, `phone`, `is_published`, `verification_status`) VALUES
(1, 6, 'The Cutting Edge', 'Premium men''s grooming salon', 'Barber Shop', '123 Shear St', 'Suite 1', 'New York', 'NY', '10001', '212-555-0101', 1, 'approved'),
(2, 7, 'Curl Up & Dye', 'Full-service salon for all hair types', 'Hair Salon', '456 Style Ave', 'Floor 2', 'Brooklyn', 'NY', '11201', '718-555-0102', 1, 'approved'),
(3, 8, 'Hairitage', 'Upscale barbershop and salon', 'Barber Shop', '789 Brush Blvd', NULL, 'New York', 'NY', '10002', '212-555-0103', 1, 'pending'),
(4, 9, 'The Mane Event', 'Modern hair styling studio', 'Hair Salon', '101 Comb Ct', 'Suite 5', 'Queens', 'NY', '11101', '718-555-0104', 0, 'approved'),
(5, 10, 'Shear Luck', 'Casual neighborhood barber', 'Barber Shop', '212 Dryer Dr', NULL, 'New York', 'NY', '10003', '212-555-0105', 1, 'rejected'),
(6, 11, 'The Hair Studio', 'Luxury salon for women', 'Hair Salon', '303 Strand St', 'Suite 10', 'Manhattan', 'NY', '10004', '212-555-0106', 1, 'approved');

-- ========================
-- STAFF
-- ========================
INSERT INTO `staff` (`staff_id`, `salon_id`, `user_id`, `title`, `schedule`) VALUES
(1, 1, 6, 'Owner / Senior Stylist', NULL),
(2, 2, 7, 'Owner / Colorist', NULL),
(3, 3, 8, 'Owner / Barber', NULL),
(4, 4, 9, 'Owner / Stylist', NULL),
(5, 5, 10, 'Owner / Barber', NULL),
(6, 6, 11, 'Owner / Senior Stylist', NULL),
(7, 1, 12, 'Junior Stylist', NULL),
(8, 1, 13, 'Barber', NULL),
(9, 2, 14, 'Colorist', NULL),
(10, 2, 15, 'Shampoo Assistant', NULL),
(11, 3, 16, 'Barber', NULL),
(12, 4, 17, 'Stylist', NULL),
(13, 6, 18, 'Senior Colorist', NULL),
(14, 6, 19, 'Blow-Dry Specialist', NULL);

-- ========================
-- SCHEDULES
-- ========================
INSERT INTO `schedules` (`staff_id`, `day_of_week`, `start_time`, `end_time`) VALUES
-- Staff 1 - Monday to Friday
(1, 1, '09:00:00', '17:00:00'),
(1, 2, '09:00:00', '17:00:00'),
(1, 3, '09:00:00', '17:00:00'),
(1, 4, '09:00:00', '17:00:00'),
(1, 5, '09:00:00', '17:00:00'),
(1, 6, '10:00:00', '14:00:00'),
-- Staff 2 - Monday to Friday
(2, 1, '10:00:00', '18:00:00'),
(2, 2, '10:00:00', '18:00:00'),
(2, 3, '10:00:00', '18:00:00'),
(2, 4, '10:00:00', '18:00:00'),
(2, 5, '10:00:00', '18:00:00'),
(2, 6, '11:00:00', '15:00:00'),
-- Staff 3 - Tuesday to Saturday
(3, 2, '08:30:00', '16:30:00'),
(3, 3, '08:30:00', '16:30:00'),
(3, 4, '08:30:00', '16:30:00'),
(3, 5, '08:30:00', '16:30:00'),
(3, 6, '08:30:00', '16:30:00'),
(3, 0, '09:00:00', '13:00:00'),
-- Staff 7 - Monday, Wednesday, Friday
(7, 1, '11:00:00', '19:00:00'),
(7, 3, '11:00:00', '19:00:00'),
(7, 5, '11:00:00', '19:00:00'),
-- Staff 8 - Tuesday, Thursday, Saturday
(8, 2, '09:00:00', '17:00:00'),
(8, 4, '09:00:00', '17:00:00'),
(8, 6, '09:00:00', '17:00:00'),
-- Staff 9 - Daily
(9, 1, '10:00:00', '18:00:00'),
(9, 2, '10:00:00', '18:00:00'),
(9, 3, '10:00:00', '18:00:00'),
(9, 4, '10:00:00', '18:00:00'),
(9, 5, '10:00:00', '18:00:00'),
-- Staff 13 - Daily
(13, 1, '09:00:00', '17:00:00'),
(13, 2, '09:00:00', '17:00:00'),
(13, 3, '09:00:00', '17:00:00'),
(13, 4, '09:00:00', '17:00:00'),
(13, 5, '09:00:00', '17:00:00');

-- ========================
-- TIME_BLOCKS
-- ========================
INSERT INTO `time_blocks` (`staff_id`, `starts_at`, `ends_at`, `reason`) VALUES
(1, '2025-11-10 12:00:00', '2025-11-10 13:00:00', 'Lunch Break'),
(1, '2025-11-11 12:00:00', '2025-11-11 13:00:00', 'Lunch Break'),
(1, '2025-11-15 14:00:00', '2025-11-15 16:00:00', 'Training Session'),
(2, '2025-11-12 13:00:00', '2025-11-12 14:00:00', 'Lunch Break'),
(2, '2025-11-20 10:00:00', '2025-11-20 12:00:00', 'Client Meeting'),
(3, '2025-11-13 12:00:00', '2025-11-13 13:00:00', 'Lunch Break'),
(7, '2025-11-14 15:00:00', '2025-11-14 16:00:00', 'Break'),
(8, '2025-11-17 12:00:00', '2025-11-17 13:00:00', 'Lunch Break');

-- ========================
-- SERVICES
-- ========================
INSERT INTO `services` (`service_id`, `salon_id`, `name`, `description`, `price_cents`, `duration_minutes`) VALUES
-- The Cutting Edge (Salon 1)
(1, 1, 'Men''s Haircut', 'Classic men''s haircut and style.', 3000, 30),
(2, 1, 'Beard Trim', 'Shape and trim your beard.', 1500, 15),
(3, 1, 'Hot Shave', 'Classic hot towel and straight razor shave.', 4000, 45),
(4, 1, 'Fade with Line', 'Precision fade with detailed line work.', 3500, 35),
-- Curl Up & Dye (Salon 2)
(5, 2, 'Women''s Haircut', 'Shampoo, cut, and blow-dry.', 6000, 60),
(6, 2, 'Full Color', 'Single-process hair color.', 8000, 90),
(7, 2, 'Highlights', 'Partial highlights for dimension.', 10000, 120),
(8, 2, 'Blowout Service', 'Professional blow-dry styling.', 4500, 45),
-- Hairitage (Salon 3)
(9, 3, 'Barber Haircut', 'Traditional barber haircut.', 3500, 40),
(10, 3, 'Buzz Cut', 'Single-guard all over.', 2000, 15),
(11, 3, 'Shape Up', 'Edge cleaning and shape maintenance.', 1200, 10),
-- The Mane Event (Salon 4)
(12, 4, 'Women''s Cut', 'Precision cut and styling.', 5500, 55),
(13, 4, 'Blowout', 'Shampoo and professional blowout.', 4500, 45),
(14, 4, 'Makeup Service', 'Professional makeup application.', 6000, 60),
-- Shear Luck (Salon 5)
(15, 5, 'Kids Cut', 'Haircut for children 10 and under.', 2500, 30),
(16, 5, 'Teen Haircut', 'Stylish haircut for teens.', 3000, 30),
-- The Hair Studio (Salon 6)
(17, 6, 'Luxury Cut', 'High-end haircut with consultation.', 8000, 75),
(18, 6, 'Color Treatment', 'Premium color with conditioning treatment.', 12000, 120),
(19, 6, 'Hair Spa', 'Deep conditioning and scalp treatment.', 7000, 60),
(20, 6, 'Extensions', 'Hair extension application and styling.', 20000, 180);

-- ========================
-- PRODUCTS
-- ========================
INSERT INTO `products` (`product_id`, `salon_id`, `name`, `description`, `price_cents`, `stock_quantity`) VALUES
-- The Cutting Edge (Salon 1)
(1, 1, 'Styling Gel', 'Strong hold styling gel for men.', 1800, 50),
(2, 1, 'Beard Oil', 'Nourishing oil for beards.', 2200, 30),
(3, 1, 'Beard Balm', 'Conditioning balm with light hold.', 2500, 25),
(4, 1, 'Aftershave Splash', 'Classic bay rum aftershave.', 1600, 40),
-- Curl Up & Dye (Salon 2)
(5, 2, 'Volumizing Shampoo', 'Adds volume and shine.', 2500, 40),
(6, 2, 'Hair Spray', 'Flexible hold hair spray.', 1600, 60),
(7, 2, 'Deep Conditioner', 'Intensive hydration treatment.', 3000, 35),
(8, 2, 'Hair Serum', 'Anti-frizz and shine serum.', 2800, 28),
-- Hairitage (Salon 3)
(9, 3, 'Pomade', 'High-shine pomade for styling.', 1900, 45),
(10, 3, 'Clipper Oil', 'Maintenance oil for clippers.', 1200, 60),
-- The Mane Event (Salon 4)
(12, 4, 'Texturizing Spray', 'Adds texture and grip to hair.', 2000, 50),
(13, 4, 'Dry Shampoo', 'Absorbs oil and adds volume.', 1800, 55),
-- Shear Luck (Salon 5)
(14, 5, 'Kids Shampoo', 'Gentle shampoo for children.', 1200, 40),
(15, 5, 'Hair Detangler', 'Easy-to-use detangler spray.', 1400, 35),
-- The Hair Studio (Salon 6)
(16, 6, 'Luxury Hair Oil', 'Premium argan and jojoba oil blend.', 4500, 20),
(17, 6, 'Color-Protect Shampoo', 'Maintains color vibrancy.', 3500, 32),
(18, 6, 'Hair Mask Treatment', 'Intensive repair mask.', 4000, 25),
(19, 6, 'Scalp Scrub', 'Exfoliating scalp treatment.', 3200, 28);

-- ========================
-- APPOINTMENTS
-- ========================
INSERT INTO `appointments` (`appointment_id`, `salon_id`, `staff_id`, `service_id`, `client_id`, `starts_at`, `ends_at`, `status`, `notes`) VALUES
-- Completed appointments
(1, 1, 1, 1, 14, '2025-11-01 10:00:00', '2025-11-01 10:30:00', 'completed', 'Client wants a #2 on the sides.'),
(2, 1, 7, 1, 15, '2025-11-01 11:00:00', '2025-11-01 11:30:00', 'completed', 'First time client. Very happy with results.'),
(3, 2, 2, 5, 16, '2025-11-02 13:00:00', '2025-11-02 14:00:00', 'completed', NULL),
(4, 1, 1, 2, 14, '2025-11-03 10:00:00', '2025-11-03 10:15:00', 'completed', 'Just a quick trim.'),
(5, 2, 2, 6, 17, '2025-11-04 14:00:00', '2025-11-04 15:30:00', 'completed', 'Full color treatment completed.'),
(6, 3, 3, 9, 18, '2025-11-05 11:00:00', '2025-11-05 11:40:00', 'completed', 'Client satisfied with fade.'),
(7, 1, 8, 1, 19, '2025-11-05 09:00:00', '2025-11-05 09:30:00', 'completed', 'Buzz cut with clean edges.'),
(8, 4, 12, 12, 20, '2025-11-06 15:00:00', '2025-11-06 15:55:00', 'completed', 'Layered cut requested.'),
(9, 2, 9, 5, 21, '2025-11-06 10:00:00', '2025-11-06 11:00:00', 'completed', 'Color correction performed.'),
(10, 6, 13, 17, 22, '2025-11-07 11:00:00', '2025-11-07 12:15:00', 'completed', 'Luxury cut with styling.'),
-- Booked appointments
(11, 1, 1, 2, 14, '2025-11-12 10:00:00', '2025-11-12 10:15:00', 'booked', 'Beard trim appointment.'),
(12, 2, 2, 6, 23, '2025-11-13 14:00:00', '2025-11-13 15:30:00', 'booked', 'Highlight appointment.'),
(13, 3, 3, 10, 24, '2025-11-14 11:00:00', '2025-11-14 11:15:00', 'booked', 'Buzz cut requested.'),
(14, 1, 7, 1, 25, '2025-11-15 09:00:00', '2025-11-15 09:30:00', 'booked', 'Regular haircut.'),
(15, 4, 12, 13, 26, '2025-11-15 14:00:00', '2025-11-15 14:45:00', 'booked', 'Blowout service.'),
(16, 2, 2, 8, 27, '2025-11-16 16:00:00', '2025-11-16 16:45:00', 'booked', 'Blow-dry for evening event.'),
(17, 6, 13, 18, 28, '2025-11-17 10:00:00', '2025-11-17 12:00:00', 'booked', 'Premium color treatment.'),
(18, 3, 11, 9, 29, '2025-11-18 10:30:00', '2025-11-18 11:10:00', 'booked', 'Traditional barber cut.'),
(19, 5, 5, 16, 30, '2025-11-19 14:00:00', '2025-11-19 14:30:00', 'booked', 'Teen haircut.'),
(20, 1, 1, 4, 31, '2025-11-20 11:00:00', '2025-11-20 11:35:00', 'booked', 'Fade with line work.'),
-- No-show appointments
(21, 1, 7, 1, 12, '2025-10-28 10:00:00', '2025-10-28 10:30:00', 'no-show', 'Client did not show up.'),
(22, 2, 9, 5, 13, '2025-10-29 15:00:00', '2025-10-29 16:00:00', 'no-show', NULL),
-- Cancelled appointments
(23, 1, 8, 2, 12, '2025-10-20 14:00:00', '2025-10-20 14:15:00', 'cancelled', 'Client rescheduled.'),
(24, 4, 12, 14, 15, '2025-10-22 09:00:00', '2025-10-22 09:45:00', 'cancelled', 'Cancelled due to weather.');

-- ========================
-- REVIEWS
-- ========================
INSERT INTO `reviews` (`review_id`, `salon_id`, `client_id`, `rating`, `comment`) VALUES
(1, 1, 14, 5, 'Great haircut, very professional! Will definitely come back.'),
(2, 1, 15, 4, 'Good service, but the wait was a bit long. Still worth it though.'),
(3, 2, 16, 5, 'Loved my haircut! Catherine is the best colorist in the city.'),
(4, 1, 19, 5, 'Amazing experience. Clean salon and skilled barber.'),
(5, 2, 21, 4, 'Good work on the color correction. Very professional team.'),
(6, 3, 18, 4, 'Solid barber work. Will be back for my next cut.'),
(7, 4, 20, 5, 'Perfect blowout! She really knows her stuff.'),
(8, 6, 22, 5, 'Luxury experience at a great price. Highly recommend!'),
(9, 1, 25, 3, 'Decent haircut but a bit pricey for what I got.'),
(10, 2, 27, 5, 'Exceptional styling for my event. Looked amazing!');

-- ========================
-- REVIEW_REPLIES
-- ========================
INSERT INTO `review_replies` (`reply_id`, `review_id`, `user_id`, `reply_text`) VALUES
(1, 1, 6, 'Thank you so much! Glad you enjoyed it. See you next time!'),
(2, 2, 6, 'Apologies for the wait, we were short-staffed that day. We appreciate the feedback and will work on improving our scheduling!'),
(3, 3, 7, 'Catherine says thank you! We look forward to seeing you again soon.'),
(4, 4, 8, 'Thanks for the review! We pride ourselves on cleanliness and skill. Excited to see you at your next appointment.'),
(5, 5, 7, 'Glad the color correction turned out great! Our team is dedicated to making you happy.'),
(6, 7, 9, 'Thank you for choosing The Mane Event! We''ll see you soon.'),
(7, 8, 11, 'We appreciate the high rating! Our team works hard to provide the best experience possible.'),
(8, 10, 7, 'So happy we could help make your event special! Hope to see you again.');

-- ========================
-- LOYALTY_PROGRAMS
-- ========================
INSERT INTO `loyalty_programs` (`program_id`, `salon_id`, `points_per_dollar`, `reward_description`, `is_active`) VALUES
(1, 1, 10, '1000 points = Free Beard Trim', 1),
(2, 2, 5, '5000 points = 50% off Full Color', 1),
(3, 3, 8, '800 points = Free Buzz Cut', 1),
(4, 4, 7, '700 points = Free Blowout Service', 1),
(5, 6, 12, '1200 points = Free Luxury Haircut', 1);

-- ========================
-- CLIENT_LOYALTY
-- ========================
INSERT INTO `client_loyalty` (`salon_id`, `client_id`, `points_balance`) VALUES
(1, 14, 300),
(1, 15, 150),
(1, 19, 250),
(1, 25, 100),
(2, 16, 300),
(2, 17, 500),
(2, 21, 350),
(2, 27, 400),
(3, 18, 240),
(3, 24, 160),
(4, 20, 315),
(4, 26, 280),
(6, 22, 960),
(6, 28, 720);

-- ========================
-- PAYMENT_METHODS
-- ========================
INSERT INTO `payment_methods` (`payment_method_id`, `user_id`, `card_holder_name`, `card_number_last_four`, `card_brand`, `expiry_month`, `expiry_year`, `is_default`) VALUES
(1, 14, 'Chris Client', '4242', 'Visa', 12, 2026, 1),
(2, 14, 'Chris Client', '1111', 'MasterCard', 6, 2025, 0),
(3, 15, 'Christina Client', '5555', 'MasterCard', 3, 2027, 1),
(4, 16, 'Cody Client', '3782', 'American Express', 9, 2026, 1),
(5, 17, 'Chelsea Client', '6011', 'Discover', 11, 2025, 1),
(6, 18, 'Connor Client', '4012', 'Visa', 8, 2027, 1),
(7, 19, 'Chloe Client', '3530', 'JCB', 2, 2026, 0),
(8, 20, 'Caleb Client', '5200', 'MasterCard', 10, 2025, 1),
(9, 21, 'Claire Client', '3782', 'American Express', 5, 2027, 1),
(10, 22, 'Daniel Client', '4916', 'Visa', 7, 2026, 1),
(11, 23, 'Danielle Client', '5105', 'MasterCard', 4, 2025, 1),
(12, 24, 'Derek Client', '3100', 'American Express', 9, 2026, 1),
(13, 25, 'Destiny Client', '1117', 'Discover', 12, 2025, 1),
(14, 26, 'Ethan Client', '3100', 'JCB', 6, 2027, 1),
(15, 27, 'Eva Client', '4444', 'MasterCard', 8, 2026, 1);

-- ========================
-- FAVORITE_SALONS
-- ========================
INSERT INTO `favorite_salons` (`user_id`, `salon_id`) VALUES
(14, 1),
(14, 2),
(15, 1),
(16, 2),
(17, 2),
(18, 3),
(19, 1),
(20, 4),
(21, 2),
(22, 6),
(23, 2),
(24, 3),
(25, 1),
(26, 4),
(27, 2),
(28, 6),
(29, 3),
(30, 5),
(31, 1);

-- ========================
-- TRANSACTIONS
-- ========================
INSERT INTO `transactions` (`transaction_id`, `user_id`, `appointment_id`, `payment_method_id`, `amount_cents`, `status`, `transaction_date`) VALUES
(1, 14, 1, 1, 3000, 'completed', '2025-11-01 10:35:00'),
(2, 15, 2, 3, 3000, 'completed', '2025-11-01 11:35:00'),
(3, 16, 3, 4, 6000, 'completed', '2025-11-02 14:05:00'),
(4, 14, 4, 1, 1500, 'completed', '2025-11-03 10:20:00'),
(5, 17, 5, 5, 8000, 'completed', '2025-11-04 15:35:00'),
(6, 18, 6, 6, 4000, 'completed', '2025-11-05 11:45:00'),
(7, 19, 7, 7, 3000, 'completed', '2025-11-05 09:35:00'),
(8, 20, 8, 8, 4500, 'completed', '2025-11-06 15:59:00'),
(9, 21, 9, 9, 6000, 'completed', '2025-11-06 11:05:00'),
(10, 22, 10, 10, 8000, 'completed', '2025-11-07 12:20:00'),
(11, 14, 11, 1, 1500, 'pending', '2025-11-12 10:15:00'),
(12, 23, 12, 11, 10000, 'pending', '2025-11-13 14:30:00'),
(13, 24, 13, 12, 2000, 'pending', '2025-11-14 11:15:00'),
(14, 25, 14, 13, 3000, 'pending', '2025-11-15 09:30:00'),
(15, 26, 15, 14, 4500, 'pending', '2025-11-15 14:45:00'),
(16, 27, 16, 15, 4500, 'pending', '2025-11-16 16:45:00'),
(17, 28, 17, 11, 12000, 'pending', '2025-11-17 10:00:00'),
(18, 29, 18, 12, 4000, 'pending', '2025-11-18 10:30:00'),
(19, 30, 19, 13, 3000, 'pending', '2025-11-19 14:00:00'),
(20, 31, 20, 14, 3500, 'pending', '2025-11-20 11:00:00');

-- ========================
-- STAFF_RATINGS
-- ========================
INSERT INTO `staff_ratings` (`rating_id`, `staff_id`, `client_id`, `rating`, `comment`) VALUES
(1, 1, 14, 5, 'Excellent barber! Very skilled with the clippers.'),
(2, 7, 15, 5, 'Great haircut and friendly service.'),
(3, 2, 16, 5, 'Amazing colorist! My highlights look perfect.'),
(4, 1, 19, 4, 'Good work, nice person.'),
(5, 9, 21, 5, 'Catherine is wonderful! Best colorist around.'),
(6, 3, 18, 4, 'Solid barber, knows what he''s doing.'),
(7, 12, 20, 5, 'Perfect blowout service! Very talented.'),
(8, 13, 22, 5, 'Exceptional stylist! Highly recommend her.'),
(9, 7, 25, 3, 'Decent cut, but could be better.'),
(10, 11, 29, 5, 'Professional barber, very clean salon.'),
(11, 14, 28, 5, 'Best blow-dry specialist in the city!'),
(12, 1, 31, 4, 'Good fade work, will return.');

-- ========================
-- AUDIT_LOG
-- ========================
INSERT INTO `audit_log` (`user_id`, `action`, `table_name`, `record_id`, `details`) VALUES
(1, 'UPDATE', 'salons', 3, '{"before": {"verification_status": "pending"}, "after": {"verification_status": "approved"}}'),
(6, 'INSERT', 'services', 1, '{"new_data": {"name": "Men''s Haircut", "price_cents": 3000}}'),
(2, 'DELETE', 'reviews', 4, '{"deleted_data": {"rating": 1, "review_text": "Spam comment removed."}}'),
(1, 'UPDATE', 'salons', 5, '{"before": {"verification_status": "rejected"}, "after": {"verification_status": "pending"}}'),
(7, 'INSERT', 'services', 5, '{"new_data": {"name": "Women''s Haircut", "price_cents": 6000}}'),
(3, 'UPDATE', 'users', 8, '{"before": {"name": "Valerie Vendor"}, "after": {"name": "Valerie V"}}'),
(1, 'INSERT', 'salons', 6, '{"new_data": {"name": "The Hair Studio", "vendor_id": 11}}'),
(5, 'UPDATE', 'loyalty_programs', 1, '{"before": {"points_per_dollar": 10}, "after": {"points_per_dollar": 12}}'),
(1, 'DELETE', 'appointments', 25, '{"deleted_data": {"appointment_id": 25, "status": "cancelled"}}'),
(9, 'INSERT', 'staff', 14, '{"new_data": {"salon_id": 6, "user_id": 19, "title": "Blow-Dry Specialist"}}');