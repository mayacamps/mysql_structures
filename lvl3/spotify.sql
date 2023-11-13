-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `spotify` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema universidad
-- -----------------------------------------------------
USE `spotify` ;

-- -----------------------------------------------------
-- Table `spotify`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`user` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(60) NOT NULL,
  `password` VARCHAR(20) NOT NULL,
  `username` VARCHAR(15) NOT NULL,
  `dob` DATE NOT NULL COMMENT 'date of birth',
  `sex` ENUM('m', 'f') NOT NULL COMMENT 'm - male, f - female',
  `country` VARCHAR(3) NOT NULL COMMENT '3 digit format following ISO 3166-1 alpha-3',
  `zipcode` VARCHAR(5) NOT NULL COMMENT '5 digit zipcode',
  `type` ENUM('free', 'premium') NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`paypal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`paypal` (
  `id` INT NOT NULL,
  `username` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`cc`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`cc` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `number` INT UNSIGNED NOT NULL,
  `expiry` DATE NOT NULL,
  `sec_code` INT(3) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`subscription`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`subscription` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `start_date` DATETIME NOT NULL,
  `renew_date` DATETIME NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `paypal_id` INT NOT NULL,
  `cc_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_subscription_user_idx` (`user_id` ASC) ,
  INDEX `fk_subscription_paypal1_idx` (`paypal_id` ASC) ,
  INDEX `fk_subscription_cc1_idx` (`cc_id` ASC) ,
  CONSTRAINT `fk_subscription_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `spotify`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_subscription_paypal1`
    FOREIGN KEY (`paypal_id`)
    REFERENCES `spotify`.`paypal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_subscription_cc1`
    FOREIGN KEY (`cc_id`)
    REFERENCES `spotify`.`cc` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`payment` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL,
  `order_num` INT NOT NULL,
  `total` DOUBLE NOT NULL,
  `subscription_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `order_num_UNIQUE` (`order_num` ASC) ,
  INDEX `fk_payment_subscription1_idx` (`subscription_id` ASC) ,
  CONSTRAINT `fk_payment_subscription1`
    FOREIGN KEY (`subscription_id`)
    REFERENCES `spotify`.`subscription` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlist` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100) NOT NULL,
  `song_quant` INT UNSIGNED NULL DEFAULT NULL COMMENT 'number of songs in playlist',
  `creation_date` DATETIME NOT NULL,
  `type` ENUM('shared', 'private') NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`artist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`artist` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `image` LONGBLOB NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`album`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`album` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100) NOT NULL,
  `year_pub` YEAR NOT NULL,
  `cover_im` LONGBLOB NULL DEFAULT NULL,
  `artist_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_album_artist1_idx` (`artist_id` ASC) ,
  CONSTRAINT `fk_album_artist1`
    FOREIGN KEY (`artist_id`)
    REFERENCES `spotify`.`artist` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`song`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`song` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100) NOT NULL,
  `duration` TIME NOT NULL,
  `reproductions` INT NULL DEFAULT 0,
  `album_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_song_album1_idx` (`album_id` ASC) ,
  CONSTRAINT `fk_song_album1`
    FOREIGN KEY (`album_id`)
    REFERENCES `spotify`.`album` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`song_added`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`song_added` (
  `playlist_id` INT UNSIGNED NOT NULL,
  `song_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`playlist_id`, `song_id`, `user_id`),
  INDEX `fk_playlist_has_song_song1_idx` (`song_id` ASC) ,
  INDEX `fk_playlist_has_song_playlist1_idx` (`playlist_id` ASC) ,
  INDEX `fk_song_added_user1_idx` (`user_id` ASC) ,
  CONSTRAINT `fk_playlist_has_song_playlist1`
    FOREIGN KEY (`playlist_id`)
    REFERENCES `spotify`.`playlist` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_playlist_has_song_song1`
    FOREIGN KEY (`song_id`)
    REFERENCES `spotify`.`song` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_song_added_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `spotify`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`user_follows_artist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`user_follows_artist` (
  `user_id` INT UNSIGNED NOT NULL,
  `artist_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`, `artist_id`),
  INDEX `fk_user_has_artist_artist1_idx` (`artist_id` ASC) ,
  INDEX `fk_user_has_artist_user1_idx` (`user_id` ASC) ,
  CONSTRAINT `fk_user_has_artist_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `spotify`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_artist_artist1`
    FOREIGN KEY (`artist_id`)
    REFERENCES `spotify`.`artist` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`similar_artists`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`similar_artists` (
  `artist_id` INT UNSIGNED NOT NULL,
  `artist_id1` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`artist_id`, `artist_id1`),
  INDEX `fk_artist_has_artist_artist2_idx` (`artist_id1` ASC) ,
  INDEX `fk_artist_has_artist_artist1_idx` (`artist_id` ASC) ,
  CONSTRAINT `fk_artist_has_artist_artist1`
    FOREIGN KEY (`artist_id`)
    REFERENCES `spotify`.`artist` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_artist_has_artist_artist2`
    FOREIGN KEY (`artist_id1`)
    REFERENCES `spotify`.`artist` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`user_fav_song`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`user_fav_song` (
  `user_id` INT UNSIGNED NOT NULL,
  `song_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`, `song_id`),
  INDEX `fk_user_has_song_song1_idx` (`song_id` ASC) ,
  INDEX `fk_user_has_song_user1_idx` (`user_id` ASC) ,
  CONSTRAINT `fk_user_has_song_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `spotify`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_song_song1`
    FOREIGN KEY (`song_id`)
    REFERENCES `spotify`.`song` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`user_fav_album`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`user_fav_album` (
  `user_id` INT UNSIGNED NOT NULL,
  `album_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`, `album_id`),
  INDEX `fk_user_has_album_user1_idx` (`user_id` ASC) ,
  INDEX `fk_user_fav_album_album1_idx` (`album_id` ASC) ,
  CONSTRAINT `fk_user_has_album_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `spotify`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_fav_album_album1`
    FOREIGN KEY (`album_id`)
    REFERENCES `spotify`.`album` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`user_has_playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`user_has_playlist` (
  `user_id` INT UNSIGNED NOT NULL,
  `playlist_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`, `playlist_id`),
  INDEX `fk_user_has_playlist_playlist1_idx` (`playlist_id` ASC) ,
  INDEX `fk_user_has_playlist_user1_idx` (`user_id` ASC) ,
  CONSTRAINT `fk_user_has_playlist_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `spotify`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_playlist_playlist1`
    FOREIGN KEY (`playlist_id`)
    REFERENCES `spotify`.`playlist` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`deleted_playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`deleted_playlist` (
  `playlist_id` INT UNSIGNED NOT NULL,
  `deleted_date` DATETIME NOT NULL,
  INDEX `fk_deleted_playlist_playlist1_idx` (`playlist_id` ASC) ,
  PRIMARY KEY (`playlist_id`),
  CONSTRAINT `fk_deleted_playlist_playlist1`
    FOREIGN KEY (`playlist_id`)
    REFERENCES `spotify`.`playlist` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
