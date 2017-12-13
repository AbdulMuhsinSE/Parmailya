DELIMITER $$
CREATE TRIGGER `user_create` BEFORE INSERT ON `User`
 FOR EACH ROW BEGIN
SET NEW.salt = "N/A";
SET NEW.password_hash = password(NEW.password_hash);
END$$
DELIMITER;

DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `get_games`(IN `uemail` INT(45))
    READS SQL DATA
SELECT Game.idGame, Game.name, Game.description, User.username FROM Game INNER JOIN User on Game.User_email_DM = User.email WHERE User.email = uemail$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `get_user_info`(IN `email` VARCHAR(45), IN `pass` VARCHAR(512))
    READS SQL DATA
SELECT User.username, User.email, User.DCI_Number FROM User where User.email = email AND User.password_hash = password(pass)$$
DELIMITER ;
