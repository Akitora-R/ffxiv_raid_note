```sql
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

 Date: 18/03/2020 09:00:09
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for mistake
-- ----------------------------
DROP TABLE IF EXISTS `mistake`;
CREATE TABLE `mistake`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NULL DEFAULT NULL,
  `p1` int(11) NULL DEFAULT 0,
  `p2` int(11) NULL DEFAULT 0,
  `p3` int(11) NULL DEFAULT 0,
  `p4` int(11) NULL DEFAULT 0,
  `log_time` datetime(0) NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `valid` bit(1) NULL DEFAULT NULL COMMENT '有效与否',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of mistake
-- ----------------------------
INSERT INTO `mistake` VALUES (11, 4, 1, 0, 0, 0, '2020-03-12 16:09:37', '活着', b'1');
INSERT INTO `mistake` VALUES (12, 4, 1, 0, 0, 0, '2020-03-12 16:09:37', '活着', b'1');
INSERT INTO `mistake` VALUES (13, 4, 1, 0, 0, 0, '2020-03-13 16:09:37', '活着', b'1');
INSERT INTO `mistake` VALUES (14, 4, 1, 0, 0, 0, '2020-03-17 16:09:37', '活着', b'1');
INSERT INTO `mistake` VALUES (15, 3, 1, 0, 0, 0, '2020-03-17 16:09:37', '活着', b'1');
INSERT INTO `mistake` VALUES (16, 2, 1, 0, 0, 0, '2020-03-17 16:09:37', '活着', b'1');
INSERT INTO `mistake` VALUES (17, 2, 1, 0, 0, 0, '2020-03-18 16:09:37', '活着', b'1');
INSERT INTO `mistake` VALUES (18, 2, 1, 0, 0, 0, '2020-03-18 16:09:37', '活着', b'1');
INSERT INTO `mistake` VALUES (19, 2, 1, 0, 0, 0, '2020-03-18 16:09:37', '活着', b'1');

-- ----------------------------
-- Table structure for player
-- ----------------------------
DROP TABLE IF EXISTS `player`;
CREATE TABLE `player`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `position` varchar(31) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `active` tinyint(1) NULL DEFAULT NULL,
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
-- Table structure for timer
-- ----------------------------
DROP TABLE IF EXISTS `timer`;
CREATE TABLE `timer`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `begin` datetime(0) NULL DEFAULT NULL,
  `end` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;

```