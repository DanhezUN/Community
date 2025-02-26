
CREATE TABLE apartamentos
(
  id             INT        NOT NULL AUTO_INCREMENT,
  numero         VARCHAR(4) NOT NULL,
  id_torre       INT        NOT NULL,
  id_propietario INT        NULL    ,
  PRIMARY KEY (id)
);

ALTER TABLE apartamentos
  ADD CONSTRAINT UQ_id UNIQUE (id);

CREATE TABLE areas_comunes
(
  id     INT          NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

ALTER TABLE areas_comunes
  ADD CONSTRAINT UQ_id UNIQUE (id);

ALTER TABLE areas_comunes
  ADD CONSTRAINT UQ_nombre UNIQUE (nombre);

CREATE TABLE mascotas
(
  id     INT         NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  tipo   VARCHAR(45) NOT NULL,
  id     INT         NOT NULL,
  PRIMARY KEY (id)
);

ALTER TABLE mascotas
  ADD CONSTRAINT UQ_id UNIQUE (id);

CREATE TABLE pagos
(
  id    INT           NOT NULL AUTO_INCREMENT,
  valor DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id)
);

ALTER TABLE pagos
  ADD CONSTRAINT UQ_id UNIQUE (id);

CREATE TABLE pqr
(
  id         INT                           NOT NULL AUTO_INCREMENT,
  asunto     VARCHAR(64)                   NOT NULL,
  texto      TEXT                          NULL    ,
  fecha      DATETIME                      NOT NULL,
  estado     ENUM('pendiente', 'resuelto') NOT NULL DEFAULT 'pendiente',
  id_usuario INT                           NOT NULL,
  PRIMARY KEY (id)
) COMMENT 'Peticiones, Quejas y Reclamos';

ALTER TABLE pqr
  ADD CONSTRAINT UQ_id UNIQUE (id);

CREATE TABLE reservas
(
  id         INT      NOT NULL AUTO_INCREMENT,
  finicio    DATETIME NOT NULL,
  ffinal     DATETIME NOT NULL,
  id_area    INT      NOT NULL,
  id_usuario INT      NOT NULL,
  PRIMARY KEY (id)
);

ALTER TABLE reservas
  ADD CONSTRAINT UQ_id UNIQUE (id);

CREATE TABLE residentes
(
  id_usuario     INT NOT NULL,
  id_apartamento INT NOT NULL,
  PRIMARY KEY (id_usuario, id_apartamento)
);

CREATE TABLE torres
(
  id     INT        NOT NULL AUTO_INCREMENT,
  numero VARCHAR(4) NOT NULL,
  PRIMARY KEY (id)
);

ALTER TABLE torres
  ADD CONSTRAINT UQ_id UNIQUE (id);

ALTER TABLE torres
  ADD CONSTRAINT UQ_numero UNIQUE (numero);

CREATE TABLE usuarios
(
  id       INT                                             NOT NULL AUTO_INCREMENT,
  nombre   VARCHAR(100)                                    NOT NULL,
  telefono VARCHAR(15)                                     NOT NULL,
  email    VARCHAR(60)                                     NOT NULL,
  password VARCHAR(256)                                    NOT NULL,
  username VARCHAR(45)                                     NOT NULL,
  tipo     ENUM('residente', 'vigilante', 'admin', 'otro') NOT NULL DEFAULT 'otro',
  PRIMARY KEY (id)
) COMMENT 'Usuarios Conjunto';

ALTER TABLE usuarios
  ADD CONSTRAINT UQ_id UNIQUE (id);

CREATE TABLE visitantes
(
  id             INT         NOT NULL AUTO_INCREMENT,
  nombre         VARCHAR(45) NOT NULL,
  fentrada       DATETIME    NOT NULL,
  fsalida        DATETIME    NULL    ,
  telefono       VARCHAR(10) NOT NULL,
  documento      VARCHAR(11) NOT NULL,
  id_apartamento INT         NOT NULL,
  PRIMARY KEY (id)
);

ALTER TABLE visitantes
  ADD CONSTRAINT UQ_id UNIQUE (id);

ALTER TABLE apartamentos
  ADD CONSTRAINT FK_torres_TO_apartamentos
    FOREIGN KEY (id_torre)
    REFERENCES torres (id);

ALTER TABLE residentes
  ADD CONSTRAINT FK_usuarios_TO_residentes
    FOREIGN KEY (id_usuario)
    REFERENCES usuarios (id);

ALTER TABLE residentes
  ADD CONSTRAINT FK_apartamentos_TO_residentes
    FOREIGN KEY (id_apartamento)
    REFERENCES apartamentos (id);

ALTER TABLE visitantes
  ADD CONSTRAINT FK_apartamentos_TO_visitantes
    FOREIGN KEY (id_apartamento)
    REFERENCES apartamentos (id);

ALTER TABLE mascotas
  ADD CONSTRAINT FK_apartamentos_TO_mascotas
    FOREIGN KEY (id)
    REFERENCES apartamentos (id);

ALTER TABLE apartamentos
  ADD CONSTRAINT FK_usuarios_TO_apartamentos
    FOREIGN KEY (id_propietario)
    REFERENCES usuarios (id);

ALTER TABLE pqr
  ADD CONSTRAINT FK_usuarios_TO_pqr
    FOREIGN KEY (id_usuario)
    REFERENCES usuarios (id);

ALTER TABLE reservas
  ADD CONSTRAINT FK_areas_comunes_TO_reservas
    FOREIGN KEY (id_area)
    REFERENCES areas_comunes (id);

ALTER TABLE reservas
  ADD CONSTRAINT FK_usuarios_TO_reservas
    FOREIGN KEY (id_usuario)
    REFERENCES usuarios (id);
