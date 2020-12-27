CREATE DATABASE  IF NOT EXISTS `db_proyecto_consulta`;
USE `db_proyecto_consulta`;


DROP TABLE IF EXISTS `answer`;

CREATE TABLE `answer` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `validated` tinyint(1) NOT NULL DEFAULT '0',
  `validated_at` int unsigned DEFAULT NULL,
  `validated_by_id` bigint DEFAULT NULL,
  `content_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_answer_1_idx` (`content_id`),
  KEY `fk_answer_2_idx` (`validated_by_id`),
  CONSTRAINT `fk_answer_1` FOREIGN KEY (`content_id`) REFERENCES `question_content` (`id`),
  CONSTRAINT `fk_answer_2` FOREIGN KEY (`validated_by_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


DROP TABLE IF EXIST `avatar`;

CREATE TABLE `avatar` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `type` enum('gravatar','custom') NOT NULL DEFAULT 'custom',
  `avatar` varchar(1024) NOT NULL,
  `selected` tinyint(1) NOT NULL DEFAULT '1',
  `added_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_avatar_1_idx` (`user_id`),
  CONSTRAINT `fk_avatar_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


DROP TABLE IF EXISTS `comment`;

CREATE TABLE `comment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content_id` bigint NOT NULL,
  `parent_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_comment_1_idx` (`content_id`,`parent_id`),
  KEY `fk_comment_2_idx` (`parent_id`),
  CONSTRAINT `fk_comment_1` FOREIGN KEY (`content_id`) REFERENCES `question_content` (`id`),
  CONSTRAINT `fk_comment_2` FOREIGN KEY (`parent_id`) REFERENCES `question_content` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


DROP TABLE IF EXISTS `language`;

CREATE TABLE `language` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` text NOT NULL,
  `added_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `nombre_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


DROP TABLE IF EXISTS `question`;

CREATE TABLE `question` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(300) NOT NULL DEFAULT '',
  `view_count` int unsigned NOT NULL DEFAULT '0',
  `language_id` bigint NOT NULL,
  `closed` tinyint(1) NOT NULL DEFAULT '0',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `title_UNIQUE` (`title`),
  KEY `fk_question_1_idx` (`language_id`),
  CONSTRAINT `fk_question_1` FOREIGN KEY (`language_id`) REFERENCES `language` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


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
  `added_at` int unsigned NOT NULL DEFAULT '0',
  `modified_at` int unsigned NOT NULL DEFAULT '0',
  `first_access` int unsigned NOT NULL DEFAULT '0',
  `last_access` int unsigned NOT NULL DEFAULT '0',
  `last_login` int unsigned NOT NULL DEFAULT '0',
  `current_login` int unsigned NOT NULL DEFAULT '0',
  `last_ip` varchar(45) NOT NULL DEFAULT '',
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `suspended` tinyint(1) NOT NULL DEFAULT '0',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `login_attemps` smallint unsigned NOT NULL DEFAULT '0',
  `login_lockout_expiry` int unsigned NOT NULL DEFAULT '0',
  `reputation` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


DROP TABLE IF EXISTS `question_content`;

CREATE TABLE `question_content` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type` enum('question','answer','comment') NOT NULL DEFAULT 'question',
  `author` bigint NOT NULL DEFAULT '1',
  `question_id` bigint NOT NULL,
  `added_at` int unsigned NOT NULL,
  `last_activity_at` int unsigned NOT NULL,
  `last_activity_by_id` bigint NOT NULL,
  `last_edited_at` int unsigned DEFAULT NULL,
  `last_edited_by_id` bigint DEFAULT NULL,
  `content` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_question_content_1_idx` (`question_id`),
  KEY `fk_question_content_2_idx` (`last_activity_by_id`),
  KEY `fk_question_content_3_idx` (`last_edited_by_id`),
  CONSTRAINT `fk_question_content_1` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`),
  CONSTRAINT `fk_question_content_2` FOREIGN KEY (`author`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_question_content_3` FOREIGN KEY (`last_activity_by_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_question_content_4` FOREIGN KEY (`last_edited_by_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


DROP TABLE IF EXISTS `question_close_reason`; 

CREATE TABLE `question_close_reason` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `reason` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reason_UNIQUE` (`reason`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


DROP TABLE IF EXISTS `question_closed`;

CREATE TABLE `question_closed` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `question_id` bigint NOT NULL,
  `closed_at` int unsigned NOT NULL,
  `closed_reason` bigint NOT NULL,
  `closed_by_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `question_id_UNIQUE` (`question_id`),
  KEY `fk_question_closed_2_idx` (`closed_by_id`),
  KEY `fk_question_closed_3_idx` (`closed_reason`),
  CONSTRAINT `fk_question_closed_1` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`),
  CONSTRAINT `fk_question_closed_2` FOREIGN KEY (`closed_by_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_question_closed_3` FOREIGN KEY (`closed_reason`) REFERENCES `question_closed` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


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
