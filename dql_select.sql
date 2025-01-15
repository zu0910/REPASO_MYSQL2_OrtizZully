USE RepasoMysql2 ;

-- Consultas 

-- 1. Encuentra el profesor que ha impartido más asignaturas en el último año académico.
select distinct p.id_profesor, p.nombre, p.apellido1, a.id_asignatura from asignatura a
inner join profesor p on a.id_profesor = a.id_profesor;

-- 2. Lista los cinco departamentos con mayor cantidad de asignaturas asignadas.

select d.id_departamento, d.nombre, count(a.id_asignatura) as total_asignaturas from departamento d
join profesor p on d.id_departamento = p.id_departamento 
join asignatura a on p.id_profesor = a.id_profesor 
group by d.id_departamento order by total_asignaturas desc ;

-- 3. Obtén el total de alumnos y docentes por departamento.

select a.id_alumno, a.nombre, p.id_profesor, d.id_departamento, d.nombre from departamento d
inner join alumno a on d.id_alumno = 5;

-- 4. Calcula el número total de alumnos matriculados en asignaturas de un género específico en un semestre determinado.

select a.nombre, a.cuatrimestre, a.tipo, count(a.id) as cantidad_matricuklados from alumno al 
join alumno_se_matricula_asignatura am on al.id = am.id_alumno
join asignatura a on am.id_asignatura = a.id
group by 1,2,3;

-- 5. Encuentra los alumnos que han cursado todas las asignaturas de un grado específico.

select distinct g.nombre, al.nombre, count(al.id) from grado g
join asignatura a on g.id = a.id_grado
join alumno_se_matricula_asignatura am on a.id = am.id_asignatura
join alumno al on am.id_alumno = al.id group by 1,2;

-- 6. Lista los tres grados con mayor número de asignaturas cursadas en el último semestre.

select g.nombre, count(a.id) from grado g
join asignatura a on g.id = a.id_grado
join alumno_se_matricula_asignatura am on a.id = am.id_asignatura
join curso_escolar c on am.id_curso_escolar = c.id
where (select max(anyo_fin) from curso_escolar) group by 1;

-- 7. Muestra los cinco profesores con menos asignaturas impartidas en el último año académico.

select d.nombre, count(p.id_departamento) as cantidad_asignaturas from departamento d
inner join profesor p on d.id = p.id_departamento
inner join asignatura a on p.id = a.id_profesor group by d.nombre;

-- 8. Calcula el promedio de edad de los alumnos al momento de su primera matrícula.
-- 9. Encuentra los cinco profesores que han impartido más clases de un mismo grado.

select g.nombre, p.nombre, p.apellido1, count(p.id) as profesores from profesor p 
join asignatura a on p.id = a.id_profesor 
join grado g on a.id_grado = g.id
group by 1,2,3;

-- 10. Genera un informe con los alumnos que han cursado más de 10 asignaturas en el último año.

select concat(al.nombre,' ',al.apellido1) as nombre_alumno, count(al.id) as cant_asignaturas from alumno al
join alumno_se_matricula_asignatura asm on al.id = asm.id_alumno
join asignatura a on asm.id_asignatura = a.id
join curso_escolar ce on asm.id_curso_escolar = ce.id
where ce.anyo_fin = 2018
group by 1;

-- 11. Calcula el promedio de créditos de las asignaturas por grado.

select avg(a.creditos) as promedio_creditos from asignatura a 
join grado g on a.id_grado = g.id 
group by g.id;

-- 12. Lista las cinco asignaturas más largas (en horas) impartidas en el último semestre.
-- 13. Muestra los alumnos que han cursado más asignaturas de un género específico.
-- 14. Encuentra la cantidad total de horas cursadas por cada alumno en el último semestre.
-- 15. Muestra el número de asignaturas impartidas diariamente en cada mes del último trimestre.



-- 16. Calcula el total de asignaturas impartidas por cada profesor en el último semestre.

select p.nombre as nombre_profesor, count(a.nombre) as total_asignatura from profesor p 
inner join asignatura a on p.id = a.id_profesor 
where a.cuatrimestre = 2 group by 1;

-- 17. Encuentra al alumno con la matrícula más reciente.

select * from alumno a inner join alumno_se_matricula_asignatura am on a.id = am.id_alumno;

-- 18. Lista los cinco grados con mayor número de alumnos matriculados durante los últimos tres meses.
-- 19. Obtén la cantidad de asignaturas cursadas por cada alumno en el último semestre.
-- 20. Lista los profesores que no han impartido clases en el último año académico.