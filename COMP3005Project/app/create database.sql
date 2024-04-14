-- -----------------------------------------------------
-- Schema health_fitness_club
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS health_fitness_club;
USE health_fitness_club ;

-- -----------------------------------------------------
-- Table accounts
-- -----------------------------------------------------
DROP TABLE IF EXISTS accounts ;

CREATE TABLE IF NOT EXISTS accounts (
  user_id INT NOT NULL AUTO_INCREMENT,
  username VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL,
  member_id INT NOT NULL,
  PRIMARY KEY (user_id),
  UNIQUE INDEX username (username ASC) VISIBLE
);


-- -----------------------------------------------------
-- Table admins
-- -----------------------------------------------------
DROP TABLE IF EXISTS admins ;

CREATE TABLE IF NOT EXISTS admins (
  admin_id INT NOT NULL AUTO_INCREMENT,
  email VARCHAR(100) NULL DEFAULT NULL,
  first_name VARCHAR(50) NULL DEFAULT NULL,
  last_name VARCHAR(50) NULL DEFAULT NULL,
  profile_picture VARCHAR(255) NULL DEFAULT NULL,
  is_active TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (admin_id),
  UNIQUE INDEX email (email ASC) VISIBLE
);


-- -----------------------------------------------------
-- Table class_members
-- -----------------------------------------------------
DROP TABLE IF EXISTS class_members ;

CREATE TABLE IF NOT EXISTS class_members (
  class_id INT NOT NULL,
  member_id INT NOT NULL,
  date_joined DATE NULL DEFAULT NULL,
  PRIMARY KEY (class_id, member_id)
)
ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table classes
-- -----------------------------------------------------
DROP TABLE IF EXISTS classes ;

CREATE TABLE IF NOT EXISTS classes (
  class_id INT NOT NULL AUTO_INCREMENT,
  class_name VARCHAR(100) NULL DEFAULT NULL,
  description TEXT NULL DEFAULT NULL,
  trainer_id INT NULL DEFAULT NULL,
  class_day VARCHAR(25) NOT NULL,
  class_time TIME NULL DEFAULT NULL,
  duration_min INT NULL DEFAULT NULL,
  max_capacity INT NULL DEFAULT NULL,
  PRIMARY KEY (class_id)
);


-- -----------------------------------------------------
-- Table equipment_maintenance
-- -----------------------------------------------------
DROP TABLE IF EXISTS equipment_maintenance ;

CREATE TABLE IF NOT EXISTS equipment_maintenance (
  equipment_id INT NOT NULL AUTO_INCREMENT,
  admin_id INT NULL DEFAULT NULL,
  equipment_name VARCHAR(100) NULL DEFAULT NULL,
  last_maintenance_description TEXT NULL DEFAULT NULL,
  last_maintenance_date DATE NULL DEFAULT NULL,
  current_condition VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (equipment_id)
);


-- -----------------------------------------------------
-- Table members
-- -----------------------------------------------------
DROP TABLE IF EXISTS members ;

CREATE TABLE IF NOT EXISTS members (
  member_id INT NOT NULL AUTO_INCREMENT,
  email VARCHAR(100) NULL DEFAULT NULL,
  first_name VARCHAR(50) NULL DEFAULT NULL,
  last_name VARCHAR(50) NULL DEFAULT NULL,
  gender VARCHAR(15) NULL DEFAULT 'Unspecified',
  birthdate DATE NULL DEFAULT NULL,
  phone_number VARCHAR(20) NULL DEFAULT NULL,
  address VARCHAR(255) NULL DEFAULT NULL,
  registration_date TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  membership_type VARCHAR(20) NULL DEFAULT NULL,
  profile_picture VARCHAR(255) NULL DEFAULT NULL,
  is_active TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (member_id),
  UNIQUE INDEX email (email ASC) VISIBLE
);


-- -----------------------------------------------------
-- Table exercise_routines
-- -----------------------------------------------------
DROP TABLE IF EXISTS exercise_routines ;

CREATE TABLE IF NOT EXISTS exercise_routines (
  routine_id INT NOT NULL,
  member_id INT NOT NULL,
  exercise_name TEXT NOT NULL,
  sets INT NOT NULL,
  reps INT NOT NULL,
  weight INT NOT NULL,
  day_of_week TEXT NOT NULL,
  PRIMARY KEY (routine_id),
  INDEX member_id (member_id ASC) VISIBLE,
  CONSTRAINT exercise_routines_ibfk_1
    FOREIGN KEY (member_id) REFERENCES members (member_id)
)


-- -----------------------------------------------------
-- Table goals
-- -----------------------------------------------------
DROP TABLE IF EXISTS goals ;

CREATE TABLE IF NOT EXISTS goals (
  goal_id INT NOT NULL AUTO_INCREMENT,
  member_id INT NULL DEFAULT NULL,
  goal_type VARCHAR(100) NULL DEFAULT NULL,
  target_value DECIMAL(10,2) NULL DEFAULT NULL,
  start_date DATE NULL DEFAULT NULL,
  end_date DATE NULL DEFAULT NULL,
  progress DECIMAL(10,2) NULL DEFAULT NULL,
  notes TEXT NULL DEFAULT NULL,
  PRIMARY KEY (goal_id),
  INDEX member_id (member_id ASC) VISIBLE,
  CONSTRAINT goals_ibfk_1 
    FOREIGN KEY (member_id) REFERENCES members (member_id)
);


-- -----------------------------------------------------
-- Table fitness_achievements
-- -----------------------------------------------------
DROP TABLE IF EXISTS fitness_achievements ;

CREATE TABLE IF NOT EXISTS fitness_achievements (
  achievement_id INT NOT NULL AUTO_INCREMENT,
  member_id INT NULL DEFAULT NULL,
  achievement_date DATE NULL DEFAULT NULL,
  achievement_description TEXT NULL DEFAULT NULL,
  goal_id INT NULL DEFAULT NULL,
  PRIMARY KEY (achievement_id),
  INDEX member_id (member_id ASC) VISIBLE,
  INDEX goal_id (goal_id ASC) VISIBLE,
  CONSTRAINT fitness_achievements_ibfk_1
    FOREIGN KEY (member_id) REFERENCES members (member_id),
  CONSTRAINT fitness_achievements_ibfk_2
    FOREIGN KEY (goal_id) REFERENCES goals (goal_id)
);


-- -----------------------------------------------------
-- Table health_statistics
-- -----------------------------------------------------
DROP TABLE IF EXISTS health_statistics ;

CREATE TABLE IF NOT EXISTS health_statistics (
  stat_id INT NOT NULL AUTO_INCREMENT,
  member_id INT NULL DEFAULT NULL,
  date DATE NULL DEFAULT NULL,
  weight DECIMAL(5,2) NULL DEFAULT NULL,
  height DECIMAL(5,2) NULL DEFAULT NULL,
  body_fat_percentage DECIMAL(5,2) NULL DEFAULT NULL,
  blood_pressure_systolic INT NULL DEFAULT NULL,
  blood_pressure_diastolic INT NULL DEFAULT NULL,
  resting_heart_rate INT NULL DEFAULT NULL,
  notes TEXT NULL DEFAULT NULL,
  PRIMARY KEY (stat_id),
  INDEX member_id (member_id ASC) VISIBLE,
  CONSTRAINT health_statistics_ibfk_1
    FOREIGN KEY (member_id) REFERENCES members (member_id)
);


-- -----------------------------------------------------
-- Table payments
-- -----------------------------------------------------
DROP TABLE IF EXISTS payments ;

CREATE TABLE IF NOT EXISTS payments (
  payment_id INT NOT NULL AUTO_INCREMENT,
  member_id INT NULL DEFAULT NULL,
  payment_date TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  amount DECIMAL(10,2) NULL DEFAULT NULL,
  payment_method VARCHAR(50) NULL DEFAULT NULL,
  description TEXT NULL DEFAULT NULL,
  PRIMARY KEY (payment_id)
);


-- -----------------------------------------------------
-- Table room_bookings
-- -----------------------------------------------------
DROP TABLE IF EXISTS room_bookings ;

CREATE TABLE IF NOT EXISTS room_bookings (
  booking_id INT NOT NULL AUTO_INCREMENT,
  class_id INT NULL DEFAULT NULL,
  room VARCHAR(50) NULL DEFAULT NULL,
  status VARCHAR(20) NULL DEFAULT NULL,
  booking_date DATE NULL DEFAULT NULL,
  from_time TIME NULL DEFAULT NULL,
  to_time TIME NULL DEFAULT NULL,
  PRIMARY KEY (booking_id)
);


-- -----------------------------------------------------
-- Table trainers
-- -----------------------------------------------------
DROP TABLE IF EXISTS trainers ;

CREATE TABLE IF NOT EXISTS trainers (
  trainer_id INT NOT NULL AUTO_INCREMENT,
  email VARCHAR(100) NULL DEFAULT NULL,
  first_name VARCHAR(50) NULL DEFAULT NULL,
  last_name VARCHAR(50) NULL DEFAULT NULL,
  gender VARCHAR(15) NULL DEFAULT 'Unspecified',
  specialization VARCHAR(100) NULL DEFAULT NULL,
  bio TEXT NULL DEFAULT NULL,
  profile_picture VARCHAR(255) NULL DEFAULT NULL,
  is_active TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (trainer_id),
  UNIQUE INDEX email (email ASC) VISIBLE
);


-- -----------------------------------------------------
-- Table sessions
-- -----------------------------------------------------
DROP TABLE IF EXISTS sessions ;

CREATE TABLE IF NOT EXISTS sessions (
  session_id INT NOT NULL AUTO_INCREMENT,
  trainer_id INT NOT NULL,
  session_type ENUM('Personal Training', 'Group Fitness Class') NOT NULL,
  session_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  class_id INT NULL DEFAULT NULL,
  member_id INT NULL DEFAULT NULL,
  PRIMARY KEY (session_id),
  INDEX trainer_id (trainer_id ASC) VISIBLE,
  INDEX class_id (class_id ASC) VISIBLE,
  INDEX member_id (member_id ASC) VISIBLE,
  CONSTRAINT sessions_ibfk_1
    FOREIGN KEY (trainer_id) REFERENCES trainers (trainer_id),
  CONSTRAINT sessions_ibfk_2
    FOREIGN KEY (class_id) REFERENCES classes (class_id),
  CONSTRAINT sessions_ibfk_3
    FOREIGN KEY (member_id) REFERENCES members (member_id)
);

