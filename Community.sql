-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema community
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `community` ;

-- -----------------------------------------------------
-- Schema community
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `community` DEFAULT CHARACTER SET latin1 COLLATE latin1_spanish_ci ;
USE `community` ;

-- -----------------------------------------------------
-- Table `community`.`torres`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `community`.`torres` ;

CREATE TABLE IF NOT EXISTS `community`.`torres` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `numero` VARCHAR(4) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UQ_id` (`id` ASC) VISIBLE,
  UNIQUE INDEX `UQ_numero` (`numero` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_spanish_ci;


-- -----------------------------------------------------
-- Table `community`.`usuarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `community`.`usuarios` ;

CREATE TABLE IF NOT EXISTS `community`.`usuarios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `telefono` VARCHAR(15) NOT NULL,
  `email` VARCHAR(60) NOT NULL,
  `password` VARCHAR(256) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `tipo` ENUM('residente', 'vigilante', 'admin', 'otro') NOT NULL DEFAULT 'otro',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UQ_id` (`id` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_spanish_ci
COMMENT = 'Usuarios Conjunto';


-- -----------------------------------------------------
-- Table `community`.`apartamentos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `community`.`apartamentos` ;

CREATE TABLE IF NOT EXISTS `community`.`apartamentos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `numero` VARCHAR(4) NOT NULL,
  `id_torre` INT NOT NULL,
  `id_propietario` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UQ_id` (`id` ASC) VISIBLE,
  INDEX `FK_torres_TO_apartamentos` (`id_torre` ASC) VISIBLE,
  INDEX `FK_usuarios_TO_apartamentos` (`id_propietario` ASC) VISIBLE,
  CONSTRAINT `FK_torres_TO_apartamentos`
    FOREIGN KEY (`id_torre`)
    REFERENCES `community`.`torres` (`id`),
  CONSTRAINT `FK_usuarios_TO_apartamentos`
    FOREIGN KEY (`id_propietario`)
    REFERENCES `community`.`usuarios` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_spanish_ci;


-- -----------------------------------------------------
-- Table `community`.`areas_comunes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `community`.`areas_comunes` ;

CREATE TABLE IF NOT EXISTS `community`.`areas_comunes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NOT NULL,
  `estado` BOOL NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UQ_id` (`id` ASC) VISIBLE,
  UNIQUE INDEX `UQ_nombre` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_spanish_ci;


-- -----------------------------------------------------
-- Table `community`.`mascotas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `community`.`mascotas` ;

CREATE TABLE IF NOT EXISTS `community`.`mascotas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `tipo` VARCHAR(45) NOT NULL,
  `id_apartamento` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UQ_id` (`id` ASC) VISIBLE,
  INDEX `FK_apartamentos_TO_mascotas` (`id_apartamento` ASC) VISIBLE,
  CONSTRAINT `FK_apartamentos_TO_mascotas`
    FOREIGN KEY (`id_apartamento`)
    REFERENCES `community`.`apartamentos` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_spanish_ci;


-- -----------------------------------------------------
-- Table `community`.`pagos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `community`.`pagos` ;

CREATE TABLE IF NOT EXISTS `community`.`pagos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `valor` DECIMAL(10,2) NOT NULL,
  `concepto` VARCHAR(45) NOT NULL,
  `id_usuario` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UQ_id` (`id` ASC) VISIBLE,
  INDEX `id_usuario_idx` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `id_usuario`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `community`.`usuarios` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_spanish_ci;


-- -----------------------------------------------------
-- Table `community`.`pqr`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `community`.`pqr` ;

CREATE TABLE IF NOT EXISTS `community`.`pqr` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `asunto` VARCHAR(64) NOT NULL,
  `texto` TEXT NULL DEFAULT NULL,
  `fecha` DATETIME NOT NULL,
  `estado` ENUM('pendiente', 'resuelto') NOT NULL DEFAULT 'pendiente',
  `id_usuario` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UQ_id` (`id` ASC) VISIBLE,
  INDEX `FK_usuarios_TO_pqr` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `FK_usuarios_TO_pqr`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `community`.`usuarios` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_spanish_ci
COMMENT = 'Peticiones, Quejas y Reclamos';


-- -----------------------------------------------------
-- Table `community`.`reservas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `community`.`reservas` ;

CREATE TABLE IF NOT EXISTS `community`.`reservas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `finicio` DATETIME NOT NULL,
  `ffinal` DATETIME NOT NULL,
  `id_area` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UQ_id` (`id` ASC) VISIBLE,
  INDEX `FK_areas_comunes_TO_reservas` (`id_area` ASC) VISIBLE,
  INDEX `FK_usuarios_TO_reservas` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `FK_areas_comunes_TO_reservas`
    FOREIGN KEY (`id_area`)
    REFERENCES `community`.`areas_comunes` (`id`),
  CONSTRAINT `FK_usuarios_TO_reservas`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `community`.`usuarios` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_spanish_ci;


-- -----------------------------------------------------
-- Table `community`.`residentes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `community`.`residentes` ;

CREATE TABLE IF NOT EXISTS `community`.`residentes` (
  `id_usuario` INT NOT NULL,
  `id_apartamento` INT NOT NULL,
  PRIMARY KEY (`id_usuario`, `id_apartamento`),
  INDEX `FK_apartamentos_TO_residentes` (`id_apartamento` ASC) VISIBLE,
  CONSTRAINT `FK_apartamentos_TO_residentes`
    FOREIGN KEY (`id_apartamento`)
    REFERENCES `community`.`apartamentos` (`id`),
  CONSTRAINT `FK_usuarios_TO_residentes`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `community`.`usuarios` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_spanish_ci;


-- -----------------------------------------------------
-- Table `community`.`visitantes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `community`.`visitantes` ;

CREATE TABLE IF NOT EXISTS `community`.`visitantes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `fentrada` DATETIME NOT NULL,
  `fsalida` DATETIME NULL DEFAULT NULL,
  `telefono` VARCHAR(10) NOT NULL,
  `documento` VARCHAR(11) NOT NULL,
  `id_apartamento` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UQ_id` (`id` ASC) VISIBLE,
  INDEX `FK_apartamentos_TO_visitantes` (`id_apartamento` ASC) VISIBLE,
  CONSTRAINT `FK_apartamentos_TO_visitantes`
    FOREIGN KEY (`id_apartamento`)
    REFERENCES `community`.`apartamentos` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_spanish_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

DROP TRIGGER IF EXISTS `community`.`reservas_AFTER_INSERT`;

DELIMITER $$
USE `community`$$
CREATE DEFINER = CURRENT_USER TRIGGER `community`.`reservas_AFTER_INSERT` AFTER INSERT ON `reservas` FOR EACH ROW
BEGIN
    if (SELECT estado FROM  `community`.`areas_comunes` where (id = new.id_area)) = FALSE then
		UPDATE areas_comunes set estado=TRUE where id = new.id_area;
	else
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Area Ya en reserva Activa';
	end if;
END$$
DELIMITER ;

