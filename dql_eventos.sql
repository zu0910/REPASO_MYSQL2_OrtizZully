USE RepasoMysql2 ;
-- eventos 

-- 1. ReporteMensualDeAlumnos: Genera un informe mensual con el total de alumnos matriculados por grado y lo 
-- almacena automaticamente 

DELIMITER //
CREATE EVENT ReporteMensual
ON SCHEDULE EVERY  1 MONTH 
STARTS '2025-01-31 23:59:59' DO
BEGIN
    INSERT INTO ReporteMensualAlumnos (mes, año, id_grado, grado_nombre, total_alumnos)
    SELECT MONTH(CURRENT_DATE) AS mes, YEAR(CURRENT_DATE) AS año,
	g.id_grado, g.nombre AS grado_nombre,
	COUNT(am.id_alumno) AS total_alumnos
    FROM grado g JOIN asignatura ON g.id_grado = alumno.id_grado
    JOIN alumno_se_matricula_asignatura am ON alumno.id_asignatura = am.id_asignatura
    WHERE am.id_alumno IS NOT NULL 
    GROUP BY g.id_grado, g.nombre;
END //
DELIMITER ;

-- 2. ActualizarHorasDepartamento: Actualiza el total de horas impartidas por cada departamento al final de cada semestre.
delimiter //
create event ActualizarHoras on schedule every 6 month
starts '2024-06-30 23:59:59' do
begin
    update TotalHoras th
    join (
        select profesor.id_departamento, sum(alumno.creditos * 25) as total_horas
        from asignatura
        join profesor on alumno.id_profesor = profesor.id_profesor
        where alumno.cuatrimestre = 1 and year(alumno.fecha_inicio) = year(current_date)
        group by profesor.id_departamento
    ) as horas on th.id_departamento = horas.id_departamento
    set th.total_horas = horas.total_horas, th.semestre = 1, th.año = year(current_date);
    update TotalHoras th
    join (
        select profesor.id_departamento, sum(alumno.creditos * 25) as total_horas
        from asignatura
        join profesor on alumno.id_profesor = profesor.id_profesor
        where alumno.cuatrimestre = 2 and year(alumno.fecha_inicio) = year(current_date)
        group by profesor.id_departamento
    ) as horas on thd.id_departamento = horas.id_departamento
    set thd.total_horas = horas.total_horas, thd.semestre = 2, thd.año = year(current_date);
end //
delimiter ;

-- 3. AlertaAsignaturaNoCursadaAnual: Envía una alerta cuando una asignatura no ha sido cursada en el último año.
delimiter //
create event AlertaAsignatura
on schedule every 1 year
starts '2025-01-01 00:00:00' do
begin
    insert into Alertas (mensaje)
    select concat('La asignatura "', alumno.nombre, '" no ha sido cursada en el último año.')
    from asignatura
    left join alumno_se_matricula_asignatura on alumno.id_asignatura = alumno_se_matricula_asignatura.id_asignatura
    left join curso_escolar on alumno_se_matricula_asignatura.id_curso_escolar = curso_escolar.id_curso_escolar
    where curso_escolar.anyo_inicio = (select max(anyo_inicio) from curso_escolar)
    and alumno_se_matricula_asignatura.id_asignatura is null;
end //
delimiter ;

-- 4. LimpiarAuditoriaCadaSemestre: Borra los registros antiguos de auditoría al final de cada semestre.
create event eliminar_evento1 on schedule 
every 1 week do delete from asignatura 
where cuatrimestre < month(1) - interval 1 month;

-- 5. ActualizarListaDeProfesoresDestacados: Actualiza la lista de profesores destacados al final de cada semestre basándose en evaluaciones y desempeño.
create event nuevo_profesor1 on schedule
every 10 hour starts '2024-12-02  10:00' ends '2024-12-02  10:01' 
do update nuevo_profesor set value = value + 1 where id_profesor = 1;

