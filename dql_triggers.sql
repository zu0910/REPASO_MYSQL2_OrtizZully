USE RepasoMysql2 ;

-- 1. ActualizarTotalAsignaturasProfesor: Al asignar una nueva asignatura a un profesor, actualiza el total de asignaturas impartidas por dicho profesor.
delimiter //
create trigger tabla_asignatura1 
after update on asignatura 
for each row
begin 
insert into tablas_asignatura(id_asignatura, nombre)
values(new.id_asignatura, 'Zully');
end 
// 
delimiter ;
-- 2. AuditarActualizacionAlumno: Cada vez que se modifica un registro de un alumno, guarda el cambio en una tabla de auditoría.
delimiter //
create trigger tablas_alumnos1
before update on alumno
for each row
begin 
insert into tabla_alumno(id_alumno, ciudad)
values (new.id_alumno, 'Bucaramanga');
end
//
delimiter ;
-- 3. RegistrarHistorialCreditos: Al modificar los créditos de una asignatura, guarda un historial de los cambios.
delimiter //
create trigger tablas_asignaturas1
before insert on asignatura 
for each row
begin insert into tabla_asignaturas(id_asignatura, apellido1)
values (new.id_asignatura, 'Ortiz');
end
//
delimiter ;
-- 4. NotificarCancelacionMatricula: Registra una notificación cuando se elimina una matrícula de un alumno.
delimiter //
create trigger NotificarCancelacion
after delete on alumno_se_matricula_asignatura
for each row 
begin
    insert into Notificaciones (mensaje)
    values (concat('La matrícula del alumno con ID ', old.id_alumno, ' en la asignatura con ID ', old.id_asignatura, ' ha sido eliminada.'));
end //
delimiter ;



-- 5. RestringirAsignacionExcesiva: Evita que un profesor tenga más de 10 asignaturas asignadas en un semestre.
