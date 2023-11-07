-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema universidad
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema optica
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pizzeria` DEFAULT CHARACTER SET utf8 ;
USE `pizzeria` ;

-- -----------------------------------------------------
-- Table `pizzeria`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`category` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `name` (`name` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pizzeria`.`province`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`province` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `name` (`name` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pizzeria`.`locality`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`locality` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `province_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `province_id`),
  INDEX `fk_locality_province1_idx` (`province_id` ASC) ,
  CONSTRAINT `fk_locality_province1`
    FOREIGN KEY (`province_id`)
    REFERENCES `pizzeria`.`province` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pizzeria`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`customer` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  `surname1` VARCHAR(30) NOT NULL,
  `surname2` VARCHAR(30) NOT NULL,
  `address` VARCHAR(200) NOT NULL,
  `postal_code` INT(5) NOT NULL COMMENT '5 digit postal code',
  `phone` VARCHAR(15) NOT NULL COMMENT 'following E.164: maximum 15 digits for international phone numbers.',
  `locatity_id` INT UNSIGNED NOT NULL,
  `province_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `locatity_id` (`locatity_id` ASC, `province_id` ASC) ,
  INDEX `name` (`name` ASC) ,
  INDEX `province_id` (`province_id` ASC) ,
  CONSTRAINT `fk_customer_location1`
    FOREIGN KEY (`locatity_id`)
    REFERENCES `pizzeria`.`locality` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pizzeria`.`store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`store` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(200) NOT NULL,
  `postal_code` INT(5) UNSIGNED NOT NULL COMMENT '5 digit postal code\\n',
  `locatity_id` INT UNSIGNED NOT NULL,
  `province_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `locatity_id` (`locatity_id` ASC, `province_id` ASC) ,
  CONSTRAINT `fk_store_location1`
    FOREIGN KEY (`locatity_id`)
    REFERENCES `pizzeria`.`locality` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pizzeria`.`employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`employee` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(20) NOT NULL,
  `surname1` VARCHAR(30) NOT NULL,
  `surname2` VARCHAR(30) NOT NULL,
  `nif` VARCHAR(9) NOT NULL,
  `phone` INT(15) UNSIGNED NOT NULL COMMENT 'following E.164: maximum 15 digits for international phone numbers.',
  `type` ENUM('cook', 'delivery') NOT NULL,
  `store_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `nif_UNIQUE` (`nif` ASC) ,
  INDEX `store_id` (`store_id` ASC) ,
  CONSTRAINT `fk_employee_store1`
    FOREIGN KEY (`store_id`)
    REFERENCES `pizzeria`.`store` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pizzeria`.`home_delivery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`home_delivery` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `date_time` DATETIME NOT NULL,
  `employee_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `employee_id` (`employee_id` ASC) ,
  CONSTRAINT `fk_home_delivery_employee1`
    FOREIGN KEY (`employee_id`)
    REFERENCES `pizzeria`.`employee` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pizzeria`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`order` (
  `id` INT UNSIGNED NOT NULL,
  `date_time` DATETIME NOT NULL,
  `home_or_pickup` ENUM('home', 'pick_up') NOT NULL,
  `product_quant` INT UNSIGNED NOT NULL,
  `price` DOUBLE UNSIGNED NOT NULL,
  `customer_id` INT UNSIGNED NOT NULL,
  `store_id` INT UNSIGNED NOT NULL,
  `home_delivery_id` INT UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `customer_id` (`customer_id` ASC) ,
  INDEX `store_id` (`store_id` ASC) ,
  INDEX `home_delivery_id` (`home_delivery_id` ASC) ,
  CONSTRAINT `fk_order_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `pizzeria`.`customer` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_order_home_delivery1`
    FOREIGN KEY (`home_delivery_id`)
    REFERENCES `pizzeria`.`home_delivery` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_order_store1`
    FOREIGN KEY (`store_id`)
    REFERENCES `pizzeria`.`store` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pizzeria`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`product` (
  `id` INT UNSIGNED NOT NULL,
  `name_prod` ENUM('pizza', 'hamburger', 'drink') NOT NULL,
  `description` VARCHAR(200) NOT NULL,
  `image` LONGBLOB NULL DEFAULT NULL,
  `price` DOUBLE UNSIGNED NOT NULL,
  `id_category` INT UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `category_id` (`id_category` ASC) ,
  INDEX `name` (`name_prod` ASC) ,
  CONSTRAINT `fk_product_category1`
    FOREIGN KEY (`id_category`)
    REFERENCES `pizzeria`.`category` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `pizzeria`.`order_has_product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`order_has_product` (
  `order_id_order` INT UNSIGNED NOT NULL,
  `product_id_product` INT UNSIGNED NOT NULL,
  `quantity` INT UNSIGNED NOT NULL COMMENT 'quantity of each product',
  PRIMARY KEY (`order_id_order`, `product_id_product`),
  INDEX `product_id` (`product_id_product` ASC) ,
  INDEX `order_id` (`order_id_order` ASC) ,
  CONSTRAINT `fk_order_has_product_order1`
    FOREIGN KEY (`order_id_order`)
    REFERENCES `pizzeria`.`order` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_order_has_product_product1`
    FOREIGN KEY (`product_id_product`)
    REFERENCES `pizzeria`.`product` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
