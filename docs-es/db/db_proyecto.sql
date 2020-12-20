CREATE DATABASE  IF NOT EXISTS `db_proyecto_consulta`;
USE `db_proyecto_consulta`;


DROP TABLE IF EXISTS `answer`;

CREATE TABLE `answer` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_question` bigint NOT NULL,
  `id_user` bigint NOT NULL,
  `content` varchar(500) NOT NULL,
  `created` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_respuesta_1_idx` (`id_question`),
  KEY `fk_respuesta_2_idx` (`id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `language`;

CREATE TABLE `language` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `nombre_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `question`;

CREATE TABLE `question` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_language` bigint NOT NULL,
  `id_user` bigint NOT NULL,
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
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `surname_1` varchar(100) NOT NULL DEFAULT '',
  `surname_2` varchar(100) NOT NULL DEFAULT '',
  `username` varchar(100) NOT NULL DEFAULT '',
  `password` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL,
  `bio` longtext,
  `timecreated` int unsigned NOT NULL DEFAULT '0',
  `timemodified` int unsigned NOT NULL DEFAULT '0',
  `firstaccess` int unsigned NOT NULL DEFAULT '0',
  `lastaccess` int unsigned NOT NULL DEFAULT '0',
  `lastlogin` int unsigned NOT NULL DEFAULT '0',
  `currentlogin` int unsigned NOT NULL DEFAULT '0',
  `lastip` varchar(45) NOT NULL DEFAULT '',
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `suspended` tinyint(1) NOT NULL DEFAULT '0',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `loginattemps` smallint unsigned NOT NULL DEFAULT '0',
  `loginlockoutexpiry` int unsigned NOT NULL DEFAULT '0',
  `reputation` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `user - language`;

CREATE TABLE `user - language` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_user` bigint NOT NULL,
  `id_language` bigint NOT NULL,
  `reputation` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_usuario - lenguaje_1_idx` (`id_user`),
  KEY `fk_usuario - lenguaje_2_idx` (`id_language`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `vote`;

CREATE TABLE `vote` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_question` bigint NOT NULL,
  `id_user` bigint NOT NULL,
  `vote` enum('-1','0','1') NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `usuario_pregunta_UNIQUE` (`id_question`,`id_user`),
  KEY `fk_voto_2_idx` (`id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELIMITER ;;
CREATE PROCEDURE `updateLanguageReputation`()
BEGIN
	
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE idUserLanguageRel BIGINT DEFAULT 0;
    
	DECLARE pointer CURSOR FOR SELECT id FROM `user - language`;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;  
	
    OPEN pointer;
    
    updateReputation: LOOP
		FETCH pointer INTO idUserLanguageRel;
		IF finished = 1 THEN 
			LEAVE updateReputation;
		END IF;
		CALL `db_proyecto_consulta`.`updateUserLanguageReputation`(idUserLanguageRel);
	END LOOP updateReputation;
    
    CLOSE pointer;
        
END ;;
DELIMITER ;


DELIMITER ;;
CREATE PROCEDURE `updatePlatformReputation`()
BEGIN
	
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE userID BIGINT DEFAULT 0;
    
	DECLARE pointer CURSOR FOR SELECT id FROM user;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;  
	
    OPEN pointer;
    
    updateReputation: LOOP
		FETCH pointer INTO userID;
		IF finished = 1 THEN 
			LEAVE updateReputation;
		END IF;
		CALL `db_proyecto_consulta`.`updateUserPlatformReputation`(userID);
	END LOOP updateReputation;
    
    CLOSE pointer;
        
END ;;
DELIMITER ;


DELIMITER ;;
CREATE PROCEDURE `updateUserLanguageReputation`(IN idrow BIGINT)
BEGIN
	DECLARE aux INTEGER DEFAULT 1;
    DECLARE rep INTEGER DEFAULT 0;

	SELECT reputation
	INTO rep
    FROM `user - language`
    WHERE id = idrow;
    
    IF rep - 2 >= 1 THEN
		SET aux = rep - 2;
	END IF;
    
	UPDATE `user - language`
        SET reputation=aux
        WHERE id = idrow;
END ;;
DELIMITER ;


DELIMITER ;;
CREATE PROCEDURE `updateUserPlatformReputation`(IN userID BIGINT)
BEGIN
	DECLARE aux INTEGER DEFAULT 1;
    DECLARE rep INTEGER DEFAULT 0;

	SELECT reputation
	INTO rep
    FROM user
    WHERE id = userID;
    
    IF rep - 2 >= 1 THEN
		SET aux = rep - 2;
	END IF;
    
	UPDATE user
        SET reputation=aux
        WHERE id = userID;
END ;;
DELIMITER ;

CREATE EVENT IF NOT EXISTS reduceReputationDaily
ON SCHEDULE EVERY 5 DAY_HOUR
COMMENT 'Reduce user\'s reputation every day'
DO
	CALL `db_proyecto_consulta`.`updatePlatformReputation`();
	CALL `db_proyecto_consulta`.`updateLanguageReputation`();
