/*
 Navicat Premium Data Transfer

 Source Server         : 10.130.135.60-sit
 Source Server Type    : MySQL
 Source Server Version : 50727
 Source Host           : 10.130.135.60:3306
 Source Schema         : basedemo

 Target Server Type    : MySQL
 Target Server Version : 50727
 File Encoding         : 65001

 Date: 07/12/2020 11:21:55
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for gitee_commit
-- ----------------------------
DROP TABLE IF EXISTS `gitee_commit`;
CREATE TABLE `gitee_commit`  (
  `id` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `repository_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库地址',
  `commit_message` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '提交message',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `repository_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库名称',
  `program_id` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'gitee推送数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu`  (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) NULL DEFAULT NULL COMMENT '父菜单ID，一级菜单为0',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单名称',
  `url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单URL',
  `perms` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '授权(多个用逗号分隔，如：user:list,user:create)',
  `type` int(11) NULL DEFAULT NULL COMMENT '类型   0：目录   1：菜单   2：按钮',
  `icon` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单图标',
  `order_num` int(11) NULL DEFAULT NULL COMMENT '排序',
  `del_tag` int(2) NULL DEFAULT NULL COMMENT '删除标志（1：已删除）',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu` VALUES (1, 0, '系统管理', NULL, NULL, 0, 'system', 0, 0);
INSERT INTO `menu` VALUES (2, 1, '管理员列表', 'sys/user', NULL, 1, 'admin', 1, 0);
INSERT INTO `menu` VALUES (10, 0, '系统监控', NULL, NULL, 0, 'jiankong', 4, 0);
INSERT INTO `menu` VALUES (11, 10, '实时监控', 'sys/server', NULL, 1, 'config', 8, 0);
INSERT INTO `menu` VALUES (12, 10, '系统日志', 'sys/log', NULL, 1, 'log', 9, 0);
INSERT INTO `menu` VALUES (13, 10, '接口监控', 'https://xianyum.cn/base-demo/swagger-ui.html', NULL, 1, 'suoding', 10, 0);
INSERT INTO `menu` VALUES (14, 10, 'druid监控', 'https://xianyum.cn/base-demo/druid/login.html', NULL, 1, 'sql', 11, 0);
INSERT INTO `menu` VALUES (15, 0, '爬虫监控', NULL, NULL, 0, 'analysis', 3, 0);
INSERT INTO `menu` VALUES (16, 15, '小刀数据', 'analysis/xiaodao', NULL, 1, 'xiaodao', 12, 0);
INSERT INTO `menu` VALUES (17, 0, '微信推送中心', NULL, NULL, 0, 'weixin', 2, 0);
INSERT INTO `menu` VALUES (18, 17, '推送用户列表', 'weixin/push_list', NULL, 1, 'weixinpushcenter', 13, 0);
INSERT INTO `menu` VALUES (19, 0, '咸鱼客户端', NULL, NULL, 0, 'xianyu', 2, 0);
INSERT INTO `menu` VALUES (20, 19, '发布版本', 'xianyu/release', NULL, 1, 'release', 14, 0);
INSERT INTO `menu` VALUES (21, 0, '程序设计', 'program', NULL, 0, 'program', 2, 0);
INSERT INTO `menu` VALUES (22, 21, '程序申请单', 'program/manage', NULL, 1, 'programManage', 15, 0);

-- ----------------------------
-- Table structure for program
-- ----------------------------
DROP TABLE IF EXISTS `program`;
CREATE TABLE `program`  (
  `id` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `program_title` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '程序题目',
  `program_requirements` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '程序要求',
  `contact_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  `create_user_id` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人名称',
  `expect_time` datetime(0) NULL DEFAULT NULL COMMENT '预计完成时间',
  `status` int(1) NULL DEFAULT NULL COMMENT '程序状态(0: 完成 1：未完成)',
  `tmall_status` int(1) NULL DEFAULT NULL COMMENT '是否淘系买家(0:是 1:不是)',
  `completion_time` datetime(0) NULL DEFAULT NULL COMMENT '最终完成时间',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `gitee_url` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '代码地址',
  `type` int(11) NULL DEFAULT NULL COMMENT '订单类型 0：系统 1：系统+论文 2：论文',
  `update_user_id` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `update_user_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  `money` double(10, 2) NULL DEFAULT NULL COMMENT '订单价格',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '程序设计' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_constant
-- ----------------------------
DROP TABLE IF EXISTS `system_constant`;
CREATE TABLE `system_constant`  (
  `id` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `constant_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `constant_value` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `constant_describe` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述',
  `constant_visible` int(2) NULL DEFAULT NULL COMMENT '0:公用 1：私有',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统常用常量' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_constant
-- ----------------------------
INSERT INTO `system_constant` VALUES ('3733c691342a4bf2be48bc2f01876a6d', 'program_template', 'http://oss.xianyum.cn/%E6%AF%95%E8%AE%BE%E7%B3%BB%E7%BB%9F%E8%A6%81%E6%B1%82%EF%BC%88%E8%AF%B7%E4%BF%AE%E6%94%B9%E4%B8%BA%E8%AE%BA%E6%96%87%E9%A2%98%E7%9B%AE%EF%BC%89.doc', '获取程序下载模板', 0, '2020-11-20 22:10:31', NULL);
INSERT INTO `system_constant` VALUES ('3733c691342a4bfabe48bc2f01876a6d', 'xianyu_client', '{\"versionNo\":\"4.2\",\"title\":\"冬天的第一件绿棉袄\",\"downloadUrl\":\"https://wws.lanzous.com/ipxFPigp9yh\",\"notice\":\"2020年11月16日 V4.2版本程序启动优化\",\"labelTitle\":\"贴心小棉袄\"}', '获取咸鱼客户端信息', 0, '2020-11-03 19:33:58', '2020-11-21 12:46:43');
INSERT INTO `system_constant` VALUES ('6c49169e-d969-4a51-bef6-899fd8a93f3b', 'program_help', 'https://xiaoyaxiaokeai.gitee.io/base/20201121/program_get_help.png', '程序订单申请帮助', 0, '2020-11-21 18:22:26', NULL);
INSERT INTO `system_constant` VALUES ('8448bdbc-0013-47f5-a508-9f33394fa8bd', 'program_schedule_url', 'https://xiaoyaxiaokeai.gitee.io/base/20201121/favicon.ico', '获取订单进度图片', 0, '2020-11-21 18:15:33', NULL);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` varchar(40) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `username` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT '用户名',
  `password` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '密码',
  `salt` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '盐',
  `email` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '邮箱',
  `mobile` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '手机号',
  `status` int(2) NULL DEFAULT NULL COMMENT '状态(0：允许 1：禁止)',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `del_tag` int(2) NOT NULL COMMENT '删除状态（0：未删除，1：删除）',
  `permission` int(2) NULL DEFAULT NULL COMMENT '权限（0：管理员 1：普通用户）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'admin', 'e91eef1fe372102aeffbe1cc15d8054f03ba8ce115b129b86c1745bf8fa12e5a', 'ZEaFev22CcnwW3aVim9D', '80616059@qq.com', '18888888888', 0, '2019-05-25 20:29:37', 0, 0);
INSERT INTO `user` VALUES ('2', 'xianyu', 'e91eef1fe372102aeffbe1cc15d8054f03ba8ce115b129b86c1745bf8fa12e5a', 'ZEaFev22CcnwW3aVim9D', 'admin@xianyum.cn', '16666666666', 0, '2020-11-05 21:10:25', 0, 1);

-- ----------------------------
-- Table structure for user_log
-- ----------------------------
DROP TABLE IF EXISTS `user_log`;
CREATE TABLE `user_log`  (
  `id` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `username` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `operation` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户操作',
  `method` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '请求方法',
  `params` varchar(5000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '请求参数',
  `time` bigint(30) NULL DEFAULT NULL COMMENT '执行时长（毫秒）',
  `ip` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'ip地址',
  `ip_info` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'ip地点',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`, `create_time`) USING BTREE,
  INDEX `ix_username`(`username`) USING BTREE,
  INDEX `ix_createtime`(`create_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic PARTITION BY RANGE (TO_DAYS( create_time ))
PARTITIONS 107
(PARTITION `p20200825` VALUES LESS THAN (738027) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200826` VALUES LESS THAN (738028) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200827` VALUES LESS THAN (738029) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200828` VALUES LESS THAN (738030) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200829` VALUES LESS THAN (738031) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200830` VALUES LESS THAN (738032) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200831` VALUES LESS THAN (738033) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200901` VALUES LESS THAN (738034) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200902` VALUES LESS THAN (738035) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200903` VALUES LESS THAN (738036) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200904` VALUES LESS THAN (738037) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p_20200905` VALUES LESS THAN (738038) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p_20200906` VALUES LESS THAN (738039) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200906` VALUES LESS THAN (738040) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200907` VALUES LESS THAN (738041) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200908` VALUES LESS THAN (738042) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200909` VALUES LESS THAN (738043) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200910` VALUES LESS THAN (738044) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200911` VALUES LESS THAN (738045) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200912` VALUES LESS THAN (738046) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200913` VALUES LESS THAN (738047) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200914` VALUES LESS THAN (738048) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200915` VALUES LESS THAN (738049) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200916` VALUES LESS THAN (738050) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200917` VALUES LESS THAN (738051) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200918` VALUES LESS THAN (738052) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200919` VALUES LESS THAN (738053) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200920` VALUES LESS THAN (738054) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200921` VALUES LESS THAN (738055) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200922` VALUES LESS THAN (738056) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200923` VALUES LESS THAN (738057) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200924` VALUES LESS THAN (738058) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200925` VALUES LESS THAN (738059) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200926` VALUES LESS THAN (738060) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200927` VALUES LESS THAN (738061) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200928` VALUES LESS THAN (738062) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200929` VALUES LESS THAN (738063) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20200930` VALUES LESS THAN (738064) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201001` VALUES LESS THAN (738065) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201002` VALUES LESS THAN (738066) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201003` VALUES LESS THAN (738067) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201004` VALUES LESS THAN (738068) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201005` VALUES LESS THAN (738069) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201006` VALUES LESS THAN (738070) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201007` VALUES LESS THAN (738071) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201008` VALUES LESS THAN (738072) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201009` VALUES LESS THAN (738073) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201010` VALUES LESS THAN (738074) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201011` VALUES LESS THAN (738075) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201012` VALUES LESS THAN (738076) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201013` VALUES LESS THAN (738077) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201014` VALUES LESS THAN (738078) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201015` VALUES LESS THAN (738079) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201016` VALUES LESS THAN (738080) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201017` VALUES LESS THAN (738081) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201018` VALUES LESS THAN (738082) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201019` VALUES LESS THAN (738083) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201020` VALUES LESS THAN (738084) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201021` VALUES LESS THAN (738085) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201022` VALUES LESS THAN (738086) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201023` VALUES LESS THAN (738087) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201024` VALUES LESS THAN (738088) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201025` VALUES LESS THAN (738089) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201026` VALUES LESS THAN (738090) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201027` VALUES LESS THAN (738091) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201028` VALUES LESS THAN (738092) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201029` VALUES LESS THAN (738093) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201030` VALUES LESS THAN (738094) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201031` VALUES LESS THAN (738095) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201101` VALUES LESS THAN (738096) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201102` VALUES LESS THAN (738097) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201103` VALUES LESS THAN (738098) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201104` VALUES LESS THAN (738099) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201105` VALUES LESS THAN (738100) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201106` VALUES LESS THAN (738101) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201107` VALUES LESS THAN (738102) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201108` VALUES LESS THAN (738103) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201109` VALUES LESS THAN (738104) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201110` VALUES LESS THAN (738105) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201111` VALUES LESS THAN (738106) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201112` VALUES LESS THAN (738107) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201113` VALUES LESS THAN (738108) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201114` VALUES LESS THAN (738109) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201115` VALUES LESS THAN (738110) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201116` VALUES LESS THAN (738111) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201117` VALUES LESS THAN (738112) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201118` VALUES LESS THAN (738113) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201119` VALUES LESS THAN (738114) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201120` VALUES LESS THAN (738115) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201121` VALUES LESS THAN (738116) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201122` VALUES LESS THAN (738117) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201123` VALUES LESS THAN (738118) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201124` VALUES LESS THAN (738119) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201125` VALUES LESS THAN (738120) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201126` VALUES LESS THAN (738121) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201127` VALUES LESS THAN (738122) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201128` VALUES LESS THAN (738123) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201129` VALUES LESS THAN (738124) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201130` VALUES LESS THAN (738125) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201201` VALUES LESS THAN (738126) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201202` VALUES LESS THAN (738127) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201203` VALUES LESS THAN (738128) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201204` VALUES LESS THAN (738129) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201205` VALUES LESS THAN (738130) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201206` VALUES LESS THAN (738131) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201207` VALUES LESS THAN (738132) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 ,
PARTITION `p20201208` VALUES LESS THAN (738133) ENGINE = InnoDB MAX_ROWS = 0 MIN_ROWS = 0 )
;

-- ----------------------------
-- Table structure for user_third
-- ----------------------------
DROP TABLE IF EXISTS `user_third`;
CREATE TABLE `user_third`  (
  `id` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `user_id` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户id',
  `ali_user_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '阿里用户id',
  `qq_user_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'qq用户id',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for wx_push_center
-- ----------------------------
DROP TABLE IF EXISTS `wx_push_center`;
CREATE TABLE `wx_push_center`  (
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `uid` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关注用户id',
  `app_key` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关注应用的appKey',
  `app_name` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '应用名字',
  `source` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户关注渠道，scan表示扫码关注',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '关注时间',
  `extend` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '扩展字段',
  `user_name` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '微信用户名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for xiao_dao
-- ----------------------------
DROP TABLE IF EXISTS `xiao_dao`;
CREATE TABLE `xiao_dao`  (
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标题',
  `url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '地址',
  `time` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文章时间',
  `params` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '参数',
  `push_status` int(255) NULL DEFAULT NULL COMMENT '推送状态',
  `push_time` datetime(0) NULL DEFAULT NULL COMMENT '推送时间',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
