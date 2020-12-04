CREATE DATABASE  IF NOT EXISTS `db_proyecto2`;
USE `db_proyecto2`;

DROP TABLE IF EXISTS `lenguaje`;

CREATE TABLE `lenguaje` (
  `id` mediumint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



DROP TABLE IF EXISTS `usuario`;

CREATE TABLE `usuario` (
  `id` mediumint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `primerApellido` varchar(45) DEFAULT NULL,
  `segundoApellido` varchar(45) DEFAULT NULL,
  `email` varchar(60) NOT NULL,
  `password` varchar(100) DEFAULT NULL,
  `fechaRegistro` timestamp NOT NULL,
  `nombreUsuario` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



DROP TABLE IF EXISTS `pregunta`;

CREATE TABLE `pregunta` (
  `id` mediumint NOT NULL AUTO_INCREMENT,
  `idLenguaje` mediumint NOT NULL,
  `idUsuario` mediumint NOT NULL,
  `creado` timestamp NOT NULL,
  `titulo` varchar(100) NOT NULL,
  `contenido` varchar(500) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_pregunta_1_idx` (`idLenguaje`),
  KEY `fk_pregunta_2_idx` (`idUsuario`),
  CONSTRAINT `fk_pregunta_1` FOREIGN KEY (`idLenguaje`) REFERENCES `lenguaje` (`id`),
  CONSTRAINT `fk_pregunta_2` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



DROP TABLE IF EXISTS `respuesta`;

CREATE TABLE `respuesta` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idPregunta` mediumint NOT NULL,
  `idUsuario` mediumint NOT NULL,
  `contenido` varchar(500) NOT NULL,
  `creado` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_respuesta_1_idx` (`idPregunta`),
  KEY `fk_respuesta_2_idx` (`idUsuario`),
  CONSTRAINT `fk_respuesta_1` FOREIGN KEY (`idPregunta`) REFERENCES `pregunta` (`id`),
  CONSTRAINT `fk_respuesta_2` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



DROP TABLE IF EXISTS `usuario - lenguaje`;

CREATE TABLE `usuario - lenguaje` (
  `id` mediumint NOT NULL AUTO_INCREMENT,
  `idUsuario` mediumint NOT NULL,
  `idLenguaje` mediumint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_usuario - lenguaje_1_idx` (`idUsuario`),
  KEY `fk_usuario - lenguaje_2_idx` (`idLenguaje`),
  CONSTRAINT `fk_usuario - lenguaje_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`id`),
  CONSTRAINT `fk_usuario - lenguaje_2` FOREIGN KEY (`idLenguaje`) REFERENCES `lenguaje` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



DROP TABLE IF EXISTS `voto`;

CREATE TABLE `voto` (
  `id` mediumint NOT NULL AUTO_INCREMENT,
  `idPregunta` mediumint NOT NULL,
  `idUsuario` mediumint NOT NULL,
  `voto` enum('-1','0','1') NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `usuario_pregunta_UNIQUE` (`idPregunta`,`idUsuario`),
  KEY `fk_voto_2_idx` (`idUsuario`),
  CONSTRAINT `fk_voto_1` FOREIGN KEY (`idPregunta`) REFERENCES `pregunta` (`id`),
  CONSTRAINT `fk_voto_2` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
