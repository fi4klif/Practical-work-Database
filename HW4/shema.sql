-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: mydb
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Table structure for table `authorbook`
--

DROP TABLE IF EXISTS `authorbook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authorbook` (
  `AuthorID` int NOT NULL,
  `BookID` int NOT NULL,
  `AuthorOrder` int DEFAULT NULL,
  PRIMARY KEY (`AuthorID`,`BookID`),
  KEY `fk_Author_has_Books_Books1_idx` (`BookID`),
  KEY `fk_Author_has_Books_Author1_idx` (`AuthorID`),
  CONSTRAINT `fk_Author_has_Books_Author1` FOREIGN KEY (`AuthorID`) REFERENCES `authors` (`AuthorID`),
  CONSTRAINT `fk_Author_has_Books_Books1` FOREIGN KEY (`BookID`) REFERENCES `books` (`BookID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authorbook`
--

LOCK TABLES `authorbook` WRITE;
/*!40000 ALTER TABLE `authorbook` DISABLE KEYS */;
INSERT INTO `authorbook` VALUES (1,1,1),(2,2,1),(3,3,1),(4,4,1),(5,5,1),(6,6,1),(7,7,1),(8,8,1),(9,9,1),(10,10,1);
/*!40000 ALTER TABLE `authorbook` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `authors`
--

DROP TABLE IF EXISTS `authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authors` (
  `AuthorID` int NOT NULL AUTO_INCREMENT,
  `Country` varchar(100) DEFAULT NULL,
  `Name` varchar(200) NOT NULL,
  `Phone` varchar(50) DEFAULT NULL,
  `Email` varchar(255) NOT NULL,
  PRIMARY KEY (`AuthorID`),
  UNIQUE KEY `email_UNIQUE` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authors`
--

LOCK TABLES `authors` WRITE;
/*!40000 ALTER TABLE `authors` DISABLE KEYS */;
INSERT INTO `authors` VALUES (1,'Ukraine','Ірина Савчук','+380501111111','iryna.savchuk@ex.com'),(2,'Ukraine','Олег Петренко','+380671111112','oleg.petrenko@ex.com'),(3,'Italy','Maria Rossi','+39061111111','m.rossi@ex.com'),(4,'France','Jean Martin','+33111111111','jean.martin@ex.com'),(5,'Switzerland','Anna Müller','+41441111111','anna.mueller@ex.com'),(6,'Switzerland','Lukas Steiner','+41441111112','lukas.steiner@ex.com'),(7,'Spain','Sofia Garcia','+34911111111','sofia.garcia@ex.com'),(8,'USA','Noah Johnson','+12025550111','noah.johnson@ex.com'),(9,'Japan','Akira Tanaka','+81311111111','akira.tanaka@ex.com'),(10,'Czechia','Eva Novak','+42021111111','eva.novak@ex.com');
/*!40000 ALTER TABLE `authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `BookID` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(300) NOT NULL,
  `Genre` varchar(100) DEFAULT NULL,
  `ISBN` varchar(32) NOT NULL,
  `PublishYear` year DEFAULT NULL,
  PRIMARY KEY (`BookID`),
  UNIQUE KEY `ISBN_UNIQUE` (`ISBN`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'Python для початківців','Навчальна','978-0-100000-001',2023),(2,'SQL на практиці','Навчальна','978-0-100000-002',2024),(3,'Data Analytics 101','Навчальна','978-0-100000-003',2025),(4,'Story Craft','Fiction','978-0-100000-004',2022),(5,'Mountains & Lakes','Travel','978-0-100000-005',2021),(6,'AI for Editors','Technology','978-0-100000-006',2025),(7,'Clean Data','Non-Fiction','978-0-100000-007',2020),(8,'Sci-Fi Tales','Sci-Fi','978-0-100000-008',2019),(9,'Business Blue','Business','978-0-100000-009',2024),(10,'Creative SQL','Technology','978-0-100000-010',2023);
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contracts`
--

DROP TABLE IF EXISTS `contracts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contracts` (
  `ContractID` int NOT NULL AUTO_INCREMENT,
  `EmployeeID` int DEFAULT NULL,
  `ContractType` enum('Author','Employee') NOT NULL,
  `StartDate` date NOT NULL,
  `EndDate` date DEFAULT NULL,
  `AuthorID` int DEFAULT NULL,
  PRIMARY KEY (`ContractID`),
  KEY `fk_Contracts_Author_idx` (`AuthorID`),
  CONSTRAINT `fk_Contracts_Author` FOREIGN KEY (`AuthorID`) REFERENCES `authors` (`AuthorID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contracts`
--

LOCK TABLES `contracts` WRITE;
/*!40000 ALTER TABLE `contracts` DISABLE KEYS */;
INSERT INTO `contracts` VALUES (1,NULL,'Author','2025-01-01','2025-12-31',1),(2,NULL,'Author','2025-02-01',NULL,3),(3,NULL,'Author','2025-03-01',NULL,5),(4,NULL,'Author','2025-03-15','2026-03-15',9),(5,NULL,'Author','2025-04-01',NULL,10),(6,1,'Employee','2025-01-10',NULL,NULL),(7,2,'Employee','2025-02-10','2025-12-31',NULL),(8,3,'Employee','2025-03-05',NULL,NULL),(9,5,'Employee','2025-03-20',NULL,NULL),(10,10,'Employee','2025-04-15',NULL,NULL);
/*!40000 ALTER TABLE `contracts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employeebook`
--

DROP TABLE IF EXISTS `employeebook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employeebook` (
  `BookID` int NOT NULL,
  `EmployeeID` int NOT NULL,
  `Task` enum('Edit','Proofread','Translate','Design') DEFAULT NULL,
  PRIMARY KEY (`BookID`,`EmployeeID`),
  KEY `fk_Books_has_Employees_Employees1_idx` (`EmployeeID`),
  KEY `fk_Books_has_Employees_Books1_idx` (`BookID`),
  CONSTRAINT `fk_Books_has_Employees_Books1` FOREIGN KEY (`BookID`) REFERENCES `books` (`BookID`),
  CONSTRAINT `fk_Books_has_Employees_Employees1` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employeebook`
--

LOCK TABLES `employeebook` WRITE;
/*!40000 ALTER TABLE `employeebook` DISABLE KEYS */;
INSERT INTO `employeebook` VALUES (1,1,'Edit'),(2,2,'Proofread'),(3,3,'Translate'),(4,4,'Design'),(5,5,'Edit'),(6,6,'Proofread'),(7,7,'Translate'),(8,8,'Design'),(9,9,'Edit'),(10,10,'Proofread');
/*!40000 ALTER TABLE `employeebook` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `EmployeeID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  `Role` enum('Editor','Proofreader','Translator','Designer') NOT NULL,
  `Email` varchar(225) DEFAULT NULL,
  PRIMARY KEY (`EmployeeID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,'Alice Novak','Editor','alice@pub.ch'),(2,'Bohdan Petrenko','Proofreader','bohdan@pub.ch'),(3,'Chloe Martin','Translator','chloe@pub.ch'),(4,'Dmytro Savchuk','Designer','dmytro@pub.ch'),(5,'Emma Rossi','Editor','emma@pub.ch'),(6,'Felix Weber','Proofreader','felix@pub.ch'),(7,'Hanna Kovalenko','Translator','hanna@pub.ch'),(8,'Ivan Horak','Designer','ivan@pub.ch'),(9,'Julia Novakova','Editor','julia@pub.ch'),(10,'Karl Meier','Proofreader','karl@pub.ch');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderitem`
--

DROP TABLE IF EXISTS `orderitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderitem` (
  `OrderItemID` int NOT NULL AUTO_INCREMENT,
  `BookID` int NOT NULL,
  `Quantity` int NOT NULL,
  `OrderID` int NOT NULL,
  `UnitPrice` decimal(10,2) NOT NULL,
  PRIMARY KEY (`OrderItemID`),
  KEY `fk_Orders_has_Books_Books1_idx` (`BookID`),
  KEY `fk_Orders_has_Books_Orders1_idx` (`OrderItemID`),
  CONSTRAINT `fk_Orders_has_Books_Books1` FOREIGN KEY (`BookID`) REFERENCES `books` (`BookID`),
  CONSTRAINT `fk_Orders_has_Books_Orders1` FOREIGN KEY (`OrderItemID`) REFERENCES `orders` (`OrderID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderitem`
--

LOCK TABLES `orderitem` WRITE;
/*!40000 ALTER TABLE `orderitem` DISABLE KEYS */;
INSERT INTO `orderitem` VALUES (1,1,3,1,49.90),(2,2,2,2,59.00),(3,3,1,3,39.50),(4,4,5,4,29.90),(5,5,4,5,54.00),(6,6,3,6,46.00),(7,7,2,7,32.00),(8,8,6,8,52.50),(9,9,2,9,28.90),(10,10,7,10,44.00);
/*!40000 ALTER TABLE `orderitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `OrderID` int NOT NULL AUTO_INCREMENT,
  `OrderDate` date NOT NULL,
  `ClientName` varchar(200) NOT NULL,
  `Status` enum('New','InProgress','Completed','Canceled') NOT NULL,
  PRIMARY KEY (`OrderID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'2025-01-10','TechBooks GmbH','New'),(2,'2025-01-15','EduLab SA','Completed'),(3,'2025-02-01','DataWorks AG','InProgress'),(4,'2025-02-18','Libra LLC','Completed'),(5,'2025-03-03','Orion Labs','New'),(6,'2025-03-20','Pixel Media','InProgress'),(7,'2025-04-05','QuickLearn','Completed'),(8,'2025-04-22','Read&Co','New'),(9,'2025-05-09','Star Books','Completed'),(10,'2025-05-25','Nova Print','Canceled');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-01 14:31:43
