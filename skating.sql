create database if not exists eldoret_skating_club;
use eldoret_skating_club;
CREATE TABLE if not exists members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    join_date datetime default current_timestamp ,
    membership_status ENUM('active', 'expired') DEFAULT 'active',
    UNIQUE KEY uk_email (email)
)

CREATE TABLE activities (
    activity_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    activity_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    activity_type VARCHAR(50) NOT NULL,
    notes TEXT,
    FOREIGN KEY fk_activities_member (member_id) REFERENCES members(member_id) ON DELETE CASCADE
) 

CREATE TABLE resources (
    resource_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    resource_type VARCHAR(50) NOT NULL,
    distribution_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    return_date DATETIME DEFAULT NULL,
    status ENUM('issued', 'returned') DEFAULT 'issued',
    FOREIGN KEY fk_resources_member (member_id) REFERENCES members(member_id) ON DELETE CASCADE
)

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    payment_period VARCHAR(7) NOT NULL COMMENT 'Format: YYYY-MM',
    status ENUM('paid', 'pending') DEFAULT 'paid',
    FOREIGN KEY fk_payments_member (member_id) REFERENCES members(member_id) ON DELETE CASCADE
) 

INSERT INTO members (first_name, last_name, email, phone, join_date, membership_status) VALUES
('John', 'Kamau', 'john.kamau@example.com', '+254712345678', '2025-01-01', 'active'),
('Mary', 'Wanjiku', 'mary.wanjiku@example.com', '+254723456789', '2025-01-15', 'active'),
('Peter', 'Ochieng', 'peter.ochieng@example.com', '+254734567890', '2025-02-01', 'expired'),
('Grace', 'Njeri', 'grace.njeri@example.com', '+254745678901', '2025-02-10', 'active'),
('James', 'Muthoni', 'james.muthoni@example.com', '+254756789012', '2025-03-01', 'active'),
('Lucy', 'Achieng', 'lucy.achieng@example.com', '+254767890123', '2025-03-15', 'expired'),
('David', 'Kariuki', 'david.kariuki@example.com', '+254778901234', '2025-04-01', 'active'),
('Sarah', 'Atieno', 'sarah.atieno@example.com', '+254789012345', '2025-04-10', 'active'),
('Michael', 'Njoroge', 'michael.njoroge@example.com', '+254790123456', '2025-05-01', 'expired'),
('Esther', 'Wambui', 'esther.wambui@example.com', '+254701234567', '2025-05-15', 'active');

INSERT INTO activities (member_id, activity_date, activity_type, notes) VALUES
(1, '2025-06-01 10:00:00', 'training', 'Morning training session'),
(2, '2025-06-02 15:00:00', 'group skate', 'Group skate at the park'),
(3, '2025-06-03 09:00:00', 'event', 'Skating competition'),
(4, '2025-06-04 11:00:00', 'training', 'Speed skating practice'),
(5, '2025-06-05 14:00:00', 'group skate', 'Evening group skate'),
(6, '2025-06-06 10:00:00', 'training', 'Beginner training'),
(7, '2025-06-07 16:00:00', 'event', 'Club showcase event'),
(8, '2025-06-08 12:00:00', 'training', 'Advanced tricks session'),
(9, '2025-06-09 09:00:00', 'group skate', 'Morning skate with members'),
(10, '2025-06-10 13:00:00', 'training', 'Endurance training');


INSERT INTO resources (member_id, resource_type, distribution_date, return_date, status) VALUES
(1, 'skates', '2025-06-01 09:00:00', NULL, 'issued'),
(2, 'helmet', '2025-06-02 10:00:00', '2025-06-10 10:00:00', 'returned'),
(3, 'pads', '2025-06-03 08:00:00', NULL, 'issued'),
(4, 'skates', '2025-06-04 11:00:00', NULL, 'issued'),
(5, 'helmet', '2025-06-05 12:00:00', NULL, 'issued'),
(6, 'pads', '2025-06-06 09:00:00', '2025-06-12 09:00:00', 'returned'),
(7, 'skates', '2025-06-07 10:00:00', NULL, 'issued'),
(8, 'helmet', '2025-06-08 11:00:00', NULL, 'issued'),
(9, 'pads', '2025-06-09 08:00:00', NULL, 'issued'),
(10, 'skates', '2025-06-10 12:00:00', NULL, 'issued');


INSERT INTO payments (member_id, payment_date, amount, payment_period, status) VALUES
(1, '2025-06-01 08:00:00', 1500.00, '2025-06', 'paid'),
(2, '2025-06-02 09:00:00', 1500.00, '2025-06', 'paid'),
(3, '2025-05-01 10:00:00', 1500.00, '2025-05', 'paid'),
(4, '2025-06-04 11:00:00', 1500.00, '2025-06', 'paid'),
(5, '2025-06-05 12:00:00', 1500.00, '2025-06', 'paid'),
(6, '2025-05-15 13:00:00', 1500.00, '2025-05', 'paid'),
(7, '2025-06-07 14:00:00', 1500.00, '2025-06', 'paid'),
(8, '2025-06-08 15:00:00', 1500.00, '2025-06', 'paid'),
(9, '2025-05-01 16:00:00', 1500.00, '2025-05', 'paid'),
(10, '2025-06-10 17:00:00', 1500.00, '2025-06', 'paid');