
-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 2025-01-08
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Database: `mymemberlinkdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_email` varchar(255) NOT NULL,
  `user_pass` varchar(255) NOT NULL,
  `user_datereg` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_email` (`user_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_pass`, `user_datereg`) VALUES
(1, 'slumberjer@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '2024-10-23 15:44:57'),
(10, 'sayaali@gmail.com', '792faa46d69a0d0fc1afdc0d37964067a92590bd', '2024-11-27 20:03:01'),
(13, 'sayainas@gmail.com', '951c57c0c4fb684b58fe6b6197f7b72bbba08d', '2024-12-12 18:13:47');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_news`
--

CREATE TABLE `tbl_news` (
  `news_id` int(3) NOT NULL AUTO_INCREMENT,
  `news_title` varchar(300) NOT NULL,
  `news_details` text NOT NULL,
  `news_date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`news_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_news`
--

INSERT INTO `tbl_news` (`news_id`, `news_title`, `news_details`, `news_date`) VALUES
(1, 'Exclusive Member Rewards Unlocked!', 'We’re excited to announce a new rewards program exclusively for our valued members!', '2024-10-30 15:46:06'),
(7, 'Potential Flood Alert Issued for UUM Sintok Area', 'Authorities warn of possible flooding in UUM Sintok area.', '2024-11-27 21:10:09'),
(8, 'Examination a241', 'system.out.print("hello world");', '2024-11-27 23:15:41');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_products`
--

CREATE TABLE `tbl_products` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_title` varchar(255) NOT NULL,
  `product_description` text NOT NULL,
  `product_image` varchar(255) NOT NULL,
  `product_quantity` int(11) NOT NULL,
  `product_price` decimal(10,2) NOT NULL,
  `product_type` varchar(50) NOT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_products`
--

INSERT INTO `tbl_products` (`product_id`, `product_title`, `product_description`, `product_image`, `product_quantity`, `product_price`, `product_type`) VALUES
(3, 'Conference Ticket', 'Access to the 2024 Annual Tech Conference.', 'assets/images/cticket.png', 100, 39.99, 'Ticket'),
(4, 'Mymemberlink Shirt', 'Very comfortable cotton shirt with the Mymemberlink logo.', 'assets/images/baju.png', 50, 30.00, 'Apparel'),
(5, 'Exclusive Cup', 'A limited edition cup with an exclusive design.', 'assets/images/cup.png', 30, 15.00, 'Merchandise');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_events`
--

CREATE TABLE `tbl_events` (
  `event_id` int(11) NOT NULL AUTO_INCREMENT,
  `event_title` varchar(255) NOT NULL,
  `event_description` text NOT NULL,
  `event_startdate` datetime NOT NULL,
  `event_enddate` datetime NOT NULL,
  `event_type` varchar(50) NOT NULL,
  `event_location` varchar(255) NOT NULL,
  `event_filename` varchar(255) NOT NULL,
  `event_date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_events`
--

INSERT INTO `tbl_events` (`event_id`, `event_title`, `event_description`, `event_startdate`, `event_enddate`, `event_type`, `event_location`, `event_filename`, `event_date`) VALUES
(4, 'Kerusi Ikea', 'Penjualan Kerusi Ikea Premium', '2024-12-10 08:30:00', '2024-12-10 10:30:00', 'Conference', 'Ikea Batu Kawan', 'event-bfkjdybx3.jpg', '2024-12-12 08:27:34'),
(5, 'efef', 'efef', '2024-12-10 02:06:00', '2024-12-10 03:06:00', 'Conference', 'efef', 'event-2bftxh8cv6.jpg', '2024-12-12 10:06:47');

COMMIT;
