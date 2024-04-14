CREATE TABLE IF NOT EXISTS accounts (
  user_id SERIAL,
  username VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL,
  member_id INTEGER NOT NULL,
  PRIMARY KEY (user_id)
 );
 
CREATE TABLE IF NOT EXISTS admins (
  admin_id SERIAL,
  email VARCHAR(100) NULL DEFAULT NULL UNIQUE,
  first_name VARCHAR(50) NULL DEFAULT NULL,
  last_name VARCHAR(50) NULL DEFAULT NULL,
  profile_picture VARCHAR(255) NULL DEFAULT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (admin_id)
);
 
CREATE TABLE IF NOT EXISTS class_members (
  class_id INTEGER NOT NULL,
  member_id INTEGER NOT NULL,
  date_joined DATE NULL DEFAULT NULL,
  PRIMARY KEY (class_id, member_id)); 
  
CREATE TABLE IF NOT EXISTS classes (
  class_id SERIAL,
  class_name VARCHAR(100) NULL DEFAULT NULL,
  description TEXT NULL DEFAULT NULL,
  trainer_id INTEGER NULL DEFAULT NULL,
  class_day VARCHAR(25) NOT NULL,
  class_time TIME NULL DEFAULT NULL,
  duration_min INTEGER NULL DEFAULT NULL,
  max_capacity INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (class_id));
 
CREATE TABLE IF NOT EXISTS equipment_maintenance (
  equipment_id SERIAL,
  admin_id INTEGER NULL DEFAULT NULL,
  equipment_name VARCHAR(100) NULL DEFAULT NULL,
  last_maintenance_description TEXT NULL DEFAULT NULL,
  last_maintenance_date DATE NULL DEFAULT NULL,
  current_condition VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (equipment_id));
 
CREATE TABLE IF NOT EXISTS members (
  member_id SERIAL,
  email VARCHAR(100) NULL DEFAULT NULL UNIQUE,
  first_name VARCHAR(50) NULL DEFAULT NULL,
  last_name VARCHAR(50) NULL DEFAULT NULL,
  gender VARCHAR(15) NULL DEFAULT 'Unspecified',
  birthdate DATE NULL DEFAULT NULL,
  phone_number VARCHAR(20) NULL DEFAULT NULL,
  address VARCHAR(255) NULL DEFAULT NULL,
  registration_date TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  membership_type VARCHAR(20) NULL DEFAULT NULL,
  profile_picture VARCHAR(255) NULL DEFAULT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (member_id)
);
 
CREATE TABLE IF NOT EXISTS exercise_routines (
  routine_id INTEGER NOT NULL,
  member_id INTEGER NOT NULL,
  exercise_name TEXT NOT NULL,
  sets INTEGER NOT NULL,
  reps INTEGER NOT NULL,
  weight INTEGER NOT NULL,
  day_of_week TEXT NOT NULL,
  PRIMARY KEY (routine_id),
  CONSTRAINT exercise_routines_ibfk_1 FOREIGN KEY (member_id) REFERENCES members (member_id));

CREATE TABLE IF NOT EXISTS goals (
  goal_id SERIAL,
  member_id INTEGER NULL DEFAULT NULL,
  goal_type VARCHAR(100) NULL DEFAULT NULL,
  target_value DECIMAL(10,2) NULL DEFAULT NULL,
  start_date DATE NULL DEFAULT NULL,
  end_date DATE NULL DEFAULT NULL,
  progress DECIMAL(10,2) NULL DEFAULT NULL,
  notes TEXT NULL DEFAULT NULL,
  PRIMARY KEY (goal_id),
  CONSTRAINT goals_ibfk_1 FOREIGN KEY (member_id) REFERENCES members (member_id));
 
CREATE TABLE IF NOT EXISTS fitness_achievements (
  achievement_id SERIAL,
  member_id INTEGER NULL DEFAULT NULL,
  achievement_date DATE NULL DEFAULT NULL,
  achievement_description TEXT NULL DEFAULT NULL,
  goal_id INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (achievement_id),
  CONSTRAINT fitness_achievements_ibfk_1 FOREIGN KEY (member_id) REFERENCES members (member_id),
  CONSTRAINT fitness_achievements_ibfk_2 FOREIGN KEY (goal_id) REFERENCES goals (goal_id));
 
CREATE TABLE IF NOT EXISTS health_statistics (
  stat_id SERIAL,
  member_id INTEGER NULL DEFAULT NULL,
  date DATE NULL DEFAULT NULL,
  weight DECIMAL(5,2) NULL DEFAULT NULL,
  height DECIMAL(5,2) NULL DEFAULT NULL,
  body_fat_percentage DECIMAL(5,2) NULL DEFAULT NULL,
  blood_pressure_systolic INTEGER NULL DEFAULT NULL,
  blood_pressure_diastolic INTEGER NULL DEFAULT NULL,
  resting_heart_rate INTEGER NULL DEFAULT NULL,
  notes TEXT NULL DEFAULT NULL,
  PRIMARY KEY (stat_id),
  CONSTRAINT health_statistics_ibfk_1 FOREIGN KEY (member_id) REFERENCES members (member_id));
 
CREATE TABLE IF NOT EXISTS payments (
  payment_id SERIAL,
  member_id INTEGER NULL DEFAULT NULL,
  payment_date TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  amount DECIMAL(10,2) NULL DEFAULT NULL,
  payment_method VARCHAR(50) NULL DEFAULT NULL,
  description TEXT NULL DEFAULT NULL,
  PRIMARY KEY (payment_id));
 
CREATE TABLE IF NOT EXISTS room_bookings (
  booking_id SERIAL,
  class_id INTEGER NULL DEFAULT NULL,
  room VARCHAR(50) NULL DEFAULT NULL,
  status VARCHAR(20) NULL DEFAULT NULL,
  booking_date DATE NULL DEFAULT NULL,
  from_time TIME NULL DEFAULT NULL,
  to_time TIME NULL DEFAULT NULL,
  PRIMARY KEY (booking_id));
 
CREATE TABLE IF NOT EXISTS trainers (
  trainer_id SERIAL,
  email VARCHAR(100) NULL DEFAULT NULL UNIQUE,
  first_name VARCHAR(50) NULL DEFAULT NULL,
  last_name VARCHAR(50) NULL DEFAULT NULL,
  gender VARCHAR(15) NULL DEFAULT 'Unspecified',
  specialization VARCHAR(100) NULL DEFAULT NULL,
  bio TEXT NULL DEFAULT NULL,
  profile_picture VARCHAR(255) NULL DEFAULT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (trainer_id)
);

CREATE TYPE session_type_enum AS  ENUM('Personal Training', 'Group Fitness Class');
 
CREATE TABLE IF NOT EXISTS sessions (
  session_id SERIAL,
  trainer_id INTEGER NOT NULL,
  session_type session_type_enum,
  session_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  class_id INTEGER NULL DEFAULT NULL,
  member_id INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (session_id),
  CONSTRAINT sessions_ibfk_1 FOREIGN KEY (trainer_id) REFERENCES trainers (trainer_id),
  CONSTRAINT sessions_ibfk_2 FOREIGN KEY (class_id) REFERENCES classes (class_id),
  CONSTRAINT sessions_ibfk_3 FOREIGN KEY (member_id) REFERENCES members (member_id));