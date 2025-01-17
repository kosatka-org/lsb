-- phpMyAdmin SQL Dump
-- version 3.2.3
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 08, 2013 at 04:29 PM
-- Server version: 5.1.40
-- PHP Version: 5.3.13

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `ok__luxury`
--

-- --------------------------------------------------------

--
-- Table structure for table `locations2links`
--

DROP TABLE IF EXISTS `locations2links`;
CREATE TABLE IF NOT EXISTS `locations2links` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `sex` tinyint(4) NOT NULL,
  `item_location` varchar(255) CHARACTER SET utf8 NOT NULL,
  `name` varchar(255) NOT NULL,
  `link` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=61 ;

--
-- Dumping data for table `locations2links`
--

INSERT INTO `locations2links` (`id`, `sex`, `item_location`, `name`, `link`) VALUES
(1, 1, '', 'Luxury Store', 'http://ru.lsboutique.ru/db/shops/'),
(2, 1, 'Luxury Store (НВН)', 'Luxury Store', 'http://ru.lsboutique.ru/db/shops/muzhskoy_zal_luxury_store'),
(3, 1, 'ПОДИУМ#Podium VIP', 'Podium VIP', 'http://ru.lsboutique.ru/db/shops/podium_vip'),
(4, 1, 'Podium VIP', 'Podium VIP', 'http://ru.lsboutique.ru/db/shops/podium_vip'),
(5, 1, 'Out Let', 'Outlet Luxury Store', 'http://ru.lsboutique.ru/db/shops/outlet_luxury_store_2'),
(6, 1, 'Luxury Store (Этажи)', 'Luxury Store Concept', 'http://ru.lsboutique.ru/db/shops/luxury_store_concept_2'),
(7, 1, 'Ice Iceberg', 'ICE iceberg', 'http://ru.lsboutique.ru/db/shops/ice_iceberg'),
(8, 1, 'Интернет-магазин', 'Luxury Store', 'http://lsboutique.ru/'),
(9, 1, 'Отложка LS(НВН)', 'Luxury Store', 'http://ru.lsboutique.ru/db/shops/muzhskoy_zal_luxury_store'),
(10, 1, 'Out Let#Luxury Store (Этажи)', 'Outlet Luxury Store', 'http://ru.lsboutique.ru/db/shops/outlet_luxury_store_2'),
(11, 1, 'ПОДИУМ', 'Podium Элита', 'http://ru.lsboutique.ru/db/shops/podium_elita'),
(12, 1, 'Luxury Store (НВН)#Out Let', 'Outlet Luxury Store', 'http://ru.lsboutique.ru/db/shops/outlet_luxury_store_2'),
(13, 1, 'Luxury Store (Этажи)#Out Let', 'Outlet Luxury Store', 'http://ru.lsboutique.ru/db/shops/outlet_luxury_store_2'),
(14, 1, 'Luxury Store (НВН)#Podium VIP', 'Podium VIP', 'http://ru.lsboutique.ru/db/shops/podium_vip'),
(15, 1, 'Ice Iceberg#Luxury Store (Этажи)#Luxury Store (НВН)', 'Luxury Store Concept', 'http://ru.lsboutique.ru/db/shops/luxury_store_concept_2'),
(16, 1, 'Ice Iceberg#Luxury Store (Этажи)', 'Luxury Store Concept', 'http://ru.lsboutique.ru/db/shops/luxury_store_concept_2'),
(17, 1, 'Luxury Store (Этажи)#Luxury Store (НВН)', 'Luxury Store Concept', 'http://ru.lsboutique.ru/db/shops/luxury_store_concept_2'),
(18, 1, 'Luxury Store (НВН)#Luxury Store (Этажи)', 'Luxury Store Concept', 'http://ru.lsboutique.ru/db/shops/luxury_store_concept_2'),
(19, 1, 'Podium VIP#Luxury Store (НВН)', 'Podium VIP', 'http://ru.lsboutique.ru/db/shops/podium_vip'),
(20, 1, 'Podium VIP#Luxury Store (Этажи)', 'Podium VIP', 'http://ru.lsboutique.ru/db/shops/podium_vip'),
(21, 2, '', 'Luxury Store', 'http://ru.lsboutique.ru/db/shops/'),
(22, 2, 'Luxury Store (НВН)', 'Luxury Store', 'http://ru.lsboutique.ru/db/shops/zhenskiy_zal_luxury_store'),
(23, 2, 'ПОДИУМ#Podium VIP', 'Podium VIP', 'http://ru.lsboutique.ru/db/shops/podium_vip'),
(24, 2, 'Podium VIP', 'Podium VIP', 'http://ru.lsboutique.ru/db/shops/podium_vip'),
(25, 2, 'Out Let', 'Outlet Luxury Store', 'http://ru.lsboutique.ru/db/shops/outlet_luxury_store_2'),
(26, 2, 'Luxury Store (Этажи)', 'Luxury Store Concept', 'http://ru.lsboutique.ru/db/shops/luxury_store_concept_2'),
(27, 2, 'Ice Iceberg', 'ICE iceberg', 'http://ru.lsboutique.ru/db/shops/ice_iceberg'),
(28, 2, 'Интернет-магазин', 'Luxury Store', 'http://lsboutique.ru/'),
(29, 2, 'Отложка LS(НВН)', 'Luxury Store', 'http://ru.lsboutique.ru/db/shops/zhenskiy_zal_luxury_store'),
(30, 2, 'Out Let#Luxury Store (Этажи)', 'Outlet Luxury Store', 'http://ru.lsboutique.ru/db/shops/outlet_luxury_store_2'),
(31, 2, 'ПОДИУМ', 'Podium Элита', 'http://ru.lsboutique.ru/db/shops/podium_elita'),
(32, 2, 'Luxury Store (НВН)#Out Let', 'Outlet Luxury Store', 'http://ru.lsboutique.ru/db/shops/outlet_luxury_store_2'),
(33, 2, 'Luxury Store (Этажи)#Out Let', 'Outlet Luxury Store', 'http://ru.lsboutique.ru/db/shops/outlet_luxury_store_2'),
(34, 2, 'Luxury Store (НВН)#Podium VIP', 'Podium VIP', 'http://ru.lsboutique.ru/db/shops/podium_vip'),
(35, 2, 'Ice Iceberg#Luxury Store (Этажи)#Luxury Store (НВН)', 'Luxury Store Concept', 'http://ru.lsboutique.ru/db/shops/luxury_store_concept_2'),
(36, 2, 'Ice Iceberg#Luxury Store (Этажи)', 'Luxury Store Concept', 'http://ru.lsboutique.ru/db/shops/luxury_store_concept_2'),
(37, 2, 'Luxury Store (Этажи)#Luxury Store (НВН)', 'Luxury Store Concept', 'http://ru.lsboutique.ru/db/shops/luxury_store_concept_2'),
(38, 2, 'Luxury Store (НВН)#Luxury Store (Этажи)', 'Luxury Store Concept', 'http://ru.lsboutique.ru/db/shops/luxury_store_concept_2'),
(39, 2, 'Podium VIP#Luxury Store (НВН)', 'Podium VIP', 'http://ru.lsboutique.ru/db/shops/podium_vip'),
(40, 2, 'Podium VIP#Luxury Store (Этажи)', 'Podium VIP', 'http://ru.lsboutique.ru/db/shops/podium_vip'),
(41, 0, '', 'Luxury Store', 'http://ru.lsboutique.ru/db/shops/'),
(42, 0, 'Luxury Store (НВН)', 'Luxury Store', 'http://ru.lsboutique.ru/db/shops/muzhskoy_zal_luxury_store'),
(43, 0, 'ПОДИУМ#Podium VIP', 'Podium VIP', 'http://ru.lsboutique.ru/db/shops/podium_vip'),
(44, 0, 'Podium VIP', 'Podium VIP', 'http://ru.lsboutique.ru/db/shops/podium_vip'),
(45, 0, 'Out Let', 'Outlet Luxury Store', 'http://ru.lsboutique.ru/db/shops/outlet_luxury_store_2'),
(46, 0, 'Luxury Store (Этажи)', 'Luxury Store Concept', 'http://ru.lsboutique.ru/db/shops/luxury_store_concept_2'),
(47, 0, 'Ice Iceberg', 'ICE iceberg', 'http://ru.lsboutique.ru/db/shops/ice_iceberg'),
(48, 0, 'Интернет-магазин', 'Luxury Store', 'http://lsboutique.ru/'),
(49, 0, 'Отложка LS(НВН)', 'Luxury Store', 'http://ru.lsboutique.ru/db/shops/muzhskoy_zal_luxury_store'),
(50, 0, 'Out Let#Luxury Store (Этажи)', 'Outlet Luxury Store', 'http://ru.lsboutique.ru/db/shops/outlet_luxury_store_2'),
(51, 0, 'ПОДИУМ', 'Podium Элита', 'http://ru.lsboutique.ru/db/shops/podium_elita'),
(52, 0, 'Luxury Store (НВН)#Out Let', 'Outlet Luxury Store', 'http://ru.lsboutique.ru/db/shops/outlet_luxury_store_2'),
(53, 0, 'Luxury Store (Этажи)#Out Let', 'Outlet Luxury Store', 'http://ru.lsboutique.ru/db/shops/outlet_luxury_store_2'),
(54, 0, 'Luxury Store (НВН)#Podium VIP', 'Podium VIP', 'http://ru.lsboutique.ru/db/shops/podium_vip'),
(55, 0, 'Ice Iceberg#Luxury Store (Этажи)#Luxury Store (НВН)', 'Luxury Store Concept', 'http://ru.lsboutique.ru/db/shops/luxury_store_concept_2'),
(56, 0, 'Ice Iceberg#Luxury Store (Этажи)', 'Luxury Store Concept', 'http://ru.lsboutique.ru/db/shops/luxury_store_concept_2'),
(57, 0, 'Luxury Store (Этажи)#Luxury Store (НВН)', 'Luxury Store Concept', 'http://ru.lsboutique.ru/db/shops/luxury_store_concept_2'),
(58, 0, 'Luxury Store (НВН)#Luxury Store (Этажи)', 'Luxury Store Concept', 'http://ru.lsboutique.ru/db/shops/luxury_store_concept_2'),
(59, 0, 'Podium VIP#Luxury Store (НВН)', 'Podium VIP', 'http://ru.lsboutique.ru/db/shops/podium_vip'),
(60, 0, 'Podium VIP#Luxury Store (Этажи)', 'Podium VIP', 'http://ru.lsboutique.ru/db/shops/podium_vip');
