-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: lifeplan_db
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
-- Table structure for table `agent_collection_sequences`
--

DROP TABLE IF EXISTS `agent_collection_sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_collection_sequences` (
  `collection_year` smallint unsigned NOT NULL,
  `next_number` int unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`collection_year`),
  CONSTRAINT `chk_agent_collection_sequence_next` CHECK ((`next_number` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_collection_sequences`
--

LOCK TABLES `agent_collection_sequences` WRITE;
/*!40000 ALTER TABLE `agent_collection_sequences` DISABLE KEYS */;
INSERT INTO `agent_collection_sequences` VALUES (2026,2);
/*!40000 ALTER TABLE `agent_collection_sequences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agent_collections`
--

DROP TABLE IF EXISTS `agent_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_collections` (
  `collection_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `collection_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `agent_id` bigint unsigned NOT NULL,
  `contract_id` bigint unsigned NOT NULL,
  `remittance_id` bigint unsigned DEFAULT NULL,
  `collection_date` datetime NOT NULL,
  `amount_collected` decimal(15,2) NOT NULL,
  `payment_method` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING_REMITTANCE',
  `posted_payment_id` bigint unsigned DEFAULT NULL,
  `recorded_by` bigint unsigned NOT NULL,
  `verified_by` bigint unsigned DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `remarks` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`collection_id`),
  UNIQUE KEY `uq_agent_collection_no` (`collection_no`),
  UNIQUE KEY `uq_agent_collection_payment` (`posted_payment_id`),
  KEY `idx_agent_collection_agent` (`agent_id`,`collection_date`),
  KEY `idx_agent_collection_contract` (`contract_id`),
  KEY `idx_agent_collection_remittance` (`remittance_id`),
  KEY `idx_agent_collection_status` (`status`),
  KEY `fk_agent_collection_recorder` (`recorded_by`),
  KEY `fk_agent_collection_verifier` (`verified_by`),
  CONSTRAINT `fk_agent_collection_agent` FOREIGN KEY (`agent_id`) REFERENCES `collection_agents` (`agent_id`),
  CONSTRAINT `fk_agent_collection_contract` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`contract_id`),
  CONSTRAINT `fk_agent_collection_payment` FOREIGN KEY (`posted_payment_id`) REFERENCES `payments` (`payment_id`),
  CONSTRAINT `fk_agent_collection_recorder` FOREIGN KEY (`recorded_by`) REFERENCES `app_users` (`user_id`),
  CONSTRAINT `fk_agent_collection_remittance` FOREIGN KEY (`remittance_id`) REFERENCES `agent_remittances` (`remittance_id`),
  CONSTRAINT `fk_agent_collection_verifier` FOREIGN KEY (`verified_by`) REFERENCES `app_users` (`user_id`),
  CONSTRAINT `chk_agent_collection_amount` CHECK ((`amount_collected` > 0)),
  CONSTRAINT `chk_agent_collection_method` CHECK ((`payment_method` in (_utf8mb4'CASH',_utf8mb4'BANK_TRANSFER',_utf8mb4'GCASH',_utf8mb4'CHECK',_utf8mb4'OTHER'))),
  CONSTRAINT `chk_agent_collection_status` CHECK ((`status` in (_utf8mb4'PENDING_REMITTANCE',_utf8mb4'SUBMITTED',_utf8mb4'VERIFIED',_utf8mb4'REJECTED',_utf8mb4'POSTED')))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_collections`
--

LOCK TABLES `agent_collections` WRITE;
/*!40000 ALTER TABLE `agent_collections` DISABLE KEYS */;
INSERT INTO `agent_collections` VALUES (1,'AC-2026-000001',1,2,NULL,'2026-11-10 16:00:00',680.00,'GCASH','GCASH-DEMO-001','PENDING_REMITTANCE',NULL,1,NULL,NULL,'Demo collection awaiting remittance.','2026-11-16 10:23:06');
/*!40000 ALTER TABLE `agent_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agent_commission_settings`
--

DROP TABLE IF EXISTS `agent_commission_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_commission_settings` (
  `setting_id` tinyint unsigned NOT NULL,
  `commission_rate_percent` decimal(5,2) NOT NULL DEFAULT '25.00',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`setting_id`),
  CONSTRAINT `chk_agent_commission_rate` CHECK (((`commission_rate_percent` > 0) and (`commission_rate_percent` <= 100)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_commission_settings`
--

LOCK TABLES `agent_commission_settings` WRITE;
/*!40000 ALTER TABLE `agent_commission_settings` DISABLE KEYS */;
INSERT INTO `agent_commission_settings` VALUES (1,25.00,'2026-11-16 10:23:06');
/*!40000 ALTER TABLE `agent_commission_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agent_commissions`
--

DROP TABLE IF EXISTS `agent_commissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_commissions` (
  `commission_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `payment_id` bigint unsigned NOT NULL,
  `agent_id` bigint unsigned NOT NULL,
  `contract_id` bigint unsigned NOT NULL,
  `member_id` bigint unsigned NOT NULL,
  `payment_amount` decimal(15,2) NOT NULL,
  `commission_rate` decimal(5,2) NOT NULL DEFAULT '25.00',
  `commission_amount` decimal(15,2) NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'APPROVED',
  `approved_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `paid_at` datetime DEFAULT NULL,
  `remarks` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`commission_id`),
  UNIQUE KEY `uq_agent_commissions_payment` (`payment_id`),
  KEY `idx_agent_commissions_agent_status` (`agent_id`,`status`),
  KEY `fk_agent_commissions_contract` (`contract_id`),
  KEY `fk_agent_commissions_member` (`member_id`),
  CONSTRAINT `fk_agent_commissions_agent` FOREIGN KEY (`agent_id`) REFERENCES `collection_agents` (`agent_id`),
  CONSTRAINT `fk_agent_commissions_contract` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`contract_id`),
  CONSTRAINT `fk_agent_commissions_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`),
  CONSTRAINT `fk_agent_commissions_payment` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`),
  CONSTRAINT `chk_agent_commissions_amount` CHECK (((`payment_amount` > 0) and (`commission_rate` >= 0) and (`commission_amount` >= 0))),
  CONSTRAINT `chk_agent_commissions_status` CHECK ((`status` in (_utf8mb4'APPROVED',_utf8mb4'PAID')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_commissions`
--

LOCK TABLES `agent_commissions` WRITE;
/*!40000 ALTER TABLE `agent_commissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `agent_commissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agent_member_assignments`
--

DROP TABLE IF EXISTS `agent_member_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_member_assignments` (
  `assignment_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `agent_id` bigint unsigned NOT NULL,
  `member_id` bigint unsigned NOT NULL,
  `assigned_by` bigint unsigned NOT NULL,
  `assigned_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `effective_to` datetime DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE',
  `remarks` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`assignment_id`),
  KEY `idx_agent_assignment_agent` (`agent_id`,`status`),
  KEY `idx_agent_assignment_member` (`member_id`,`status`),
  KEY `fk_agent_assignment_user` (`assigned_by`),
  CONSTRAINT `fk_agent_assignment_agent` FOREIGN KEY (`agent_id`) REFERENCES `collection_agents` (`agent_id`),
  CONSTRAINT `fk_agent_assignment_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`),
  CONSTRAINT `fk_agent_assignment_user` FOREIGN KEY (`assigned_by`) REFERENCES `app_users` (`user_id`),
  CONSTRAINT `chk_agent_assignment_status` CHECK ((`status` in (_utf8mb4'ACTIVE',_utf8mb4'ENDED')))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_member_assignments`
--

LOCK TABLES `agent_member_assignments` WRITE;
/*!40000 ALTER TABLE `agent_member_assignments` DISABLE KEYS */;
INSERT INTO `agent_member_assignments` VALUES (1,1,2,1,'2026-11-02 08:00:00',NULL,'ACTIVE','Demo agent assignment.'),(2,2,3,1,'2026-11-02 08:15:00',NULL,'ACTIVE','Demo agent assignment.');
/*!40000 ALTER TABLE `agent_member_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agent_remittance_sequences`
--

DROP TABLE IF EXISTS `agent_remittance_sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_remittance_sequences` (
  `remittance_year` smallint unsigned NOT NULL,
  `next_number` int unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`remittance_year`),
  CONSTRAINT `chk_agent_remittance_sequence_next` CHECK ((`next_number` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_remittance_sequences`
--

LOCK TABLES `agent_remittance_sequences` WRITE;
/*!40000 ALTER TABLE `agent_remittance_sequences` DISABLE KEYS */;
INSERT INTO `agent_remittance_sequences` VALUES (2026,1);
/*!40000 ALTER TABLE `agent_remittance_sequences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `agent_remittances`
--

DROP TABLE IF EXISTS `agent_remittances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agent_remittances` (
  `remittance_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `remittance_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `agent_id` bigint unsigned NOT NULL,
  `remittance_date` datetime NOT NULL,
  `declared_amount` decimal(15,2) NOT NULL,
  `verified_amount` decimal(15,2) DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SUBMITTED',
  `submitted_by` bigint unsigned NOT NULL,
  `verified_by` bigint unsigned DEFAULT NULL,
  `submitted_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `verified_at` datetime DEFAULT NULL,
  `remarks` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`remittance_id`),
  UNIQUE KEY `uq_agent_remittance_no` (`remittance_no`),
  KEY `idx_agent_remittance_agent` (`agent_id`,`remittance_date`),
  KEY `idx_agent_remittance_status` (`status`),
  KEY `fk_agent_remittance_submitter` (`submitted_by`),
  KEY `fk_agent_remittance_verifier` (`verified_by`),
  CONSTRAINT `fk_agent_remittance_agent` FOREIGN KEY (`agent_id`) REFERENCES `collection_agents` (`agent_id`),
  CONSTRAINT `fk_agent_remittance_submitter` FOREIGN KEY (`submitted_by`) REFERENCES `app_users` (`user_id`),
  CONSTRAINT `fk_agent_remittance_verifier` FOREIGN KEY (`verified_by`) REFERENCES `app_users` (`user_id`),
  CONSTRAINT `chk_agent_remittance_amount` CHECK (((`declared_amount` > 0) and ((`verified_amount` is null) or (`verified_amount` >= 0)))),
  CONSTRAINT `chk_agent_remittance_status` CHECK ((`status` in (_utf8mb4'SUBMITTED',_utf8mb4'VERIFIED',_utf8mb4'REJECTED')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agent_remittances`
--

LOCK TABLES `agent_remittances` WRITE;
/*!40000 ALTER TABLE `agent_remittances` DISABLE KEYS */;
/*!40000 ALTER TABLE `agent_remittances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app_users`
--

DROP TABLE IF EXISTS `app_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_users` (
  `user_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_app_users_username` (`username`),
  CONSTRAINT `chk_app_users_role` CHECK ((`role` in (_utf8mb4'ADMIN',_utf8mb4'ENCODER',_utf8mb4'APPROVER')))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_users`
--

LOCK TABLES `app_users` WRITE;
/*!40000 ALTER TABLE `app_users` DISABLE KEYS */;
INSERT INTO `app_users` VALUES (1,'germar','$2a$12$PISY995WTPO4VR.h6XigAuHLcP2pXFwxHkCIKRpuA7KLVX3FZIokK','germar bunda','ADMIN',1,'2026-10-30 01:11:48','2026-10-30 01:11:48'),(2,'jess','$2a$12$wClyCIG3zByGMQVrlmStxOf7hY0A/smo1e0MQsKWWyE4RsdVAprCe','Jessica Samilin','ENCODER',1,'2026-11-13 11:23:56','2026-11-13 11:23:56');
/*!40000 ALTER TABLE `app_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `audit_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned DEFAULT NULL,
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_role` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `action` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_type` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `old_values` json DEFAULT NULL,
  `new_values` json DEFAULT NULL,
  `reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`audit_id`),
  KEY `idx_audit_user` (`user_id`),
  KEY `idx_audit_entity` (`entity_type`,`entity_id`),
  KEY `idx_audit_action` (`action`),
  KEY `idx_audit_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,1,'germar','ADMIN','SEED','DEMO_DATASET','2026-11',NULL,'{\"agents\": 2, \"members\": 3, \"contracts\": 3, \"installments_per_contract\": 60}','Generated fictional demo dataset after controlled operational-table reset.',NULL,'2026-11-16 10:23:06');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection_agents`
--

DROP TABLE IF EXISTS `collection_agents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collection_agents` (
  `agent_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `agent_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `linked_user_id` bigint unsigned DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`agent_id`),
  UNIQUE KEY `uq_collection_agents_code` (`agent_code`),
  UNIQUE KEY `uq_collection_agents_user` (`linked_user_id`),
  CONSTRAINT `fk_collection_agents_user` FOREIGN KEY (`linked_user_id`) REFERENCES `app_users` (`user_id`),
  CONSTRAINT `chk_collection_agents_status` CHECK ((`status` in (_utf8mb4'ACTIVE',_utf8mb4'INACTIVE')))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection_agents`
--

LOCK TABLES `collection_agents` WRITE;
/*!40000 ALTER TABLE `collection_agents` DISABLE KEYS */;
INSERT INTO `collection_agents` VALUES (1,'AG-2026-0001','Roberto Mendoza','09181234001','General Santos City',NULL,'ACTIVE','2026-11-16 10:23:06',NULL),(2,'AG-2026-0002','Elena Bautista','09181234002','Polomolok, South Cotabato',NULL,'ACTIVE','2026-11-16 10:23:06',NULL);
/*!40000 ALTER TABLE `collection_agents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract_installments`
--

DROP TABLE IF EXISTS `contract_installments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contract_installments` (
  `installment_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` bigint unsigned NOT NULL,
  `installment_no` smallint unsigned NOT NULL,
  `due_date` date NOT NULL,
  `amount_due` decimal(15,2) NOT NULL,
  `amount_paid` decimal(15,2) NOT NULL DEFAULT '0.00',
  `balance_due` decimal(15,2) NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`installment_id`),
  UNIQUE KEY `uq_contract_installment_no` (`contract_id`,`installment_no`),
  KEY `idx_contract_installments_due_date` (`due_date`),
  KEY `idx_contract_installments_status` (`status`),
  CONSTRAINT `fk_contract_installments_contract` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`contract_id`),
  CONSTRAINT `chk_contract_installment_amount` CHECK (((`amount_due` >= 0) and (`amount_paid` >= 0) and (`balance_due` >= 0))),
  CONSTRAINT `chk_contract_installment_no` CHECK ((`installment_no` > 0)),
  CONSTRAINT `chk_contract_installment_status` CHECK ((`status` in (_utf8mb4'PENDING',_utf8mb4'PARTIAL',_utf8mb4'PAID',_utf8mb4'OVERDUE')))
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract_installments`
--

LOCK TABLES `contract_installments` WRITE;
/*!40000 ALTER TABLE `contract_installments` DISABLE KEYS */;
INSERT INTO `contract_installments` VALUES (1,3,1,'2026-12-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(2,2,1,'2026-12-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(3,1,1,'2026-12-01',680.00,680.00,0.00,'PAID','2026-11-01 09:00:00','2026-11-05 10:00:00'),(4,3,2,'2027-01-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(5,2,2,'2027-01-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(6,1,2,'2027-01-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(7,3,3,'2027-02-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(8,2,3,'2027-02-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(9,1,3,'2027-02-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(10,3,4,'2027-03-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(11,2,4,'2027-03-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(12,1,4,'2027-03-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(13,3,5,'2027-04-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(14,2,5,'2027-04-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(15,1,5,'2027-04-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(16,3,6,'2027-05-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(17,2,6,'2027-05-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(18,1,6,'2027-05-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(19,3,7,'2027-06-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(20,2,7,'2027-06-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(21,1,7,'2027-06-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(22,3,8,'2027-07-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(23,2,8,'2027-07-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(24,1,8,'2027-07-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(25,3,9,'2027-08-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(26,2,9,'2027-08-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(27,1,9,'2027-08-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(28,3,10,'2027-09-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(29,2,10,'2027-09-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(30,1,10,'2027-09-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(31,3,11,'2027-10-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(32,2,11,'2027-10-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(33,1,11,'2027-10-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(34,3,12,'2027-11-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(35,2,12,'2027-11-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(36,1,12,'2027-11-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(37,3,13,'2027-12-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(38,2,13,'2027-12-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(39,1,13,'2027-12-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(40,3,14,'2028-01-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(41,2,14,'2028-01-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(42,1,14,'2028-01-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(43,3,15,'2028-02-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(44,2,15,'2028-02-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(45,1,15,'2028-02-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(46,3,16,'2028-03-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(47,2,16,'2028-03-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(48,1,16,'2028-03-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(49,3,17,'2028-04-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(50,2,17,'2028-04-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(51,1,17,'2028-04-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(52,3,18,'2028-05-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(53,2,18,'2028-05-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(54,1,18,'2028-05-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(55,3,19,'2028-06-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(56,2,19,'2028-06-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(57,1,19,'2028-06-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(58,3,20,'2028-07-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(59,2,20,'2028-07-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(60,1,20,'2028-07-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(61,3,21,'2028-08-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(62,2,21,'2028-08-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(63,1,21,'2028-08-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(64,3,22,'2028-09-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(65,2,22,'2028-09-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(66,1,22,'2028-09-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(67,3,23,'2028-10-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(68,2,23,'2028-10-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(69,1,23,'2028-10-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(70,3,24,'2028-11-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(71,2,24,'2028-11-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(72,1,24,'2028-11-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(73,3,25,'2028-12-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(74,2,25,'2028-12-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(75,1,25,'2028-12-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(76,3,26,'2029-01-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(77,2,26,'2029-01-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(78,1,26,'2029-01-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(79,3,27,'2029-02-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(80,2,27,'2029-02-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(81,1,27,'2029-02-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(82,3,28,'2029-03-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(83,2,28,'2029-03-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(84,1,28,'2029-03-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(85,3,29,'2029-04-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(86,2,29,'2029-04-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(87,1,29,'2029-04-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(88,3,30,'2029-05-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(89,2,30,'2029-05-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(90,1,30,'2029-05-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(91,3,31,'2029-06-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(92,2,31,'2029-06-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(93,1,31,'2029-06-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(94,3,32,'2029-07-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(95,2,32,'2029-07-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(96,1,32,'2029-07-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(97,3,33,'2029-08-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(98,2,33,'2029-08-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(99,1,33,'2029-08-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(100,3,34,'2029-09-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(101,2,34,'2029-09-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(102,1,34,'2029-09-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(103,3,35,'2029-10-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(104,2,35,'2029-10-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(105,1,35,'2029-10-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(106,3,36,'2029-11-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(107,2,36,'2029-11-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(108,1,36,'2029-11-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(109,3,37,'2029-12-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(110,2,37,'2029-12-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(111,1,37,'2029-12-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(112,3,38,'2030-01-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(113,2,38,'2030-01-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(114,1,38,'2030-01-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(115,3,39,'2030-02-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(116,2,39,'2030-02-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(117,1,39,'2030-02-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(118,3,40,'2030-03-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(119,2,40,'2030-03-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(120,1,40,'2030-03-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(121,3,41,'2030-04-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(122,2,41,'2030-04-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(123,1,41,'2030-04-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(124,3,42,'2030-05-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(125,2,42,'2030-05-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(126,1,42,'2030-05-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(127,3,43,'2030-06-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(128,2,43,'2030-06-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(129,1,43,'2030-06-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(130,3,44,'2030-07-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(131,2,44,'2030-07-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(132,1,44,'2030-07-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(133,3,45,'2030-08-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(134,2,45,'2030-08-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(135,1,45,'2030-08-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(136,3,46,'2030-09-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(137,2,46,'2030-09-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(138,1,46,'2030-09-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(139,3,47,'2030-10-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(140,2,47,'2030-10-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(141,1,47,'2030-10-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(142,3,48,'2030-11-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(143,2,48,'2030-11-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(144,1,48,'2030-11-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(145,3,49,'2030-12-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(146,2,49,'2030-12-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(147,1,49,'2030-12-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(148,3,50,'2031-01-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(149,2,50,'2031-01-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(150,1,50,'2031-01-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(151,3,51,'2031-02-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(152,2,51,'2031-02-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(153,1,51,'2031-02-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(154,3,52,'2031-03-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(155,2,52,'2031-03-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(156,1,52,'2031-03-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(157,3,53,'2031-04-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(158,2,53,'2031-04-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(159,1,53,'2031-04-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(160,3,54,'2031-05-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(161,2,54,'2031-05-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(162,1,54,'2031-05-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(163,3,55,'2031-06-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(164,2,55,'2031-06-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(165,1,55,'2031-06-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(166,3,56,'2031-07-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(167,2,56,'2031-07-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(168,1,56,'2031-07-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(169,3,57,'2031-08-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(170,2,57,'2031-08-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(171,1,57,'2031-08-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(172,3,58,'2031-09-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(173,2,58,'2031-09-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(174,1,58,'2031-09-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(175,3,59,'2031-10-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(176,2,59,'2031-10-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(177,1,59,'2031-10-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(178,3,60,'2031-11-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(179,2,60,'2031-11-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL),(180,1,60,'2031-11-01',680.00,0.00,680.00,'PENDING','2026-11-01 09:00:00',NULL);
/*!40000 ALTER TABLE `contract_installments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contracts`
--

DROP TABLE IF EXISTS `contracts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contracts` (
  `contract_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `contract_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `member_id` bigint unsigned NOT NULL,
  `rate_version_id` bigint unsigned NOT NULL,
  `contract_date` date NOT NULL,
  `total_price_snapshot` decimal(15,2) NOT NULL,
  `down_payment_snapshot` decimal(15,2) NOT NULL,
  `term_months_snapshot` smallint unsigned NOT NULL,
  `monthly_installment_snapshot` decimal(15,2) NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `created_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`contract_id`),
  UNIQUE KEY `uq_contracts_contract_no` (`contract_no`),
  KEY `idx_contracts_member_date` (`member_id`,`contract_date`),
  KEY `idx_contracts_rate_version` (`rate_version_id`),
  KEY `idx_contracts_status` (`status`),
  CONSTRAINT `fk_contracts_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`),
  CONSTRAINT `fk_contracts_rate_version` FOREIGN KEY (`rate_version_id`) REFERENCES `plan_rate_versions` (`rate_version_id`),
  CONSTRAINT `chk_contracts_down_payment` CHECK (((`down_payment_snapshot` >= 0) and (`down_payment_snapshot` <= `total_price_snapshot`))),
  CONSTRAINT `chk_contracts_status` CHECK ((`status` in (_utf8mb4'DRAFT',_utf8mb4'ACTIVE',_utf8mb4'CANCELLED',_utf8mb4'LAPSED'))),
  CONSTRAINT `chk_contracts_term` CHECK ((`term_months_snapshot` > 0)),
  CONSTRAINT `chk_contracts_total_price` CHECK ((`total_price_snapshot` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contracts`
--

LOCK TABLES `contracts` WRITE;
/*!40000 ALTER TABLE `contracts` DISABLE KEYS */;
INSERT INTO `contracts` VALUES (1,'LP-2026-000001-C01',1,6,'2026-11-01',40800.00,0.00,60,680.00,'ACTIVE','germar','2026-11-16 10:23:06',NULL),(2,'LP-2026-000002-C01',2,6,'2026-11-01',40800.00,0.00,60,680.00,'ACTIVE','germar','2026-11-16 10:23:06',NULL),(3,'LP-2026-000003-C01',3,6,'2026-11-01',40800.00,0.00,60,680.00,'ACTIVE','germar','2026-11-16 10:23:06',NULL);
/*!40000 ALTER TABLE `contracts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_application_history`
--

DROP TABLE IF EXISTS `member_application_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_application_history` (
  `history_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `application_id` bigint unsigned NOT NULL,
  `action` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `actor_user_id` bigint unsigned NOT NULL,
  `actor_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `actor_role` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `remarks` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`history_id`),
  KEY `idx_application_history` (`application_id`,`created_at`),
  KEY `fk_application_history_actor` (`actor_user_id`),
  CONSTRAINT `fk_application_history_actor` FOREIGN KEY (`actor_user_id`) REFERENCES `app_users` (`user_id`),
  CONSTRAINT `fk_application_history_application` FOREIGN KEY (`application_id`) REFERENCES `member_applications` (`application_id`),
  CONSTRAINT `chk_application_history_action` CHECK ((`action` in (_utf8mb4'SUBMITTED',_utf8mb4'APPROVED',_utf8mb4'REJECTED')))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_application_history`
--

LOCK TABLES `member_application_history` WRITE;
/*!40000 ALTER TABLE `member_application_history` DISABLE KEYS */;
INSERT INTO `member_application_history` VALUES (1,1,'SUBMITTED',1,'germar bunda','ADMIN','Demo application submitted.','2026-10-28 08:30:00'),(2,1,'APPROVED',1,'germar bunda','ADMIN','Approved; contract created.','2026-11-01 09:00:00'),(3,2,'SUBMITTED',1,'germar bunda','ADMIN','Demo application submitted.','2026-10-29 08:30:00'),(4,2,'APPROVED',1,'germar bunda','ADMIN','Approved; contract created.','2026-11-01 09:15:00'),(5,3,'SUBMITTED',1,'germar bunda','ADMIN','Demo application submitted.','2026-10-30 08:30:00'),(6,3,'APPROVED',1,'germar bunda','ADMIN','Approved; contract created.','2026-11-01 09:30:00');
/*!40000 ALTER TABLE `member_application_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_applications`
--

DROP TABLE IF EXISTS `member_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_applications` (
  `application_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `application_no` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `member_id` bigint unsigned NOT NULL,
  `rate_version_id` bigint unsigned NOT NULL,
  `application_date` date NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING_APPROVAL',
  `submitted_by` bigint unsigned NOT NULL,
  `reviewed_by` bigint unsigned DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `contract_id` bigint unsigned DEFAULT NULL,
  `remarks` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`application_id`),
  UNIQUE KEY `uq_member_applications_no` (`application_no`),
  UNIQUE KEY `uq_member_applications_contract` (`contract_id`),
  KEY `idx_applications_member` (`member_id`),
  KEY `idx_applications_status` (`status`),
  KEY `idx_applications_rate` (`rate_version_id`),
  KEY `fk_application_submitter` (`submitted_by`),
  KEY `fk_application_reviewer` (`reviewed_by`),
  CONSTRAINT `fk_application_contract` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`contract_id`),
  CONSTRAINT `fk_application_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`),
  CONSTRAINT `fk_application_rate` FOREIGN KEY (`rate_version_id`) REFERENCES `plan_rate_versions` (`rate_version_id`),
  CONSTRAINT `fk_application_reviewer` FOREIGN KEY (`reviewed_by`) REFERENCES `app_users` (`user_id`),
  CONSTRAINT `fk_application_submitter` FOREIGN KEY (`submitted_by`) REFERENCES `app_users` (`user_id`),
  CONSTRAINT `chk_application_status` CHECK ((`status` in (_utf8mb4'PENDING_APPROVAL',_utf8mb4'APPROVED',_utf8mb4'REJECTED')))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_applications`
--

LOCK TABLES `member_applications` WRITE;
/*!40000 ALTER TABLE `member_applications` DISABLE KEYS */;
INSERT INTO `member_applications` VALUES (1,'APP-2026-000001',1,6,'2026-10-28','APPROVED',1,1,'2026-11-01 09:00:00',1,'Demo application approved.','2026-11-16 10:23:06',NULL),(2,'APP-2026-000002',2,6,'2026-10-29','APPROVED',1,1,'2026-11-01 09:15:00',2,'Demo application approved.','2026-11-16 10:23:06',NULL),(3,'APP-2026-000003',3,6,'2026-10-30','APPROVED',1,1,'2026-11-01 09:30:00',3,'Demo application approved.','2026-11-16 10:23:06',NULL);
/*!40000 ALTER TABLE `member_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_number_sequences`
--

DROP TABLE IF EXISTS `member_number_sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_number_sequences` (
  `registration_year` smallint unsigned NOT NULL,
  `next_number` int unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`registration_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_number_sequences`
--

LOCK TABLES `member_number_sequences` WRITE;
/*!40000 ALTER TABLE `member_number_sequences` DISABLE KEYS */;
INSERT INTO `member_number_sequences` VALUES (0,4),(2026,4);
/*!40000 ALTER TABLE `member_number_sequences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `member_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `member_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `middle_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `suffix` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `sex` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `civil_status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `uq_members_member_no` (`member_no`),
  KEY `idx_members_name` (`last_name`,`first_name`),
  KEY `idx_members_contact` (`contact_no`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (1,'MSA00001','Maria','Isabel','Santos',NULL,'1988-04-12','Female','Married','09171234501','maria.santos@example.test','General Santos City','ACTIVE','2026-11-16 10:23:06','2026-11-20 14:24:39'),(2,'MSA00002','Juan','Miguel','Dela Cruz',NULL,'1992-09-23','Male','Single','09171234502','juan.delacruz@example.test','Polomolok, South Cotabato','ACTIVE','2026-11-16 10:23:06','2026-11-20 14:24:39'),(3,'MSA00003','Ana','Marie','Reyes',NULL,'1985-01-30','Female','Married','09171234503','ana.reyes@example.test','Koronadal City, South Cotabato','ACTIVE','2026-11-16 10:23:06','2026-11-20 14:24:39');
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_allocations`
--

DROP TABLE IF EXISTS `payment_allocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_allocations` (
  `allocation_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `payment_id` bigint unsigned NOT NULL,
  `installment_id` bigint unsigned NOT NULL,
  `amount_allocated` decimal(15,2) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`allocation_id`),
  UNIQUE KEY `uq_payment_installment` (`payment_id`,`installment_id`),
  KEY `idx_allocation_installment` (`installment_id`),
  CONSTRAINT `fk_allocation_installment` FOREIGN KEY (`installment_id`) REFERENCES `contract_installments` (`installment_id`),
  CONSTRAINT `fk_allocation_payment` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`payment_id`),
  CONSTRAINT `chk_allocation_amount` CHECK ((`amount_allocated` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_allocations`
--

LOCK TABLES `payment_allocations` WRITE;
/*!40000 ALTER TABLE `payment_allocations` DISABLE KEYS */;
INSERT INTO `payment_allocations` VALUES (1,1,3,680.00,'2026-11-05 10:00:00');
/*!40000 ALTER TABLE `payment_allocations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_receipt_sequences`
--

DROP TABLE IF EXISTS `payment_receipt_sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_receipt_sequences` (
  `receipt_year` smallint unsigned NOT NULL,
  `next_number` int unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`receipt_year`),
  CONSTRAINT `chk_receipt_next_number` CHECK ((`next_number` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_receipt_sequences`
--

LOCK TABLES `payment_receipt_sequences` WRITE;
/*!40000 ALTER TABLE `payment_receipt_sequences` DISABLE KEYS */;
INSERT INTO `payment_receipt_sequences` VALUES (2026,2);
/*!40000 ALTER TABLE `payment_receipt_sequences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `receipt_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contract_id` bigint unsigned NOT NULL,
  `payment_date` datetime NOT NULL,
  `amount_received` decimal(15,2) NOT NULL,
  `payment_method` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `collection_channel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DIRECT',
  `collected_by_user_id` bigint unsigned DEFAULT NULL,
  `received_by_user_id` bigint unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `uq_payments_receipt_no` (`receipt_no`),
  KEY `idx_payments_contract_date` (`contract_id`,`payment_date`),
  KEY `idx_payments_collector` (`collected_by_user_id`),
  KEY `fk_payments_receiver` (`received_by_user_id`),
  CONSTRAINT `fk_payments_collector` FOREIGN KEY (`collected_by_user_id`) REFERENCES `app_users` (`user_id`),
  CONSTRAINT `fk_payments_contract` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`contract_id`),
  CONSTRAINT `fk_payments_receiver` FOREIGN KEY (`received_by_user_id`) REFERENCES `app_users` (`user_id`),
  CONSTRAINT `chk_payments_amount` CHECK ((`amount_received` > 0)),
  CONSTRAINT `chk_payments_channel` CHECK ((`collection_channel` in (_utf8mb4'DIRECT',_utf8mb4'AGENT'))),
  CONSTRAINT `chk_payments_method` CHECK ((`payment_method` in (_utf8mb4'CASH',_utf8mb4'BANK_TRANSFER',_utf8mb4'GCASH',_utf8mb4'CHECK',_utf8mb4'OTHER')))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,'OR-2026-000001',1,'2026-11-05 10:00:00',680.00,'CASH',NULL,'DIRECT',NULL,1,'2026-11-16 10:23:06');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plan_products`
--

DROP TABLE IF EXISTS `plan_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plan_products` (
  `plan_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `plan_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `plan_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`plan_id`),
  UNIQUE KEY `uq_plan_products_code` (`plan_code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plan_products`
--

LOCK TABLES `plan_products` WRITE;
/*!40000 ALTER TABLE `plan_products` DISABLE KEYS */;
INSERT INTO `plan_products` VALUES (1,'BRONZE','Bronze Plan','Initial Bronze plan configuration','ACTIVE','2026-10-29 23:54:52','2026-10-29 23:54:52'),(2,'SILVER','Silver Plan','Silver plan test','ACTIVE','2026-10-30 00:23:27','2026-10-30 00:23:27'),(5,'GOLD','Gold Plan','Gold Life Plan - 60 months','ACTIVE','2026-10-31 20:58:24','2026-10-31 20:58:24');
/*!40000 ALTER TABLE `plan_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plan_rate_approval_history`
--

DROP TABLE IF EXISTS `plan_rate_approval_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plan_rate_approval_history` (
  `history_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `rate_version_id` bigint unsigned NOT NULL,
  `action` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `actor_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `actor_role` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `remarks` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`history_id`),
  KEY `idx_rate_approval_history` (`rate_version_id`,`created_at`),
  CONSTRAINT `fk_rate_approval_history_version` FOREIGN KEY (`rate_version_id`) REFERENCES `plan_rate_versions` (`rate_version_id`),
  CONSTRAINT `chk_rate_approval_action` CHECK ((`action` in (_utf8mb4'SUBMITTED',_utf8mb4'APPROVED',_utf8mb4'REJECTED',_utf8mb4'RESUBMITTED')))
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plan_rate_approval_history`
--

LOCK TABLES `plan_rate_approval_history` WRITE;
/*!40000 ALTER TABLE `plan_rate_approval_history` DISABLE KEYS */;
INSERT INTO `plan_rate_approval_history` VALUES (9,5,'SUBMITTED','Lenovo','SUBMITTER','Submitted through Plans & Pricing window.','2026-10-31 21:01:02'),(10,6,'SUBMITTED','Lenovo','SUBMITTER','Submitted through Plans & Pricing window.','2026-10-31 21:01:13'),(11,7,'SUBMITTED','Lenovo','SUBMITTER','Submitted through Plans & Pricing window.','2026-10-31 21:01:23'),(12,5,'APPROVED','germar','ADMIN','Approved','2026-10-31 21:03:04'),(13,7,'APPROVED','germar','ADMIN','Approved','2026-10-31 21:03:17'),(14,6,'APPROVED','germar','ADMIN','Approved','2026-10-31 21:03:24');
/*!40000 ALTER TABLE `plan_rate_approval_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plan_rate_versions`
--

DROP TABLE IF EXISTS `plan_rate_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plan_rate_versions` (
  `rate_version_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `plan_id` bigint unsigned NOT NULL,
  `version_no` int unsigned NOT NULL,
  `total_price` decimal(15,2) NOT NULL,
  `down_payment` decimal(15,2) NOT NULL DEFAULT '0.00',
  `term_months` smallint unsigned NOT NULL,
  `effective_from` date NOT NULL,
  `effective_to` date DEFAULT NULL,
  `approval_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `approved_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rate_version_id`),
  UNIQUE KEY `uq_plan_rate_version` (`plan_id`,`version_no`),
  KEY `idx_plan_rate_effective` (`plan_id`,`effective_from`),
  CONSTRAINT `fk_rate_plan` FOREIGN KEY (`plan_id`) REFERENCES `plan_products` (`plan_id`),
  CONSTRAINT `chk_rate_down_payment` CHECK (((`down_payment` >= 0) and (`down_payment` <= `total_price`))),
  CONSTRAINT `chk_rate_price` CHECK ((`total_price` >= 0)),
  CONSTRAINT `chk_rate_term` CHECK ((`term_months` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plan_rate_versions`
--

LOCK TABLES `plan_rate_versions` WRITE;
/*!40000 ALTER TABLE `plan_rate_versions` DISABLE KEYS */;
INSERT INTO `plan_rate_versions` VALUES (5,1,2,33000.00,0.00,60,'2026-10-31',NULL,'APPROVED','2026-10-31 21:03:04','2026-10-31 20:58:24'),(6,2,2,40800.00,0.00,60,'2026-10-31',NULL,'APPROVED','2026-10-31 21:03:24','2026-10-31 20:58:24'),(7,5,1,48000.00,0.00,60,'2026-10-31',NULL,'APPROVED','2026-10-31 21:03:17','2026-10-31 20:58:24');
/*!40000 ALTER TABLE `plan_rate_versions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-20 16:57:54
