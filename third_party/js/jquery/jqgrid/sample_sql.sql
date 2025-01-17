-- phpMyAdmin SQL Dump
-- version 2.11.9.4
-- http://www.phpmyadmin.net
--
-- Host: 10.6.186.24
-- Generation Time: Aug 07, 2009 at 12:10 PM
-- Server version: 5.0.67
-- PHP Version: 5.2.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `Mine`
--

-- --------------------------------------------------------

--
-- Table structure for table `jqgrid`
--

CREATE TABLE `jqgrid` (
  `id` int(100) NOT NULL,
  `title` varchar(1000) NOT NULL,
  `director` varchar(1000) NOT NULL,
  `year` int(11) NOT NULL,
  `bond` varchar(1000) NOT NULL,
  `budget` double NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `jqgrid`
--

INSERT INTO `jqgrid` VALUES(1, 'Dr. No', 'Terence Young', 1962, 'Sean Connery', 0.9);
INSERT INTO `jqgrid` VALUES(2, 'From Russia With Love', 'Terence Young', 1963, 'Sean Connery', 2);
INSERT INTO `jqgrid` VALUES(3, 'Goldfinger', 'Guy Hamilton', 1964, 'Sean Connery', 3);
INSERT INTO `jqgrid` VALUES(4, 'Thunderball', 'Terence Young', 1965, 'Sean Connery', 5.5);
INSERT INTO `jqgrid` VALUES(5, 'You Only Live Twice', 'Lewis Gilbert', 1967, 'Sean Connery', 8.5);
INSERT INTO `jqgrid` VALUES(6, 'On Her Majesty''s Secret Service', 'Peter R. Hunt', 1969, 'George Lazenby ', 7);
INSERT INTO `jqgrid` VALUES(7, 'Diamonds Are Forever', 'Guy Hamilton', 1971, 'Sean Connery', 8.5);
INSERT INTO `jqgrid` VALUES(8, 'Live and Let Die', 'Guy Hamilton', 1973, ' Roger Moore', 10);
INSERT INTO `jqgrid` VALUES(9, 'The Man with the Golden Gun ', 'Guy Hamilton', 1974, 'Roger Moore', 13);
INSERT INTO `jqgrid` VALUES(10, 'The Living Daylights', 'John Glen', 1987, 'Timothy Dalton', 30);
INSERT INTO `jqgrid` VALUES(11, 'A View to a Kill', 'John Glen', 1985, 'Roger Moore', 25);
INSERT INTO `jqgrid` VALUES(12, 'The Spy Who Loved Me', 'Lewis Gilbert', 1977, 'Roger Moore', 14);
INSERT INTO `jqgrid` VALUES(13, 'Moonraker', 'Lewis Gilbert', 1979, 'Roger Moore', 27);
INSERT INTO `jqgrid` VALUES(14, 'For Your Eyes Only', 'John Glen', 1981, 'Roger Moore', 27);
INSERT INTO `jqgrid` VALUES(15, 'Octopussy', 'John Glen', 1983, 'Roger Moore', 25);
INSERT INTO `jqgrid` VALUES(16, 'Licence to Kill', 'John Glen', 1989, 'Timothy Dalton', 36);
INSERT INTO `jqgrid` VALUES(17, 'GoldenEye', 'Martin Campbell', 1995, 'Pierce Brosnan', 58);
INSERT INTO `jqgrid` VALUES(18, 'Tomorrow Never Dies', 'Roger Spottiswoode', 1997, 'Pierce Brosnan', 110);
INSERT INTO `jqgrid` VALUES(19, 'The World is Not Enough', 'Michael Apted', 1999, 'Pierce Brosnan', 135);
INSERT INTO `jqgrid` VALUES(20, 'Die Another Day', 'Lee Tamahori', 2002, 'Pierce Brosnan', 142);
INSERT INTO `jqgrid` VALUES(21, 'Casino Royale', 'Martin Campbell', 2006, 'Daniel Craig', 150);
INSERT INTO `jqgrid` VALUES(22, 'Quantum of Solace', 'Marc Forster', 2008, 'Daniel Craig', 200);
