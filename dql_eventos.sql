USE RepasoMysql2 ;
-- eventos 

-- Evento 

-- -- 1. ReporteMensualDeAlumnos: Genera un informe mensual con el total de alumnos matriculados por grado y lo 
-- almacena automaticamente 

-- O_O Hay que tener una tabla que almacene el informe mensual del total de alumnos. Se propone la siguiente tabla:

CREATE TABLE informe_mensual_matriculas (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    grado_id INT UNSIGNED NOT NULL,
    total_alumnos INT NOT NULL,
    fecha_informe DATETIME NOT NULL,
    FOREIGN KEY (grado_id) REFERENCES grado(id)
);


DELIMITER //
CREATE EVENT ReporteMensualDeAlumnos
ON SCHEDULE EVERY 1 MONTH
DO 
BEGIN 
	INSERT INTO informe_mensual_matriculas
    (grado_id, total_alumnos, fecha_informe)
    SELECT id_grado, COUNT(id_alumno), NOW()
    FROM alumno_se_matricula_asigantura
    GROUP BY id_grado;
END ;
DELIMITER //

-- 2. ActualizarHorasDepartamento: Actualiza el total de horas impartidas por cada departamento al final de cada semestre.

DELIMITER //
CREATE EVENT ActualizarHorasDepartamento 
ON SCHEDULE EVERY 6 MONTH 
DO 
BEGIN 
	UPDATE departamento d 
    JOIN (
    SELECT p.id_departamento, SUM(a.creditos) AS total_horas FROM asignatura a
    JOIN profesor p ON p.id = a.id_departamento 
    GROUP BY p.id_departamento
    ) AS horas_totales ON d.id = horas_totales.id_departamento 
    SET d.total_horas_impartidas = horas_totales.total_horas;
END //
DELIMITER ;

-- 3. AlertaAsignaturaNoCursadaAnual: Envía una alerta cuando una asignatura no ha sido cursada en el último año.

-- 4. LimpiarAuditoriaCadaSemestre: Borra los registros antiguos de auditoría al final de cada semestre.
create event eliminar_evento1 on schedule 
every 1 week do delete from asignatura 
where cuatrimestre < month(1) - interval 1 month;

-- 5. ActualizarListaDeProfesoresDestacados: Actualiza la lista de profesores destacados al final de cada semestre basándose en evaluaciones y desempeño.
create event nuevo_profesor1 on schedule
every 10 hour starts '2024-12-02  10:00' ends '2024-12-02  10:01' 
do update nuevo_profesor set value = value + 1 where id_profesor = 1;
