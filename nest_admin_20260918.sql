-- MySQL dump 10.13  Distrib 5.7.26, for Win64 (x86_64)
--
-- Host: localhost    Database: nest_admin
-- ------------------------------------------------------
-- Server version	5.7.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ai`
--

DROP TABLE IF EXISTS `ai`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ai` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(255) DEFAULT NULL COMMENT '创建人',
  `create_user_id` varchar(255) DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_user` varchar(255) DEFAULT NULL COMMENT '更新人',
  `is_delete` char(1) DEFAULT NULL COMMENT '是否删除: NULL未删除，1删除',
  `user_id` varchar(255) DEFAULT NULL,
  `sessionId` varchar(255) DEFAULT NULL COMMENT '会话id',
  `question` varchar(255) DEFAULT NULL COMMENT '问题标题',
  `answer` varchar(10000) DEFAULT NULL COMMENT '回答内容',
  `is_collect` char(1) NOT NULL DEFAULT '0' COMMENT '是否收藏: 1是，0否，默认0',
  `is_session` char(1) NOT NULL DEFAULT '0' COMMENT '是否会话: 1是，0否，默认0',
  `userId` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_c5d55852810417bb80c1d2e6b6a` (`userId`),
  CONSTRAINT `FK_c5d55852810417bb80c1d2e6b6a` FOREIGN KEY (`userId`) REFERENCES `sys_user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai`
--

LOCK TABLES `ai` WRITE;
/*!40000 ALTER TABLE `ai` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `busi_article`
--

DROP TABLE IF EXISTS `busi_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `busi_article` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(255) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_user` varchar(255) DEFAULT NULL COMMENT '更新人',
  `is_delete` char(1) DEFAULT NULL COMMENT '是否删除: NULL未删除，1删除',
  `title` varchar(255) DEFAULT NULL,
  `desc` varchar(255) DEFAULT NULL,
  `catalog_id` bigint(20) DEFAULT NULL COMMENT '目录id',
  `thumb` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `order` varchar(8) NOT NULL DEFAULT '1' COMMENT '排序',
  `create_user_id` varchar(255) DEFAULT NULL COMMENT '创建人ID',
  `status` enum('0','1','2','3') NOT NULL DEFAULT '2' COMMENT '菜单类型，默认 2',
  `publish_time` datetime DEFAULT NULL COMMENT '定时发布时间',
  PRIMARY KEY (`id`),
  KEY `FK_779981e648bdd5f860a77d89f70` (`catalog_id`),
  CONSTRAINT `FK_779981e648bdd5f860a77d89f70` FOREIGN KEY (`catalog_id`) REFERENCES `busi_article_catalog` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `busi_article`
--

LOCK TABLES `busi_article` WRITE;
/*!40000 ALTER TABLE `busi_article` DISABLE KEYS */;
/*!40000 ALTER TABLE `busi_article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `busi_article_catalog`
--

DROP TABLE IF EXISTS `busi_article_catalog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `busi_article_catalog` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(255) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_user` varchar(255) DEFAULT NULL COMMENT '更新人',
  `is_delete` char(1) DEFAULT NULL COMMENT '是否删除: NULL未删除，1删除',
  `name` varchar(255) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL COMMENT '父级id',
  `create_user_id` varchar(255) DEFAULT NULL COMMENT '创建人ID',
  PRIMARY KEY (`id`),
  KEY `FK_0dfc936d2a2d433f628e1867200` (`parent_id`),
  CONSTRAINT `FK_0dfc936d2a2d433f628e1867200` FOREIGN KEY (`parent_id`) REFERENCES `busi_article_catalog` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `busi_article_catalog`
--

LOCK TABLES `busi_article_catalog` WRITE;
/*!40000 ALTER TABLE `busi_article_catalog` DISABLE KEYS */;
/*!40000 ALTER TABLE `busi_article_catalog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `busi_article_catalog_closure`
--

DROP TABLE IF EXISTS `busi_article_catalog_closure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `busi_article_catalog_closure` (
  `id_ancestor` bigint(20) NOT NULL,
  `id_descendant` bigint(20) NOT NULL,
  PRIMARY KEY (`id_ancestor`,`id_descendant`),
  KEY `IDX_b54dc4901c089fb17feae9b182` (`id_ancestor`),
  KEY `IDX_f464e150a4bf852a4a7973233f` (`id_descendant`),
  CONSTRAINT `FK_b54dc4901c089fb17feae9b1828` FOREIGN KEY (`id_ancestor`) REFERENCES `busi_article_catalog` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_f464e150a4bf852a4a7973233f4` FOREIGN KEY (`id_descendant`) REFERENCES `busi_article_catalog` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `busi_article_catalog_closure`
--

LOCK TABLES `busi_article_catalog_closure` WRITE;
/*!40000 ALTER TABLE `busi_article_catalog_closure` DISABLE KEYS */;
/*!40000 ALTER TABLE `busi_article_catalog_closure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `family_member`
--

DROP TABLE IF EXISTS `family_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `family_member` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(255) DEFAULT NULL COMMENT '创建人',
  `create_user_id` varchar(255) DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_user` varchar(255) DEFAULT NULL COMMENT '更新人',
  `is_delete` char(1) DEFAULT NULL COMMENT '是否删除: NULL未删除，1删除',
  `name` varchar(20) DEFAULT NULL COMMENT '姓名',
  `formerName` varchar(20) DEFAULT NULL COMMENT '曾用名',
  `gender` tinyint(4) NOT NULL DEFAULT '1' COMMENT '性别: 1男 0女',
  `city` varchar(50) DEFAULT NULL COMMENT '所在城市',
  `birthplace` varchar(50) DEFAULT NULL COMMENT '出生地',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `avatar` varchar(500) DEFAULT NULL COMMENT '头像',
  `parentId` bigint(20) DEFAULT NULL COMMENT '父节点ID(族谱用,兼容旧数据)',
  `is_active` char(1) NOT NULL DEFAULT '1' COMMENT '是否激活: 1是，0否，默认1',
  `fatherId` bigint(20) DEFAULT NULL COMMENT '父亲ID',
  `motherId` bigint(20) DEFAULT NULL COMMENT '母亲ID',
  `spouseId` bigint(20) DEFAULT NULL COMMENT '配偶ID',
  `generation` int(11) DEFAULT NULL COMMENT '世代(相对世代,基准代可自定义,允许负数)',
  `birth` date DEFAULT NULL COMMENT '出生年月',
  `death` date DEFAULT NULL COMMENT '逝世年月',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `family_member`
--

LOCK TABLES `family_member` WRITE;
/*!40000 ALTER TABLE `family_member` DISABLE KEYS */;
INSERT INTO `family_member` VALUES (1,'2026-09-11 15:19:37','admin','46','2026-09-11 16:24:14','admin',NULL,'杨皓','宁宁',1,'江苏省/无锡市/惠山区','黑龙江省/牡丹江市/宁安市','15555555555','avatar\\2026-09-11/1789111176400-381401426.jpg',5,'1',5,NULL,NULL,1,NULL,NULL,NULL),(2,'2026-09-11 16:25:38','admin','46','2026-09-11 20:23:13',NULL,NULL,'王佳',NULL,0,'江苏省/苏州市/昆山市','黑龙江省/牡丹江市/宁安市','15555555556','avatar\\2026-09-11/1789115136283-678624643.jpg',6,'1',NULL,6,3,1,NULL,NULL,NULL),(3,'2026-09-11 16:26:48','admin','46','2026-09-11 17:20:13',NULL,NULL,'曾飞家',NULL,1,'江苏省/苏州市/昆山市','重庆市/县/云阳县','15555555557',NULL,NULL,'1',NULL,NULL,2,1,NULL,NULL,NULL),(4,'2026-09-11 16:51:16','admin','46','2026-09-11 20:23:13','admin',NULL,'曾家豪',NULL,1,'江苏省/苏州市/昆山市','江苏省/苏州市/昆山市','15666666668',NULL,2,'1',NULL,2,NULL,1,NULL,NULL,NULL),(5,'2026-09-11 17:11:36','admin','46','2026-09-11 20:23:13',NULL,NULL,'杨明新',NULL,1,'黑龙江省/牡丹江市/宁安市','黑龙江省/牡丹江市/海林市','13333333333',NULL,7,'1',NULL,7,NULL,4,'1969-06-01',NULL,NULL),(6,'2026-09-11 17:12:19','admin','46','2026-09-11 20:23:13','admin',NULL,'杨明华',NULL,0,NULL,NULL,'1222222222',NULL,7,'1',NULL,7,NULL,4,NULL,NULL,NULL),(7,'2026-09-11 17:27:58','admin','46',NULL,NULL,NULL,'李桂琴',NULL,0,NULL,NULL,'15555555555',NULL,NULL,'1',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `family_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` char(1) DEFAULT NULL COMMENT '是否删除: NULL未删除，1删除',
  `create_user` varchar(255) DEFAULT NULL COMMENT '创建人',
  `update_user` varchar(255) DEFAULT NULL COMMENT '更新人',
  `system_name` varchar(255) DEFAULT NULL,
  `system_logo` varchar(255) DEFAULT NULL,
  `create_user_id` varchar(255) DEFAULT NULL COMMENT '创建人ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_dept` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `parent_id` bigint(20) DEFAULT NULL COMMENT '父级id',
  `is_delete` char(1) DEFAULT NULL COMMENT '是否删除: NULL未删除，1删除',
  `create_user` varchar(255) DEFAULT NULL COMMENT '创建人',
  `update_user` varchar(255) DEFAULT NULL COMMENT '更新人',
  `name` varchar(255) DEFAULT NULL COMMENT '部门名称',
  `create_user_id` varchar(255) DEFAULT NULL COMMENT '创建人ID',
  PRIMARY KEY (`id`),
  KEY `FK_92dad1cb42d3b62bc9f2e8e58ba` (`parent_id`),
  CONSTRAINT `FK_92dad1cb42d3b62bc9f2e8e58ba` FOREIGN KEY (`parent_id`) REFERENCES `sys_dept` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (1,'2026-08-27 16:57:23',NULL,NULL,NULL,'admin',NULL,'秘书处','46'),(2,'2026-09-11 14:42:20',NULL,NULL,NULL,'admin',NULL,'家族管理员','46');
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept_closure`
--

DROP TABLE IF EXISTS `sys_dept_closure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_dept_closure` (
  `id_ancestor` bigint(20) NOT NULL,
  `id_descendant` bigint(20) NOT NULL,
  PRIMARY KEY (`id_ancestor`,`id_descendant`),
  KEY `IDX_cfc440ee3ad8e00d7706a5769b` (`id_ancestor`),
  KEY `IDX_aec3172874d6b45638d3c50566` (`id_descendant`),
  CONSTRAINT `FK_aec3172874d6b45638d3c505667` FOREIGN KEY (`id_descendant`) REFERENCES `sys_dept` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_cfc440ee3ad8e00d7706a5769b1` FOREIGN KEY (`id_ancestor`) REFERENCES `sys_dept` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept_closure`
--

LOCK TABLES `sys_dept_closure` WRITE;
/*!40000 ALTER TABLE `sys_dept_closure` DISABLE KEYS */;
INSERT INTO `sys_dept_closure` VALUES (1,1),(2,2);
/*!40000 ALTER TABLE `sys_dept_closure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_login_log`
--

DROP TABLE IF EXISTS `sys_login_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_login_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` char(1) DEFAULT NULL COMMENT '是否删除: NULL未删除，1删除',
  `is_success` char(1) NOT NULL DEFAULT '1' COMMENT '是否登录成功: 1是，0否，默认1',
  `session` varchar(200) DEFAULT NULL COMMENT '会话编号',
  `msg` varchar(500) NOT NULL DEFAULT '登录成功' COMMENT '提示消息',
  `create_user` varchar(255) DEFAULT NULL COMMENT '创建人',
  `update_user` varchar(255) DEFAULT NULL COMMENT '更新人',
  `account` varchar(255) DEFAULT NULL COMMENT '登录账号',
  `password` varchar(255) DEFAULT NULL COMMENT '登录密码',
  `ip` varchar(255) DEFAULT NULL COMMENT 'ip地址',
  `address` varchar(255) DEFAULT NULL COMMENT '登录地点',
  `browser` varchar(255) DEFAULT NULL COMMENT '浏览器类型',
  `os` varchar(255) DEFAULT NULL COMMENT '操作系统',
  `create_user_id` varchar(255) DEFAULT NULL COMMENT '创建人ID',
  `country_code` varchar(255) DEFAULT NULL COMMENT '国家代码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_login_log`
--

LOCK TABLES `sys_login_log` WRITE;
/*!40000 ALTER TABLE `sys_login_log` DISABLE KEYS */;
INSERT INTO `sys_login_log` VALUES (109,'2026-08-05 23:39:02',NULL,NULL,'0',NULL,'用户不存在',NULL,NULL,'NestAdmin','123456','::1',NULL,'Chrome','Windows',NULL,NULL),(110,'2026-08-05 23:39:10',NULL,NULL,'0',NULL,'用户不存在',NULL,NULL,'admin','admin123','::1',NULL,'Chrome','Windows',NULL,NULL),(111,'2026-08-05 23:39:25',NULL,NULL,'0',NULL,'用户不存在',NULL,NULL,'admin','admin123','::1',NULL,'Chrome','Windows',NULL,NULL),(112,'2026-08-05 23:41:39',NULL,NULL,'0',NULL,'密码错误',NULL,NULL,'admin','123456','::1',NULL,'Chrome','Windows',NULL,NULL),(113,'2026-08-05 23:41:44',NULL,NULL,'0',NULL,'验证码错误',NULL,NULL,'admin','123456','::1',NULL,'Chrome','Windows',NULL,NULL),(114,'2026-08-05 23:41:51',NULL,NULL,'0',NULL,'密码错误',NULL,NULL,'admin','123456','::1',NULL,'Chrome','Windows',NULL,NULL),(115,'2026-08-05 23:42:27',NULL,NULL,'0',NULL,'密码错误',NULL,NULL,'admin','123456','::1',NULL,'Chrome','Windows',NULL,NULL),(116,'2026-08-05 23:45:06',NULL,NULL,'1','2hQI3yfztHnrZ-EFvmj7G293c-UB5_lRZ077cT_x970','登录成功',NULL,NULL,'admin','123456','::1','本地','Chrome','Windows',NULL,NULL),(117,'2026-08-05 23:45:31',NULL,NULL,'1','2hQI3yfztHnrZ-EFvmj7G293c-UB5_lRZ077cT_x970','退出登录',NULL,NULL,'admin',NULL,'::1','本地','Chrome','Windows',NULL,NULL),(118,'2026-08-06 00:08:59',NULL,NULL,'0',NULL,'用户不存在',NULL,NULL,'NestAdmin','123456','::1',NULL,'Chrome','Windows',NULL,NULL),(119,'2026-08-06 00:09:07',NULL,NULL,'1','sA8gVHahAynY6qj9cmr3MiZj1B-lnW2-gCVfOqecayo','登录成功',NULL,NULL,'admin','123456','::1','本地','Chrome','Windows',NULL,NULL),(120,'2026-08-06 00:09:45',NULL,NULL,'1','sA8gVHahAynY6qj9cmr3MiZj1B-lnW2-gCVfOqecayo','退出登录',NULL,NULL,'admin',NULL,'::1','本地','Chrome','Windows',NULL,NULL),(121,'2026-08-06 00:11:50',NULL,NULL,'1','VdAE5qFDKi2tGWvvtayD0A0JkEn0sEAqFwBILPY29Uo','登录成功',NULL,NULL,'admin','123456','::1','本地','Chrome','Windows',NULL,NULL),(122,'2026-08-18 15:02:37',NULL,NULL,'1','czYyH7RV_ndO5JYChKqPixWPixzi9fZZPVfA2wJ6P-Y','登录成功',NULL,NULL,'admin','123456','::1','本地','Chrome','Linux',NULL,NULL),(123,'2026-08-27 13:47:23',NULL,NULL,'1','KPDJSnwfgL_tLH03Ya2s9FuVSFR_5y7CyzoAAI8wOn4','登录成功',NULL,NULL,'admin','123456','::1','本地','Chrome','Windows',NULL,NULL),(124,'2026-08-27 17:28:08',NULL,NULL,'1','1xz_VAWHflzXzd25jqbqBh53ru_1ZnF2BW-AEB0ZhCk','退出登录',NULL,NULL,'admin',NULL,'::1','未知地址','Chrome','Windows',NULL,NULL),(125,'2026-08-27 17:28:11',NULL,NULL,'1','kKjjHTE8_pak1J_ilQWdi5l619n3nkQuMClE7p_vqvw','登录成功',NULL,NULL,'admin','123456','::1','本地','Chrome','Windows',NULL,NULL),(126,'2026-08-27 17:37:31',NULL,NULL,'1','kKjjHTE8_pak1J_ilQWdi5l619n3nkQuMClE7p_vqvw','退出登录',NULL,NULL,'admin',NULL,'::1','本地','Chrome','Windows',NULL,NULL),(127,'2026-08-27 17:37:37',NULL,NULL,'1','wfTgwWqJyKX7acwWCDUczoOP6GP1XU44Td0LI78ousQ','登录成功',NULL,NULL,'yanghao','123456','::1','本地','Chrome','Windows',NULL,NULL),(128,'2026-08-27 17:37:48',NULL,NULL,'0',NULL,'验证码错误',NULL,NULL,'admin','123456','::1',NULL,'Chrome','Windows',NULL,NULL),(129,'2026-08-27 17:37:57',NULL,NULL,'1','EBMEDEZA0u7uK8d_B5bjlkDzXNLGjumO5n9b_gJVcKw','登录成功',NULL,NULL,'admin','123456','::1','本地','Chrome','Windows',NULL,NULL),(130,'2026-08-27 17:38:18',NULL,NULL,'1','EBMEDEZA0u7uK8d_B5bjlkDzXNLGjumO5n9b_gJVcKw','退出登录',NULL,NULL,'admin',NULL,'::1','本地','Chrome','Windows',NULL,NULL),(131,'2026-08-27 17:38:48',NULL,NULL,'1','3cM4EG5p2Hf9-cSu5sHStyLwPiXYZOnSTBHORqiLz08','登录成功',NULL,NULL,'yanghao','123456','::1','本地','Chrome','Windows',NULL,NULL),(132,'2026-08-27 17:42:22',NULL,NULL,'1','3cM4EG5p2Hf9-cSu5sHStyLwPiXYZOnSTBHORqiLz08','退出登录','admin',NULL,'yanghao',NULL,'::1','本地','Chrome','Windows','46',NULL),(133,'2026-09-11 14:40:56',NULL,NULL,'1','hkYbOskR8sy3EX7SRWMyaQo8yd05SHmd4dNQATVs1z4','登录成功',NULL,NULL,'admin','123456','::1','本地','Chrome','Windows',NULL,NULL),(134,'2026-09-11 15:07:49',NULL,NULL,'1','hkYbOskR8sy3EX7SRWMyaQo8yd05SHmd4dNQATVs1z4','退出登录',NULL,NULL,'admin',NULL,'::1','本地','Chrome','Windows',NULL,NULL),(135,'2026-09-11 15:07:51',NULL,NULL,'1','1fJxWFng5fDVMKiJK90dqGCTtBY7m3TP2SYJJ07D7LM','登录成功',NULL,NULL,'admin','123456','::1','本地','Chrome','Windows',NULL,NULL),(136,'2026-09-11 19:43:17',NULL,NULL,'1','EBLHuY-g2g5C-RD76s1Hb0Y-aBr5ffqHQjcITj2Y7Gs','登录成功',NULL,NULL,'admin','123456','::1','本地','Chrome','Windows',NULL,NULL),(137,'2026-09-11 19:43:31',NULL,NULL,'1','EBLHuY-g2g5C-RD76s1Hb0Y-aBr5ffqHQjcITj2Y7Gs','退出登录',NULL,NULL,'admin',NULL,'::1','本地','Chrome','Windows',NULL,NULL),(138,'2026-09-11 19:43:39',NULL,NULL,'1','vNbsUF8_pbdhbXVDBFkgnIAIqWKEMzpdeGKjSw5CFdw','登录成功',NULL,NULL,'13333333333','123456','::1','本地','Chrome','Windows',NULL,NULL),(139,'2026-09-11 19:43:46',NULL,NULL,'1','vNbsUF8_pbdhbXVDBFkgnIAIqWKEMzpdeGKjSw5CFdw','退出登录','admin',NULL,'13333333333',NULL,'::1','本地','Chrome','Windows','46',NULL),(140,'2026-09-11 19:43:49',NULL,NULL,'1','BkZBG_MW4J6JwrpRrKyB9hka-gCg05xSEGn3HyGHqK0','登录成功',NULL,NULL,'admin','123456','::1','本地','Chrome','Windows',NULL,NULL),(141,'2026-09-11 19:44:09',NULL,NULL,'1','BkZBG_MW4J6JwrpRrKyB9hka-gCg05xSEGn3HyGHqK0','退出登录',NULL,NULL,'admin',NULL,'::1','本地','Chrome','Windows',NULL,NULL),(142,'2026-09-11 19:44:14',NULL,NULL,'1','-uH_lbl1_Gw7_jNCm8plISenHi7qtKlT9xrmKBxr7Zg','登录成功',NULL,NULL,'13333333333','123456','::1','本地','Chrome','Windows',NULL,NULL),(143,'2026-09-11 20:27:56',NULL,NULL,'1','-uH_lbl1_Gw7_jNCm8plISenHi7qtKlT9xrmKBxr7Zg','退出登录','admin',NULL,'13333333333',NULL,'::1','本地','Chrome','Windows','46',NULL),(144,'2026-09-11 20:28:06',NULL,NULL,'1','2pTydoO96LSlyHgKbegR_D1IPvU7um-57xL0FbIrg8A','登录成功',NULL,NULL,'13333333333','123456','::1','本地','Chrome','Windows',NULL,NULL),(145,'2026-09-11 20:41:51',NULL,NULL,'1','2pTydoO96LSlyHgKbegR_D1IPvU7um-57xL0FbIrg8A','退出登录','admin',NULL,'13333333333',NULL,'::1','本地','Chrome','Windows','46',NULL),(146,'2026-09-11 20:41:53',NULL,NULL,'1','QRKxd3xEmC6ceoiOqgfipF8sC9lT_Z7nyk_Eena_Dts','登录成功',NULL,NULL,'admin','123456','::1','本地','Chrome','Windows',NULL,NULL),(147,'2026-09-18 20:47:04',NULL,NULL,'1','4hFqsi7AGj56d_xCjSJUs4e_UDoAXV1GIJ3iq526BZc','登录成功',NULL,NULL,'admin','123456','::1','本地','Chrome','Windows',NULL,NULL);
/*!40000 ALTER TABLE `sys_login_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_menu` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `desc` varchar(100) DEFAULT NULL COMMENT '菜单描述',
  `parent_id` bigint(20) DEFAULT NULL COMMENT '父级id',
  `order` varchar(8) NOT NULL DEFAULT '1' COMMENT '排序',
  `path` varchar(100) DEFAULT NULL COMMENT '路由地址',
  `component` varchar(100) DEFAULT NULL COMMENT '组件路径',
  `type` enum('catalog','menu','button') NOT NULL DEFAULT 'catalog' COMMENT '菜单类型，默认catalog',
  `icon` varchar(100) DEFAULT NULL COMMENT '菜单图标',
  `is_hidden` char(1) NOT NULL DEFAULT '0' COMMENT '是否隐藏: 1是，0否，默认0',
  `is_active` char(1) NOT NULL DEFAULT '1' COMMENT '是否激活: 1是，0否，默认1',
  `is_delete` char(1) DEFAULT NULL COMMENT '是否删除: NULL未删除，1删除',
  `create_user` varchar(255) DEFAULT NULL COMMENT '创建人',
  `update_user` varchar(255) DEFAULT NULL COMMENT '更新人',
  `name` varchar(255) DEFAULT NULL COMMENT '菜单名称',
  `create_user_id` varchar(255) DEFAULT NULL COMMENT '创建人ID',
  `permissionKey` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_7cef4adcf9b01b2c6f14d52b0f3` (`parent_id`) USING BTREE,
  CONSTRAINT `FK_7cef4adcf9b01b2c6f14d52b0f3` FOREIGN KEY (`parent_id`) REFERENCES `sys_menu` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (5,'2024-08-06 22:03:07','2024-10-27 17:43:22','',NULL,'1','system','','catalog','system','0','1',NULL,'','admin','系统管理',NULL,NULL),(6,'2024-08-06 22:20:45','2024-10-27 17:40:42','用户管理',5,'1','users','system/users/index','menu','user','0','1',NULL,'','admin','用户管理',NULL,NULL),(7,'2024-08-06 22:22:56','2024-10-27 17:43:12','',5,'2','roles','system/roles/index','menu','peoples','0','1',NULL,'','admin','角色管理',NULL,NULL),(8,'2024-08-06 22:30:06','2024-10-27 17:44:03','',5,'3','menus','system/menus/index','menu','tree-table','0','1',NULL,'','admin','菜单管理',NULL,NULL),(9,'2024-08-15 00:04:06','2024-10-27 17:50:00','',NULL,'2','content','','catalog','dict','0','1',NULL,'','admin','内容管理',NULL,NULL),(10,'2024-08-15 00:06:53','2024-10-27 17:45:47','通知管理',5,'4','notices','system/notices/index','menu','message','0','1',NULL,'','admin','通知管理',NULL,NULL),(11,'2024-08-15 00:10:33','2024-10-27 17:47:14','系统监控',NULL,'2','systemMonitor','','catalog','monitor','0','1',NULL,'','admin','系统监控',NULL,NULL),(12,'2024-08-15 00:22:13','2024-10-27 17:48:21','登录日志',11,'1','loginLog','systemMonitor/loginLog/index','menu','log','0','1',NULL,'','admin','登录日志',NULL,NULL),(13,'2024-08-15 00:22:59','2024-10-02 15:34:33','操作日志',11,'2','operateLog','','catalog','','0','1','1','','','操作日志',NULL,NULL),(14,'2024-08-15 00:23:45','2024-10-27 17:47:53','',11,'1','onlineUser','systemMonitor/onlineUser/index','menu','online','0','1',NULL,'','admin','在线用户',NULL,NULL),(15,'2024-08-15 00:27:21','2024-10-27 17:49:41','服务监控',11,'2','osInfo','systemMonitor/osInfo/index','menu','druid','0','1',NULL,'','admin','服务监控',NULL,NULL),(16,'2024-08-15 00:33:54','2024-10-27 17:50:07','文章管理',9,'1','articleManage','','catalog','clipboard','0','1',NULL,'','admin','文章管理',NULL,NULL),(17,'2024-08-15 00:36:52','2024-10-27 17:46:28','配置管理',5,'5','configs','system/configs/index','menu','swagger','0','1',NULL,'','admin','配置管理',NULL,NULL),(18,'2024-08-15 00:41:15','2024-10-02 15:34:35','首页',NULL,'1','index','','catalog','dashboard','0','1',NULL,'','','首页',NULL,NULL),(19,'2024-08-15 00:44:53','2024-10-27 17:50:34','首页',18,'1','index','index/index','menu','dashboard','1','1',NULL,'','admin','首页',NULL,NULL),(20,'2024-08-15 01:12:57','2024-10-02 15:34:36','应用工具',NULL,'6','appTools','','catalog','','0','0',NULL,'','admin','应用工具',NULL,NULL),(21,'2024-08-15 01:14:35','2024-10-02 15:34:36','',20,'1','poster','appTools/poster/index','menu','','0','1',NULL,'','','宣传海报',NULL,NULL),(22,'2024-08-15 01:15:47','2024-10-02 15:34:36','',20,'1','forms','appTools/forms/index','menu','','0','1',NULL,'','','访问表单',NULL,NULL),(23,'2024-10-19 00:24:43','2024-10-19 00:25:25',NULL,16,'1','index','content/articleManage/index','menu',NULL,'1','1',NULL,'admin','admin','文章列表',NULL,NULL),(24,'2024-10-19 00:26:05',NULL,NULL,16,'2','aev','content/articleManage/aev','menu',NULL,'1','1',NULL,'admin',NULL,'{新增}',NULL,NULL),(25,'2026-08-27 16:04:32',NULL,'部门管理',5,'6','depts','system/depts/index','menu','tree','0','1',NULL,'admin','admin','部门管理',NULL,'dept'),(26,'2026-08-27 17:12:43',NULL,'垃圾官网管理',NULL,'5','trash',NULL,'catalog','app','0','1',NULL,'admin',NULL,'垃圾官网管理','46',NULL),(27,'2026-08-27 17:13:26','2026-08-27 17:35:17','站点配置',26,'1','config','trash/config/index','menu',NULL,'0','1',NULL,'admin','admin','站点配置','46','trash:config'),(28,'2026-08-27 17:35:17',NULL,NULL,26,'2','stories','trash/stories/index','menu',NULL,'0','1',NULL,NULL,NULL,'故事管理',NULL,NULL),(29,'2026-08-27 17:35:17',NULL,NULL,26,'3','applies','trash/applies/index','menu',NULL,'0','1',NULL,NULL,NULL,'申请列表',NULL,NULL),(30,'2026-09-11 15:04:53','2026-09-11 15:07:42','家族成员与族谱管理',NULL,'3','family',NULL,'catalog','peoples','0','1',NULL,'admin','admin','家族管理',NULL,NULL),(31,'2026-09-11 15:04:53',NULL,'中国地图展示成员分布',30,'1','memberMap','family/memberMap/index','menu','','0','1',NULL,'admin',NULL,'成员地图',NULL,'family:memberMap'),(32,'2026-09-11 15:17:59',NULL,'家族成员信息管理',30,'2','members','family/members/index','menu','','0','1',NULL,'admin',NULL,'成员管理',NULL,'family:members'),(33,'2026-09-11 17:18:39','2026-09-11 17:18:39','家族成员族谱组织结构图',30,'3','familyTree','family/familyTree/index','menu','Tree','0','1',NULL,NULL,NULL,'族谱图',NULL,'family:tree');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu_closure`
--

DROP TABLE IF EXISTS `sys_menu_closure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_menu_closure` (
  `id_ancestor` bigint(20) NOT NULL,
  `id_descendant` bigint(20) NOT NULL,
  PRIMARY KEY (`id_ancestor`,`id_descendant`),
  KEY `IDX_ee0a4003eda64ae8081ebdde04` (`id_ancestor`),
  KEY `IDX_78f742978fc6b23a674732d027` (`id_descendant`),
  CONSTRAINT `FK_78f742978fc6b23a674732d027c` FOREIGN KEY (`id_descendant`) REFERENCES `sys_menu` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_ee0a4003eda64ae8081ebdde042` FOREIGN KEY (`id_ancestor`) REFERENCES `sys_menu` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu_closure`
--

LOCK TABLES `sys_menu_closure` WRITE;
/*!40000 ALTER TABLE `sys_menu_closure` DISABLE KEYS */;
INSERT INTO `sys_menu_closure` VALUES (5,5),(5,6),(5,7),(5,8),(5,10),(5,17),(5,25),(6,6),(7,7),(8,8),(9,9),(9,16),(9,23),(9,24),(10,10),(11,11),(11,12),(11,13),(11,14),(11,15),(12,12),(13,13),(14,14),(15,15),(16,16),(16,23),(16,24),(17,17),(18,18),(18,19),(19,19),(20,20),(20,21),(20,22),(21,21),(22,22),(23,23),(24,24),(25,25),(26,26),(26,27),(26,28),(26,29),(27,27),(28,28),(29,29),(30,30),(30,31),(30,32),(31,31),(32,32);
/*!40000 ALTER TABLE `sys_menu_closure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_notice` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` char(1) DEFAULT NULL COMMENT '是否删除: NULL未删除，1删除',
  `is_active` char(1) NOT NULL DEFAULT '1' COMMENT '是否激活: 1是，0否，默认1',
  `content` varchar(200) DEFAULT NULL COMMENT '公告内容',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注',
  `create_user` varchar(255) DEFAULT NULL COMMENT '创建人',
  `update_user` varchar(255) DEFAULT NULL COMMENT '更新人',
  `title` varchar(255) DEFAULT NULL COMMENT '公告标题',
  `create_user_id` varchar(255) DEFAULT NULL COMMENT '创建人ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注',
  `order` varchar(8) NOT NULL DEFAULT '1' COMMENT '排序',
  `is_active` char(1) NOT NULL DEFAULT '1' COMMENT '是否激活: 1是，0否，默认1',
  `is_delete` char(1) DEFAULT NULL COMMENT '是否删除: NULL未删除，1删除',
  `create_user` varchar(255) DEFAULT NULL COMMENT '创建人',
  `update_user` varchar(255) DEFAULT NULL COMMENT '更新人',
  `name` varchar(255) DEFAULT NULL,
  `permissionKey` varchar(255) DEFAULT NULL,
  `create_user_id` varchar(255) DEFAULT NULL COMMENT '创建人ID',
  `dataPermissionType` enum('self','dept','deptAndChildren','all') NOT NULL DEFAULT 'self' COMMENT '数据权限类型，默认self',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'2026-08-27 17:37:15','2026-08-27 17:38:14',NULL,'1','1',NULL,'admin','admin','审核员','auth','46','self'),(2,'2026-09-11 14:43:47','2026-09-11 19:16:31',NULL,'1','1',NULL,'admin','admin','家族系统管理员','family','46','deptAndChildren');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_role_menu` (
  `roleId` bigint(20) NOT NULL,
  `menuId` bigint(20) NOT NULL,
  PRIMARY KEY (`roleId`,`menuId`),
  KEY `IDX_bdd82e5f4c2bedda41f89b69ba` (`roleId`),
  KEY `IDX_7e0fc887979c9dee7a3dbed7eb` (`menuId`),
  CONSTRAINT `fk_sys_menu_role` FOREIGN KEY (`menuId`) REFERENCES `sys_menu` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sys_role_menu` FOREIGN KEY (`roleId`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (1,26),(1,27),(1,28),(1,29),(2,30),(2,31),(2,32),(2,33);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `password` varchar(50) NOT NULL DEFAULT 's3wmd2VReF1IjZhK59gLBY0OjYlzjA==' COMMENT '密码',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像地址',
  `phone` varchar(11) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `dept_id` bigint(20) DEFAULT NULL COMMENT '部门id',
  `is_active` char(1) NOT NULL DEFAULT '1' COMMENT '是否激活: 1是，0否，默认1',
  `is_delete` char(1) DEFAULT NULL COMMENT '是否删除: NULL未删除，1删除',
  `email` varchar(255) DEFAULT NULL,
  `gender` enum('man','woamn') DEFAULT NULL COMMENT '性别，默认 null',
  `create_user` varchar(255) DEFAULT NULL COMMENT '创建人',
  `update_user` varchar(255) DEFAULT NULL COMMENT '更新人',
  `name` varchar(255) DEFAULT NULL COMMENT '名称',
  `nickname` varchar(255) DEFAULT NULL COMMENT '昵称',
  `create_user_id` varchar(255) DEFAULT NULL COMMENT '创建人ID',
  `account` varchar(255) DEFAULT NULL COMMENT '登录账号',
  PRIMARY KEY (`id`),
  KEY `FK_96bde34263e2ae3b46f011124ac` (`dept_id`),
  CONSTRAINT `FK_96bde34263e2ae3b46f011124ac` FOREIGN KEY (`dept_id`) REFERENCES `sys_dept` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (46,'s3wmd2VReF1IjZhK59gLBY0OjYlzjA==',NULL,NULL,'2026-08-05 23:40:31','2026-08-27 16:51:28',NULL,'1',NULL,NULL,NULL,NULL,NULL,'admin','超级管理员',NULL,'admin'),(47,'s3wmd2VReF1IjZhK59gLBY0OjYlzjA==','avatar\\2026-08-27/1787823421245-801303359.jpg','15555555555','2026-08-27 17:37:04','2026-08-27 17:37:26',1,'1',NULL,NULL,NULL,'admin','admin','杨皓',NULL,'46','yanghao'),(48,'s3wmd2VReF1IjZhK59gLBY0OjYlzjA==',NULL,'15555555556','2026-09-11 14:43:14','2026-09-11 14:44:14',2,'1',NULL,NULL,NULL,'admin','admin','杨皓',NULL,'46','family'),(49,'s3wmd2VReF1IjZhK59gLBY0OjYlzjA==','avatar\\2026-09-11/1789125368710-528296358.jpg','13333333333','2026-09-11 19:16:15',NULL,2,'1',NULL,NULL,NULL,'admin',NULL,'杨明新',NULL,'46','13333333333');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_user_role` (
  `userId` bigint(20) NOT NULL,
  `roleId` bigint(20) NOT NULL,
  PRIMARY KEY (`userId`,`roleId`),
  KEY `IDX_3ec9b31612c830bf0221b9e7f3` (`roleId`),
  KEY `IDX_3c879483a655a9387b8c487608` (`userId`),
  CONSTRAINT `fk_sys_user_role_role` FOREIGN KEY (`roleId`) REFERENCES `sys_role` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_sys_user_role_user` FOREIGN KEY (`userId`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (47,1),(48,2),(49,2);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trash_join_apply`
--

DROP TABLE IF EXISTS `trash_join_apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trash_join_apply` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(255) DEFAULT NULL COMMENT '创建人',
  `create_user_id` varchar(255) DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_user` varchar(255) DEFAULT NULL COMMENT '更新人',
  `is_delete` char(1) DEFAULT NULL COMMENT '是否删除: NULL未删除，1删除',
  `name` varchar(20) DEFAULT NULL COMMENT '姓名',
  `phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `wechat` varchar(50) DEFAULT NULL COMMENT '微信号',
  `city` varchar(50) DEFAULT NULL COMMENT '当前所在城市',
  `birth_date` varchar(20) DEFAULT NULL COMMENT '出生日期',
  `birth_time` varchar(30) DEFAULT NULL COMMENT '出生时辰',
  `birth_place` varchar(100) DEFAULT NULL COMMENT '出生地',
  `experience` text COMMENT '过往职业经历',
  `skills` text COMMENT '擅长技能',
  `direction` text COMMENT '希望探索的方向',
  `status` enum('0','1','2','3') NOT NULL DEFAULT '0' COMMENT '申请状态',
  `remark` text COMMENT '管理员备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trash_join_apply`
--

LOCK TABLES `trash_join_apply` WRITE;
/*!40000 ALTER TABLE `trash_join_apply` DISABLE KEYS */;
INSERT INTO `trash_join_apply` VALUES (1,'2026-08-18 17:29:09','官网用户','0',NULL,NULL,NULL,'王一','15555555555','yy12f453','深圳','2015-06-28','未时 (13:00-15:00)','黑龙江','前端','编程','跨境电商','0',NULL);
/*!40000 ALTER TABLE `trash_join_apply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trash_site_config`
--

DROP TABLE IF EXISTS `trash_site_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trash_site_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(255) DEFAULT NULL COMMENT '创建人',
  `create_user_id` varchar(255) DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_user` varchar(255) DEFAULT NULL COMMENT '更新人',
  `is_delete` char(1) DEFAULT NULL COMMENT '是否删除: NULL未删除，1删除',
  `heroBadge` varchar(50) NOT NULL DEFAULT '已有 1,247 位伙伴在这里重新出发' COMMENT 'Hero徽章文字',
  `heroTitle1` varchar(50) NOT NULL DEFAULT '失业不是终点' COMMENT 'Hero标题第一行',
  `heroTitle2Accent` varchar(50) NOT NULL DEFAULT '是重新认识自己' COMMENT 'Hero标题第二行强调部分',
  `heroTitle2` varchar(50) NOT NULL DEFAULT '的开始' COMMENT 'Hero标题第二行后续',
  `heroDesc` text COMMENT 'Hero描述文字',
  `heroBg` varchar(200) DEFAULT NULL COMMENT 'Hero背景图URL',
  `heroPartnersText` varchar(20) NOT NULL DEFAULT '来自各行各业的伙伴' COMMENT '伙伴描述文字',
  `aboutP1` text COMMENT 'About描述段落1',
  `aboutP2` text COMMENT 'About描述段落2',
  `aboutP3` text COMMENT 'About描述段落3',
  `aboutImage` varchar(200) DEFAULT NULL COMMENT 'About右侧图片',
  `statValue1` varchar(20) NOT NULL DEFAULT '1,247' COMMENT '统计数字1',
  `statLabel1` varchar(20) NOT NULL DEFAULT '社区成员' COMMENT '统计标签1',
  `statValue2` varchar(20) NOT NULL DEFAULT '86' COMMENT '统计数字2',
  `statLabel2` varchar(20) NOT NULL DEFAULT '成功组队' COMMENT '统计标签2',
  `statValue3` varchar(20) NOT NULL DEFAULT '34' COMMENT '统计数字3',
  `statLabel3` varchar(20) NOT NULL DEFAULT '创业项目' COMMENT '统计标签3',
  `processSubtitle` varchar(100) NOT NULL DEFAULT '我们不卖课程，不推销机会。只是帮你找到对的人，一起做点有意义的事。' COMMENT '运作方式副标题',
  `step1Title` varchar(50) NOT NULL DEFAULT '提交你的信息' COMMENT '步骤1标题',
  `step1Desc` text COMMENT '步骤1描述',
  `step1Meta` varchar(30) NOT NULL DEFAULT '约 5 分钟完成' COMMENT '步骤1标签',
  `step2Title` varchar(50) NOT NULL DEFAULT '等待分组匹配' COMMENT '步骤2标题',
  `step2Desc` text COMMENT '步骤2描述',
  `step2Meta` varchar(30) NOT NULL DEFAULT '平均 3-7 天匹配' COMMENT '步骤2标签',
  `step3Title` varchar(50) NOT NULL DEFAULT '开始探索' COMMENT '步骤3标题',
  `step3Desc` text COMMENT '步骤3描述',
  `step3Meta` varchar(30) NOT NULL DEFAULT '持续跟进支持' COMMENT '步骤3标签',
  `footerSlogan` varchar(200) NOT NULL DEFAULT '没有真正的垃圾，只有放错位置的资源。' COMMENT 'Footer口号',
  `contactEmail` varchar(100) NOT NULL DEFAULT 'hello@trash.center' COMMENT '联系邮箱',
  `contactWechat` varchar(100) NOT NULL DEFAULT 'TrashCenter2024' COMMENT '微信号',
  `footerDesc` varchar(200) NOT NULL DEFAULT '帮助被裁员的30+人才找到合适的伙伴，重新出发。' COMMENT 'Footer描述',
  `footerNote` varchar(200) NOT NULL DEFAULT '让每一个被丢弃的人才，找到新的归属' COMMENT 'Footer底部备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trash_site_config`
--

LOCK TABLES `trash_site_config` WRITE;
/*!40000 ALTER TABLE `trash_site_config` DISABLE KEYS */;
INSERT INTO `trash_site_config` VALUES (1,'2026-08-18 16:58:29',NULL,NULL,'2026-08-27 13:49:22','admin',NULL,'已有 1 位伙伴在这里重新出发','失业不是终点','是重新认识自己','的开始',NULL,NULL,'来自各行各业的伙伴',NULL,NULL,NULL,NULL,'1','社区成员','0','成功组队','3','创业项目','我们不卖课程，不推销机会。只是帮你找到对的人，一起做点有意义的事。','提交你的信息',NULL,'约 5 分钟完成','等待分组匹配',NULL,'平均 3-7 天匹配','开始探索',NULL,'持续跟进支持','没有真正的垃圾，只有放错位置的资源。','royce1030507142@outlook.com','qq群1085651290','帮助被裁员的30+人才找到合适的伙伴，重新出发。','让每一个被丢弃的人才，找到新的归属');
/*!40000 ALTER TABLE `trash_site_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trash_story`
--

DROP TABLE IF EXISTS `trash_story`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trash_story` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(255) DEFAULT NULL COMMENT '创建人',
  `create_user_id` varchar(255) DEFAULT NULL COMMENT '创建人ID',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_user` varchar(255) DEFAULT NULL COMMENT '更新人',
  `is_delete` char(1) DEFAULT NULL COMMENT '是否删除: NULL未删除，1删除',
  `tag` varchar(30) DEFAULT NULL COMMENT '标签，如：前教培从业者',
  `tagColor` varchar(10) NOT NULL DEFAULT '#c68642' COMMENT '标签颜色',
  `avatarColor` varchar(10) NOT NULL DEFAULT '#d49a5c' COMMENT '头像颜色',
  `avatarLetter` varchar(2) DEFAULT NULL COMMENT '头像文字（姓氏）',
  `title` varchar(100) DEFAULT NULL COMMENT '故事标题',
  `quote` text COMMENT '引用语/故事内容',
  `name` varchar(20) DEFAULT NULL COMMENT '姓名',
  `duration` varchar(30) DEFAULT NULL COMMENT '加入时长文字',
  `image` varchar(500) DEFAULT NULL COMMENT '配图URL',
  `order` int(11) NOT NULL DEFAULT '0' COMMENT '排序，数字越小越靠前',
  `is_active` char(1) NOT NULL DEFAULT '1' COMMENT '是否激活: 1是，0否，默认1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trash_story`
--

LOCK TABLES `trash_story` WRITE;
/*!40000 ALTER TABLE `trash_story` DISABLE KEYS */;
/*!40000 ALTER TABLE `trash_story` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'nest_admin'
--

--
-- Dumping routines for database 'nest_admin'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-18 21:21:38
