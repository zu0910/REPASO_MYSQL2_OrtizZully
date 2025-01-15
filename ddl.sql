CREATE DATABASE RepasoMysql2;
-- drop database RepasoMysql2;
USE RepasoMysql2;


CREATE TABLE departamento (
	id_departamento INT(10) PRIMARY KEY,
    nombre VARCHAR(50)
);
);

CREATE TABLE profesor (
	id_profesor INT(10) PRIMARY KEY,
	nif VARCHAR(9) NULL,
	nombre VARCHAR(25),
	apellido1 VARCHAR(50),
	apellido2 VARCHAR(50) NULL,
	ciudad VARCHAR(25),
	direccion VARCHAR(50),
	telefono VARCHAR(9) NULL,
	fecha_nacimiento DATE,
	sexo ENUM('H','M'),
    id_departamento INT(10),
	FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)

CREATE TABLE alumno (
	id_alumno INT(10) PRIMARY KEY,
	nif VARCHAR(9) NULL,
	nombre VARCHAR(25),
	apellido1 VARCHAR(50),
	apellido2 VARCHAR(50) NULL,
	ciudad VARCHAR(25),
	direccion VARCHAR(50),
	telefono VARCHAR(9) NULL,
	fecha_nacimiento DATE,
	sexo ENUM('H','M')
);

CREATE TABLE curso_escolar (
	id_curso_escolar INT(10) PRIMARY KEY,
    anyo_inicio YEAR(4),
    anyo_fin YEAR(4)
);

CREATE TABLE grado (
	id_grado INT(10) PRIMARY KEY,
    nombre VARCHAR(100) 
);

CREATE TABLE asignatura (
	id_asignatura INT(10) PRIMARY KEY,
	nombre VARCHAR(100),
	creditos FLOAT,
	tipo ENUM('básica','optativa','obligatoria'),
	curso TINYINT(3),
	cuatrimestre TINYINT(3),
	id_profesor INT(10) NULL,
	id_grado INT(10),
	FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
	FOREIGN KEY(id_grado) REFERENCES grado(id_grado)
);

CREATE TABLE alumno_se_matricula_asignatura(
	id_alumno INT(10),
    id_asignatura INT(10),
    id_curso_escolar INT(10),
    FOREIGN KEY(id_alumno) REFERENCES alumno(id_alumno),
    FOREIGN KEY(id_asignatura) REFERENCES asignatura(id_asignatura),
    FOREIGN KEY(id_curso_escolar) REFERENCES curso_escolar(id_curso_escolar)
);