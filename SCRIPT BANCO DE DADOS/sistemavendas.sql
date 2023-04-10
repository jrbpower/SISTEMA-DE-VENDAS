/*
 Navicat Premium Data Transfer

 Source Server         : SISTEMASVENDAS
 Source Server Type    : MySQL
 Source Server Version : 50740
 Source Host           : localhost:3306
 Source Schema         : sistemavendas

 Target Server Type    : MySQL
 Target Server Version : 50740
 File Encoding         : 65001

 Date: 10/04/2023 02:56:35
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for clientes
-- ----------------------------
DROP TABLE IF EXISTS `clientes`;
CREATE TABLE `clientes`  (
  `cod_cliente` int(11) NOT NULL,
  `nome` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `cidade` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `uf` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`cod_cliente`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pedidos
-- ----------------------------
DROP TABLE IF EXISTS `pedidos`;
CREATE TABLE `pedidos`  (
  `cod_nu_pedido` int(11) NOT NULL,
  `data_emissao` datetime(6) NULL DEFAULT NULL,
  `cod_cliente` int(11) NOT NULL,
  `vl_total` decimal(20, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`cod_nu_pedido`) USING BTREE,
  INDEX `cod_cliente`(`cod_cliente`) USING BTREE,
  CONSTRAINT `cod_cliente` FOREIGN KEY (`cod_cliente`) REFERENCES `clientes` (`cod_cliente`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for produtos
-- ----------------------------
DROP TABLE IF EXISTS `produtos`;
CREATE TABLE `produtos`  (
  `cod_produto` int(11) NOT NULL,
  `descricao` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `preco_venda` decimal(20, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`cod_produto`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for produtos_pedidos
-- ----------------------------
DROP TABLE IF EXISTS `produtos_pedidos`;
CREATE TABLE `produtos_pedidos`  (
  `cod_pedido_produto` int(11) NOT NULL AUTO_INCREMENT,
  `cod_nu_pedido` int(11) NULL DEFAULT NULL,
  `cod_produto` int(11) NULL DEFAULT NULL,
  `quantidade` decimal(20, 4) NULL DEFAULT NULL,
  `valor_unit` decimal(20, 2) NULL DEFAULT NULL,
  `valor_total` decimal(20, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`cod_pedido_produto`) USING BTREE,
  INDEX `cod_pedido_produto`(`cod_nu_pedido`) USING BTREE,
  INDEX `cod_produto_pedido`(`cod_produto`) USING BTREE,
  CONSTRAINT `cod_pedido_produto` FOREIGN KEY (`cod_nu_pedido`) REFERENCES `pedidos` (`cod_nu_pedido`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `cod_produto_pedido` FOREIGN KEY (`cod_produto`) REFERENCES `produtos` (`cod_produto`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 85 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
