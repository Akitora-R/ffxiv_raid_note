/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80019
 Source Host           : localhost:3306
 Source Schema         : mydb

 Target Server Type    : MySQL
 Target Server Version : 80019
 File Encoding         : 65001

 Date: 30/03/2020 23:38:49
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for mistake
-- ----------------------------
DROP TABLE IF EXISTS `mistake`;
CREATE TABLE `mistake`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `player_id` int(0) NULL DEFAULT NULL,
  `p1` int(0) NULL DEFAULT 0,
  `p2` int(0) NULL DEFAULT 0,
  `p3` int(0) NULL DEFAULT 0,
  `p4` int(0) NULL DEFAULT 0,
  `log_time` datetime(0) NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `valid` tinyint(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mistake
-- ----------------------------
INSERT INTO `mistake` VALUES (3, 6, 2, 0, 0, 0, '2020-03-08 20:44:56', '8走慢', NULL);
INSERT INTO `mistake` VALUES (4, 4, 0, 2, 0, 0, '2020-03-08 22:08:21', '接毒晚了', NULL);

-- ----------------------------
-- Table structure for phase
-- ----------------------------
DROP TABLE IF EXISTS `phase`;
CREATE TABLE `phase`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `phase` int(0) NULL DEFAULT NULL,
  `point` int(0) NULL DEFAULT NULL,
  `detail` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for player
-- ----------------------------
DROP TABLE IF EXISTS `player`;
CREATE TABLE `player`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `position` varchar(31) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `is_active` tinyint(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of player
-- ----------------------------
INSERT INTO `player` VALUES (1, 'BLM', 'D1', 1);
INSERT INTO `player` VALUES (2, 'D2', 'D2', 1);
INSERT INTO `player` VALUES (3, 'D3', 'D3', 1);
INSERT INTO `player` VALUES (4, '大島虎彦', 'D4', 1);
INSERT INTO `player` VALUES (5, 'WHM', 'H1', 1);
INSERT INTO `player` VALUES (6, 'SCH', 'H2', 1);
INSERT INTO `player` VALUES (7, 'T1', 'T1', 1);
INSERT INTO `player` VALUES (8, 'T2', 'T2', 1);

-- ----------------------------
-- Table structure for progress
-- ----------------------------
DROP TABLE IF EXISTS `progress`;
CREATE TABLE `progress`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `progress` int(0) NULL DEFAULT NULL,
  `date` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for timer
-- ----------------------------
DROP TABLE IF EXISTS `timer`;
CREATE TABLE `timer`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `begin` datetime(0) NULL DEFAULT NULL,
  `end` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of timer
-- ----------------------------
INSERT INTO `timer` VALUES (3, '2020-03-08 19:34:48', '2020-03-08 21:34:31');
INSERT INTO `timer` VALUES (4, '2020-03-08 22:00:54', '2020-03-08 23:09:56');

SET FOREIGN_KEY_CHECKS = 1;
