USE RepasoMysql2 ;

-- funciones 

-- 1. TotalCreditosAlumno(AlumnoID, Anio): Calcula el total de créditos cursados por un alumno en un año específico.
delimiter //
create function nuevas_funciones(id_asignatura int)
returns int 
deterministic
begin
declare asignatura int;
select avg(creditos)
into asignatura
from asignatura
where id_asignatura = id_asignatura;
return asignatura;
end
//
delimiter ;
select nuevas_funciones(1);

-- 2. PromedioHorasPorAsignatura(AsignaturaID): Retorna el promedio de horas de clases para una asignatura.
delimiter //
create function PromedioHoras(asignaturaid int)
returns float
deterministic
begin
    declare promedio_horas float;
    select avg(alumno.creditos * 25) into promedio_horas
    from asignatura a
    where alumno.id_asignatura = asignaturaid;
    return promedio_horas;
end //
delimiter ;

-- 3. TotalHorasPorDepartamento(DepartamentoID): Calcula la cantidad total de horas impartidas por un departamento específico.
delimiter //
create function TotalHoras(departamentoid int)
returns float
deterministic
begin
    declare total_horas float;
    select sum(alumno.creditos * 25) into total_horas
    from asignatura
    join profesor on alumno.id_profesor = profesor.id_profesor
    where profesor.id_departamento = departamentoid;
    return total_horas;
end //
delimiter ;

-- 4. VerificarAlumnoActivo(AlumnoID): Verifica si un alumno está activo en el semestre actual basándose en su matrícula.
