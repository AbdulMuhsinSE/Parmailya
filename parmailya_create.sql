-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Parmailya
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Parmailya
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Parmailya` DEFAULT CHARACTER SET utf8 ;
USE `Parmailya` ;

-- -----------------------------------------------------
-- Table `Parmailya`.`Item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Item` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Item` (
  `idItem` INT(11) NOT NULL AUTO_INCREMENT,
  `Item_Name` VARCHAR(45) NULL DEFAULT NULL,
  `value` INT(10) UNSIGNED NULL DEFAULT NULL,
  `lvRestriction` INT(10) UNSIGNED NULL DEFAULT NULL,
  `Item_desc` VARCHAR(256) NULL DEFAULT NULL,
  `weight` INT(10) UNSIGNED NULL DEFAULT NULL,
  `type` ENUM('Treasure', 'Consumable', 'Armor', 'Weapon', 'Mount') NOT NULL,
  PRIMARY KEY (`idItem`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Armor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Armor` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Armor` (
  `Item_idItem` INT(11) NOT NULL,
  `AC` VARCHAR(45) NULL DEFAULT NULL,
  `min_STR` INT(11) NULL DEFAULT NULL,
  `stealth_disadvantage` TINYINT(4) NULL DEFAULT '0',
  PRIMARY KEY (`Item_idItem`),
  CONSTRAINT `fk_Armor_Item1`
    FOREIGN KEY (`Item_idItem`)
    REFERENCES `Parmailya`.`Item` (`idItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Background`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Background` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Background` (
  `idBackground` INT(11) NOT NULL,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `description` LONGTEXT NULL DEFAULT NULL,
  PRIMARY KEY (`idBackground`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Race`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Race` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Race` (
  `idRace` INT(11) NOT NULL,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `description` LONGTEXT NULL DEFAULT NULL,
  `size` INT(11) NULL DEFAULT NULL,
  `speed` INT(11) NULL DEFAULT NULL,
  `adulthood_age` INT(11) NULL DEFAULT NULL,
  `average_lifespan` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idRace`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Subrace`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Subrace` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Subrace` (
  `Race_idRace` INT(11) NOT NULL,
  `Subrace_id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `desc` LONGTEXT NULL DEFAULT NULL,
  PRIMARY KEY (`Subrace_id`, `Race_idRace`),
  INDEX `fk_Subrace_Race1` (`Race_idRace` ASC),
  CONSTRAINT `fk_Subrace_Race1`
    FOREIGN KEY (`Race_idRace`)
    REFERENCES `Parmailya`.`Race` (`idRace`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Character`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Character` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Character` (
  `idCharacter` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `XP` INT(10) UNSIGNED NULL DEFAULT '10',
  `STR` INT(10) UNSIGNED NULL DEFAULT '10',
  `DEX` INT(10) UNSIGNED NULL DEFAULT '10',
  `CON` INT(10) UNSIGNED NULL DEFAULT '10',
  `INTE` INT(10) UNSIGNED NULL DEFAULT '10',
  `WIS` INT(10) UNSIGNED NULL DEFAULT '10',
  `CHA` INT(10) UNSIGNED NULL DEFAULT '10',
  `MAXHP` INT(10) UNSIGNED NULL DEFAULT NULL,
  `Subrace_Subrace_id` INT(11) NOT NULL,
  `Subrace_Race_idRace` INT(11) NOT NULL,
  `Background_idBackground` INT(11) NOT NULL,
  `Money` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT 'Money conversion happens on frontend based on config files',
  PRIMARY KEY (`idCharacter`),
  INDEX `fk_Character_Subrace1_idx` (`Subrace_Subrace_id` ASC, `Subrace_Race_idRace` ASC),
  INDEX `NAME` (`name` ASC),
  INDEX `fk_Character_Background1_idx` (`Background_idBackground` ASC),
  CONSTRAINT `fk_Character_Background1`
    FOREIGN KEY (`Background_idBackground`)
    REFERENCES `Parmailya`.`Background` (`idBackground`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Character_Subrace1`
    FOREIGN KEY (`Subrace_Subrace_id` , `Subrace_Race_idRace`)
    REFERENCES `Parmailya`.`Subrace` (`Subrace_id` , `Race_idRace`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Spell_Attack`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Spell_Attack` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Spell_Attack` (
  `idSpell_Attack` INT(11) NOT NULL,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `description` LONGTEXT NULL DEFAULT NULL,
  `type` ENUM('Attack', 'Spell', 'Ritual', 'Cantrip') NULL DEFAULT NULL,
  `requiresConcentration` TINYINT(4) NULL DEFAULT NULL,
  `range` VARCHAR(45) NULL DEFAULT NULL,
  `area_of_effect` VARCHAR(45) NULL DEFAULT NULL,
  `dmg_die` VARCHAR(45) NULL DEFAULT NULL,
  `saving_throw_invoked` ENUM('STR', 'DEX', 'CON', 'INTE', 'WIS', 'CHA') NULL DEFAULT NULL,
  `school_of_magic` VARCHAR(45) NULL DEFAULT NULL,
  `classes` VARCHAR(240) NULL DEFAULT NULL COMMENT 'example -> classnameX:classnameY:classnameZ',
  PRIMARY KEY (`idSpell_Attack`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Character_Spell_Attack_List`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Character_Spell_Attack_List` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Character_Spell_Attack_List` (
  `Character_idCharacter` INT(11) NOT NULL,
  `Spell_idSpell_Attack` INT(11) NOT NULL,
  PRIMARY KEY (`Character_idCharacter`, `Spell_idSpell_Attack`),
  INDEX `fk_Character_has_Spell_Spell1_idx` (`Spell_idSpell_Attack` ASC),
  INDEX `fk_Character_has_Spell_Character1_idx` (`Character_idCharacter` ASC),
  CONSTRAINT `fk_Character_has_Spell_Character1`
    FOREIGN KEY (`Character_idCharacter`)
    REFERENCES `Parmailya`.`Character` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Character_has_Spell_Spell1`
    FOREIGN KEY (`Spell_idSpell_Attack`)
    REFERENCES `Parmailya`.`Spell_Attack` (`idSpell_Attack`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Class`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Class` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Class` (
  `idClass` INT(11) NOT NULL,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `description` VARCHAR(240) NULL DEFAULT NULL,
  `hit_die` VARCHAR(45) NULL DEFAULT NULL,
  `primary_ability` ENUM('STR', 'DEX', 'CON', 'INTE', 'WIS', 'CHA') NULL DEFAULT NULL,
  `primary_ability2` ENUM('STR', 'DEX', 'CON', 'INTE', 'WIS', 'CHA') NULL DEFAULT NULL,
  `saving_throw_prof` ENUM('STR', 'DEX', 'CON', 'INTE', 'WIS', 'CHA') NULL DEFAULT NULL,
  `saving_throw_prof2` ENUM('STR', 'DEX', 'CON', 'INTE', 'WIS', 'CHA') NULL DEFAULT NULL,
  `starting_equipment` LONGTEXT NULL DEFAULT NULL,
  PRIMARY KEY (`idClass`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Specialization`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Specialization` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Specialization` (
  `idPath` INT(11) NOT NULL,
  `Class_idClass` INT(11) NOT NULL,
  `Specialization_Desc` LONGTEXT NULL DEFAULT NULL,
  PRIMARY KEY (`idPath`, `Class_idClass`),
  INDEX `fk_Path_Class1_idx` (`Class_idClass` ASC),
  CONSTRAINT `fk_Path_Class1`
    FOREIGN KEY (`Class_idClass`)
    REFERENCES `Parmailya`.`Class` (`idClass`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Character_has_Class`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Character_has_Class` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Character_has_Class` (
  `Character_idCharacter` INT(11) NOT NULL,
  `classLevel` INT(11) NULL DEFAULT '1',
  `Specialization_idPath` INT(11) NOT NULL,
  `Specialization_Class_idClass` INT(11) NOT NULL,
  PRIMARY KEY (`Character_idCharacter`, `Specialization_idPath`, `Specialization_Class_idClass`),
  INDEX `fk_Character_has_Class_Character1_idx` (`Character_idCharacter` ASC),
  INDEX `fk_Character_has_Class_Specialization1_idx` (`Specialization_idPath` ASC, `Specialization_Class_idClass` ASC),
  CONSTRAINT `fk_Character_has_Class_Character1`
    FOREIGN KEY (`Character_idCharacter`)
    REFERENCES `Parmailya`.`Character` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Character_has_Class_Specialization1`
    FOREIGN KEY (`Specialization_idPath` , `Specialization_Class_idClass`)
    REFERENCES `Parmailya`.`Specialization` (`idPath` , `Class_idClass`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Character_has_Item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Character_has_Item` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Character_has_Item` (
  `Character_idCharacter` INT(11) NOT NULL,
  `Item_idItem` INT(11) NOT NULL,
  PRIMARY KEY (`Character_idCharacter`, `Item_idItem`),
  INDEX `fk_Character_has_Item_Item1_idx` (`Item_idItem` ASC),
  INDEX `fk_Character_has_Item_Character1_idx` (`Character_idCharacter` ASC),
  CONSTRAINT `fk_Character_has_Item_Character1`
    FOREIGN KEY (`Character_idCharacter`)
    REFERENCES `Parmailya`.`Character` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Character_has_Item_Item1`
    FOREIGN KEY (`Item_idItem`)
    REFERENCES `Parmailya`.`Item` (`idItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Item_Class`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Item_Class` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Item_Class` (
  `idItem_Class` INT(11) NOT NULL,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `desc` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idItem_Class`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Character_has_Item_Class_Proficency`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Character_has_Item_Class_Proficency` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Character_has_Item_Class_Proficency` (
  `Character_idCharacter` INT(11) NOT NULL,
  `Item_Class_idItem_Class` INT(11) NOT NULL,
  PRIMARY KEY (`Character_idCharacter`, `Item_Class_idItem_Class`),
  INDEX `fk_Character_has_Item_Class_Item_Class1_idx` (`Item_Class_idItem_Class` ASC),
  INDEX `fk_Character_has_Item_Class_Character1_idx` (`Character_idCharacter` ASC),
  CONSTRAINT `fk_Character_has_Item_Class_Character1`
    FOREIGN KEY (`Character_idCharacter`)
    REFERENCES `Parmailya`.`Character` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Character_has_Item_Class_Item_Class1`
    FOREIGN KEY (`Item_Class_idItem_Class`)
    REFERENCES `Parmailya`.`Item_Class` (`idItem_Class`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Language`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Language` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Language` (
  `idLanguage` INT(11) NOT NULL,
  `lang_name` VARCHAR(45) NULL DEFAULT NULL,
  `lang_desc` LONGTEXT NULL DEFAULT NULL,
  PRIMARY KEY (`idLanguage`),
  INDEX `NAME` (`lang_name` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Character_has_Language`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Character_has_Language` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Character_has_Language` (
  `Character_idCharacter` INT(11) NOT NULL,
  `Character_Race_idRace` INT(11) NOT NULL,
  `Language_idLanguage` INT(11) NOT NULL,
  `Speaks` TINYINT(4) NULL DEFAULT NULL,
  `Reads` TINYINT(4) NULL DEFAULT NULL,
  `Writes` TINYINT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`Character_idCharacter`, `Character_Race_idRace`, `Language_idLanguage`),
  INDEX `fk_Character_has_Language_Language1_idx` (`Language_idLanguage` ASC),
  INDEX `fk_Character_has_Language_Character1_idx` (`Character_idCharacter` ASC, `Character_Race_idRace` ASC),
  CONSTRAINT `fk_Character_has_Language_Character1`
    FOREIGN KEY (`Character_idCharacter`)
    REFERENCES `Parmailya`.`Character` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Character_has_Language_Language1`
    FOREIGN KEY (`Language_idLanguage`)
    REFERENCES `Parmailya`.`Language` (`idLanguage`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Class_has_Item_Class_Proficency`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Class_has_Item_Class_Proficency` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Class_has_Item_Class_Proficency` (
  `Class_idClass` INT(11) NOT NULL,
  `Item_Class_idItem_Class` INT(11) NOT NULL,
  PRIMARY KEY (`Class_idClass`, `Item_Class_idItem_Class`),
  INDEX `fk_Class_has_Item_Class_Item_Class1_idx` (`Item_Class_idItem_Class` ASC),
  INDEX `fk_Class_has_Item_Class_Class1_idx` (`Class_idClass` ASC),
  CONSTRAINT `fk_Class_has_Item_Class_Class1`
    FOREIGN KEY (`Class_idClass`)
    REFERENCES `Parmailya`.`Class` (`idClass`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Class_has_Item_Class_Item_Class1`
    FOREIGN KEY (`Item_Class_idItem_Class`)
    REFERENCES `Parmailya`.`Item_Class` (`idItem_Class`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`GAME_BACKUP`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`GAME_BACKUP` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`GAME_BACKUP` (
  `old_idGame` INT(11) NOT NULL,
  `old_name` VARCHAR(256) NOT NULL,
  `old_User_email` VARCHAR(45) NOT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Game`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Game` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Game` (
  `idGame` INT(11) NOT NULL,
  `name` VARCHAR(256) NULL DEFAULT NULL,
  `description` LONGTEXT NULL DEFAULT NULL,
  `game_icon_loc` VARCHAR(512) NULL DEFAULT NULL,
  `User_email_DM` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idGame`, `User_email_DM`),
  INDEX `fk_Game_User1_idx` (`User_email_DM` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Game_has_Character`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Game_has_Character` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Game_has_Character` (
  `Game_idGame` INT(11) NOT NULL,
  `Game_User_email_DM` VARCHAR(45) NOT NULL,
  `Character_idCharacter` INT(11) NOT NULL,
  `isPlayableCharacter` TINYINT(4) NULL DEFAULT '1' COMMENT 'Indicates whether the character is an NPC.',
  PRIMARY KEY (`Game_idGame`, `Game_User_email_DM`, `Character_idCharacter`),
  INDEX `fk_Game_has_Character_Character1_idx` (`Character_idCharacter` ASC),
  INDEX `fk_Game_has_Character_Game1_idx` (`Game_idGame` ASC, `Game_User_email_DM` ASC),
  CONSTRAINT `fk_Game_has_Character_Character1`
    FOREIGN KEY (`Character_idCharacter`)
    REFERENCES `Parmailya`.`Character` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Game_has_Character_Game1`
    FOREIGN KEY (`Game_idGame` , `Game_User_email_DM`)
    REFERENCES `Parmailya`.`Game` (`idGame` , `User_email_DM`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Mount`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Mount` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Mount` (
  `Item_idItem` INT(11) NOT NULL,
  `isFlying` TINYINT(4) NULL DEFAULT '0',
  `isSwimming` TINYINT(4) NULL DEFAULT '0',
  `SpeedArray` VARCHAR(45) NULL DEFAULT NULL COMMENT 'Goes as follows:\nlandspeed,flightspeed,swimmingspeed',
  PRIMARY KEY (`Item_idItem`),
  CONSTRAINT `fk_Mount_Item1`
    FOREIGN KEY (`Item_idItem`)
    REFERENCES `Parmailya`.`Item` (`idItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Race_has_Language`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Race_has_Language` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Race_has_Language` (
  `Race_idRace` INT(11) NOT NULL,
  `Language_idLanguage` INT(11) NOT NULL,
  PRIMARY KEY (`Race_idRace`, `Language_idLanguage`),
  INDEX `fk_Race_has_Language_Language1_idx` (`Language_idLanguage` ASC),
  INDEX `fk_Race_has_Language_Race1_idx` (`Race_idRace` ASC),
  CONSTRAINT `fk_Race_has_Language_Language1`
    FOREIGN KEY (`Language_idLanguage`)
    REFERENCES `Parmailya`.`Language` (`idLanguage`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Race_has_Language_Race1`
    FOREIGN KEY (`Race_idRace`)
    REFERENCES `Parmailya`.`Race` (`idRace`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Special_Trait`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Special_Trait` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Special_Trait` (
  `idSpecial_Traits` INT(11) NOT NULL,
  `AbilityScoreMod` VARCHAR(4) NULL DEFAULT NULL COMMENT 'Takes values in the following manner:\nX:Y\nWhere x is a value between 1 and 6 inclusive, and indicates\none of the Abilty Scores\nY indicates the modification and can be positive or negative',
  `Other` VARCHAR(512) NULL DEFAULT NULL COMMENT 'This is a catch all for any traits that don\'t fall within the previous two categories.\nThis shall allow for flexibility but will also produce the need of fine tuning by the DM/Player.',
  `name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idSpecial_Traits`),
  INDEX `NAME` (`name` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Specialization_has_Special_Trait`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Specialization_has_Special_Trait` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Specialization_has_Special_Trait` (
  `Specialization_idPath` INT(11) NOT NULL,
  `Specialization_Class_idClass` INT(11) NOT NULL,
  `Special_Trait_idSpecial_Traits` INT(11) NOT NULL,
  PRIMARY KEY (`Specialization_idPath`, `Specialization_Class_idClass`, `Special_Trait_idSpecial_Traits`),
  INDEX `fk_Specialization_has_Special_Trait_Special_Trait1_idx` (`Special_Trait_idSpecial_Traits` ASC),
  INDEX `fk_Specialization_has_Special_Trait_Specialization1_idx` (`Specialization_idPath` ASC, `Specialization_Class_idClass` ASC),
  CONSTRAINT `fk_Specialization_has_Special_Trait_Special_Trait1`
    FOREIGN KEY (`Special_Trait_idSpecial_Traits`)
    REFERENCES `Parmailya`.`Special_Trait` (`idSpecial_Traits`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Specialization_has_Special_Trait_Specialization1`
    FOREIGN KEY (`Specialization_idPath` , `Specialization_Class_idClass`)
    REFERENCES `Parmailya`.`Specialization` (`idPath` , `Class_idClass`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Subrace_has_Special_Trait`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Subrace_has_Special_Trait` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Subrace_has_Special_Trait` (
  `Subrace_Subrace_id` INT(11) NOT NULL,
  `Subrace_Race_idRace` INT(11) NOT NULL,
  `Special_Trait_idSpecial_Traits` INT(11) NOT NULL,
  PRIMARY KEY (`Subrace_Subrace_id`, `Subrace_Race_idRace`, `Special_Trait_idSpecial_Traits`),
  INDEX `fk_Subrace_has_Special_Trait_Special_Trait1_idx` (`Special_Trait_idSpecial_Traits` ASC),
  INDEX `fk_Subrace_has_Special_Trait_Subrace1_idx` (`Subrace_Subrace_id` ASC, `Subrace_Race_idRace` ASC),
  CONSTRAINT `fk_Subrace_has_Special_Trait_Special_Trait1`
    FOREIGN KEY (`Special_Trait_idSpecial_Traits`)
    REFERENCES `Parmailya`.`Special_Trait` (`idSpecial_Traits`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Subrace_has_Special_Trait_Subrace1`
    FOREIGN KEY (`Subrace_Subrace_id` , `Subrace_Race_idRace`)
    REFERENCES `Parmailya`.`Subrace` (`Subrace_id` , `Race_idRace`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`User`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`User` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`User` (
  `username` VARCHAR(45) NOT NULL,
  `password_hash` VARCHAR(512) NULL DEFAULT NULL,
  `salt` VARCHAR(256) NULL DEFAULT NULL,
  `email` VARCHAR(45) NOT NULL,
  `DCI_Number` VARCHAR(45) NULL DEFAULT NULL COMMENT 'Wizards of the Coast Official Number',
  PRIMARY KEY (`email`),
  INDEX `UNAME` (`username` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`User_has_Character`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`User_has_Character` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`User_has_Character` (
  `User_email` VARCHAR(45) NOT NULL,
  `Character_idCharacter` INT(11) NOT NULL,
  PRIMARY KEY (`User_email`, `Character_idCharacter`),
  INDEX `fk_User_has_Character_Character1_idx` (`Character_idCharacter` ASC),
  INDEX `fk_User_has_Character_User_idx` (`User_email` ASC),
  CONSTRAINT `fk_User_has_Character_Character1`
    FOREIGN KEY (`Character_idCharacter`)
    REFERENCES `Parmailya`.`Character` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_User_has_Character_User`
    FOREIGN KEY (`User_email`)
    REFERENCES `Parmailya`.`User` (`email`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Parmailya`.`Weapon`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parmailya`.`Weapon` ;

CREATE TABLE IF NOT EXISTS `Parmailya`.`Weapon` (
  `Item_idItem` INT(11) NOT NULL,
  `dmg_die` VARCHAR(45) NULL DEFAULT NULL,
  `class_restriction` VARCHAR(45) NULL DEFAULT NULL,
  `min_stat_array` VARCHAR(45) NULL DEFAULT NULL,
  `damage_type` VARCHAR(45) NULL DEFAULT NULL,
  `properties` VARCHAR(256) NULL DEFAULT NULL,
  `range` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`Item_idItem`),
  INDEX `fk_Weapon_Item1_idx` (`Item_idItem` ASC),
  CONSTRAINT `fk_Weapon_Item1`
    FOREIGN KEY (`Item_idItem`)
    REFERENCES `Parmailya`.`Item` (`idItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

USE `Parmailya` ;

-- -----------------------------------------------------
-- procedure create_game_no_image
-- -----------------------------------------------------

USE `Parmailya`;
DROP procedure IF EXISTS `Parmailya`.`create_game_no_image`;

DELIMITER $$
USE `Parmailya`$$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `create_game_no_image`(IN `uemail` VARCHAR(45), IN `gName` VARCHAR(256), IN `description` LONGTEXT, IN `game_id` INT(11))
    MODIFIES SQL DATA
REPLACE INTO Game (idGame, name, description, User_email_DM) 
VALUES (game_id,gName,description,uemail)$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_game
-- -----------------------------------------------------

USE `Parmailya`;
DROP procedure IF EXISTS `Parmailya`.`delete_game`;

DELIMITER $$
USE `Parmailya`$$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `delete_game`(IN `gameid` INT)
    MODIFIES SQL DATA
DELETE FROM Game WHERE Game.idGame = gameid$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure get_games
-- -----------------------------------------------------

USE `Parmailya`;
DROP procedure IF EXISTS `Parmailya`.`get_games`;

DELIMITER $$
USE `Parmailya`$$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `get_games`(IN `uemail` VARCHAR(45))
    READS SQL DATA
SELECT Game.idGame, Game.name, Game.description, User.username, User.email FROM Game INNER JOIN User on Game.User_email_DM = User.email WHERE User.email = uemail$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure get_user_info
-- -----------------------------------------------------

USE `Parmailya`;
DROP procedure IF EXISTS `Parmailya`.`get_user_info`;

DELIMITER $$
USE `Parmailya`$$
CREATE DEFINER=`phpmyadmin`@`localhost` PROCEDURE `get_user_info`(IN `email` VARCHAR(45), IN `pass` VARCHAR(512))
    READS SQL DATA
SELECT User.username, User.email, User.DCI_Number FROM User where User.email = email AND User.password_hash = password(pass)$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `Parmailya`;

DELIMITER $$

USE `Parmailya`$$
DROP TRIGGER IF EXISTS `Parmailya`.`game_delete_trigger` $$
USE `Parmailya`$$
CREATE
DEFINER=`phpmyadmin`@`localhost`
TRIGGER `Parmailya`.`game_delete_trigger`
BEFORE DELETE ON `Parmailya`.`Game`
FOR EACH ROW
INSERT INTO GANE_BACKUP VALUES (OLD.idGame,OLD.name,OLD.User_email_DM)$$


USE `Parmailya`$$
DROP TRIGGER IF EXISTS `Parmailya`.`user_create` $$
USE `Parmailya`$$
CREATE
DEFINER=`phpmyadmin`@`localhost`
TRIGGER `Parmailya`.`user_create`
BEFORE INSERT ON `Parmailya`.`User`
FOR EACH ROW
BEGIN
SET NEW.salt = "N/A";
SET NEW.password_hash = password(NEW.password_hash);
END$$


DELIMITER ;
