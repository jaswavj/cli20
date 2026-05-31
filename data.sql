/*
SQLyog Community v13.3.1 (64 bit)
MySQL - 8.4.7 : Database - teabench
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`teabench` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `teabench`;

/*Table structure for table `attendance` */

DROP TABLE IF EXISTS `attendance`;

CREATE TABLE `attendance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `entry_date` date NOT NULL,
  `in_time` time DEFAULT NULL,
  `out_time` time DEFAULT NULL,
  `in_time2` time DEFAULT NULL,
  `out_time2` time DEFAULT NULL,
  `in_time3` time DEFAULT NULL,
  `out_time3` time DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `attendance` */

insert  into `attendance`(`id`,`user_id`,`entry_date`,`in_time`,`out_time`,`in_time2`,`out_time2`,`in_time3`,`out_time3`,`created_at`,`updated_at`) values 
(7,1,'2026-05-31','14:50:07','14:55:13','14:55:16','15:50:18','16:50:21','17:50:23','2026-05-31 14:50:07','2026-05-31 14:51:15');

/*Table structure for table `attender` */

DROP TABLE IF EXISTS `attender`;

CREATE TABLE `attender` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `is_active` int DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `attender` */

/*Table structure for table `company_details` */

DROP TABLE IF EXISTS `company_details`;

CREATE TABLE `company_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `shop_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `address` text,
  `gstin` varchar(255) DEFAULT NULL,
  `print_type` int NOT NULL DEFAULT '0',
  `printer_name` varchar(255) DEFAULT NULL,
  `bank_details` varchar(255) DEFAULT NULL,
  `barcode_printer` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `company_details` */

insert  into `company_details`(`id`,`shop_name`,`address`,`gstin`,`print_type`,`printer_name`,`bank_details`,`barcode_printer`) values 
(2,'Javera Collections','4,TSMO Syed Ali Nagar\r\nKurichi Main Road\r\nTirunelveli-627005','',2,'','Bank name:SBI\r\nNo : 74748499\r\nIFSC:37ADD','AP4909');

/*Table structure for table `configure_bank_details` */

DROP TABLE IF EXISTS `configure_bank_details`;

CREATE TABLE `configure_bank_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `is_blocked` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Data for the table `configure_bank_details` */

insert  into `configure_bank_details`(`id`,`name`,`is_blocked`) values 
(1,'SBI BANK',0),
(2,'CANARA BANK',0),
(3,'AXIS BANK',0),
(4,'IOB BANK',0);

/*Table structure for table `configure_payment_type` */

DROP TABLE IF EXISTS `configure_payment_type`;

CREATE TABLE `configure_payment_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `is_blocked` int unsigned NOT NULL DEFAULT '0',
  `type_id` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `configure_payment_type` */

insert  into `configure_payment_type`(`id`,`name`,`is_blocked`,`type_id`) values 
(1,'Cash',0,1),
(2,'BANK',0,2);

/*Table structure for table `credit_days` */

DROP TABLE IF EXISTS `credit_days`;

CREATE TABLE `credit_days` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `credit_days` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `credit_days` */

insert  into `credit_days`(`id`,`credit_days`) values 
(1,10);

/*Table structure for table `customers` */

DROP TABLE IF EXISTS `customers`;

CREATE TABLE `customers` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `is_eligible_for_commission` tinyint DEFAULT '1',
  `is_active` int DEFAULT '1',
  `gstin` varchar(255) DEFAULT NULL,
  `is_gst` int DEFAULT '0',
  `salesman` int DEFAULT NULL,
  `area` int DEFAULT NULL,
  `credit_limit` double(10,2) NOT NULL DEFAULT '0.00',
  `local` int DEFAULT '1',
  `exchange_point` double(10,3) DEFAULT '0.000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `customers` */

insert  into `customers`(`id`,`name`,`phone_number`,`address`,`date`,`time`,`is_eligible_for_commission`,`is_active`,`gstin`,`is_gst`,`salesman`,`area`,`credit_limit`,`local`,`exchange_point`) values 
(1,'aa','-','','2026-05-27','22:00:23',0,1,'',0,NULL,NULL,0.00,1,0.000),
(2,'a','-','','2026-05-27','22:01:00',0,1,'',0,NULL,NULL,0.00,1,0.000),
(3,'sd','333333333','','2026-05-31','15:18:46',0,1,'',0,NULL,NULL,0.00,1,0.000),
(4,'ss','-','','2026-05-31','16:36:49',0,1,'',0,NULL,NULL,0.00,1,0.000);

/*Table structure for table `customers_exchange_point` */

DROP TABLE IF EXISTS `customers_exchange_point`;

CREATE TABLE `customers_exchange_point` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `bill_id` int NOT NULL,
  `old_point` double(10,3) DEFAULT '0.000',
  `exchange_point` double(10,3) DEFAULT '0.000',
  `total_point` double(10,3) DEFAULT '0.000',
  `uid` int DEFAULT NULL,
  `date_time` datetime DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `customers_exchange_point` */

/*Table structure for table `day_closer` */

DROP TABLE IF EXISTS `day_closer`;

CREATE TABLE `day_closer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `closer_date` date NOT NULL,
  `opening_balance` decimal(12,2) NOT NULL DEFAULT '0.00',
  `closing_balance` decimal(12,2) DEFAULT NULL,
  `total_sale` decimal(12,2) DEFAULT NULL,
  `purchase` decimal(12,2) DEFAULT NULL,
  `expense` decimal(12,2) DEFAULT NULL,
  `notes` text,
  `opening_bal_datetime` datetime NOT NULL,
  `closing_bal_datetime` datetime DEFAULT NULL,
  `opening_user_id` int NOT NULL,
  `closing_user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `closer_date` (`closer_date`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `day_closer` */

insert  into `day_closer`(`id`,`closer_date`,`opening_balance`,`closing_balance`,`total_sale`,`purchase`,`expense`,`notes`,`opening_bal_datetime`,`closing_bal_datetime`,`opening_user_id`,`closing_user_id`) values 
(1,'2026-05-31',100.00,62.00,32.00,90.00,15.00,'hh','2026-05-31 15:14:03','2026-05-31 15:32:09',1,1);

/*Table structure for table `expense_entry` */

DROP TABLE IF EXISTS `expense_entry`;

CREATE TABLE `expense_entry` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `exp_type` int NOT NULL,
  `content` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` text,
  `exc_date_time` datetime DEFAULT NULL,
  `entry_date_time` datetime DEFAULT NULL,
  `is_active` int DEFAULT '1',
  `uid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type` (`exp_type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `expense_entry` */

insert  into `expense_entry`(`id`,`exp_type`,`content`,`amount`,`description`,`exc_date_time`,`entry_date_time`,`is_active`,`uid`) values 
(1,1,'fd',15.00,'df','2026-05-31 15:20:00','2026-05-31 15:20:14',1,1);

/*Table structure for table `expense_type` */

DROP TABLE IF EXISTS `expense_type`;

CREATE TABLE `expense_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `is_active` int DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `expense_type` */

insert  into `expense_type`(`id`,`type`,`is_active`) values 
(1,'s',1);

/*Table structure for table `gstin` */

DROP TABLE IF EXISTS `gstin`;

CREATE TABLE `gstin` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `gstin` varchar(255) NOT NULL,
  `shop_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `gstin` */

/*Table structure for table `heading` */

DROP TABLE IF EXISTS `heading`;

CREATE TABLE `heading` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `head1` varchar(255) DEFAULT NULL,
  `head2` varchar(255) DEFAULT NULL,
  `head3` varchar(255) DEFAULT NULL,
  `active` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `heading` */

insert  into `heading`(`id`,`head1`,`head2`,`head3`,`active`) values 
(1,'Category','Brand','Product',200);

/*Table structure for table `order_tables` */

DROP TABLE IF EXISTS `order_tables`;

CREATE TABLE `order_tables` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `is_occupied` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `order_tables` */

insert  into `order_tables`(`id`,`name`,`is_occupied`) values 
(1,'table1',0),
(2,'table2',0),
(3,'table3',0);

/*Table structure for table `pro_bill_exchange` */

DROP TABLE IF EXISTS `pro_bill_exchange`;

CREATE TABLE `pro_bill_exchange` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL,
  `customer_id` int NOT NULL,
  `old_prod_id` int NOT NULL,
  `new_prod_id` int NOT NULL,
  `uid` int NOT NULL,
  `date_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `pro_bill_exchange` */

/*Table structure for table `prod_batch` */

DROP TABLE IF EXISTS `prod_batch`;

CREATE TABLE `prod_batch` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `product_id` int NOT NULL,
  `cost` double(10,3) DEFAULT '0.000',
  `mrp` double(10,3) DEFAULT '0.000',
  `commission` double(10,3) DEFAULT '0.000',
  `stock` decimal(10,2) NOT NULL,
  `disc_type` int DEFAULT '0' COMMENT '1=rs 2=%',
  `discount` double(10,3) DEFAULT '0.000',
  `date` date DEFAULT NULL,
  `time` time DEFAULT '00:00:00',
  `added_stock` decimal(10,2) NOT NULL,
  `uid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `prod` (`product_id`),
  KEY `disc` (`disc_type`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

/*Data for the table `prod_batch` */

insert  into `prod_batch`(`id`,`name`,`product_id`,`cost`,`mrp`,`commission`,`stock`,`disc_type`,`discount`,`date`,`time`,`added_stock`,`uid`) values 
(1,'Z101',1,90.000,90.000,0.000,1.00,0,0.000,'2026-05-27','21:50:09',0.00,1),
(2,'Z201',2,10.000,10.000,0.000,13.00,0,0.000,'2026-05-27','21:50:38',10.00,1),
(3,'Z202',3,10.000,10.000,0.000,0.00,0,0.000,'2026-05-27','21:50:50',0.00,1),
(4,'Z203',4,10.000,10.000,0.000,0.00,0,0.000,'2026-05-27','21:52:06',0.00,1),
(5,'Z401',5,15.000,15.000,0.000,0.00,0,0.000,'2026-05-27','22:18:27',0.00,1),
(6,'Z402',6,20.000,20.000,0.000,12.00,0,0.000,'2026-05-27','22:18:42',0.00,1),
(7,'Zasx',7,21.000,12.000,0.000,0.00,0,0.000,'2026-05-28','22:28:33',0.00,1),
(8,'Zasas',8,21.000,2.000,0.000,0.00,0,0.000,'2026-05-28','22:28:40',0.00,1);

/*Table structure for table `prod_batch_updated` */

DROP TABLE IF EXISTS `prod_batch_updated`;

CREATE TABLE `prod_batch_updated` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `product_id` int NOT NULL,
  `cost` double(10,3) NOT NULL DEFAULT '0.000',
  `mrp` double(10,3) NOT NULL DEFAULT '0.000',
  `stock` decimal(10,2) NOT NULL,
  `disc_type` int DEFAULT '0' COMMENT '1=rs 2=%',
  `discount` double(10,3) DEFAULT '0.000',
  `date` date DEFAULT NULL,
  `time` time DEFAULT '00:00:00',
  `added_stock` decimal(10,2) NOT NULL,
  `uid` int NOT NULL DEFAULT '0',
  `updatedDate` date DEFAULT NULL,
  `updatedTime` time DEFAULT '00:00:00',
  `updatedUid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `prod` (`product_id`),
  KEY `disc` (`disc_type`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `prod_batch_updated` */

/*Table structure for table `prod_batch_zero_stock_bill` */

DROP TABLE IF EXISTS `prod_batch_zero_stock_bill`;

CREATE TABLE `prod_batch_zero_stock_bill` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `batch_id` varchar(255) NOT NULL,
  `product_id` int NOT NULL,
  `qty` decimal(10,2) NOT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT '00:00:00',
  `uid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `batch` (`batch_id`),
  KEY `prod` (`product_id`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

/*Data for the table `prod_batch_zero_stock_bill` */

insert  into `prod_batch_zero_stock_bill`(`id`,`batch_id`,`product_id`,`qty`,`date`,`time`,`uid`) values 
(1,'1',1,1.00,'2026-05-27','22:00:23',1),
(2,'1',1,1.00,'2026-05-27','22:01:00',1),
(3,'0',1,1.00,'2026-05-27','22:44:14',1),
(4,'0',6,1.00,'2026-05-27','22:44:14',1),
(5,'0',5,1.00,'2026-05-27','22:44:14',1),
(6,'0',6,1.00,'2026-05-27','22:52:16',1),
(7,'0',1,1.00,'2026-05-27','22:52:16',1),
(8,'5',5,1.00,'2026-05-27','22:54:41',1),
(9,'1',1,1.00,'2026-05-27','22:54:41',1),
(10,'3',3,2.00,'2026-05-27','22:54:41',1),
(11,'6',6,1.00,'2026-05-27','22:54:41',1),
(12,'0',1,1.00,'2026-05-28','21:58:53',1),
(13,'0',5,1.00,'2026-05-28','21:58:53',1),
(14,'0',6,1.00,'2026-05-28','21:58:53',1),
(15,'0',7,1.00,'2026-05-31','15:17:47',1),
(16,'0',3,1.00,'2026-05-31','15:17:47',1),
(17,'0',2,1.00,'2026-05-31','15:18:46',1),
(18,'0',4,1.00,'2026-05-31','15:18:46',1),
(19,'0',2,1.00,'2026-05-31','16:36:49',1),
(20,'0',3,1.00,'2026-05-31','16:36:49',1);

/*Table structure for table `prod_bill` */

DROP TABLE IF EXISTS `prod_bill`;

CREATE TABLE `prod_bill` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_display` varchar(255) NOT NULL,
  `is_tax_bill` tinyint(1) DEFAULT '1',
  `is_receipt` int DEFAULT '1',
  `total` double(10,3) DEFAULT '0.000',
  `prodDisc` double(10,3) DEFAULT '0.000',
  `extraDisc` double(10,3) DEFAULT '0.000',
  `payable` double(10,3) DEFAULT '0.000',
  `paid` double(10,3) DEFAULT '0.000',
  `balance` double(10,3) DEFAULT '0.000',
  `currentBalance` double(10,3) DEFAULT '0.000',
  `is_balance` int DEFAULT '0',
  `paymentMode` int NOT NULL COMMENT 'prod_bill_payment_mode',
  `paymentType` int DEFAULT '0' COMMENT 'prod_bill_payment_type',
  `uid` int NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL DEFAULT '00:00:00',
  `is_cancelled` int DEFAULT '0',
  `bill_type` int DEFAULT '1' COMMENT '1=prod bill',
  `cusName` varchar(255) DEFAULT '""',
  `cusPhn` varchar(255) DEFAULT '-',
  `customerId` int DEFAULT NULL,
  `price_category` int NOT NULL,
  `lr_no` varchar(255) DEFAULT NULL,
  `lr_date` date DEFAULT NULL,
  `lr_name` varchar(255) DEFAULT NULL,
  `attender_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `mode` (`paymentMode`),
  KEY `type` (`paymentType`),
  KEY `idx_is_tax_bill` (`is_tax_bill`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

/*Data for the table `prod_bill` */

insert  into `prod_bill`(`id`,`bill_display`,`is_tax_bill`,`is_receipt`,`total`,`prodDisc`,`extraDisc`,`payable`,`paid`,`balance`,`currentBalance`,`is_balance`,`paymentMode`,`paymentType`,`uid`,`date`,`time`,`is_cancelled`,`bill_type`,`cusName`,`cusPhn`,`customerId`,`price_category`,`lr_no`,`lr_date`,`lr_name`,`attender_id`) values 
(1,'26-1',1,1,90.000,0.000,0.000,90.000,90.000,0.000,0.000,0,1,0,1,'2026-05-27','22:00:23',0,1,'aa','-',1,3,NULL,NULL,NULL,NULL),
(2,'26-2',1,1,90.000,0.000,0.000,90.000,90.000,0.000,0.000,0,1,0,1,'2026-05-27','22:01:00',0,1,'a','-',2,3,NULL,NULL,NULL,NULL),
(3,'26-3',1,1,125.000,0.000,0.000,125.000,125.000,0.000,0.000,0,1,0,1,'2026-05-27','22:44:14',0,1,'-','-',1,3,NULL,NULL,NULL,NULL),
(4,'26-4',1,1,130.000,0.000,0.000,130.000,130.000,0.000,0.000,0,1,0,1,'2026-05-27','22:52:16',0,1,'-','-',1,3,NULL,NULL,NULL,NULL),
(5,'26-5',1,1,155.000,0.000,0.000,155.000,155.000,0.000,0.000,0,1,0,1,'2026-05-27','22:54:41',0,1,'-','-',1,3,NULL,NULL,NULL,NULL),
(6,'26-6',1,1,125.000,0.000,0.000,125.000,125.000,0.000,0.000,0,1,1,1,'2026-05-28','21:58:53',0,1,'-','-',NULL,3,NULL,NULL,NULL,NULL),
(7,'26-7',1,1,22.000,0.000,0.000,22.000,22.000,0.000,0.000,0,1,1,1,'2026-05-31','15:17:47',0,1,'-','-',NULL,3,NULL,NULL,NULL,NULL),
(8,'26-8',1,1,20.000,0.000,0.000,20.000,10.000,10.000,5.000,1,2,1,1,'2026-05-31','15:18:46',0,1,'sd','333333333',3,3,NULL,NULL,NULL,NULL),
(9,'26-9',1,1,20.000,0.000,0.000,20.000,10.000,10.000,10.000,1,1,1,1,'2026-05-31','16:36:49',0,1,'ss','-',4,3,NULL,NULL,NULL,NULL);

/*Table structure for table `prod_bill_cancel` */

DROP TABLE IF EXISTS `prod_bill_cancel`;

CREATE TABLE `prod_bill_cancel` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL,
  `reason` text,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `uid` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `billId` (`bill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `prod_bill_cancel` */

/*Table structure for table `prod_bill_datechange` */

DROP TABLE IF EXISTS `prod_bill_datechange`;

CREATE TABLE `prod_bill_datechange` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `billId` int NOT NULL,
  `oldDate` date DEFAULT NULL,
  `changeDate` date DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `uid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `billId` (`billId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `prod_bill_datechange` */

/*Table structure for table `prod_bill_details` */

DROP TABLE IF EXISTS `prod_bill_details`;

CREATE TABLE `prod_bill_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL,
  `prod_id` int NOT NULL,
  `qty` decimal(10,2) NOT NULL,
  `price` double(10,3) DEFAULT '0.000',
  `disc` double(10,3) DEFAULT '0.000',
  `total` double(10,3) DEFAULT '0.000',
  `cost` double(10,3) DEFAULT '0.000',
  `commission` double(10,3) DEFAULT '0.000',
  `gst` int NOT NULL DEFAULT '0',
  `is_cancelled` int DEFAULT '0',
  `cancel_date` datetime DEFAULT NULL,
  `is_exchanged` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `bill` (`bill_id`),
  KEY `prod` (`prod_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;

/*Data for the table `prod_bill_details` */

insert  into `prod_bill_details`(`id`,`bill_id`,`prod_id`,`qty`,`price`,`disc`,`total`,`cost`,`commission`,`gst`,`is_cancelled`,`cancel_date`,`is_exchanged`) values 
(1,1,1,1.00,90.000,0.000,90.000,90.000,0.000,0,0,NULL,0),
(2,2,1,1.00,90.000,0.000,90.000,90.000,0.000,0,0,NULL,0),
(3,3,1,1.00,90.000,0.000,90.000,90.000,0.000,0,0,NULL,0),
(4,3,6,1.00,20.000,0.000,20.000,20.000,0.000,0,0,NULL,0),
(5,3,5,1.00,15.000,0.000,15.000,15.000,0.000,0,0,NULL,0),
(6,4,3,1.00,10.000,0.000,10.000,10.000,0.000,0,0,NULL,0),
(7,4,2,1.00,10.000,0.000,10.000,10.000,0.000,0,0,NULL,0),
(8,4,6,1.00,20.000,0.000,20.000,20.000,0.000,0,0,NULL,0),
(9,4,1,1.00,90.000,0.000,90.000,90.000,0.000,0,0,NULL,0),
(10,5,4,1.00,10.000,0.000,10.000,10.000,0.000,0,0,NULL,0),
(11,5,5,1.00,15.000,0.000,15.000,15.000,0.000,0,0,NULL,0),
(12,5,1,1.00,90.000,0.000,90.000,90.000,0.000,0,0,NULL,0),
(13,5,6,1.00,20.000,0.000,20.000,20.000,0.000,0,0,NULL,0),
(14,5,2,1.00,10.000,0.000,10.000,10.000,0.000,0,0,NULL,0),
(15,5,3,1.00,10.000,0.000,10.000,10.000,0.000,0,0,NULL,0),
(16,6,1,1.00,90.000,0.000,90.000,0.000,0.000,0,0,NULL,0),
(17,6,5,1.00,15.000,0.000,15.000,0.000,0.000,0,0,NULL,0),
(18,6,6,1.00,20.000,0.000,20.000,0.000,0.000,0,0,NULL,0),
(19,7,7,1.00,12.000,0.000,12.000,0.000,0.000,0,0,NULL,0),
(20,7,3,1.00,10.000,0.000,10.000,0.000,0.000,0,0,NULL,0),
(21,8,2,1.00,10.000,0.000,10.000,0.000,0.000,0,0,NULL,0),
(22,8,4,1.00,10.000,0.000,10.000,0.000,0.000,0,0,NULL,0),
(23,9,2,1.00,10.000,0.000,10.000,0.000,0.000,0,0,NULL,0),
(24,9,3,1.00,10.000,0.000,10.000,0.000,0.000,0,0,NULL,0);

/*Table structure for table `prod_bill_due_collection` */

DROP TABLE IF EXISTS `prod_bill_due_collection`;

CREATE TABLE `prod_bill_due_collection` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL,
  `balance` double(10,2) DEFAULT NULL,
  `paid` double(10,2) DEFAULT NULL,
  `finalBalance` double(10,2) DEFAULT NULL,
  `mode` int DEFAULT NULL,
  `bankOption` int DEFAULT NULL,
  `uid` int NOT NULL,
  `collectDate` varchar(255) DEFAULT NULL,
  `collectTime` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `billId` (`bill_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `prod_bill_due_collection` */

insert  into `prod_bill_due_collection`(`id`,`bill_id`,`balance`,`paid`,`finalBalance`,`mode`,`bankOption`,`uid`,`collectDate`,`collectTime`,`date`,`time`) values 
(1,8,10.00,5.00,5.00,1,0,1,'2026-05-31','15:19:30','2026-05-31','15:19:30');

/*Table structure for table `prod_bill_payment` */

DROP TABLE IF EXISTS `prod_bill_payment`;

CREATE TABLE `prod_bill_payment` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL,
  `cash` double(10,2) DEFAULT '0.00',
  `bank` double(10,2) DEFAULT '0.00',
  `paymentType` int DEFAULT '0' COMMENT 'prod_bill_payment_type',
  PRIMARY KEY (`id`),
  KEY `billid` (`bill_id`),
  KEY `paymentType` (`paymentType`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

/*Data for the table `prod_bill_payment` */

insert  into `prod_bill_payment`(`id`,`bill_id`,`cash`,`bank`,`paymentType`) values 
(1,1,90.00,0.00,0),
(2,2,90.00,0.00,0),
(3,3,125.00,0.00,0),
(4,4,130.00,0.00,0),
(5,5,155.00,0.00,0),
(6,6,125.00,0.00,1),
(7,7,22.00,0.00,1),
(8,8,0.00,10.00,1),
(9,9,10.00,0.00,1);

/*Table structure for table `prod_bill_payment_mode` */

DROP TABLE IF EXISTS `prod_bill_payment_mode`;

CREATE TABLE `prod_bill_payment_mode` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `mode` varchar(255) NOT NULL,
  `is_active` int DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `prod_bill_payment_mode` */

insert  into `prod_bill_payment_mode`(`id`,`mode`,`is_active`) values 
(1,'cash',1),
(2,'bank',1),
(3,'mixed',1);

/*Table structure for table `prod_bill_payment_type` */

DROP TABLE IF EXISTS `prod_bill_payment_type`;

CREATE TABLE `prod_bill_payment_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `is_active` int DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

/*Data for the table `prod_bill_payment_type` */

insert  into `prod_bill_payment_type`(`id`,`type`,`is_active`) values 
(0,'CASH',1),
(1,'UPI',1),
(2,'DEBIT CARD',1),
(3,'CREDIT CARD',1),
(4,'NET BANKING',1),
(5,'WALLET',1),
(6,'CHEQUE',1);

/*Table structure for table `prod_bill_payment_type_change` */

DROP TABLE IF EXISTS `prod_bill_payment_type_change`;

CREATE TABLE `prod_bill_payment_type_change` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL,
  `old_cash_amount` double(10,3) DEFAULT NULL,
  `cash_amount` double(10,3) DEFAULT NULL,
  `old_bank_amount` double(10,3) DEFAULT NULL,
  `bank_amount` double(10,3) DEFAULT NULL,
  `bank_mode` int DEFAULT NULL,
  `uid` int DEFAULT NULL,
  `date_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_bill_payment_type_change` */

/*Table structure for table `prod_brands` */

DROP TABLE IF EXISTS `prod_brands`;

CREATE TABLE `prod_brands` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `is_active` int DEFAULT '1',
  PRIMARY KEY (`id`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `prod_brands` */

insert  into `prod_brands`(`id`,`name`,`date`,`time`,`is_active`) values 
(1,'OWN','2026-05-27','21:49:40',1);

/*Table structure for table `prod_category` */

DROP TABLE IF EXISTS `prod_category`;

CREATE TABLE `prod_category` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `is_active` int DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `prod_category` */

insert  into `prod_category`(`id`,`name`,`date`,`time`,`is_active`) values 
(1,'SNACKS','2026-05-27','21:49:31',1),
(2,'VEG','2026-05-27','21:49:33',1),
(3,'BREAD','2026-05-27','21:49:34',1),
(4,'OWN','2026-05-27','21:49:36',0),
(5,'TEA','2026-05-27','22:18:12',1);

/*Table structure for table `prod_cheque_allocation` */

DROP TABLE IF EXISTS `prod_cheque_allocation`;

CREATE TABLE `prod_cheque_allocation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cheque_id` int NOT NULL,
  `bill_id` int NOT NULL,
  `allocated_amount` double NOT NULL,
  `allocated_date` date DEFAULT NULL,
  `allocated_time` time DEFAULT NULL,
  `due_date` date NOT NULL,
  `credit_days` int DEFAULT '10',
  `status` enum('ALLOCATED','CLEARED','REVERSED','BOUNCED') DEFAULT 'ALLOCATED',
  `cleared_date` date DEFAULT NULL,
  `cleared_time` time DEFAULT NULL,
  `reversed_date` date DEFAULT NULL,
  `reversed_time` time DEFAULT NULL,
  `reversed_by` int DEFAULT NULL,
  `is_reversed` tinyint DEFAULT '0',
  `uid` int NOT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `idx_cheque` (`cheque_id`),
  KEY `idx_bill` (`bill_id`),
  KEY `idx_status` (`status`),
  KEY `idx_due_date` (`due_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_cheque_allocation` */

/*Table structure for table `prod_cheque_events` */

DROP TABLE IF EXISTS `prod_cheque_events`;

CREATE TABLE `prod_cheque_events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cheque_id` int NOT NULL,
  `event_type` enum('BOUNCE','EXPIRY','MANUAL_CLEAR') NOT NULL,
  `event_date` date DEFAULT NULL,
  `event_time` time DEFAULT NULL,
  `reason` text,
  `uid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cheque` (`cheque_id`),
  KEY `idx_event_type` (`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_cheque_events` */

/*Table structure for table `prod_cheque_stock` */

DROP TABLE IF EXISTS `prod_cheque_stock`;

CREATE TABLE `prod_cheque_stock` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `cheque_number` varchar(50) NOT NULL,
  `bank_name` text,
  `status` enum('AVAILABLE','PARTIAL','FULLY_USED','CLEARED','BOUNCED','EXPIRED') DEFAULT 'AVAILABLE',
  `entry_date` date DEFAULT NULL,
  `entry_time` time DEFAULT NULL,
  `uid` int NOT NULL,
  `notes` text,
  `is_active` tinyint DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_customer` (`customer_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_cheque_stock` */

/*Table structure for table `prod_lifecycle` */

DROP TABLE IF EXISTS `prod_lifecycle`;

CREATE TABLE `prod_lifecycle` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL DEFAULT '0',
  `batch_id` int NOT NULL,
  `product_id` int NOT NULL,
  `stock_in` decimal(10,2) NOT NULL DEFAULT '0.00',
  `stock_out` decimal(10,2) NOT NULL DEFAULT '0.00',
  `stock_now` decimal(10,2) NOT NULL,
  `is_zero_stock_bill` int DEFAULT '0',
  `notes` text,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `uid` int NOT NULL,
  `stock_type` int DEFAULT '1' COMMENT '1=stock 2=noStock',
  `stockAdjType` int DEFAULT '0' COMMENT '1=add 2=remove',
  PRIMARY KEY (`id`),
  KEY `batch` (`batch_id`),
  KEY `prod` (`product_id`),
  KEY `uid` (`uid`),
  KEY `stock` (`stockAdjType`),
  KEY `billId` (`bill_id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=latin1;

/*Data for the table `prod_lifecycle` */

insert  into `prod_lifecycle`(`id`,`bill_id`,`batch_id`,`product_id`,`stock_in`,`stock_out`,`stock_now`,`is_zero_stock_bill`,`notes`,`date`,`time`,`uid`,`stock_type`,`stockAdjType`) values 
(1,0,1,1,0.00,0.00,0.00,0,'WHILE ADD PRODUCT','2026-05-27','21:50:09',1,1,0),
(2,0,2,2,10.00,0.00,10.00,0,'WHILE ADD PRODUCT','2026-05-27','21:50:38',1,1,0),
(3,0,3,3,0.00,0.00,0.00,0,'WHILE ADD PRODUCT','2026-05-27','21:50:50',1,1,0),
(4,0,4,4,0.00,0.00,0.00,0,'WHILE ADD PRODUCT','2026-05-27','21:52:06',1,1,0),
(5,0,1,2,10.00,0.00,20.00,2,'While Stock Added Through Purchase Entry','2026-05-27','22:00:16',1,2,0),
(6,0,1,3,10.00,0.00,10.00,2,'While Stock Added Through Purchase Entry','2026-05-27','22:00:16',1,2,0),
(7,1,1,1,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-27','22:00:23',1,1,0),
(8,1,2,2,0.00,1.00,19.00,0,'Bill of Materials: SANDWITCH','2026-05-27','22:00:23',1,1,0),
(9,1,3,3,0.00,2.00,8.00,0,'Bill of Materials: SANDWITCH','2026-05-27','22:00:23',1,1,0),
(10,0,1,4,10.00,0.00,10.00,2,'While Stock Added Through Purchase Entry','2026-05-27','22:00:53',1,2,0),
(11,2,1,1,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-27','22:01:00',1,1,0),
(12,2,2,2,0.00,1.00,18.00,0,'Bill of Materials: SANDWITCH','2026-05-27','22:01:00',1,1,0),
(13,2,3,3,0.00,2.00,6.00,0,'Bill of Materials: SANDWITCH','2026-05-27','22:01:00',1,1,0),
(14,2,4,4,0.00,3.00,7.00,0,'Bill of Materials: SANDWITCH','2026-05-27','22:01:00',1,1,0),
(15,0,5,5,0.00,0.00,0.00,0,'WHILE ADD PRODUCT','2026-05-27','22:18:27',1,1,0),
(16,0,6,6,0.00,0.00,0.00,0,'WHILE ADD PRODUCT','2026-05-27','22:18:42',1,1,0),
(17,3,0,1,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-27','22:44:14',1,1,0),
(18,3,2,2,0.00,1.00,17.00,0,'Bill of Materials: SANDWITCH','2026-05-27','22:44:14',1,1,0),
(19,3,3,3,0.00,2.00,4.00,0,'Bill of Materials: SANDWITCH','2026-05-27','22:44:14',1,1,0),
(20,3,4,4,0.00,3.00,4.00,0,'Bill of Materials: SANDWITCH','2026-05-27','22:44:14',1,1,0),
(21,3,0,6,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-27','22:44:14',1,1,0),
(22,3,0,5,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-27','22:44:14',1,1,0),
(23,4,3,3,0.00,1.00,3.00,0,'WHILE BILLING','2026-05-27','22:52:16',1,1,0),
(24,4,2,2,0.00,1.00,16.00,0,'WHILE BILLING','2026-05-27','22:52:16',1,1,0),
(25,4,0,6,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-27','22:52:16',1,1,0),
(26,4,0,1,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-27','22:52:16',1,1,0),
(27,4,2,2,0.00,1.00,15.00,0,'Bill of Materials: SANDWITCH','2026-05-27','22:52:16',1,1,0),
(28,4,3,3,0.00,2.00,1.00,0,'Bill of Materials: SANDWITCH','2026-05-27','22:52:16',1,1,0),
(29,4,4,4,0.00,3.00,1.00,0,'Bill of Materials: SANDWITCH','2026-05-27','22:52:16',1,1,0),
(30,5,4,4,0.00,1.00,0.00,0,'WHILE BILLING','2026-05-27','22:54:41',1,1,0),
(31,5,5,5,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-27','22:54:41',1,1,0),
(32,5,1,1,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-27','22:54:41',1,1,0),
(33,5,2,2,0.00,1.00,14.00,0,'Bill of Materials: SANDWITCH','2026-05-27','22:54:41',1,1,0),
(34,5,3,3,0.00,2.00,1.00,1,'Bill of Materials: SANDWITCH - BILL WITHOUT STOCK','2026-05-27','22:54:41',1,1,0),
(35,5,6,6,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-27','22:54:41',1,1,0),
(36,5,2,2,0.00,1.00,13.00,0,'WHILE BILLING','2026-05-27','22:54:41',1,1,0),
(37,5,3,3,0.00,1.00,0.00,0,'WHILE BILLING','2026-05-27','22:54:41',1,1,0),
(38,6,0,1,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-28','21:58:53',1,1,0),
(39,6,2,2,0.00,1.00,12.00,0,'Bill of Materials: SANDWITCH','2026-05-28','21:58:53',1,1,0),
(40,6,0,5,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-28','21:58:53',1,1,0),
(41,6,0,6,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-28','21:58:53',1,1,0),
(42,0,7,7,0.00,0.00,0.00,0,'WHILE ADD PRODUCT','2026-05-28','22:28:33',1,1,0),
(43,0,8,8,0.00,0.00,0.00,0,'WHILE ADD PRODUCT','2026-05-28','22:28:40',1,1,0),
(44,7,0,7,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-31','15:17:47',1,1,0),
(45,7,0,3,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-31','15:17:47',1,1,0),
(46,8,0,2,0.00,1.00,12.00,1,' BILL WITHOUT STOCK','2026-05-31','15:18:46',1,1,0),
(47,8,0,4,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-31','15:18:46',1,1,0),
(48,0,1,1,1.00,0.00,1.00,2,'While Stock Added Through Purchase Entry','2026-05-31','15:19:55',1,2,0),
(49,0,1,2,1.00,0.00,13.00,2,'While Stock Added Through Purchase Entry','2026-05-31','16:24:48',1,2,0),
(50,0,1,6,12.00,0.00,12.00,2,'While Stock Added Through Purchase Entry','2026-05-31','16:24:48',1,2,0),
(51,9,0,2,0.00,1.00,13.00,1,' BILL WITHOUT STOCK','2026-05-31','16:36:49',1,1,0),
(52,9,0,3,0.00,1.00,0.00,1,' BILL WITHOUT STOCK','2026-05-31','16:36:49',1,1,0);

/*Table structure for table `prod_order` */

DROP TABLE IF EXISTS `prod_order`;

CREATE TABLE `prod_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `order_no` varchar(255) NOT NULL,
  `table_id` int NOT NULL,
  `is_delivered` int DEFAULT '0',
  `is_billed` int DEFAULT '0',
  `is_cancelled` int DEFAULT '0',
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `uid` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_order` */

insert  into `prod_order`(`id`,`order_no`,`table_id`,`is_delivered`,`is_billed`,`is_cancelled`,`date`,`time`,`uid`) values 
(1,'1',1,0,1,0,'2026-05-27','22:24:07',1),
(2,'2',1,0,1,0,'2026-05-27','22:51:45',1),
(3,'3',2,0,1,0,'2026-05-27','22:54:00',1),
(4,'1',1,0,1,0,'2026-05-28','21:26:51',1),
(5,'2',1,0,0,1,'2026-05-28','21:59:19',1),
(6,'3',3,0,0,1,'2026-05-28','21:59:24',1),
(7,'1',1,0,1,0,'2026-05-31','15:17:39',1),
(8,'2',2,0,1,0,'2026-05-31','15:17:43',1),
(9,'3',1,0,1,0,'2026-05-31','16:33:24',1);

/*Table structure for table `prod_order_details` */

DROP TABLE IF EXISTS `prod_order_details`;

CREATE TABLE `prod_order_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `prod_id` int NOT NULL,
  `qty` int NOT NULL,
  `price` double(10,3) DEFAULT '0.000',
  `total` double(10,3) DEFAULT '0.000',
  `is_delivered` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_order_details` */

insert  into `prod_order_details`(`id`,`order_id`,`prod_id`,`qty`,`price`,`total`,`is_delivered`) values 
(1,1,1,1,90.000,90.000,1),
(2,1,6,1,20.000,20.000,0),
(3,1,5,1,15.000,15.000,0),
(4,2,3,1,10.000,10.000,0),
(5,2,2,1,10.000,10.000,0),
(6,2,6,1,20.000,20.000,0),
(7,2,1,1,90.000,90.000,0),
(8,3,4,1,10.000,10.000,0),
(9,3,5,1,15.000,15.000,0),
(10,3,1,1,90.000,90.000,0),
(11,3,6,1,20.000,20.000,0),
(12,3,2,1,10.000,10.000,0),
(13,3,3,1,10.000,10.000,0),
(14,4,1,1,90.000,90.000,0),
(15,4,5,1,15.000,15.000,0),
(16,4,6,1,20.000,20.000,0),
(17,5,3,1,10.000,10.000,0),
(18,5,2,1,10.000,10.000,0),
(19,5,4,1,10.000,10.000,0),
(20,6,2,1,10.000,10.000,0),
(21,6,6,1,20.000,20.000,0),
(22,6,5,1,15.000,15.000,0),
(23,7,7,1,12.000,12.000,0),
(24,7,3,1,10.000,10.000,0),
(25,8,2,1,10.000,10.000,0),
(26,8,4,1,10.000,10.000,0),
(29,9,2,1,10.000,10.000,0),
(30,9,3,1,10.000,10.000,0);

/*Table structure for table `prod_product` */

DROP TABLE IF EXISTS `prod_product`;

CREATE TABLE `prod_product` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT '0',
  `category_id` int NOT NULL,
  `brand_id` int NOT NULL,
  `unit_id` int DEFAULT '1',
  `hsn` int DEFAULT NULL,
  `uid` int NOT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `is_active` int DEFAULT '1',
  `gst` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cat` (`category_id`),
  KEY `brand` (`brand_id`),
  KEY `uid` (`uid`),
  KEY `unit` (`unit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

/*Data for the table `prod_product` */

insert  into `prod_product`(`id`,`name`,`code`,`category_id`,`brand_id`,`unit_id`,`hsn`,`uid`,`date`,`time`,`is_active`,`gst`) values 
(1,'SANDWITCH','101',1,1,1,NULL,1,'2026-05-27','21:50:09',1,0),
(2,'CHEESE','201',2,1,1,NULL,1,'2026-05-27','21:50:38',1,0),
(3,'BREAD','202',2,1,1,NULL,1,'2026-05-27','21:50:50',1,0),
(4,'TOMATO','203',2,1,1,NULL,1,'2026-05-27','21:52:06',1,0),
(5,'TEA','401',5,1,1,NULL,1,'2026-05-27','22:18:27',1,0),
(6,'COFFEE','402',5,1,1,NULL,1,'2026-05-27','22:18:42',1,0),
(7,'ax','asx',1,1,1,NULL,1,'2026-05-28','22:28:33',1,0),
(8,'saas','asas',2,1,1,NULL,1,'2026-05-28','22:28:40',1,0);

/*Table structure for table `prod_product_components` */

DROP TABLE IF EXISTS `prod_product_components`;

CREATE TABLE `prod_product_components` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL COMMENT 'Main product ID',
  `component_product_id` int NOT NULL COMMENT 'Component product ID',
  `quantity` decimal(10,2) DEFAULT '1.00' COMMENT 'Quantity needed',
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_by` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prod` (`product_id`),
  KEY `compo` (`component_product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_product_components` */

insert  into `prod_product_components`(`id`,`product_id`,`component_product_id`,`quantity`,`created_date`,`created_by`) values 
(1,1,2,1.00,'2026-05-27 21:51:29',1),
(2,1,3,2.00,'2026-05-27 21:51:43',1),
(3,1,4,3.00,'2026-05-27 21:59:29',1);

/*Table structure for table `prod_purchase` */

DROP TABLE IF EXISTS `prod_purchase`;

CREATE TABLE `prod_purchase` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `prno` varchar(25) NOT NULL DEFAULT '',
  `invno` varchar(255) DEFAULT '',
  `invdate` date DEFAULT NULL,
  `total` double(10,2) NOT NULL DEFAULT '0.00',
  `paid` double(10,2) NOT NULL DEFAULT '0.00',
  `balance` double(10,2) DEFAULT '0.00',
  `discount` double(10,2) DEFAULT '0.00',
  `net` double NOT NULL DEFAULT '0',
  `ent_date` date NOT NULL DEFAULT '0001-01-01',
  `ent_time` time NOT NULL DEFAULT '00:00:00',
  `ent_uid` int unsigned NOT NULL DEFAULT '0',
  `ispending` tinyint unsigned DEFAULT '0',
  `pay_type` int unsigned NOT NULL DEFAULT '0',
  `bank_id` int unsigned NOT NULL DEFAULT '0',
  `deal_id` int unsigned DEFAULT '0',
  `remark` varchar(100) NOT NULL DEFAULT '0',
  `is_cancelled` tinyint(1) NOT NULL DEFAULT '0',
  `cancel_date` date DEFAULT '0001-01-01',
  `cancel_time` time DEFAULT '00:00:00',
  `cancel_uid` varchar(10) DEFAULT '0',
  `is_po` tinyint DEFAULT '0',
  `po_status` tinyint DEFAULT '1',
  `pr_id` int DEFAULT NULL,
  `grn_id` int DEFAULT '0',
  `expected_date` date DEFAULT NULL,
  `po_notes` text,
  `offer` text,
  `offer_date` date DEFAULT NULL,
  `lr_no` varchar(255) DEFAULT NULL,
  `lr_date` date DEFAULT NULL,
  `lr_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prno` (`prno`),
  KEY `dealer` (`deal_id`),
  KEY `grnid` (`grn_id`),
  KEY `status` (`po_status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Data for the table `prod_purchase` */

insert  into `prod_purchase`(`id`,`prno`,`invno`,`invdate`,`total`,`paid`,`balance`,`discount`,`net`,`ent_date`,`ent_time`,`ent_uid`,`ispending`,`pay_type`,`bank_id`,`deal_id`,`remark`,`is_cancelled`,`cancel_date`,`cancel_time`,`cancel_uid`,`is_po`,`po_status`,`pr_id`,`grn_id`,`expected_date`,`po_notes`,`offer`,`offer_date`,`lr_no`,`lr_date`,`lr_name`) values 
(1,'GRN-1','ss','2026-05-27',200.00,0.00,200.00,0.00,200,'2026-05-27','22:00:16',1,0,1,0,1,'0',0,'0001-01-01','00:00:00','0',0,1,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(2,'GRN-2','2','2026-05-27',100.00,0.00,100.00,0.00,100,'2026-05-27','22:00:53',1,0,1,0,1,'0',0,'0001-01-01','00:00:00','0',0,1,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(3,'GRN-3','vb','2026-05-31',90.00,70.00,20.00,0.00,90,'2026-05-31','15:19:55',1,0,1,0,1,'0',0,'0001-01-01','00:00:00','0',0,1,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(4,'GRN-4','s','2026-05-31',250.00,250.00,0.00,0.00,250,'2026-05-31','16:24:48',1,0,2,1,1,'0',0,'0001-01-01','00:00:00','0',0,1,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `prod_purchase_counter` */

DROP TABLE IF EXISTS `prod_purchase_counter`;

CREATE TABLE `prod_purchase_counter` (
  `id` int NOT NULL,
  `last_pr_no` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_purchase_counter` */

/*Table structure for table `prod_purchase_details` */

DROP TABLE IF EXISTS `prod_purchase_details`;

CREATE TABLE `prod_purchase_details` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `prid` int unsigned DEFAULT '0',
  `prods_id` int DEFAULT '0',
  `pack` int DEFAULT '0',
  `qtypack` decimal(10,2) DEFAULT '0.00',
  `quantity` decimal(10,2) unsigned DEFAULT '0.00',
  `free` int unsigned DEFAULT '0',
  `rate` double(10,3) DEFAULT '0.000',
  `mrp` double(10,3) DEFAULT '0.000',
  `totalamt` double(10,3) DEFAULT '0.000',
  `tax` double(10,2) NOT NULL DEFAULT '0.00',
  `tax_amt` double(10,3) DEFAULT '0.000',
  `mrp_vat_amt` double(10,2) DEFAULT '0.00',
  `disc_per` double(10,2) DEFAULT '0.00',
  `disc` double(10,3) DEFAULT '0.000',
  `netamt` double(10,3) DEFAULT '0.000',
  `isinvoicereceived` int unsigned NOT NULL DEFAULT '0',
  `hsn_code` varchar(20) NOT NULL DEFAULT '0',
  `sgst_per` double(10,2) NOT NULL DEFAULT '0.00',
  `cgst_per` double(10,2) NOT NULL DEFAULT '0.00',
  `igst_per` double(10,2) NOT NULL DEFAULT '0.00',
  `sgst_amt` double(10,2) NOT NULL DEFAULT '0.00',
  `cgst_amt` double(10,2) NOT NULL DEFAULT '0.00',
  `igst_amt` double(10,2) NOT NULL DEFAULT '0.00',
  `unitrate` double(10,3) DEFAULT '0.000',
  `unitmrp` double(10,3) DEFAULT '0.000',
  `ordered_qty` int DEFAULT '0',
  `received_qty` int DEFAULT '0',
  `pending_qty` int DEFAULT '0',
  `is_fully_received` tinyint DEFAULT '0',
  `is_cancelled` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = this item was cancelled',
  PRIMARY KEY (`id`),
  KEY `prid` (`prid`),
  KEY `prod` (`prods_id`),
  KEY `fullyreceive` (`is_fully_received`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

/*Data for the table `prod_purchase_details` */

insert  into `prod_purchase_details`(`id`,`prid`,`prods_id`,`pack`,`qtypack`,`quantity`,`free`,`rate`,`mrp`,`totalamt`,`tax`,`tax_amt`,`mrp_vat_amt`,`disc_per`,`disc`,`netamt`,`isinvoicereceived`,`hsn_code`,`sgst_per`,`cgst_per`,`igst_per`,`sgst_amt`,`cgst_amt`,`igst_amt`,`unitrate`,`unitmrp`,`ordered_qty`,`received_qty`,`pending_qty`,`is_fully_received`,`is_cancelled`) values 
(1,1,2,1,10.00,10.00,0,10.000,10.000,100.000,0.00,0.000,0.00,0.00,0.000,100.000,1,'0',0.00,0.00,0.00,0.00,0.00,0.00,1.000,1.000,0,0,0,0,0),
(2,1,3,1,10.00,10.00,0,10.000,10.000,100.000,0.00,0.000,0.00,0.00,0.000,100.000,1,'0',0.00,0.00,0.00,0.00,0.00,0.00,1.000,1.000,0,0,0,0,0),
(3,2,4,1,10.00,10.00,0,10.000,10.000,100.000,0.00,0.000,0.00,0.00,0.000,100.000,1,'0',0.00,0.00,0.00,0.00,0.00,0.00,1.000,1.000,0,0,0,0,0),
(4,3,1,1,1.00,1.00,0,90.000,90.000,90.000,0.00,0.000,0.00,0.00,0.000,90.000,1,'0',0.00,0.00,0.00,0.00,0.00,0.00,90.000,90.000,0,0,0,0,0),
(5,4,2,1,1.00,1.00,0,10.000,10.000,10.000,0.00,0.000,0.00,0.00,0.000,10.000,1,'0',0.00,0.00,0.00,0.00,0.00,0.00,10.000,10.000,0,0,0,0,0),
(6,4,6,1,12.00,12.00,0,20.000,20.000,240.000,0.00,0.000,0.00,0.00,0.000,240.000,1,'0',0.00,0.00,0.00,0.00,0.00,0.00,1.667,1.667,0,0,0,0,0);

/*Table structure for table `prod_purchase_edit_log` */

DROP TABLE IF EXISTS `prod_purchase_edit_log`;

CREATE TABLE `prod_purchase_edit_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `purchase_id` int NOT NULL,
  `purchase_detail_id` int NOT NULL,
  `product_id` int NOT NULL,
  `edit_type` enum('price_edit','cancel') NOT NULL,
  `old_rate` double DEFAULT NULL,
  `new_rate` double DEFAULT NULL,
  `old_mrp` double DEFAULT NULL,
  `new_mrp` double DEFAULT NULL,
  `qty` double DEFAULT NULL,
  `reason` text,
  `uid` int NOT NULL,
  `date_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_id` (`purchase_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_purchase_edit_log` */

/*Table structure for table `prod_purchase_entry_details_link` */

DROP TABLE IF EXISTS `prod_purchase_entry_details_link`;

CREATE TABLE `prod_purchase_entry_details_link` (
  `id` int NOT NULL AUTO_INCREMENT,
  `link_id` int NOT NULL,
  `po_detail_id` bigint unsigned NOT NULL,
  `pe_detail_id` bigint unsigned NOT NULL,
  `quantity_received` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_purchase_entry_details_link` */

/*Table structure for table `prod_purchase_entry_link` */

DROP TABLE IF EXISTS `prod_purchase_entry_link`;

CREATE TABLE `prod_purchase_entry_link` (
  `id` int NOT NULL AUTO_INCREMENT,
  `po_id` bigint unsigned NOT NULL,
  `pe_id` bigint unsigned NOT NULL,
  `receipt_no` varchar(50) DEFAULT NULL,
  `receipt_date` date DEFAULT NULL,
  `received_by` int DEFAULT NULL,
  `notes` text,
  `created_date` date NOT NULL,
  `created_time` time NOT NULL,
  `uid` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_purchase_entry_link` */

/*Table structure for table `prod_purchase_order_counter` */

DROP TABLE IF EXISTS `prod_purchase_order_counter`;

CREATE TABLE `prod_purchase_order_counter` (
  `id` int NOT NULL DEFAULT '1',
  `last_po_no` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_purchase_order_counter` */

/*Table structure for table `prod_purchase_request` */

DROP TABLE IF EXISTS `prod_purchase_request`;

CREATE TABLE `prod_purchase_request` (
  `id` int NOT NULL AUTO_INCREMENT,
  `req_no` varchar(50) NOT NULL COMMENT 'REQ1, REQ2, REQ3...',
  `req_date` date NOT NULL,
  `req_time` time NOT NULL,
  `deal_id` int DEFAULT NULL COMMENT 'Supplier ID - can be null for TBD supplier',
  `total` decimal(15,2) DEFAULT '0.00' COMMENT 'Total request amount',
  `pr_status` tinyint DEFAULT '1' COMMENT '1=Draft, 2=Submitted, 3=Approved, 4=Rejected, 5=Converted to PO',
  `notes` text COMMENT 'Request notes/justification',
  `requested_by` int NOT NULL COMMENT 'User ID who created the request',
  `approver_id` int DEFAULT NULL COMMENT 'User ID who approved/rejected - for future multi-level approval',
  `approved_date` date DEFAULT NULL COMMENT 'Approval date',
  `approved_time` time DEFAULT NULL COMMENT 'Approval time',
  `approval_notes` text COMMENT 'Approval/rejection notes',
  `po_id` int DEFAULT NULL COMMENT 'Link to PO if converted',
  `is_cancelled` tinyint DEFAULT '0' COMMENT '0=Active, 1=Cancelled',
  `ent_date` date NOT NULL,
  `ent_time` time NOT NULL,
  `ent_uid` int NOT NULL COMMENT 'Entry user ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `req_no` (`req_no`),
  KEY `deal` (`deal_id`),
  KEY `status` (`pr_status`),
  KEY `po` (`po_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Purchase Request Header';

/*Data for the table `prod_purchase_request` */

/*Table structure for table `prod_purchase_request_counter` */

DROP TABLE IF EXISTS `prod_purchase_request_counter`;

CREATE TABLE `prod_purchase_request_counter` (
  `id` int NOT NULL DEFAULT '1',
  `last_req_no` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_purchase_request_counter` */

/*Table structure for table `prod_purchase_request_details` */

DROP TABLE IF EXISTS `prod_purchase_request_details`;

CREATE TABLE `prod_purchase_request_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pr_id` int NOT NULL COMMENT 'Foreign key to prod_purchase_request',
  `prods_id` int NOT NULL COMMENT 'Product ID',
  `pack` int DEFAULT '1' COMMENT 'Number of packs',
  `qtypack` int DEFAULT '1' COMMENT 'Quantity per pack',
  `quantity` int NOT NULL COMMENT 'Total quantity requested',
  `free` int DEFAULT '0' COMMENT 'Free quantity expected',
  `rate` decimal(15,2) DEFAULT '0.00' COMMENT 'Expected cost per unit',
  `mrp` decimal(15,2) DEFAULT '0.00' COMMENT 'Expected MRP',
  `total` decimal(15,2) DEFAULT '0.00' COMMENT 'Line total',
  `tax` decimal(5,2) DEFAULT '0.00' COMMENT 'Tax percentage',
  `tax_amt` decimal(15,2) DEFAULT '0.00' COMMENT 'Tax amount',
  `disc_per` decimal(5,2) DEFAULT '0.00' COMMENT 'Discount percentage',
  `disc_amt` decimal(15,2) DEFAULT '0.00' COMMENT 'Discount amount',
  `net` decimal(15,2) DEFAULT '0.00' COMMENT 'Net amount',
  `notes` text COMMENT 'Item notes',
  PRIMARY KEY (`id`),
  KEY `idx_pr_id` (`pr_id`),
  KEY `idx_prods_id` (`prods_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Purchase Request Line Items';

/*Data for the table `prod_purchase_request_details` */

/*Table structure for table `prod_purchase_return` */

DROP TABLE IF EXISTS `prod_purchase_return`;

CREATE TABLE `prod_purchase_return` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `return_no` varchar(50) DEFAULT NULL,
  `purchase_id` int NOT NULL,
  `supplier_id` int DEFAULT NULL,
  `total` double DEFAULT '0',
  `notes` text,
  `uid` int NOT NULL,
  `date_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purchase_id` (`purchase_id`),
  KEY `supplier_id` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_purchase_return` */

/*Table structure for table `prod_purchase_return_details` */

DROP TABLE IF EXISTS `prod_purchase_return_details`;

CREATE TABLE `prod_purchase_return_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `return_id` int NOT NULL,
  `purchase_detail_id` int NOT NULL,
  `product_id` int NOT NULL,
  `qty` double DEFAULT '0',
  `rate` double DEFAULT '0',
  `total` double DEFAULT '0',
  `uid` int NOT NULL,
  `date_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `return_id` (`return_id`),
  KEY `purchase_detail_id` (`purchase_detail_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_purchase_return_details` */

/*Table structure for table `prod_purchase_supplier_payment` */

DROP TABLE IF EXISTS `prod_purchase_supplier_payment`;

CREATE TABLE `prod_purchase_supplier_payment` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `prid` int NOT NULL,
  `deal_id` int NOT NULL,
  `total` double(10,2) DEFAULT NULL,
  `paid` double(10,2) DEFAULT NULL,
  `balance` double(10,2) DEFAULT NULL,
  `is_active` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prid` (`prid`),
  KEY `deal` (`deal_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Data for the table `prod_purchase_supplier_payment` */

insert  into `prod_purchase_supplier_payment`(`id`,`prid`,`deal_id`,`total`,`paid`,`balance`,`is_active`) values 
(1,1,1,200.00,0.00,200.00,1),
(2,2,1,100.00,0.00,100.00,1),
(3,3,1,90.00,70.00,20.00,1),
(4,4,1,250.00,250.00,0.00,1);

/*Table structure for table `prod_purchase_supplier_payment_details` */

DROP TABLE IF EXISTS `prod_purchase_supplier_payment_details`;

CREATE TABLE `prod_purchase_supplier_payment_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `supPayId` int NOT NULL,
  `payable` double(10,2) DEFAULT NULL,
  `paid` double(10,2) DEFAULT NULL,
  `balance` double(10,2) DEFAULT NULL,
  `pay_type` int DEFAULT NULL,
  `pay_mode` int DEFAULT '0',
  `uid` int DEFAULT NULL,
  `notes` text,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payId` (`supPayId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `prod_purchase_supplier_payment_details` */

insert  into `prod_purchase_supplier_payment_details`(`id`,`supPayId`,`payable`,`paid`,`balance`,`pay_type`,`pay_mode`,`uid`,`notes`,`date`,`time`) values 
(1,1,200.00,0.00,200.00,1,0,1,'Payment for Purchase Bill','2026-05-27','22:00:16'),
(2,2,100.00,0.00,100.00,1,0,1,'Payment for Purchase Bill','2026-05-27','22:00:53'),
(3,3,90.00,50.00,40.00,1,0,1,'Payment for Purchase Bill','2026-05-31','15:19:55'),
(4,3,40.00,20.00,20.00,2,1,1,'pending payment','2026-05-31','15:25:15'),
(5,4,250.00,250.00,0.00,2,1,1,'Payment for Purchase Bill','2026-05-31','16:24:48');

/*Table structure for table `prod_quotation` */

DROP TABLE IF EXISTS `prod_quotation`;

CREATE TABLE `prod_quotation` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_display` varchar(255) NOT NULL,
  `total` double(10,3) DEFAULT '0.000',
  `prodDisc` double(10,3) DEFAULT '0.000',
  `extraDisc` double(10,3) DEFAULT '0.000',
  `payable` double(10,3) DEFAULT '0.000',
  `is_billed` int DEFAULT '0',
  `is_cancelled` int DEFAULT '0',
  `cusName` varchar(255) DEFAULT NULL,
  `cusPhn` varchar(255) DEFAULT NULL,
  `customerId` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `uid` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_quotation` */

/*Table structure for table `prod_quotation_details` */

DROP TABLE IF EXISTS `prod_quotation_details`;

CREATE TABLE `prod_quotation_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `quot_id` int NOT NULL,
  `prod_id` int NOT NULL,
  `qty` decimal(10,2) NOT NULL,
  `price` double(10,3) NOT NULL,
  `disc` double(10,3) DEFAULT NULL,
  `total` double(10,3) DEFAULT NULL,
  `gst` int DEFAULT NULL,
  `is_cancelled` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_quotation_details` */

/*Table structure for table `prod_stock_adjustment` */

DROP TABLE IF EXISTS `prod_stock_adjustment`;

CREATE TABLE `prod_stock_adjustment` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `batch_id` int NOT NULL,
  `stockType` int NOT NULL COMMENT '1=add 2=minus',
  `stock` decimal(10,2) NOT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `notes` text,
  `uid` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `prod` (`product_id`),
  KEY `batch` (`batch_id`),
  KEY `stock` (`stockType`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `prod_stock_adjustment` */

/*Table structure for table `prod_stock_totals` */

DROP TABLE IF EXISTS `prod_stock_totals`;

CREATE TABLE `prod_stock_totals` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `prods_id` int unsigned NOT NULL DEFAULT '0',
  `stock` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `rack` char(1) NOT NULL DEFAULT '',
  `shelf` int NOT NULL DEFAULT '0',
  `userlog` text,
  `extra1` tinyint unsigned DEFAULT '0',
  `extra2` tinyint unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `store_id_index` (`prods_id`),
  KEY `stock` (`stock`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `prod_stock_totals` */

insert  into `prod_stock_totals`(`id`,`prods_id`,`stock`,`rack`,`shelf`,`userlog`,`extra1`,`extra2`) values 
(1,2,11.00,'',0,'While Stock Added Through Purchase Entry',0,0),
(2,3,10.00,'',0,'While Stock Added Through Purchase Entry',0,0),
(3,4,10.00,'',0,'While Stock Added Through Purchase Entry',0,0),
(4,1,1.00,'',0,'While Stock Added Through Purchase Entry',0,0),
(5,6,12.00,'',0,'While Stock Added Through Purchase Entry',0,0);

/*Table structure for table `prod_supplier` */

DROP TABLE IF EXISTS `prod_supplier`;

CREATE TABLE `prod_supplier` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `is_active` int DEFAULT '1',
  `gstin` varchar(255) DEFAULT NULL,
  `is_gst` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `prod_supplier` */

insert  into `prod_supplier`(`id`,`name`,`phone_number`,`description`,`date`,`time`,`is_active`,`gstin`,`is_gst`) values 
(1,'ss','','','2026-05-27','22:00:00',1,NULL,0);

/*Table structure for table `prod_supplier_cheque_allocation` */

DROP TABLE IF EXISTS `prod_supplier_cheque_allocation`;

CREATE TABLE `prod_supplier_cheque_allocation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cheque_id` int NOT NULL,
  `purchase_id` int NOT NULL,
  `allocated_amount` decimal(10,2) NOT NULL,
  `allocated_date` date NOT NULL,
  `allocated_time` time NOT NULL,
  `allocated_uid` int NOT NULL,
  `due_date` date DEFAULT NULL,
  `credit_days` int DEFAULT '10',
  `status` varchar(20) NOT NULL DEFAULT 'ALLOCATED',
  `cleared_date` date DEFAULT NULL,
  `cleared_time` time DEFAULT NULL,
  `cleared_uid` int DEFAULT NULL,
  `is_reversed` tinyint(1) DEFAULT '0',
  `reversed_date` date DEFAULT NULL,
  `reversed_time` time DEFAULT NULL,
  `reversed_uid` int DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_cheque` (`cheque_id`),
  KEY `idx_purchase` (`purchase_id`),
  KEY `idx_status` (`status`),
  KEY `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_supplier_cheque_allocation` */

/*Table structure for table `prod_supplier_cheque_events` */

DROP TABLE IF EXISTS `prod_supplier_cheque_events`;

CREATE TABLE `prod_supplier_cheque_events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cheque_id` int NOT NULL,
  `event_type` varchar(20) NOT NULL,
  `event_date` date NOT NULL,
  `event_time` time NOT NULL,
  `event_uid` int NOT NULL,
  `reason` text,
  PRIMARY KEY (`id`),
  KEY `idx_cheque` (`cheque_id`),
  KEY `idx_event_type` (`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_supplier_cheque_events` */

/*Table structure for table `prod_supplier_cheque_stock` */

DROP TABLE IF EXISTS `prod_supplier_cheque_stock`;

CREATE TABLE `prod_supplier_cheque_stock` (
  `id` int NOT NULL AUTO_INCREMENT,
  `supplier_id` int NOT NULL,
  `cheque_number` varchar(255) NOT NULL,
  `bank_name` text,
  `entry_date` date NOT NULL,
  `entry_time` time NOT NULL,
  `entry_uid` int NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'AVAILABLE',
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_supplier` (`supplier_id`),
  KEY `idx_status` (`status`),
  KEY `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_supplier_cheque_stock` */

/*Table structure for table `prod_units` */

DROP TABLE IF EXISTS `prod_units`;

CREATE TABLE `prod_units` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `convertion_unit` varchar(255) DEFAULT NULL,
  `convertion_calculation` decimal(10,2) DEFAULT NULL,
  `is_active` int DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `prod_units` */

insert  into `prod_units`(`id`,`name`,`convertion_unit`,`convertion_calculation`,`is_active`) values 
(1,'NOS',NULL,NULL,1),
(2,'Gram',NULL,NULL,1),
(3,'KG',NULL,NULL,1),
(4,'Meter',NULL,NULL,1),
(5,'length','Feet',20.00,1);

/*Table structure for table `sales_area` */

DROP TABLE IF EXISTS `sales_area`;

CREATE TABLE `sales_area` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `is_active` int DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `sales_area` */

/*Table structure for table `sales_man` */

DROP TABLE IF EXISTS `sales_man`;

CREATE TABLE `sales_man` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `is_active` int DEFAULT '1',
  `created_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `sales_man` */

/*Table structure for table `special_permission` */

DROP TABLE IF EXISTS `special_permission`;

CREATE TABLE `special_permission` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `content` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `special_permission` */

insert  into `special_permission`(`id`,`content`) values 
(1,'allow to Zero stock billing ');

/*Table structure for table `user_modules` */

DROP TABLE IF EXISTS `user_modules`;

CREATE TABLE `user_modules` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `module_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;

/*Data for the table `user_modules` */

insert  into `user_modules`(`id`,`module_name`) values 
(1,'Billing'),
(2,'Master'),
(3,'Stock Reports'),
(4,'User management'),
(5,'Inventory'),
(6,'Account Report'),
(7,'Admin'),
(8,'Statistics'),
(10,'Credit Management'),
(11,'order list'),
(12,'Expense'),
(13,'Attendance'),
(14,'Balance Summary');

/*Table structure for table `user_permission` */

DROP TABLE IF EXISTS `user_permission`;

CREATE TABLE `user_permission` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `module_id` int NOT NULL,
  `uid` int NOT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mod` (`module_id`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=latin1;

/*Data for the table `user_permission` */

insert  into `user_permission`(`id`,`module_id`,`uid`,`date`,`time`) values 
(115,1,23,'2026-02-19','12:25:37'),
(117,1,22,'2026-02-27','11:51:13'),
(118,12,22,'2026-02-27','11:51:13'),
(119,1,24,'2026-03-05','17:40:35'),
(121,1,1,'2026-05-31','14:40:36'),
(122,2,1,'2026-05-31','14:40:36'),
(123,3,1,'2026-05-31','14:40:36'),
(124,4,1,'2026-05-31','14:40:36'),
(125,5,1,'2026-05-31','14:40:36'),
(126,6,1,'2026-05-31','14:40:36'),
(127,7,1,'2026-05-31','14:40:36'),
(128,8,1,'2026-05-31','14:40:36'),
(129,10,1,'2026-05-31','14:40:36'),
(130,11,1,'2026-05-31','14:40:36'),
(131,12,1,'2026-05-31','14:40:36'),
(132,13,1,'2026-05-31','14:40:36'),
(133,14,1,'2026-05-31','14:40:36');

/*Table structure for table `user_special_permission` */

DROP TABLE IF EXISTS `user_special_permission`;

CREATE TABLE `user_special_permission` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `content_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `user_special_permission` */

insert  into `user_special_permission`(`id`,`content_id`,`user_id`) values 
(1,1,1);

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `is_active` int DEFAULT '1',
  `fullName` varchar(255) DEFAULT NULL,
  `disc_per` int DEFAULT '100',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;

/*Data for the table `users` */

insert  into `users`(`id`,`user_name`,`password`,`is_active`,`fullName`,`disc_per`) values 
(1,'admin','aecbf9a63cec1e93327dfc212f31acdb31c4f5d10bedccf8fbb8b042a6f0f39155797bdd04517905ae5d98b69fdc452cdb61b018e10939740ec96f36e133d639',1,'admin',50),
(22,'demo','3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2',1,'demo',100),
(23,'hi','3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2',1,'hi',100),
(24,'saran','3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2',1,'saran',100);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
