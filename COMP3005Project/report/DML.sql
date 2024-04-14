-- admins table
INSERT INTO admins (email, first_name, last_name, profile_picture)
VALUES ('admin.avidLee@fitnessclub.com', 'David', 'Lee', NULL),
       ('admin.arahConnor@fitnessclub.com', 'Sarah', 'Connor', NULL),
       ('admin.ichaelBrown@fitnessclub.com', 'Michael', 'Brown', NULL),
       ('admin.shleyWilliams@fitnessclub.com', 'Ashley', 'Williams', NULL),
       ('admin.randonNelson@fitnessclub.com', 'Brandon', 'Nelson', NULL),
       ('admin.essicaMiller@fitnessclub.com', 'Jessica', 'Miller', NULL),
       ('admin.hristopherDavis@fitnessclub.com', 'Christopher', 'Davis', NULL),
       ('admin.lizabethGarcia@fitnessclub.com', 'Elizabeth', 'Garcia', NULL);

-- trainers table
INSERT INTO trainers (email, first_name, last_name, gender, specialization, bio, profile_picture)
VALUES ('trainermichaeljones@fitnessclub.com', 'Michael', 'Jones', 'Male', 'Cardiovascular Training, High-Intensity Interval Training (HIIT)', 'Experienced group fitness instructor specializing in high-energy cardio workouts and HIIT classes.', 'profile_pic_trainer3.jpg'),
       ('trainersarahwilliams@fitnessclub.com', 'Sarah', 'Williams', 'Female', 'Spin Cycling', 'Certified spin instructor with a focus on creating fun and challenging cycling workouts.', 'profile_pic_trainer4.jpg'),
       ('trainerashleyRodriguez@fitnessclub.com', 'Ashley', 'Rodriguez', 'Female', 'Zumba', 'Licensed Zumba instructor who brings the fun and energy to every Zumba class.', 'profile_pic_trainer6.jpg'),
       ('trainerchristopherJohnson@fitnessclub.com', 'Christopher', 'Johnson', 'Male', 'Strength Training, Sports Performance', 'Certified strength and conditioning specialist (CSCS) with a background in helping athletes improve their performance.', 'profile_pic_trainer7.jpg'),
       ('trainerelizabethGarcia@fitnessclub.com', 'Elizabeth', 'Garcia', 'Female', 'Nutrition', 'Registered dietitian (RD) who provides personalized nutrition coaching to help clients achieve their fitness goals.', 'profile_pic_trainer8.jpg'),
       ('trainermatthewHernandez@fitnessclub.com', 'Matthew', 'Hernandez', 'Male', 'Injury Rehabilitation', 'Certified athletic trainer (ATC) specializing in helping clients recover from injuries and prevent future ones.', 'profile_pic_trainer9.jpg'),
       ('traineramandaLee@fitnessclub.com', 'Amanda', 'Lee', 'Female', 'Mindfulness & Meditation', 'Yoga instructor with a focus on mindfulness and meditation practices to promote overall well-being.', 'profile_pic_trainer10.jpg');

-- members table
INSERT INTO members (email, first_name, last_name, gender, birthdate, phone_number, address, membership_type, profile_picture)
VALUES ('user.johndoe@fitnessclub.com', 'John', 'Doe', 'Male', '1980-01-01', '555-123-4567', '123 Main St.', 'Standard', 'profile_pic1.jpg'),
       ('user.janedoe@fitnessclub.com', 'Jane', 'Doe', 'Female', '1985-07-15', '555-789-0123', '456 Elm St.', 'Premium', 'profile_pic2.jpg'),
       ('user.alicejohnson@fitnessclub.com', 'Alice', 'Johnson', 'Female', '1990-03-10', '555-456-7890', '789 Maple Ave.', 'Standard', 'profile_pic3.jpg'),
       ('user.bobsmith@fitnessclub.com', 'Bob', 'Smith', 'Male', '1975-12-24', '555-012-3456', '1011 Oak St.', 'Premium', 'profile_pic4.jpg'),
       ('user.charliebrown@fitnessclub.com', 'Charlie', 'Brown', 'Male', '1995-09-05', '555-345-6789', '1213 Pine St.', 'Standard', 'profile_pic5.jpg'),
       ('user.eianagarcia@fitnessclub.com', 'Diana', 'Garcia', 'Female', '2000-02-18', '555-678-9012', '1415 Spruce St.', 'Premium', 'profile_pic6.jpg'),
       ('user.edwardthomas@fitnessclub.com', 'Edward', 'Thomas', 'Male', '1982-05-21', '555-901-2345', '1617 Birch St.', 'Standard', 'profile_pic7.jpg'),
       ('user.frid@fitnessclub.com', 'Frida', ' Hernandez', 'Female', '1992-11-07', '555-234-5678', '1819 Elm St.', 'Premium', 'profile_pic8.jpg'),
       ('user.georgeallen@fitnessclub.com', 'George', 'Allen', 'Male', '1978-08-13', '555-567-8901', '2021 Poplar St.', 'Standard', 'profile_pic9.jpg');

-- accounts table
INSERT INTO accounts (username, password, role, member_id)
VALUES ('admindavidleee', 'admin123', 'admin', 2),
       ('admin.connor', 'admin456', 'admin', 3),
       ('trainerashley', 'fitnesstrainer', 'trainer', 5),
       ('elizatrainer', 'anothertrainer', 'trainer', 3),
       ('johndoe', 'password123', 'member', 1),
       ('janedoe', 'password456', 'member', 2),
       ('alicejohnson', 'userpassword', 'member', 3),
       ('bobsmith', 'anotherpassword', 'member', 4),
       ('charliebrown', 'unique_password', 'member', 5),
       ('dianagarcia', 'somestrongpassword', 'member', 6);

-- classes table
INSERT INTO classes (class_name, description, trainer_id, class_day, class_time, duration_min, max_capacity)
VALUES ('Yoga', 'Relaxing and strengthening yoga poses for all levels.', 11, 'Monday', '18:00:00', 60, 10),
       ('Spin', 'High-intensity indoor cycling workout.', 12, 'Wednesday', '19:00:00', 45, 15),
       ('Strength Training', 'Build muscle and improve strength with free weights and bodyweight exercises.', 11, 'Tuesday', '10:00:00', 60, 8),
       ('Bootcamp', 'Challenging workout that combines cardio, strength training, and agility exercises.', 12, 'Thursday', '17:00:00', 75, 12),
       ('Zumba', 'Fun and energetic dance fitness class.', 11, 'Friday', '16:00:00', 60, 10),
       ('Pilates', 'Improve core strength, flexibility, and posture.', 12, 'Saturday', '09:00:00', 60, 8),
       ('Barre', 'Ballet-inspired workout that combines toning and cardio exercises.', 11, 'Monday', '19:30:00', 50, 10),
       ('Cardio Kickboxing', 'Punch and kick your way to a great workout.', 12, 'Wednesday', '20:00:00', 60, 15);

-- equipment_maintenance table
INSERT INTO equipment_maintenance (admin_id, equipment_name, last_maintenance_description, last_maintenance_date, current_condition)
VALUES (1, 'Treadmill 1', 'Belt tightened and lubricated.', '2024-04-08', 'Good'),
       (NULL, 'Elliptical Trainer', 'Replaced worn-out foot pedals.', '2024-03-22', 'Excellent'),
       (2, 'Free Weights (Dumbbells)', 'Cleaned and inspected for damage.', '2024-04-05', 'Good'),
       (NULL, 'Kettlebells', 'None - Regularly inspected.', '2024-04-12', 'Excellent'),
       (1, 'Yoga Mats', 'Sanitized and stored properly.', '2024-04-01', 'Good'),
       (NULL, 'Exercise Balls', 'Inflated to proper pressure.', '2024-03-29', 'Excellent'),
       (2, 'Spin Bikes', 'Calibrated and adjusted resistance.', '2024-04-02', 'Good'),
       (NULL, 'Benches', 'Checked for stability and wear.', '2024-04-09', 'Excellent'),
       (1, 'Pull-Up Bar', 'Lubricated moving parts.', '2024-03-18', 'Good'),
       (NULL, 'Rowing Machine', 'Cleaned and inspected for wear.', '2024-04-04', 'Excellent');


-- class_members table
INSERT INTO class_members (class_id, member_id, date_joined)
VALUES (1, 1, '2024-01-10'),
       (1, 2, '2024-02-01'),
       (2, 3, '2024-03-15'),
       (2, 4, '2024-03-20'),
       (3, 5, '2024-02-05'),
       (3, 6, '2024-02-10'),
       (1, 7, '2024-03-25'),
       (2, 8, '2024-04-01'),
       (3, 9, '2024-04-05'),
       (1, 10, '2024-04-10');

-- exercise_routines table
INSERT INTO exercise_routines (member_id, exercise_name, sets, reps, weight, day_of_week)
VALUES (1, 'Push-ups', 3, 10, NULL, 'Monday'),
       (1, 'Squats', 3, 12, 20, 'Tuesday'),
       (1, 'Lunges', 3, 20, 10, 'Wednesday'),
       (1, 'Dumbbell rows', 3, 12, 15, 'Monday'),
       (1, 'Overhead press', 3, 10, 10, 'Tuesday'),
       (1, 'Bicep curls', 3, 12, 8, 'Wednesday'),
       (1, 'Plank', 3, 30, NULL, 'Monday'),
       (2, 'Crunches', 3, 20 , NULL, 'Wednesday'),
       (2, 'Russian twists', 3, 15, NULL, 'Friday'),
       (2, 'Jumping jacks', 3, 30, NULL, 'Tuesday'),
       (2, 'Burpees', 3, 10, NULL, 'Thursday'),
       (2, 'Mountain climbers', 3, 30, NULL, 'Saturday');

-- goals table
INSERT INTO goals (member_id, goal_type, target_value, start_date, end_date)
VALUES (1, 'Lose weight', 5, '2024-03-01', '2024-05-31'),
       (2, 'Increase muscle mass', 2, '2024-02-15', '2024-05-15'),
       (3, 'Improve cardiovascular health', NULL, '2024-04-01', NULL),
       (3, 'Increase flexibility', NULL, '2024-03-20', '2024-06-30'),
       (4, 'Run a 5K race', NULL, '2024-04-10', '2024-06-01'),
       (3, 'Do 10 pull-ups in a row', NULL, '2024-04-05', '2024-05-10'),
       (1, 'Improve bench press weight by 10 kg', 10, '2024-03-25', '2024-05-20'),
       (4, 'Achieve a body fat percentage of 15%', 15, '2024-04-01', '2024-06-30'),
       (5, 'Reduce resting heart rate by 5 bpm', 5, '2024-04-08', '2024-05-31'),
       (4, 'Master a new yoga pose', NULL, '2024-04-02', '2024-04-30');

-- fitness_achievements table
INSERT INTO fitness_achievements (member_id, achievement_date, achievement_description, goal_id)
VALUES (1, '2024-04-09', 'Lost 2 kg of weight.', 1),
       (2, '2024-04-07', 'Increased bench press weight by 5 kg.', 7),
       (1, '2024-04-10', 'Completed a 3-mile run.', NULL),
       (4, '4,04-2024', 'Touched toes for the first time during a forward fold.', NULL),
       (2, '2024-04-05', 'Successfully signed up for a 5K race.', 5),
       (4, '2024-04-08', 'Completed 8 pull-ups in a row.', NULL),
       (2, NULL, NULL, 3),
       (5, NULL, NULL, 8),
       (1, NULL, NULL, 9);

-- health_statistics table
INSERT INTO health_statistics (member_id, date, weight, height, body_fat_percentage, blood_pressure_systolic, blood_pressure_diastolic, resting_heart_rate)
VALUES (1, '2024-04-10', 80.5, 1.78, 20.0, 120, 80, 70),
       (2, '2024-04-05', 72.0, 1.83, 18.5, 115, 75, 65),
       (3, '2024-04-01', 68.0, 1.65, 22.0, 130, 85, 80),
       (4, '2024-03-20', 65.5, 1.70, 21.5, 125, 80, 72),
       (5, '2024-04-08', NULL, NULL, NULL, NULL, NULL, NULL),
       (4, '2024-04-02', NULL, NULL, NULL, NULL, NULL, NULL),
       (5, '2024-03-25', 85.0, 1.80, 19.0, 128, 88, 78),
       (3, '2024-04-06', 78.0, 1.75, 17.0, 110, 70, 60),
       (2, '2024-04-09', 62.0, 1.60, 23.0, 135, 90, 85),
       (1, '2024-04-03', 59.0, 1.58, 20.5, 122, 75, 68);

-- payments table
INSERT INTO payments (member_id, payment_date, amount, payment_method, description)
VALUES (1, '2024-04-01', 50.00, 'Credit card', 'Monthly membership fee'),
       (2, '2024-03-15', 75.00, 'Credit card', 'Premium membership renewal'),
       (3, '2024-03-10', 50.00, 'Credit card', 'Monthly membership fee'),
       (4, '2024-02-10', 75.00, 'Credit card', 'Premium membership purchase'),
       (5, '2024-04-05', 20.00, 'Cash', 'Personal training session'),
       (6, '2024-03-20', 10.00, 'Cash', 'Drop-in class fee');

-- room_bookings table
INSERT INTO room_bookings (class_id, room, status, booking_date, from_time, to_time)
VALUES (1, 'Studio 1', 'Confirmed', '2024-04-08', '17:30:00', '18:30:00'),
       (2, 'Studio 2', 'Confirmed', '2024-04-06', '18:45:00', '19:30:00'),
       (3, 'Studio 1', 'Confirmed', '2024-04-03', '10:15:00', '11:15:00'),
       (1, 'Studio 2', 'Cancelled', '2024-04-05', '18:00:00', '19:00:00'),
       (2, 'Studio 1', 'Completed', '2024-04-02', '19:00:00', '19:45:00'),
       (3, 'Studio 2', 'Pending', '2024-04-11', '09:30:00', '10:30:00'),
       (1, 'Studio 1', 'Confirmed', '2024-04-12', '18:00:00', '19:00:00'),
       (2, 'Studio 2', 'Confirmed', '2024-04-10', '19:00:00', '19:45:00'),
       (1, 'Studio 1', 'Waiting List', '2024-04-15', '18:00:00', '19:00:00'),
       (2, 'Studio 2', 'Confirmed', '2024-04-13', '19:00:00', '19:45:00');

