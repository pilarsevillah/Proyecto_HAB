DROP DATABASE IF EXISTS `db_proyecto_consulta`;
CREATE DATABASE IF NOT EXISTS `db_proyecto_consulta`;
USE `db_proyecto_consulta`;


DROP TABLE IF EXISTS `language`;

CREATE TABLE `language` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` text NOT NULL,
  `added_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `nombre_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `avatar`;

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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `user-language`;

CREATE TABLE `user-language` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_user` bigint NOT NULL,
  `id_language` bigint NOT NULL,
  `reputation` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_usuario - lenguaje_1_idx` (`id_user`),
  KEY `fk_usuario - lenguaje_2_idx` (`id_language`),
  CONSTRAINT `fk_user-language_1` FOREIGN KEY (`id_language`) REFERENCES `language` (`id`),
  CONSTRAINT `fk_user-language_2` FOREIGN KEY (`id_user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `question_close_reason`; 

CREATE TABLE `question_close_reason` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `reason` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reason_UNIQUE` (`reason`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `vote`;

CREATE TABLE `vote` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `vote` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `usuario_pregunta_UNIQUE` (`content_id`,`user_id`),
  KEY `fk_voto_2_idx` (`user_id`),
  CONSTRAINT `fk_vote_1` FOREIGN KEY (`content_id`) REFERENCES `question_content` (`id`),
  CONSTRAINT `fk_vote_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `vote_inrange` CHECK (((`vote` = -(1)) or (`vote` = 1)))
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DELIMITER ;;
CREATE DEFINER=`pconsulta`@`localhost` PROCEDURE `updateUserLanguageReputation`(IN idrow BIGINT)
BEGIN
    DECLARE aux INTEGER DEFAULT 1;
    DECLARE rep INTEGER DEFAULT 0;

    SELECT reputation
	INTO rep
    FROM `user-language`
    WHERE id = idrow;
    
    IF rep - 2 >= 1 THEN
		SET aux = rep - 2;
	END IF;
    
	UPDATE `user-language`
        SET reputation=aux
        WHERE id = idrow;
END ;;


CREATE DEFINER=`pconsulta`@`localhost` PROCEDURE `updateUserPlatformReputation`(IN userID BIGINT)
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


CREATE DEFINER=`pconsulta`@`localhost` PROCEDURE `updateLanguageReputation`()
BEGIN
	
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE idUserLanguageRel BIGINT DEFAULT 0;
    
	DECLARE pointer CURSOR FOR SELECT id FROM `user-language`;
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


CREATE DEFINER=`pconsulta`@`localhost` PROCEDURE `updatePlatformReputation`()
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

CREATE DEFINER=`pconsulta`@`localhost` PROCEDURE `removeSelectedAvatarsFromUser`(avatar_id BIGINT, user_id BIGINT)
BEGIN
	UPDATE `db_proyecto_consulta`.`avatar`
		SET `selected` = 0
	WHERE `avatar`.`user_id` = user_id AND `avatar`.`id` <> avatar_id;
END ;;

CREATE DEFINER=`pconsulta`@`localhost` PROCEDURE `getCommentsOf`(parent_id BIGINT)
BEGIN
	SELECT `c`.`id` AS `id`,
		`qc`.`content` AS `comment_title`,
		`u`.`username` AS `author`,
		GETCONTENTVOTES(`qc`.`id`) AS `usefull_comment`,
		`qc`.`added_at` AS `added`
	FROM `db_proyecto_consulta`.`comment` AS c
    JOIN `db_proyecto_consulta`.`question_content` `qc` ON `c`.`content_id` = `qc`.`id`
    JOIN `db_proyecto_consulta`.`user` `u` ON `qc`.`author` = `u`.`id`
    WHERE `c`.`parent_id` = parent_id
    ORDER BY `usefull_comment` DESC, `qc`.`added_at` ASC;
END ;;

CREATE DEFINER=`pconsulta`@`localhost` PROCEDURE `getAnswersOfQuestion`(question_id BIGINT)
BEGIN
	SELECT `a`.`id` as `id`,
		`qc`.`content` AS `content`,
		`u`.`username` AS `author`,
		GETCONTENTVOTES(`qc`.`id`) AS `votes_count`,
		`qc`.`added_at` AS `added`
	FROM `db_proyecto_consulta`.`answer` AS a
    JOIN `db_proyecto_consulta`.`question_content` `qc` ON `a`.`content_id` = `qc`.`id`
    JOIN `db_proyecto_consulta`.`user` `u` ON `qc`.`author` = `u`.`id`
    WHERE `qc`.`question_id` = question_id
    ORDER BY `votes_count` DESC, `qc`.`added_at` ASC;
END ;;

CREATE DEFINER=`pconsulta`@`localhost` FUNCTION `hasValidatedAnswers`(q_id BIGINT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE validations INT;
	SELECT SUM(`a`.`validated`) INTO validations
	FROM `db_proyecto_consulta`.`answer` AS a
	JOIN `db_proyecto_consulta`.`question_content` as qc ON `qc`.`id` = `a`.`content_id`
	WHERE qc.type = 'answer' AND qc.question_id = q_id;
    IF validations IS NULL THEN SET validations = 0; END IF;
    IF validations > 0 THEN SET validations = 1; END IF;
RETURN validations;
END ;;

CREATE DEFINER=`pconsulta`@`localhost` FUNCTION `getQuestionAnswersCount`(q_id BIGINT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE answers INT;
	SELECT COUNT(id) INTO answers FROM `db_proyecto_consulta`.`question_content` WHERE (type = 'answer' AND question_id = q_id);
	RETURN answers;
END ;;

CREATE DEFINER=`pconsulta`@`localhost` FUNCTION `getQuestionAnswers`(q_id BIGINT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE answers INT;
	SELECT COUNT(id) INTO answers FROM `db_proyecto_consulta`.`question_content` WHERE (type = 'answer' AND question_id = q_id);
	RETURN answers;
END ;;

CREATE DEFINER=`pconsulta`@`localhost` FUNCTION `getNumLanguageQuestionsWeek`( lang_id BIGINT ) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
DECLARE CONT INT;
	SELECT COUNT(`q`.`id`) INTO CONT
	FROM `db_proyecto_consulta`.`question` AS `q`
    JOIN `db_proyecto_consulta`.`question_content` `qc` ON `q`.`id` = `qc`.`question_id`
    WHERE `q`.`language_id` = lang_id AND `qc`.`type` = 'question'
		AND WEEK(NOW(),3) = WEEK(FROM_UNIXTIME(`qc`.`added_at`),3);
RETURN CONT;
END ;;

CREATE DEFINER=`pconsulta`@`localhost` FUNCTION `getNumLanguageQuestionsToday`( lang_id BIGINT ) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE CONT INT;
	SELECT COUNT(`q`.`id`) INTO CONT 
	FROM `db_proyecto_consulta`.`question` AS `q`
    JOIN `db_proyecto_consulta`.`question_content` `qc` ON `q`.`id` = `qc`.`question_id`
    WHERE `q`.`language_id` = lang_id AND `qc`.`type` = 'question' AND `qc`.`added_at` > UNIX_TIMESTAMP(CURDATE());
RETURN CONT;
END ;;

CREATE DEFINER=`pconsulta`@`localhost` FUNCTION `getContentVotes`(c_id BIGINT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE votes INT;
    SELECT SUM(vote) INTO votes FROM `db_proyecto_consulta`.`vote` WHERE content_id = c_id;
    IF votes is NULL THEN SET votes = 0; END IF;
RETURN votes;
END ;;

CREATE DEFINER=`pconsulta`@`localhost` FUNCTION `generateAvatarID`(mail VARCHAR(100)) RETURNS varchar(32) CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE id VARCHAR(32);
    SELECT MD5(TRIM(LOWER(mail))) AS gravatar INTO id;
RETURN id;
END ;;

CREATE DEFINER=`pconsulta`@`localhost` TRIGGER `answer_BEFORE_INSERT` BEFORE INSERT ON `answer` FOR EACH ROW BEGIN
	IF new.validated_by_id IS NULL THEN
    	SET new.validated_at = NULL;
	ELSE
		SET new.validated_at = UNIX_TIMESTAMP(NOW());
	END IF;
END;;

CREATE DEFINER=`pconsulta`@`localhost` TRIGGER `answer_BEFORE_UPDATE` BEFORE UPDATE ON `answer` FOR EACH ROW BEGIN
	IF new.validated_by_id IS NULL THEN
    	SET new.validated_at = NULL;
	ELSE
		IF old.validated_by_id <> new.validated_by_id THEN
			SET new.validated_at = UNIX_TIMESTAMP(NOW());
		END IF;
	END IF;
END;;

CREATE DEFINER=`pconsulta`@`localhost` TRIGGER `comment_BEFORE_INSERT` BEFORE INSERT ON `comment` FOR EACH ROW BEGIN
	IF (NEW.content_id = NEW.parent_id) THEN
		SIGNAL SQLSTATE '40000' SET MESSAGE_TEXT = 'invalid data';
	END IF;
END;;

CREATE DEFINER=`pconsulta`@`localhost` TRIGGER `comment_BEFORE_UPDATE` BEFORE UPDATE ON `comment` FOR EACH ROW BEGIN
	IF (NEW.content_id = NEW.parent_id) THEN
		SIGNAL SQLSTATE '40000' SET MESSAGE_TEXT = 'invalid data';
	END IF;
END;;

CREATE DEFINER=`pconsulta`@`localhost` TRIGGER `language_BEFORE_INSERT` BEFORE INSERT ON `language` FOR EACH ROW BEGIN
	SET new.added_at = UNIX_TIMESTAMP(NOW());
END;;

CREATE DEFINER=`pconsulta`@`localhost` TRIGGER `closed_questions_BEFORE_INSERT` BEFORE INSERT ON `question_closed` FOR EACH ROW BEGIN
	SET new.closed_at = UNIX_TIMESTAMP(NOW());
END;;

CREATE DEFINER=`pconsulta`@`localhost` TRIGGER `question_content_BEFORE_INSERT` BEFORE INSERT ON `question_content` FOR EACH ROW BEGIN
	SET new.added_at = UNIX_TIMESTAMP(NOW());
    SET new.last_activity_at = UNIX_TIMESTAMP(NOW());
    SET new.last_activity_by_id = new.author;
END;;

CREATE DEFINER=`pconsulta`@`localhost` TRIGGER `question_content_BEFORE_UPDATE` BEFORE UPDATE ON `question_content` FOR EACH ROW BEGIN
	SET new.last_activity_at = UNIX_TIMESTAMP(NOW());
END;;

CREATE DEFINER=`pconsulta`@`localhost` TRIGGER `user_AFTER_INSERT` AFTER INSERT ON `user` FOR EACH ROW BEGIN
	INSERT INTO `db_proyecto_consulta`.`avatar` (`user_id`, `type`, `avatar`)
	VALUES ( new.`id`, 'gravatar', `db_proyecto_consulta`.`generateAvatarID`(new.email));
END;;

CREATE DEFINER=`pconsulta`@`localhost` TRIGGER `user_AFTER_UPDATE` AFTER UPDATE ON `user` FOR EACH ROW BEGIN
	IF OLD.email <> NEW.email THEN
		UPDATE `db_proyecto_consulta`.`avatar`
		SET `avatar` = `db_proyecto_consulta`.`generateAvatarID`(new.email)
		WHERE `avatar`.`id` = OLD.`id` AND `avatar`.`type` = 'gravatar';
	END IF;
END;;

DELIMITER ;

DROP VIEW IF EXISTS `question_header`;

CREATE DEFINER=`pconsulta`@`localhost` VIEW `question_header` AS select `q`.`id` AS `id`,`q`.`title` AS `title`,`l`.`name` AS `language_name`,`q`.`view_count` AS `view_count`,`GETQUESTIONANSWERSCOUNT`(`qc`.`question_id`) AS `answer_count`,`GETCONTENTVOTES`(`qc`.`id`) AS `vote_count`,`HASVALIDATEDANSWERS`(`q`.`id`) AS `has_validated_answers`,`u`.`username` AS `asked_by`,`qc`.`added_at` AS `added_at`,`q`.`closed` AS `closed`,`q`.`deleted` AS `deleted` from (((`question_content` `qc` join `question` `q` on(((`q`.`id` = `qc`.`question_id`) and (`qc`.`type` = 'question')))) join `language` `l` on((`q`.`language_id` = `l`.`id`))) join `user` `u` on((`qc`.`author` = `u`.`id`)));


DROP VIEW IF EXISTS `languages_page`;

CREATE DEFINER=`pconsulta`@`localhost` VIEW `languages_page` AS select `l`.`name` AS `name`,`l`.`description` AS `description`,`GETNUMLANGUAGEQUESTIONSTODAY`(`l`.`id`) AS `questions_today`,`GETNUMLANGUAGEQUESTIONSWEEK`(`l`.`id`) AS `questions_week` from `language` `l`;

DROP EVENT IF EXISTS reduceReputationDaily;

CREATE DEFINER=`pconsulta`@`localhost` EVENT IF NOT EXISTS reduceReputationDaily
ON SCHEDULE EVERY 5 DAY_HOUR
COMMENT 'Reduce user\'s reputation every day'
DO
	CALL `db_proyecto_consulta`.`updatePlatformReputation`();
	CALL `db_proyecto_consulta`.`updateLanguageReputation`();
