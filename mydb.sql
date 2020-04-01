/*
 Navicat Premium Data Transfer

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 80017
 Source Host           : localhost:3306
 Source Schema         : mydb

 Target Server Type    : MySQL
 Target Server Version : 80017
 File Encoding         : 65001

 Date: 01/04/2020 18:10:15
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for mistake
-- ----------------------------
DROP TABLE IF EXISTS `mistake`;
CREATE TABLE `mistake`  (
  `id` int(7) NOT NULL AUTO_INCREMENT,
  `player_id` int(7) NULL DEFAULT NULL,
  `p1` int(7) NULL DEFAULT 0,
  `p2` int(7) NULL DEFAULT 0,
  `p3` int(7) NULL DEFAULT 0,
  `p4` int(7) NULL DEFAULT 0,
  `log_time` datetime(0) NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `valid` bit(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for phase
-- ----------------------------
DROP TABLE IF EXISTS `phase`;
CREATE TABLE `phase`  (
  `id` int(7) NOT NULL AUTO_INCREMENT,
  `phase` int(7) NULL DEFAULT NULL,
  `point` int(7) NULL DEFAULT NULL,
  `detail` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of phase
-- ----------------------------
INSERT INTO `phase` VALUES (1, 1, 1, '第一次倾泻');
INSERT INTO `phase` VALUES (2, 1, 2, '小怪');
INSERT INTO `phase` VALUES (3, 1, 3, '第二次倾泻');
INSERT INTO `phase` VALUES (4, 1, 4, '窒息');
INSERT INTO `phase` VALUES (5, 1, 5, '第三次倾泻');
INSERT INTO `phase` VALUES (6, 1, 6, '水基佬狂暴');
INSERT INTO `phase` VALUES (7, 1, 7, '麻将');
INSERT INTO `phase` VALUES (8, 2, 1, '飞盘光子');
INSERT INTO `phase` VALUES (9, 2, 2, '第一次水雷');
INSERT INTO `phase` VALUES (10, 2, 3, '计算术');
INSERT INTO `phase` VALUES (11, 2, 4, '第二次水雷');
INSERT INTO `phase` VALUES (12, 2, 5, '等离子盾');
INSERT INTO `phase` VALUES (13, 2, 6, '第三次水雷');
INSERT INTO `phase` VALUES (14, 2, 7, '排队');
INSERT INTO `phase` VALUES (15, 2, 8, '超级跳+喷火');
INSERT INTO `phase` VALUES (16, 2, 9, '飞机/正义狂暴');
INSERT INTO `phase` VALUES (17, 3, 1, '0.5运');
INSERT INTO `phase` VALUES (18, 3, 2, '1运');
INSERT INTO `phase` VALUES (19, 3, 3, '中场死刑');
INSERT INTO `phase` VALUES (20, 3, 4, '2运');
INSERT INTO `phase` VALUES (21, 3, 5, '飞机正义');
INSERT INTO `phase` VALUES (22, 3, 6, '亚历山大狂暴');
INSERT INTO `phase` VALUES (23, 4, 1, '0.5测');
INSERT INTO `phase` VALUES (24, 4, 2, '分散分摊');
INSERT INTO `phase` VALUES (25, 4, 3, '1测');
INSERT INTO `phase` VALUES (26, 4, 4, '中场死刑');
INSERT INTO `phase` VALUES (27, 4, 5, '2测');
INSERT INTO `phase` VALUES (28, 4, 6, '审判1');
INSERT INTO `phase` VALUES (29, 4, 7, '审判2');
INSERT INTO `phase` VALUES (30, 4, 8, '完美亚历山大狂暴');

-- ----------------------------
-- Table structure for player
-- ----------------------------
DROP TABLE IF EXISTS `player`;
CREATE TABLE `player`  (
  `id` int(7) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `position` varchar(31) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `active` tinyint(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of player
-- ----------------------------
INSERT INTO `player` VALUES (1, 'D1', 'D1', 1);
INSERT INTO `player` VALUES (2, 'D2', 'D2', 1);
INSERT INTO `player` VALUES (3, 'D3', 'D3', 1);
INSERT INTO `player` VALUES (4, 'D4', 'D4', 1);
INSERT INTO `player` VALUES (5, 'H1', 'H1', 1);
INSERT INTO `player` VALUES (6, 'H2', 'H2', 1);
INSERT INTO `player` VALUES (7, 'T1', 'T1', 1);
INSERT INTO `player` VALUES (8, 'T2', 'T2', 1);

-- ----------------------------
-- Table structure for progress
-- ----------------------------
DROP TABLE IF EXISTS `progress`;
CREATE TABLE `progress`  (
  `id` int(7) NOT NULL AUTO_INCREMENT,
  `progress` int(7) NULL DEFAULT NULL,
  `date` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for timer
-- ----------------------------
DROP TABLE IF EXISTS `timer`;
CREATE TABLE `timer`  (
  `id` int(7) NOT NULL AUTO_INCREMENT,
  `begin` datetime(0) NULL DEFAULT NULL,
  `end` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
