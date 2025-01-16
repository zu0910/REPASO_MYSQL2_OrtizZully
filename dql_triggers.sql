USE universidad_t2;

-- 1. ActualizarTotalAsignaturasProfesor: Al asignar una nueva asignatura a un profesor, 
-- actualiza el total de asignaturas impartidas por dicho profesor.

-- O_O este trigger sera accinado con un amodificacion en profesor, teniendo un anueva columna 
-- para el total de asignatura llamadas "total_asignatura"

ALTER TABLE profesor ADD COLUMN total_asignaturas INT DEFAULT 0;
DELIMITER //
CREATE TRIGGER ActualizarTotalAsignaturaProfesor 
AFTER INSERT ON asignatura 
FOR EACH ROW -- POR CADA FILA AFECTA EN EL ENVENTO DE LA ACCION 
BEGIN 
	DECLARE total_asignaturas_interna INT;
	-- Obtener el total de asignaturas actuales del docente 
    SELECT COUNT(*) INTO total_asignaturas_interna
    FROM asignaturas
    WHERE id_profesor = NEW.id_profesor;
    -- Actualizar el total de asignaturas impartidas por el docente 
    UPDATE profesor SET total_asignaturas = total_asignaturas_interna 
    WHERE id = NEW.id_profesor;
END //
DELIMITER ; 

-- 2. AuditarActualizacionAlumno: Cada vez que se modifica un registro de un alumno, guarda el cambio en una tabla de auditoría.

CREATE TABLE auditoria (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT UNSIGNED NOT NULL,
    fecha_creacion DATE NOT NULL,
    accion  VARCHAR(250) NOT NULL,
    FOREIGN KEY (id_alumno) REFERENCES alumno(id)
);
DELIMITER //
CREATE TRIGGER AuditarActualizacionAlumno 
AFTER UPDATE ON alumno
FOR EACH ROW 
BEGIN 
	INSERT INTO auditoria (alumno_id, fecha_creacion,accion )
    VALUES (NEW.id_alumno, NOW(), CONCAT ('Se actualizó: ', OLD.Nombre, ' -> ', NEW.Nombre))
    
END ;
DELIMITER ; 

-- 3. RegistrarHistorialCreditos: Al modificar los créditos de una asignatura, guarda un historial de los cambios.

CREATE TABLE hitoral_creditos (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_asignatura INT UNSIGNED NOT NULL,
    fecha_modificacion DATE NOT NULL,
    creditos INT NOT NULL,
    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id)
);

DELIMITER //
CREATE TRIGGER RegistrarHistorialCreditos
AFTER INSERT ON asignatura 
FOR EACH ROW 
BEGIN 
	INSERT INTO historial_creditos (id_asignatura, fecha_modificacion,creditos)
    VALUES (NEW.id, NOW(), NEW.creditos, NEW.creditos);
END //
DELIMITER ;

-- 4. NotificarCancelacionMatricula: Registra una notificación cuando se elimina una matrícula de un alumno.

CREATE TABLE notificacion_cancelacion_matricula (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_asignatura INT UNSIGNED NOT NULL,
    id_alumno INT UNSIGNED NOT NULL,
    fecha_cancelación DATE NOT NULL,
    motivo_cancelacion VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id),
    FOREIGN KEY (id_alumno) REFERENCES alumno(id)
);

DELIMITER //
CREATE TRIGGER NotificarCancelacionMatricula 
AFTER DELETE ON alumno_se_matricula_asignatura
FOR EACH ROW 
BEGIN
	INSERT INTO notificacion_cancelacion_matricula (id_asignatura, id_alumno, fecha_cancelacion, motivo_cancelacion)
    VALUES (OLD.id_alumno, OLD.id_asignatura, NOW(), CONCAT('Se ha cancelado con exito la matrícula del alumno ID: ', OLD.id_alumno, 
               ' en la asignatura ID: ', OLD.id_asignatura));
END //
DELIMITER ;

-- 5. RestringirAsignacionExcesiva: Evita que un profesor tenga más de 10 asignaturas asignadas en un semestre.

DELIMITER //
CREATE TRIGGER RestringirAsignacionExcesiva 
BEFORE INSERT ON asignatura 
FOR EACH ROW 
BEGIN 
	DECLARE total_asignaturas INT;
    SELECT COUNT(*) INTO total_asignaturas FROM asignatura 
    WHERE id_profesor = NEW.id_profesor AND cuatrimestre = NEW.cuatrimestre;
    IF total_asignaturas >= 10 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El profesor no puede tener mas de 10 asignaturas asignadas en un semestre';
	END IF;
END //
DELIMITER ;
