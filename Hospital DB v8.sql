-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: hospitaldb
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `appointment_id` int NOT NULL,
  `booking_id` int DEFAULT NULL,
  `doctor_id` int DEFAULT NULL,
  `patient_id` int DEFAULT NULL,
  `appointment_date` timestamp NULL DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`appointment_id`),
  KEY `booking_fk_idx` (`booking_id`),
  KEY `doctor_id_idx` (`doctor_id`),
  KEY `patient_id_idx` (`patient_id`),
  CONSTRAINT `booking_fk` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`),
  CONSTRAINT `doctor_id` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctors_id`),
  CONSTRAINT `patient_id` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES (443005,773005,134004,224003,'2024-12-04 08:00:00','15:00:00','15:30:00',1),(443006,773006,134005,224004,'2024-11-17 08:00:00','13:00:00','13:30:00',1),(443007,773007,134006,224005,'2024-12-01 08:00:00','10:00:00','10:30:00',1),(443008,773008,NULL,224006,'2024-12-14 08:00:00','11:00:00','11:30:00',1),(443009,773009,134001,224007,'2024-11-25 08:00:00','12:00:00','12:30:00',1),(443010,773010,134002,224007,'2024-12-06 08:00:00','13:00:00','13:30:00',1),(443011,773011,134003,224008,'2024-11-29 08:00:00','14:00:00','14:30:00',1),(443012,773012,134004,224008,'2024-12-11 08:00:00','15:00:00','15:30:00',1),(443013,773013,134005,224009,'2024-11-20 08:00:00','16:00:00','16:30:00',1),(443014,773014,134006,224009,'2024-12-08 08:00:00','17:00:00','17:30:00',1),(443015,773015,NULL,224010,'2024-12-13 08:00:00','10:00:00','10:30:00',1),(443016,773016,134001,224010,'2024-11-27 08:00:00','11:00:00','11:30:00',1),(443017,773017,134002,224011,'2024-11-28 08:00:00','12:00:00','12:30:00',1),(443018,773018,134003,224011,'2024-12-10 08:00:00','13:00:00','13:30:00',1),(443019,773019,134004,224012,'2024-11-22 08:00:00','14:00:00','14:30:00',1),(443020,773020,134005,224012,'2024-12-03 08:00:00','15:00:00','15:30:00',1),(443021,773021,134006,224013,'2024-11-18 08:00:00','16:00:00','16:30:00',1),(443022,773022,NULL,224013,'2024-12-02 08:00:00','17:00:00','17:30:00',1),(443024,773024,134002,224014,'2024-12-05 08:00:00','11:00:00','11:30:00',1),(443025,773025,134003,224015,'2024-11-26 08:00:00','12:00:00','12:30:00',1),(443026,773026,134004,224015,'2024-12-07 08:00:00','13:00:00','13:30:00',1),(443027,773027,134005,224016,'2024-11-28 08:00:00','14:00:00','14:30:00',1),(443028,773028,134006,224016,'2024-12-12 08:00:00','15:00:00','15:30:00',1),(443029,773029,NULL,224017,'2024-11-20 08:00:00','16:00:00','16:30:00',1),(443030,773030,134001,224017,'2024-12-09 08:00:00','17:00:00','17:30:00',1),(443031,773031,134001,224004,'2024-11-21 08:30:07','16:30:00','06:29:00',1),(443032,773032,134002,224004,'2024-11-21 08:31:34','16:32:00','04:31:00',1),(443033,773033,134001,224004,'2024-11-21 08:31:59','16:32:00','04:31:00',1),(443034,773034,134001,224004,'2024-11-21 08:35:42','16:35:00','04:35:00',1),(443035,773035,134001,224003,'2024-11-21 08:37:41','16:37:00','04:37:00',1),(443036,773036,134001,224009,'2024-11-21 08:41:35','16:41:00','04:41:00',1),(443037,773037,134013,224017,'2024-11-21 08:47:28','04:47:00','16:47:00',0);
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `booking_id` int NOT NULL,
  `room_id` int DEFAULT NULL,
  `start_time` timestamp NULL DEFAULT NULL,
  `end_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`booking_id`),
  KEY `room_fk_idx` (`room_id`),
  CONSTRAINT `room_fk` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (773001,663001,'2024-11-13 17:00:00','2024-11-13 18:00:00'),(773002,663002,'2024-11-14 19:00:00','2024-11-14 20:00:00'),(773005,663005,'2024-11-17 18:30:00','2024-11-17 19:30:00'),(773006,663006,'2024-11-18 20:00:00','2024-11-18 21:00:00'),(773007,663007,'2024-11-19 23:00:00','2024-11-20 00:00:00'),(773008,663008,'2024-11-20 17:30:00','2024-11-20 18:30:00'),(773009,663009,'2024-11-21 22:00:00','2024-11-21 23:00:00'),(773010,663010,'2024-11-23 00:00:00','2024-11-23 01:00:00'),(773011,663011,'2024-11-23 18:00:00','2024-11-23 19:00:00'),(773012,663012,'2024-11-24 21:00:00','2024-11-24 22:00:00'),(773013,663013,'2024-11-25 22:00:00','2024-11-25 23:00:00'),(773014,663014,'2024-11-27 00:00:00','2024-11-27 01:00:00'),(773015,663015,'2024-11-27 18:30:00','2024-11-27 19:30:00'),(773016,663016,'2024-11-28 20:00:00','2024-11-28 21:00:00'),(773017,663017,'2024-11-29 23:00:00','2024-11-30 00:00:00'),(773018,663018,'2024-11-30 16:00:00','2024-11-30 17:00:00'),(773019,663019,'2024-12-01 22:00:00','2024-12-01 23:00:00'),(773020,663020,'2024-12-03 00:30:00','2024-12-03 01:30:00'),(773021,663021,'2024-12-03 19:00:00','2024-12-03 20:00:00'),(773022,663022,'2024-12-04 21:30:00','2024-12-04 22:30:00'),(773024,663024,'2024-12-06 22:30:00','2024-12-06 23:30:00'),(773025,663025,'2024-12-08 00:00:00','2024-12-08 01:00:00'),(773026,663026,'2024-12-08 18:00:00','2024-12-08 19:00:00'),(773027,663027,'2024-12-09 21:30:00','2024-12-09 22:30:00'),(773028,663028,'2024-12-10 23:30:00','2024-12-11 00:30:00'),(773029,663029,'2024-12-11 18:00:00','2024-12-11 19:00:00'),(773030,663030,'2024-12-12 22:00:00','2024-12-12 23:00:00'),(773031,663001,'2024-11-21 08:30:00','2024-11-21 22:29:00'),(773032,663002,'2024-10-29 08:32:00','2024-10-29 20:31:00'),(773033,663001,'2024-10-29 08:32:00','2024-10-29 20:31:00'),(773034,663002,'2024-11-21 08:35:00','2024-11-21 20:35:00'),(773035,663002,'2024-11-21 08:37:00','2024-11-21 20:37:00'),(773036,663002,'2024-11-21 08:41:00','2024-11-21 20:41:00'),(773037,663019,'2024-11-21 20:47:00','2024-11-21 08:47:00'),(773045,663002,'2024-11-29 16:00:00','2024-11-29 17:00:00');
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `department_id` int NOT NULL,
  `department_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`department_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (993001,'Cardiology'),(993002,'Neurology'),(993003,'Orthopedics'),(993004,'Pediatrics'),(993005,'Oncology'),(993006,'Dermatology'),(993007,'Endocrinology'),(993008,'Gastroenterology'),(993009,'Hematology'),(993010,'Nephrology');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctors`
--

DROP TABLE IF EXISTS `doctors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctors` (
  `doctors_id` int NOT NULL,
  `staff_id` int DEFAULT NULL,
  `specialty` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`doctors_id`),
  KEY `staff_fk_idx` (`staff_id`),
  CONSTRAINT `staff_fk` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctors`
--

LOCK TABLES `doctors` WRITE;
/*!40000 ALTER TABLE `doctors` DISABLE KEYS */;
INSERT INTO `doctors` VALUES (134001,124001,'Cardiology'),(134002,124002,'Neurology'),(134003,124003,'Orthopedics'),(134004,124004,'Pediatrics'),(134005,124005,'Oncology'),(134006,124006,'Dermatology'),(134008,124008,'Gastroenterology'),(134009,124009,'Hematology'),(134010,124010,'Nephrology'),(134011,124011,'Ophthalmology'),(134012,124012,'Psychiatry'),(134013,124013,'Rheumatology'),(134014,124014,'Surgery'),(134015,124015,'Urology');
/*!40000 ALTER TABLE `doctors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipment_booking`
--

DROP TABLE IF EXISTS `equipment_booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipment_booking` (
  `equipmentBookingID` int NOT NULL,
  `equipmentID` int DEFAULT NULL,
  `booking_id` int DEFAULT NULL,
  `equipment_bookingcol` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`equipmentBookingID`),
  KEY `fk_bookings_idx` (`booking_id`),
  KEY `fk_equipment_idx` (`equipmentID`),
  CONSTRAINT `fk_bookings` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`),
  CONSTRAINT `fk_equipment` FOREIGN KEY (`equipmentID`) REFERENCES `hospital_equipments` (`equipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipment_booking`
--

LOCK TABLES `equipment_booking` WRITE;
/*!40000 ALTER TABLE `equipment_booking` DISABLE KEYS */;
INSERT INTO `equipment_booking` VALUES (883001,553028,773001,NULL),(883002,553015,773002,NULL),(883003,553002,773002,NULL),(883010,553011,773005,NULL),(883011,553021,773005,NULL),(883012,553005,773005,NULL),(883013,553007,773006,NULL),(883014,553016,773006,NULL),(883015,553022,773006,NULL),(883016,553001,773037,NULL),(883017,553002,773037,NULL);
/*!40000 ALTER TABLE `equipment_booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hospital_equipments`
--

DROP TABLE IF EXISTS `hospital_equipments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hospital_equipments` (
  `equipment_id` int NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`equipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hospital_equipments`
--

LOCK TABLES `hospital_equipments` WRITE;
/*!40000 ALTER TABLE `hospital_equipments` DISABLE KEYS */;
INSERT INTO `hospital_equipments` VALUES (553001,'ECG Machine'),(553002,'Ultrasound Machine'),(553003,'X-Ray Machine'),(553004,'MRI Scanner'),(553005,'CT Scanner'),(553006,'Infusion Pump'),(553007,'Ventilator'),(553008,'Defibrillator'),(553009,'Patient Monitor'),(553010,'Anesthesia Machine'),(553011,'ECG Machine 2'),(553012,'Ultrasound Machine 2'),(553013,'X-Ray Machine 2'),(553014,'MRI Scanner 2'),(553015,'CT Scanner 2'),(553016,'Infusion Pump 2'),(553017,'Ventilator 2'),(553018,'Defibrillator 2'),(553019,'Patient Monitor 2'),(553020,'Anesthesia Machine 2'),(553021,'ECG Machine 3'),(553022,'Ultrasound Machine 3'),(553023,'X-Ray Machine 3'),(553024,'MRI Scanner 3'),(553025,'CT Scanner 3'),(553026,'Infusion Pump 3'),(553027,'Ventilator 3'),(553028,'Defibrillator 3'),(553029,'Patient Monitor 3'),(553030,'Anesthesia Machine 3');
/*!40000 ALTER TABLE `hospital_equipments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medical_history`
--

DROP TABLE IF EXISTS `medical_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medical_history` (
  `caseID` int NOT NULL,
  `patient_ID` int DEFAULT NULL,
  `diagnosis` varchar(45) DEFAULT NULL,
  `medication` varchar(45) DEFAULT NULL,
  `height` int DEFAULT NULL,
  `weight` int DEFAULT NULL,
  PRIMARY KEY (`caseID`),
  KEY `patientFK_idx` (`patient_ID`),
  CONSTRAINT `patientFK` FOREIGN KEY (`patient_ID`) REFERENCES `patients` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='	';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_history`
--

LOCK TABLES `medical_history` WRITE;
/*!40000 ALTER TABLE `medical_history` DISABLE KEYS */;
INSERT INTO `medical_history` VALUES (334004,224003,'Migraine','Ibuprofen',160,55),(334005,224003,'Allergy','Loratadine',160,55),(334006,224004,'Chronic Pain','Morphine',180,85),(334007,224005,'Arthritis','Ibuprofen',165,60),(334008,224006,'Back Pain','Naproxen',172,78),(334009,224007,'Anxiety','Sertraline',180,88),(334010,224008,'Insomnia','Zolpidem',170,75);
/*!40000 ALTER TABLE `medical_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients` (
  `patient_id` int NOT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `age` int DEFAULT NULL,
  `gender` varchar(45) DEFAULT NULL,
  `contact_no` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (224003,'Alex','Johnson','1985-12-11',39,'M','09170815402'),(224004,'Emily','Davis','1979-07-01',45,'F','09170261619'),(224005,'Chris','Brown','1991-03-16',33,'M','09170861890'),(224006,'Katie','Wilson','1987-10-30',37,'F','09170524594'),(224007,'Liam','Miller','1990-01-25',34,'M','09170037298'),(224008,'Sophia','Garcia','1983-04-12',41,'F','09170612711'),(224009,'Noah','Martinez','1988-09-15',36,'M','09170951663'),(224010,'Olivia','Rodriguez','1995-02-28',29,'F','09170920181'),(224011,'James','Hernandez','1978-11-04',46,'M','09170745916'),(224012,'Ava','Lopez','1993-06-20',31,'F','09170969040'),(224013,'Elijah','Gonzalez','1982-05-07',42,'M','09170607449'),(224014,'Mia','Wilson','1996-08-23',28,'F','09170130127'),(224015,'William','Anderson','1984-01-12',40,'M','09170828290'),(224016,'Isabella','Thomas','1990-10-10',34,'F','09170751070'),(224017,'Mason','Taylor','1987-09-18',37,'M','09170270480'),(224018,'Evelyn','Moore','1989-03-08',35,'F','09170099190'),(224019,'Logan','Jackson','1981-07-14',43,'M','09170684511'),(224020,'Harper','Martin','1994-12-29',29,'F','09170124986'),(224021,'Benjamin','Lee','1985-11-25',39,'M','09170571398'),(224022,'Ella','Perez','1997-02-17',27,'F','09170482034'),(224023,'Lucas','White','1986-06-03',38,'M','09170695974'),(224024,'Scarlett','Harris','1991-05-15',33,'F','09170033768'),(224025,'Jackson','Clark','1979-10-24',45,'M','09170080921'),(224026,'Victoria','Lewis','1983-03-19',41,'F','09170303299'),(224027,'Sebastian','Walker','1992-07-28',32,'M','09170273734'),(224028,'Grace','Hall','1995-11-09',29,'F','09170458774'),(224029,'Jack','Allen','1980-09-02',44,'M','09170472667'),(224030,'Lily','Young','1984-04-25',40,'F','09170987015'),(224031,'Aiden','King','1988-01-06',36,'M','09170517073'),(224032,'Chloe','Scott','1991-08-31',33,'F','09170624320'),(224033,'Matthew','Green','1977-12-01',47,'M','09170570381'),(224034,'Zoey','Baker','1993-04-14',31,'F','09170978947'),(224035,'Henry','Adams','1986-11-23',38,'M','09170183592'),(224036,'Hannah','Nelson','1989-10-11',35,'F','09170981120'),(224037,'David','Carter','1982-07-20',42,'M','09170354826'),(224038,'Ella','Mitchell','1996-01-18',28,'F','09170830770'),(224040,'Aria','Roberts','1990-06-30',34,'F','09170954546'),(224041,'Doe','John','1990-01-01',34,'Male','09178888888'),(224042,'Doe','John','1985-06-15',39,'M','12345678901'),(224043,'Doe','John','1985-06-15',39,'M','12345678901'),(224044,'bin Laden','osama','1957-03-10',54,'M','09173333333'),(224045,'Jung','Wooyoung','2024-10-26',28,'M','12121222111'),(224046,'Jung','Wooyoung','2024-11-23',28,'M','12121222111');
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `room_id` int NOT NULL,
  `room_type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (663001,'Operating Room'),(663002,'ICU'),(663003,'ER'),(663004,'Radiology'),(663005,'Patient Ward'),(663006,'Laboratory'),(663007,'Recovery Room'),(663008,'Pediatric Ward'),(663009,'Maternity Ward'),(663010,'Isolation Room'),(663011,'Operating Room 2'),(663012,'ICU 2'),(663013,'ER 2'),(663014,'Radiology 2'),(663015,'Patient Ward 2'),(663016,'Laboratory 2'),(663017,'Recovery Room 2'),(663018,'Pediatric Ward 2'),(663019,'Maternity Ward 2'),(663020,'Isolation Room 2'),(663021,'Operating Room 3'),(663022,'ICU 3'),(663023,'ER 3'),(663024,'Radiology 3'),(663025,'Patient Ward 3'),(663026,'Laboratory 3'),(663027,'Recovery Room 3'),(663028,'Pediatric Ward 3'),(663029,'Maternity Ward 3'),(663030,'Isolation Room 3');
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `staff_id` int NOT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `contact_no` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`staff_id`),
  KEY `department_id_fk_idx` (`department_id`),
  CONSTRAINT `department_id_fk` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (124001,'Smith','John',993001,'08:00:00','16:00:00','09170755916'),(124002,'Johnson','Alice',993002,'09:00:00','17:00:00','09170659856'),(124003,'Williams','Michael',993003,'07:30:00','15:30:00','09170031535'),(124004,'Brown','Mary',993001,'10:00:00','18:00:00','09170178104'),(124005,'Jones','Robert',993002,'08:30:00','16:30:00','09170795916'),(124006,'Garcia','Linda',993004,'07:00:00','15:00:00','09170445269'),(124008,'Davis','Elizabeth',993003,'09:00:00','17:00:00','09170857177'),(124009,'Lopez','Richard',993002,'07:30:00','15:30:00','09170770098'),(124010,'Gonzalez','Barbara',993001,'10:00:00','18:00:00','09170278958'),(124011,'Wilson','Charles',993004,'08:30:00','16:30:00','09170084496'),(124012,'Anderson','Jessica',993005,'07:00:00','15:00:00','09170585607'),(124013,'Thomas','Christopher',993001,'08:00:00','16:00:00','09170674546'),(124014,'Taylor','Sarah',993002,'09:00:00','17:00:00','09170615909'),(124015,'Moore','Daniel',993003,'07:30:00','15:30:00','09170055907'),(124016,'Jackson','Laura',993001,'10:00:00','18:00:00','09170431811'),(124017,'Martin','Brian',993004,'08:30:00','16:30:00','09170991335'),(124018,'Lee','Karen',993005,'07:00:00','15:00:00','09170661241'),(124019,'Perez','Matthew',993002,'08:00:00','16:00:00','09170332200'),(124020,'Thompson','Nancy',993003,'09:00:00','17:00:00','09170677280'),(124021,'White','Patricia',993004,'07:30:00','15:30:00','09170389797'),(124022,'Harris','Kevin',993001,'10:00:00','18:00:00','09170917148'),(124023,'Sanchez','Jennifer',993005,'08:30:00','16:30:00','09170416348'),(124024,'Clark','George',993001,'07:00:00','15:00:00','09170330297'),(124025,'Ramirez','Betty',993002,'08:00:00','16:00:00','09170402444'),(124026,'Lewis','Joshua',993003,'09:00:00','17:00:00','09170021327'),(124027,'Robinson','Sandra',993004,'07:30:00','15:30:00','09170899303'),(124028,'Walker','Jason',993005,'10:00:00','18:00:00','09170432534'),(124029,'Young','Amber',993003,'08:30:00','16:30:00','09170464762'),(124030,'King','Pamela',993004,'07:00:00','15:00:00','09170026207'),(124031,'bin Laden','osama',993001,'07:30:00','16:10:00','09173333333');
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-23 21:34:41
