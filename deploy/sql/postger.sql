/*
 Navicat Premium Data Transfer

 Source Server         : nest-admin
 Source Server Type    : PostgreSQL
 Source Host           : localhost:5432
 Source Schema         : nest_admin

 Target Server Type    : PostgreSQL
 File Encoding         : UTF8

 Date: 28/02/2024 22:35:41
*/

-- 创建数据库 (如果不存在)
-- CREATE DATABASE nest_admin;

-- 连接到数据库
-- \c nest_admin;

-- ----------------------------
-- Table structure for sys_captcha_log
-- ----------------------------
DROP TABLE IF EXISTS sys_captcha_log CASCADE;
CREATE TABLE sys_captcha_log (
  id SERIAL PRIMARY KEY,
  user_id INTEGER DEFAULT NULL,
  account VARCHAR(255) DEFAULT NULL,
  code VARCHAR(255) DEFAULT NULL,
  provider VARCHAR(255) DEFAULT NULL,
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 创建更新时间触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为 sys_captcha_log 创建更新触发器
CREATE TRIGGER update_sys_captcha_log_updated_at BEFORE UPDATE ON sys_captcha_log FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS sys_config CASCADE;
CREATE TABLE sys_config (
  id SERIAL PRIMARY KEY,
  key VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(50) NOT NULL,
  value VARCHAR(255) DEFAULT NULL,
  remark VARCHAR(255) DEFAULT NULL,
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER update_sys_config_updated_at BEFORE UPDATE ON sys_config FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS sys_dept CASCADE;
CREATE TABLE sys_dept (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  "orderNo" INTEGER DEFAULT 0,
  mpath VARCHAR(255) DEFAULT '',
  "parentId" INTEGER DEFAULT NULL,
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_sys_dept_parent FOREIGN KEY ("parentId") REFERENCES sys_dept (id) ON DELETE SET NULL
);

CREATE TRIGGER update_sys_dept_updated_at BEFORE UPDATE ON sys_dept FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS sys_dict CASCADE;
CREATE TABLE sys_dict (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  create_by INTEGER NOT NULL, -- 创建者
  update_by INTEGER NOT NULL, -- 更新者
  name VARCHAR(50) NOT NULL UNIQUE,
  status SMALLINT NOT NULL DEFAULT 1,
  remark VARCHAR(255) DEFAULT NULL
);

CREATE TRIGGER update_sys_dict_updated_at BEFORE UPDATE ON sys_dict FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS sys_dict_type CASCADE;
CREATE TABLE sys_dict_type (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  create_by INTEGER NOT NULL, -- 创建者
  update_by INTEGER NOT NULL, -- 更新者
  name VARCHAR(50) NOT NULL,
  status SMALLINT NOT NULL DEFAULT 1,
  remark VARCHAR(255) DEFAULT NULL,
  code VARCHAR(50) NOT NULL UNIQUE
);

CREATE TRIGGER update_sys_dict_type_updated_at BEFORE UPDATE ON sys_dict_type FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ----------------------------
-- Table structure for sys_dict_item
-- ----------------------------
DROP TABLE IF EXISTS sys_dict_item CASCADE;
CREATE TABLE sys_dict_item (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  create_by INTEGER NOT NULL, -- 创建者
  update_by INTEGER NOT NULL, -- 更新者
  label VARCHAR(50) NOT NULL,
  value VARCHAR(50) NOT NULL,
  "order" INTEGER DEFAULT NULL, -- 字典项排序
  status SMALLINT NOT NULL DEFAULT 1,
  remark VARCHAR(255) DEFAULT NULL,
  type_id INTEGER DEFAULT NULL,
  "orderNo" INTEGER DEFAULT NULL, -- 字典项排序
  CONSTRAINT fk_sys_dict_item_type FOREIGN KEY (type_id) REFERENCES sys_dict_type (id) ON DELETE CASCADE
);

CREATE TRIGGER update_sys_dict_item_updated_at BEFORE UPDATE ON sys_dict_item FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS sys_user CASCADE;
CREATE TABLE sys_user (
  id SERIAL PRIMARY KEY,
  username VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  avatar VARCHAR(255) DEFAULT NULL,
  email VARCHAR(255) DEFAULT NULL,
  phone VARCHAR(255) DEFAULT NULL,
  remark VARCHAR(255) DEFAULT NULL,
  psalt VARCHAR(32) NOT NULL,
  status SMALLINT DEFAULT 1,
  qq VARCHAR(255) DEFAULT NULL,
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  nickname VARCHAR(255) DEFAULT NULL,
  dept_id INTEGER DEFAULT NULL,
  CONSTRAINT fk_sys_user_dept FOREIGN KEY (dept_id) REFERENCES sys_dept (id)
);

CREATE TRIGGER update_sys_user_updated_at BEFORE UPDATE ON sys_user FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ----------------------------
-- Table structure for sys_login_log
-- ----------------------------
DROP TABLE IF EXISTS sys_login_log CASCADE;
CREATE TABLE sys_login_log (
  id SERIAL PRIMARY KEY,
  ip VARCHAR(255) DEFAULT NULL,
  ua VARCHAR(500) DEFAULT NULL,
  address VARCHAR(255) DEFAULT NULL,
  provider VARCHAR(255) DEFAULT NULL,
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  user_id INTEGER DEFAULT NULL,
  CONSTRAINT fk_sys_login_log_user FOREIGN KEY (user_id) REFERENCES sys_user (id) ON DELETE CASCADE
);

CREATE TRIGGER update_sys_login_log_updated_at BEFORE UPDATE ON sys_login_log FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS sys_menu CASCADE;
CREATE TABLE sys_menu (
  id SERIAL PRIMARY KEY,
  parent_id INTEGER DEFAULT NULL,
  path VARCHAR(255) DEFAULT NULL,
  name VARCHAR(255) NOT NULL,
  permission VARCHAR(255) DEFAULT NULL,
  type SMALLINT NOT NULL DEFAULT 0,
  icon VARCHAR(255) DEFAULT '',
  order_no INTEGER DEFAULT 0,
  component VARCHAR(255) DEFAULT NULL,
  keep_alive SMALLINT NOT NULL DEFAULT 1,
  show SMALLINT NOT NULL DEFAULT 1,
  status SMALLINT NOT NULL DEFAULT 1,
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_ext SMALLINT NOT NULL DEFAULT 0,
  ext_open_mode SMALLINT NOT NULL DEFAULT 1,
  active_menu VARCHAR(255) DEFAULT NULL
);

CREATE TRIGGER update_sys_menu_updated_at BEFORE UPDATE ON sys_menu FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS sys_role CASCADE;
CREATE TABLE sys_role (
  id SERIAL PRIMARY KEY,
  value VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(50) NOT NULL UNIQUE,
  remark VARCHAR(255) DEFAULT NULL,
  status SMALLINT DEFAULT 1,
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "default" SMALLINT DEFAULT NULL
);

CREATE TRIGGER update_sys_role_updated_at BEFORE UPDATE ON sys_role FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ----------------------------
-- Table structure for sys_role_menus
-- ----------------------------
DROP TABLE IF EXISTS sys_role_menus CASCADE;
CREATE TABLE sys_role_menus (
  role_id INTEGER NOT NULL,
  menu_id INTEGER NOT NULL,
  PRIMARY KEY (role_id, menu_id),
  CONSTRAINT fk_sys_role_menus_role FOREIGN KEY (role_id) REFERENCES sys_role (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_sys_role_menus_menu FOREIGN KEY (menu_id) REFERENCES sys_menu (id) ON DELETE CASCADE
);

-- ----------------------------
-- Table structure for sys_task
-- ----------------------------
DROP TABLE IF EXISTS sys_task CASCADE;
CREATE TABLE sys_task (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE,
  service VARCHAR(255) NOT NULL,
  type SMALLINT NOT NULL DEFAULT 0,
  status SMALLINT NOT NULL DEFAULT 1,
  start_time TIMESTAMP DEFAULT NULL,
  end_time TIMESTAMP DEFAULT NULL,
  "limit" INTEGER DEFAULT 0,
  cron VARCHAR(255) DEFAULT NULL,
  every INTEGER DEFAULT NULL,
  data TEXT,
  job_opts TEXT,
  remark VARCHAR(255) DEFAULT NULL,
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER update_sys_task_updated_at BEFORE UPDATE ON sys_task FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ----------------------------
-- Table structure for sys_task_log
-- ----------------------------
DROP TABLE IF EXISTS sys_task_log CASCADE;
CREATE TABLE sys_task_log (
  id SERIAL PRIMARY KEY,
  task_id INTEGER DEFAULT NULL,
  status SMALLINT NOT NULL DEFAULT 0,
  detail TEXT,
  consume_time INTEGER DEFAULT 0,
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_sys_task_log_task FOREIGN KEY (task_id) REFERENCES sys_task (id)
);

CREATE TRIGGER update_sys_task_log_updated_at BEFORE UPDATE ON sys_task_log FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ----------------------------
-- Table structure for sys_user_roles
-- ----------------------------
DROP TABLE IF EXISTS sys_user_roles CASCADE;
CREATE TABLE sys_user_roles (
  user_id INTEGER NOT NULL,
  role_id INTEGER NOT NULL,
  PRIMARY KEY (user_id, role_id),
  CONSTRAINT fk_sys_user_roles_user FOREIGN KEY (user_id) REFERENCES sys_user (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_sys_user_roles_role FOREIGN KEY (role_id) REFERENCES sys_role (id)
);

-- ----------------------------
-- Table structure for todo
-- ----------------------------
DROP TABLE IF EXISTS todo CASCADE;
CREATE TABLE todo (
  id SERIAL PRIMARY KEY,
  value VARCHAR(255) NOT NULL,
  user_id INTEGER DEFAULT NULL,
  status SMALLINT NOT NULL DEFAULT 0,
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_todo_user FOREIGN KEY (user_id) REFERENCES sys_user (id)
);

CREATE TRIGGER update_todo_updated_at BEFORE UPDATE ON todo FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ----------------------------
-- Table structure for tool_storage
-- ----------------------------
DROP TABLE IF EXISTS tool_storage CASCADE;
CREATE TABLE tool_storage (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  name VARCHAR(200) NOT NULL, -- 文件名
  "fileName" VARCHAR(200) DEFAULT NULL, -- 真实文件名
  ext_name VARCHAR(255) DEFAULT NULL,
  path VARCHAR(255) NOT NULL,
  type VARCHAR(255) DEFAULT NULL,
  size VARCHAR(255) DEFAULT NULL,
  user_id INTEGER DEFAULT NULL
);

CREATE TRIGGER update_tool_storage_updated_at BEFORE UPDATE ON tool_storage FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ----------------------------
-- Table structure for user_access_tokens
-- ----------------------------
DROP TABLE IF EXISTS user_access_tokens CASCADE;
CREATE TABLE user_access_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  value VARCHAR(500) NOT NULL,
  expired_at TIMESTAMP NOT NULL, -- 令牌过期时间
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 令牌创建时间
  user_id INTEGER DEFAULT NULL,
  CONSTRAINT fk_user_access_tokens_user FOREIGN KEY (user_id) REFERENCES sys_user (id) ON DELETE CASCADE
);

-- ----------------------------
-- Table structure for user_refresh_tokens
-- ----------------------------
DROP TABLE IF EXISTS user_refresh_tokens CASCADE;
CREATE TABLE user_refresh_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  value VARCHAR(500) NOT NULL,
  expired_at TIMESTAMP NOT NULL, -- 令牌过期时间
  created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 令牌创建时间
  "accessTokenId" UUID DEFAULT NULL UNIQUE,
  CONSTRAINT fk_user_refresh_tokens_access FOREIGN KEY ("accessTokenId") REFERENCES user_access_tokens (id) ON DELETE CASCADE
);

-- ----------------------------
-- 插入初始数据
-- ----------------------------

-- Records of sys_config
INSERT INTO sys_config (id, key, name, value, remark, created_at, updated_at) VALUES 
(1, 'sys_user_initPassword', '初始密码', '123456', '创建管理员账号的初始密码', '2023-11-10 00:31:44.154921', '2023-11-10 00:31:44.161263'),
(2, 'sys_api_token', 'API Token', 'nest-admin', '用于请求 @ApiToken 的控制器', '2023-11-10 00:31:44.154921', '2024-01-29 09:52:27.000000');

-- 重置序列
SELECT setval('sys_config_id_seq', 2, true);

-- Records of sys_dept
INSERT INTO sys_dept (id, name, "orderNo", mpath, "parentId", created_at, updated_at) VALUES 
(1, '华东分部', 1, '1.', NULL, '2023-11-10 00:31:43.996025', '2023-11-10 00:31:44.008709'),
(2, '研发部', 1, '1.2.', 1, '2023-11-10 00:31:43.996025', '2023-11-10 00:31:44.008709'),
(3, '市场部', 2, '1.3.', 1, '2023-11-10 00:31:43.996025', '2023-11-10 00:31:44.008709'),
(4, '商务部', 3, '1.4.', 1, '2023-11-10 00:31:43.996025', '2023-11-10 00:31:44.008709'),
(5, '财务部', 4, '1.5.', 1, '2023-11-10 00:31:43.996025', '2023-11-10 00:31:44.008709'),
(6, '华南分部', 2, '6.', NULL, '2023-11-10 00:31:43.996025', '2023-11-10 00:31:44.008709'),
(7, '西北分部', 3, '7.', NULL, '2023-11-10 00:31:43.996025', '2023-11-10 00:31:44.008709'),
(8, '研发部', 1, '6.8.', 6, '2023-11-10 00:31:43.996025', '2023-11-10 00:31:44.008709'),
(9, '市场部', 1, '6.9.', 6, '2023-11-10 00:31:43.996025', '2023-11-10 00:31:44.008709');

SELECT setval('sys_dept_id_seq', 9, true);

-- Records of sys_dict_type
INSERT INTO sys_dict_type (id, created_at, updated_at, create_by, update_by, name, status, remark, code) VALUES 
(1, '2024-01-28 08:19:12.777447', '2024-02-08 13:05:10.000000', 1, 1, '性别', 1, '性别单选', 'sys_user_gender'),
(2, '2024-01-28 08:38:41.235185', '2024-01-29 02:11:33.000000', 1, 1, '菜单显示状态', 1, '菜单显示状态', 'sys_show_hide');

SELECT setval('sys_dict_type_id_seq', 2, true);

-- Records of sys_dict_item
INSERT INTO sys_dict_item (id, created_at, updated_at, create_by, update_by, label, value, "order", status, remark, type_id, "orderNo") VALUES 
(1, '2024-01-29 01:24:51.846135', '2024-01-29 02:23:19.000000', 1, 1, '男', '1', 0, 1, '性别男', 1, 3),
(2, '2024-01-29 01:32:58.458741', '2024-01-29 01:58:20.000000', 1, 1, '女', '0', 1, 1, '性别女', 1, 2),
(3, '2024-01-29 01:59:17.805394', '2024-01-29 14:37:18.000000', 1, 1, '人妖王', '3', NULL, 1, '安布里奥·伊万科夫', 1, 0),
(5, '2024-01-29 02:13:01.782466', '2024-01-29 02:13:01.782466', 1, 1, '显示', '1', NULL, 1, '显示菜单', 2, 0),
(6, '2024-01-29 02:13:31.134721', '2024-01-29 02:13:31.134721', 1, 1, '隐藏', '0', NULL, 1, '隐藏菜单', 2, 0);

SELECT setval('sys_dict_item_id_seq', 6, true);

-- Records of sys_user
INSERT INTO sys_user (id, username, password, avatar, email, phone, remark, psalt, status, qq, created_at, updated_at, nickname, dept_id) VALUES 
(1, 'admin', 'a11571e778ee85e82caae2d980952546', 'https://thirdqq.qlogo.cn/g?b=qq&s=100&nk=1743369777', '1743369777@qq.com', '10086', '管理员', 'xQYCspvFb8cAW6GG1pOoUGTLqsuUSO3d', 1, '1743369777', '2023-11-10 00:31:44.104382', '2024-01-29 09:49:43.000000', 'bqy', 1),
(2, 'user', 'dbd89546dec743f82bb9073d6ac39361', 'https://thirdqq.qlogo.cn/g?b=qq&s=100&nk=1743369777', 'luffy@qq.com', '10010', '王路飞', 'qlovDV7pL5dPYPI3QgFFo1HH74nP6sJe', 1, '1743369777', '2023-11-10 00:31:44.104382', '2024-01-29 09:49:57.000000', 'luffy', 8),
(8, 'developer', 'f03fa2a99595127b9a39587421d471f6', '/upload/cfd0d14459bc1a47-202402032141838.jpeg', 'nami@qq.com', '10000', '小贼猫', 'NbGM1z9Vhgo7f4dd2I7JGaGP12RidZdE', 1, '1743369777', '2023-11-10 00:31:44.104382', '2024-02-03 21:41:18.000000', '娜美', 7);

SELECT setval('sys_user_id_seq', 8, true);

-- Records of sys_role
INSERT INTO sys_role (id, value, name, remark, status, created_at, updated_at, "default") VALUES 
(1, 'admin', '管理员', '超级管理员', 1, '2023-11-10 00:31:44.058463', '2024-01-28 21:08:39.000000', NULL),
(2, 'user', '用户', '', 1, '2023-11-10 00:31:44.058463', '2024-01-30 18:44:45.000000', 1),
(9, 'test', '测试', NULL, 1, '2024-01-23 22:46:52.408827', '2024-01-30 01:04:52.000000', NULL);

SELECT setval('sys_role_id_seq', 9, true);

-- Records of sys_user_roles
INSERT INTO sys_user_roles (user_id, role_id) VALUES 
(1, 1),
(2, 2),
(8, 2);

-- Records of sys_menu (简化版，包含主要菜单项)
INSERT INTO sys_menu (id, parent_id, path, name, permission, type, icon, order_no, component, keep_alive, show, status, created_at, updated_at, is_ext, ext_open_mode, active_menu) VALUES 
(1, NULL, '/system', '系统管理', '', 0, 'ant-design:setting-outlined', 254, '', 0, 1, 1, '2023-11-10 00:31:44.023393', '2024-02-28 22:05:52.102649', 0, 1, NULL),
(2, 1, '/system/user', '用户管理', 'system:user:list', 1, 'ant-design:user-outlined', 0, 'system/user/index', 0, 1, 1, '2023-11-10 00:31:44.023393', '2024-02-28 22:05:52.102649', 0, 1, NULL),
(3, 1, '/system/role', '角色管理', 'system:role:list', 1, 'ep:user', 1, 'system/role/index', 0, 1, 1, '2023-11-10 00:31:44.023393', '2024-02-28 22:05:52.102649', 0, 1, NULL),
(4, 1, '/system/menu', '菜单管理', 'system:menu:list', 1, 'ep:menu', 2, 'system/menu/index', 0, 1, 1, '2023-11-10 00:31:44.023393', '2024-02-28 22:05:52.102649', 0, 1, NULL),
(43, NULL, '/about', '关于', '', 1, 'ant-design:info-circle-outlined', 260, 'account/about', 0, 1, 1, '2023-11-10 00:31:44.023393', '2024-02-28 22:05:52.102649', 0, 1, NULL);

SELECT setval('sys_menu_id_seq', 127, true);

-- Records of sys_role_menus (基础权限)
INSERT INTO sys_role_menus (role_id, menu_id) VALUES 
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 43),
(2, 43);

-- Records of sys_task
INSERT INTO sys_task (id, name, service, type, status, start_time, end_time, "limit", cron, every, data, job_opts, remark, created_at, updated_at) VALUES 
(2, '定时清空登录日志', 'LogClearJob.clearLoginLog', 0, 1, NULL, NULL, 0, '0 0 3 ? * 1', 0, '', '{"count":1,"key":"__default__:2:::0 0 3 ? * 1","cron":"0 0 3 ? * 1","jobId":2}', '定时清空登录日志', '2023-11-10 00:31:44.197779', '2024-02-28 22:34:53.000000'),
(3, '定时清空任务日志', 'LogClearJob.clearTaskLog', 0, 1, NULL, NULL, 0, '0 0 3 ? * 1', 0, '', '{"count":1,"key":"__default__:3:::0 0 3 ? * 1","cron":"0 0 3 ? * 1","jobId":3}', '定时清空任务日志', '2023-11-10 00:31:44.197779', '2024-02-28 22:34:53.000000'),
(4, '访问百度首页', 'HttpRequestJob.handle', 0, 0, NULL, NULL, 1, '* * * * * ?', NULL, '{"url":"https://www.baidu.com","method":"get"}', NULL, '访问百度首页', '2023-11-10 00:31:44.197779', '2023-11-10 00:31:44.206935'),
(5, '发送邮箱', 'EmailJob.send', 0, 0, NULL, NULL, -1, '0 0 0 1 * ?', NULL, '{"subject":"这是标题","to":"zeyu57@163.com","content":"这是正文"}', NULL, '每月发送邮箱', '2023-11-10 00:31:44.197779', '2023-11-10 00:31:44.206935');

SELECT setval('sys_task_id_seq', 5, true);

-- Records of todo
INSERT INTO todo (id, value, user_id, status, created_at, updated_at) VALUES 
(1, 'nest.js', NULL, 0, '2023-11-10 00:31:44.139730', '2023-11-10 00:31:44.147629');

SELECT setval('todo_id_seq', 1, true);

-- 创建索引
CREATE INDEX idx_sys_user_username ON sys_user(username);
CREATE INDEX idx_sys_user_email ON sys_user(email);
CREATE INDEX idx_sys_role_value ON sys_role(value);
CREATE INDEX idx_sys_menu_parent_id ON sys_menu(parent_id);
CREATE INDEX idx_sys_dept_parent_id ON sys_dept("parentId");
CREATE INDEX idx_sys_login_log_user_id ON sys_login_log(user_id);
CREATE INDEX idx_sys_task_log_task_id ON sys_task_log(task_id);
CREATE INDEX idx_user_access_tokens_user_id ON user_access_tokens(user_id);
