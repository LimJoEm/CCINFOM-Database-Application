-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema hospitaldb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema hospitaldb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `hospitaldb` DEFAULT CHARACTER SET utf8mb3 ;
USE `hospitaldb` ;

-- -----------------------------------------------------
-- Table `hospitaldb`.`rooms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitaldb`.`rooms` (
  `room_id` INT NOT NULL,
  `room_type` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`room_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `hospitaldb`.`bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitaldb`.`bookings` (
  `booking_id` INT NOT NULL,
  `room_id` INT NULL DEFAULT NULL,
  `start_time` TIMESTAMP NULL DEFAULT NULL,
  `end_time` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`booking_id`),
  INDEX `room_fk_idx` (`room_id` ASC) VISIBLE,
  CONSTRAINT `room_fk`
    FOREIGN KEY (`room_id`)
    REFERENCES `hospitaldb`.`rooms` (`room_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `hospitaldb`.`departments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitaldb`.`departments` (
  `department_id` INT NOT NULL,
  `department_name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`department_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `hospitaldb`.`staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitaldb`.`staff` (
  `staff_id` INT NOT NULL,
  `last_name` VARCHAR(45) NULL DEFAULT NULL,
  `first_name` VARCHAR(45) NULL DEFAULT NULL,
  `department_id` INT NULL DEFAULT NULL,
  `start_time` TIME NULL DEFAULT NULL,
  `end_time` TIME NULL DEFAULT NULL,
  `contact_no` VARCHAR(11) NULL DEFAULT NULL,
  PRIMARY KEY (`staff_id`),
  INDEX `department_id_fk_idx` (`department_id` ASC) VISIBLE,
  CONSTRAINT `department_id_fk`
    FOREIGN KEY (`department_id`)
    REFERENCES `hospitaldb`.`departments` (`department_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `hospitaldb`.`doctors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitaldb`.`doctors` (
  `doctors_id` INT NOT NULL,
  `staff_id` INT NULL DEFAULT NULL,
  `specialty` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`doctors_id`),
  INDEX `staff_fk_idx` (`staff_id` ASC) VISIBLE,
  CONSTRAINT `staff_fk`
    FOREIGN KEY (`staff_id`)
    REFERENCES `hospitaldb`.`staff` (`staff_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `hospitaldb`.`patients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitaldb`.`patients` (
  `patient_id` INT NOT NULL,
  `first_name` VARCHAR(45) NULL DEFAULT NULL,
  `last_name` VARCHAR(45) NULL DEFAULT NULL,
  `date_of_birth` DATE NULL DEFAULT NULL,
  `age` INT NULL DEFAULT NULL,
  `gender` VARCHAR(45) NULL DEFAULT NULL,
  `contact_no` VARCHAR(11) NULL DEFAULT NULL,
  PRIMARY KEY (`patient_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `hospitaldb`.`appointments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitaldb`.`appointments` (
  `appointment_id` INT NOT NULL,
  `booking_id` INT NULL DEFAULT NULL,
  `doctor_id` INT NULL DEFAULT NULL,
  `patient_id` INT NULL DEFAULT NULL,
  `appointment_date` TIMESTAMP NULL DEFAULT NULL,
  `start_time` TIME NULL DEFAULT NULL,
  `end_time` TIME NULL DEFAULT NULL,
  `status` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`appointment_id`),
  INDEX `booking_fk_idx` (`booking_id` ASC) VISIBLE,
  INDEX `doctor_id_idx` (`doctor_id` ASC) VISIBLE,
  INDEX `patient_id_idx` (`patient_id` ASC) VISIBLE,
  CONSTRAINT `booking_fk`
    FOREIGN KEY (`booking_id`)
    REFERENCES `hospitaldb`.`bookings` (`booking_id`),
  CONSTRAINT `doctor_id`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `hospitaldb`.`doctors` (`doctors_id`),
  CONSTRAINT `patient_id`
    FOREIGN KEY (`patient_id`)
    REFERENCES `hospitaldb`.`patients` (`patient_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `hospitaldb`.`hospital_equipments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitaldb`.`hospital_equipments` (
  `equipment_id` INT NOT NULL,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`equipment_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `hospitaldb`.`equipment_booking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitaldb`.`equipment_booking` (
  `equipmentBookingID` INT NOT NULL,
  `equipmentID` INT NULL DEFAULT NULL,
  `booking_id` INT NULL DEFAULT NULL,
  `equipment_bookingcol` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`equipmentBookingID`),
  INDEX `fk_bookings_idx` (`booking_id` ASC) VISIBLE,
  INDEX `fk_equipment_idx` (`equipmentID` ASC) VISIBLE,
  CONSTRAINT `fk_bookings`
    FOREIGN KEY (`booking_id`)
    REFERENCES `hospitaldb`.`bookings` (`booking_id`),
  CONSTRAINT `fk_equipment`
    FOREIGN KEY (`equipmentID`)
    REFERENCES `hospitaldb`.`hospital_equipments` (`equipment_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `hospitaldb`.`medical_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospitaldb`.`medical_history` (
  `caseID` INT NOT NULL,
  `patient_ID` INT NULL DEFAULT NULL,
  `diagnosis` VARCHAR(45) NULL DEFAULT NULL,
  `medication` VARCHAR(45) NULL DEFAULT NULL,
  `height` INT NULL DEFAULT NULL,
  `weight` INT NULL DEFAULT NULL,
  PRIMARY KEY (`caseID`),
  INDEX `patientFK_idx` (`patient_ID` ASC) VISIBLE,
  CONSTRAINT `patientFK`
    FOREIGN KEY (`patient_ID`)
    REFERENCES `hospitaldb`.`patients` (`patient_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = '	';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
