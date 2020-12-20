CREATE DATABASE  IF NOT EXISTS `db_proyecto_consulta_consulta` 
USE `db_proyecto_consulta`;


DROP TABLE IF EXISTS `answer`;

CREATE TABLE `answer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_question` mediumint NOT NULL,
  `id_user` mediumint NOT NULL,
  `content` varchar(500) NOT NULL,
  `created` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_respuesta_1_idx` (`id_question`),
  KEY `fk_respuesta_2_idx` (`id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `language`;

CREATE TABLE `language` (
  `id` mediumint NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `nombre_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `question`;

CREATE TABLE `question` (
  `id` mediumint NOT NULL AUTO_INCREMENT,
  `id_language` mediumint NOT NULL,
  `id_user` mediumint NOT NULL,
  `created` timestamp NOT NULL,
  `title` varchar(100) NOT NULL,
  `content` varchar(500) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_pregunta_1_idx` (`id_language`),
  KEY `fk_pregunta_2_idx` (`id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` mediumint NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `middle_name` varchar(45) DEFAULT NULL,
  `surname` varchar(45) DEFAULT NULL,
  `email` varchar(60) NOT NULL,
  `password` varchar(100) DEFAULT NULL,
  `registered` timestamp NOT NULL,
  `username` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `user - language`;

CREATE TABLE `user - language` (
  `id` mediumint NOT NULL AUTO_INCREMENT,
  `id_user` mediumint NOT NULL,
  `id_language` mediumint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_usuario - lenguaje_1_idx` (`id_user`),
  KEY `fk_usuario - lenguaje_2_idx` (`id_language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `vote`;

CREATE TABLE `vote` (
  `id` mediumint NOT NULL AUTO_INCREMENT,
  `id_question` mediumint NOT NULL,
  `id_user` mediumint NOT NULL,
  `vote` enum('-1','0','1') NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `usuario_pregunta_UNIQUE` (`id_question`,`id_user`),
  KEY `fk_voto_2_idx` (`id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

