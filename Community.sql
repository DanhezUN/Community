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
  UNIQUE INDEX `UQ_id` (`id` ASC) VISIBLE,
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
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
  `estado` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `UQ_id` (`id` ASC) VISIBLE,
  UNIQUE INDEX `UQ_nombre` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_spanish_ci;


-- -----------------------------------------------------
-- Table `community`.`auditoria`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `community`.`auditoria` ;

CREATE TABLE IF NOT EXISTS `community`.`auditoria` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `registro` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
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
AUTO_INCREMENT = 3
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

USE `community` ;

-- -----------------------------------------------------
-- procedure add_residente
-- -----------------------------------------------------

USE `community`;
DROP procedure IF EXISTS `community`.`add_residente`;

DELIMITER $$
USE `community`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_residente`(in username varchar(45), in numtorre varchar(4), in numapto varchar(4))
BEGIN
	declare aptoid int;
    declare torreid int;
    declare userid int;
    
    select id into userid from community.usuarios where username = username;
    select id into torreid from community.torres where numero = numtorre;
    select id into aptoid from community.apartamentos where (numero = numapto and id_torre = torreid);
    if (select tipo from community.usuarios where id = userid) = ('residente' or 'admin')  then
		insert into community.residentes values (aptoid, userid);
	else
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario no valido como residente';
	end if;
END$$

DELIMITER ;
USE `community`;

DELIMITER $$

USE `community`$$
DROP TRIGGER IF EXISTS `community`.`usuarios_AFTER_DELETE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`usuarios_AFTER_DELETE`
AFTER DELETE ON `community`.`usuarios`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Usuario ", old.username, " Eliminado"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`usuarios_AFTER_INSERT` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`usuarios_AFTER_INSERT`
AFTER INSERT ON `community`.`usuarios`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Usuario ", new.username, " Registrado"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`usuarios_AFTER_UPDATE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`usuarios_AFTER_UPDATE`
AFTER UPDATE ON `community`.`usuarios`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Usuario ", new.username, " Actualizado"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`apartamentos_AFTER_DELETE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`apartamentos_AFTER_DELETE`
AFTER DELETE ON `community`.`apartamentos`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Apartamento ", old.numero, " Eliminado"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`apartamentos_AFTER_INSERT` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`apartamentos_AFTER_INSERT`
AFTER INSERT ON `community`.`apartamentos`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Apartamento ", new.numero, " Registrado"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`apartamentos_AFTER_UPDATE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`apartamentos_AFTER_UPDATE`
AFTER UPDATE ON `community`.`apartamentos`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Apartamento ", new.numero, " Actualizado"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`areas_comunes_AFTER_DELETE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`areas_comunes_AFTER_DELETE`
AFTER DELETE ON `community`.`areas_comunes`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Area Común ", old.nombre, " Eliminada"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`areas_comunes_AFTER_INSERT` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`areas_comunes_AFTER_INSERT`
AFTER INSERT ON `community`.`areas_comunes`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Area Común ", new.nombre, " Registrada"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`areas_comunes_AFTER_UPDATE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`areas_comunes_AFTER_UPDATE`
AFTER UPDATE ON `community`.`areas_comunes`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Area Común ", new.nombre, " Actualizada"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`mascotas_AFTER_DELETE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`mascotas_AFTER_DELETE`
AFTER DELETE ON `community`.`mascotas`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Mascota ", old.nombre, " Eliminada"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`mascotas_AFTER_INSERT` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`mascotas_AFTER_INSERT`
AFTER INSERT ON `community`.`mascotas`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Mascota ", new.nombre, " Registrada"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`mascotas_AFTER_UPDATE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`mascotas_AFTER_UPDATE`
AFTER UPDATE ON `community`.`mascotas`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Mascota ", new.nombre, " Actualizada"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`pagos_AFTER_DELETE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`pagos_AFTER_DELETE`
AFTER DELETE ON `community`.`pagos`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Pago por", old.concepto, " con ID_Usuario: ", old.id_usuario, " Eliminado"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`pagos_AFTER_INSERT` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`pagos_AFTER_INSERT`
AFTER INSERT ON `community`.`pagos`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Pago por", new.concepto, " con ID_Usuario: ", new.id_usuario, " Registrado"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`pagos_AFTER_UPDATE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`pagos_AFTER_UPDATE`
AFTER UPDATE ON `community`.`pagos`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Pago por", new.concepto, " con ID_Usuario: ", new.id_usuario, " Actualizado"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`pqr_AFTER_DELETE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`pqr_AFTER_DELETE`
AFTER DELETE ON `community`.`pqr`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("PQR ", old.asunto, " Eliminado"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`pqr_AFTER_INSERT` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`pqr_AFTER_INSERT`
AFTER INSERT ON `community`.`pqr`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("PQR ", new.asunto, " Registrado"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`pqr_AFTER_UPDATE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`pqr_AFTER_UPDATE`
AFTER UPDATE ON `community`.`pqr`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("PQR ", new.asunto, " Actualizado"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`reservas_AFTER_DELETE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`reservas_AFTER_DELETE`
AFTER DELETE ON `community`.`reservas`
FOR EACH ROW
BEGIN
	declare area varchar(255);
    select nombre into area from community.areas_comunes where id = old.id_area;
	insert into community.auditoria (registro) values (concat("Reserva ", area, " Eliminada"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`reservas_AFTER_INSERT` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`reservas_AFTER_INSERT`
AFTER INSERT ON `community`.`reservas`
FOR EACH ROW
BEGIN
  declare area varchar(255);
  if (SELECT estado FROM  `community`.`areas_comunes` where (id = new.id_area)) = FALSE then
		UPDATE areas_comunes set estado=TRUE where id = new.id_area;

		select nombre into area from community.areas_comunes where id = new.id_area;
		insert into community.auditoria (registro) values (concat("Reserva ", area, " Registrada"));
	else
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Area ya en reserva Activa';
	end if;
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`reservas_AFTER_UPDATE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`reservas_AFTER_UPDATE`
AFTER UPDATE ON `community`.`reservas`
FOR EACH ROW
BEGIN
	declare area varchar(255);
    select nombre into area from community.areas_comunes where id = new.id_area;
	insert into community.auditoria (registro) values (concat("Reserva ", area, " Actualizada"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`residentes_AFTER_DELETE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`residentes_AFTER_DELETE`
AFTER DELETE ON `community`.`residentes`
FOR EACH ROW
BEGIN
	declare usuario varchar(100);
    select nombre into usuario from community.usuarios where id = old.id_usuario;
	insert into community.auditoria (registro) values (concat("Usuario ", usuario, " Eliminado como Residente"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`residentes_AFTER_INSERT` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`residentes_AFTER_INSERT`
AFTER INSERT ON `community`.`residentes`
FOR EACH ROW
BEGIN
	declare usuario varchar(100);
    select nombre into usuario from community.usuarios where id = new.id_usuario;
	insert into community.auditoria (registro) values (concat("Usuario ", usuario, " Registrado como Residente"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`residentes_AFTER_UPDATE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`residentes_AFTER_UPDATE`
AFTER UPDATE ON `community`.`residentes`
FOR EACH ROW
BEGIN
	declare usuario varchar(100);
    select nombre into usuario from community.usuarios where id = new.id_usuario;
	insert into community.auditoria (registro) values (concat("Usuario ", usuario, " Actualizado como Residente"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`visitantes_AFTER_DELETE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`visitantes_AFTER_DELETE`
AFTER DELETE ON `community`.`visitantes`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Visitante ", old.nombre, " Eliminado"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`visitantes_AFTER_INSERT` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`visitantes_AFTER_INSERT`
AFTER INSERT ON `community`.`visitantes`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Visitante ", new.nombre, " Registrado"));
END$$


USE `community`$$
DROP TRIGGER IF EXISTS `community`.`visitantes_AFTER_UPDATE` $$
USE `community`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `community`.`visitantes_AFTER_UPDATE`
AFTER UPDATE ON `community`.`visitantes`
FOR EACH ROW
BEGIN
	insert into community.auditoria (registro) values (concat("Visitante ", new.nombre, " Actualizado"));
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

