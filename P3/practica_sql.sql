--Autores: Laura Rodrigo y Leonardo Macías
/abolish
/sql
create table programadores(dni string primary key, nombre string, dirección string, teléfono string);
insert into programadores values('1','Jacinto','Jazmín 4','91-8888888');
insert into programadores values('2','Herminia','Rosa 4','91-7777777');
insert into programadores values('3','Calixto','Clavel 3','91-1231231');
insert into programadores values('4','Teodora','Petunia 3','91-6666666');

create table analistas(dni string primary key, nombre string, dirección string, teléfono string);
insert into analistas values('4','Teodora','Petunia 3','91-6666666');
insert into analistas values('5','Evaristo','Luna 1','91-1111111');
insert into analistas values('6','Luciana','Júpiter 2','91-8888888');
insert into analistas values('7','Nicodemo','Plutón 3',NULL);

create table distribución(códigoPr string, dniEmp string, horas int, primary key (códigoPr, dniEmp));
insert into distribución values('P1','1',10);
insert into distribución values('P1','2',40);
insert into distribución values('P1','4',5);
insert into distribución values('P2','4',10);
insert into distribución values('P3','1',10);
insert into distribución values('P3','3',40);
insert into distribución values('P3','4',5);
insert into distribución values('P3','5',30);
insert into distribución values('P4','4',20);
insert into distribución values('P4','5',10);

create table proyectos(código string primary key, descripción string, dniDir string);
insert into proyectos values('P1','Nómina','4');
insert into proyectos values('P2','Contabilidad','4');
insert into proyectos values('P3','Producción','5');
insert into proyectos values('P4','Clientes','5');
insert into proyectos values('P5','Ventas','6');

--1
CREATE VIEW vista1 AS SELECT programadores.dni FROM programadores UNION SELECT analistas.dni FROM analistas;

--2
CREATE VIEW vista2 AS SELECT programadores.dni FROM programadores INTERSECT SELECT analistas.dni FROM analistas;

--3
CREATE VIEW vista3 AS SELECT dni FROM vista1 EXCEPT (SELECT dniEmp FROM distribución UNION SELECT dniDir FROM proyectos);

--4
CREATE VIEW vista4 AS SELECT * FROM (SELECT código FROM proyectos) EXCEPT SELECT * FROM( SELECT códigoPr FROM distribución WHERE dniEmp IN (SELECT dni FROM analistas));

--5
create or replace view analistas_no_programadores as select dni from analistas except select dni from programadores;
create or replace view vista5(dni) as select dni from analistas_no_programadores intersect select dniDir from proyectos;

--6
create or replace view dni_proyecto_horas as select descripción, dniEmp, horas from distribución join proyectos on código = códigoPr;
create or replace view vista6(descripción, nombre, horas) as select descripción, nombre, horas from dni_proyecto_horas join programadores on dniEmp = dni;

--7
create or replace view empleados as select * from analistas union select * from programadores;
create or replace view empleados_2 as select * from analistas union select * from programadores;
create or replace view vista7(teléfono) as select empleados.teléfono from empleados, empleados_2 where empleados.dni != empleados_2.dni and empleados.teléfono = empleados_2.teléfono;

--8
create or replace view vista8(dni) as select programadores.dni from programadores natural join analistas;

--9
create or replace view vista9(dni, horas) as
select dniEmp, sum(horas) from distribución group by dniEmp;

--10
create or replace view vistaEmp as
select * from analistas union select * from programadores;

create or replace view vista10(dni, nombre,proyecto) as
select dni, nombre, códigoPr from vistaEmp left join distribución on dni=dniEmp;

--11
create or replace view vista11(dni, nombre) as
select dni, nombre from vistaEmp where teléfono is null;

--12

create or replace view empleados_y_proyecto as select * from vistaEmp left join distribución on dniEmp = dni;

create or replace view num_proyectos_empleado(dni, cantidad_proyectos) as
select dni, count(códigoPr) from empleados_y_proyecto group by dni having count(códigoPr) <> 0;

create or replace view empleados_horas_cantidad_aux as
select * from vista9 natural join num_proyectos_empleado;

create or replace view cociente_horas_proyecto_por_empleado (dni, número1) as
select dni, horas / cantidad_proyectos from
empleados_horas_cantidad_aux;

--Calculamos el otro lado de la desigualdad, es un dato cte para todos los emp
create or replace view datos_proyectos(códigoPr, horasPr, empPr) as
select códigoPr, sum(horas), count(*) from distribución group by códigoPr;

create or replace view cociente_general(número2) as
select avg(horasPr / empPr) from datos_proyectos;

create or replace view vista12 (dni) as 
select dni from cociente_horas_proyecto_por_empleado, cociente_general where número1 < número2;

--13

create or replace view dni_evaristo(dni_evar) as select dni from vistaEmp where nombre = 'Evaristo';

create or replace view beta(códigoPr) as
select códigoPr from distribución join dni_evaristo on dniEmp = dni_evar;

create or replace view vista13(dni) as
select * from (select dniEmp, códigoPr from distribución) division select * from beta;

--14

create or replace view alfa(dniEmp, códigoPr) as
select dniEmp, códigoPr from distribución;

create or replace view paréntesis1(dniEmp, códigoPr) as
select *
from (select dniEmp from alfa), beta;

create or replace view paréntesis2(dniEmp) as
select dniEmp
from (select * from paréntesis1 except select * from alfa);

create or replace view vista14(dni) as
select dniEmp from alfa except select * from paréntesis2;

--15
create or replace view proyectosEvaristo(códigoPr) as 
select códigoPr from distribución join vistaEmp on dniEmp = (select * from dni_evaristo); 

create or replace view compisEvaristo(dniEmp) as
select dniEmp from distribución where 
códigoPr in (select * from proyectosEvaristo);

create or replace view vista15(códigoPr, dni, horas) as
select códigoPr, dniEmp, 1.2*horas from
distribución where dniEmp not in (select * from compisEvaristo);

--16

create or replace view vista16(nombre) as (
  
with dniRecursivo(dni) as (
select * from dni_evaristo
union
select distribución.dniEmp from distribución, dniRecursivo, proyectos
where proyectos.dniDir
= dniRecursivo.dni and distribución.códigoPr = proyectos.código
)
  
select empleados.nombre from empleados, dniRecursivo
where dniRecursivo.dni
= empleados.dni and dniRecursivo.dni <> (select * from dni_evaristo)
);

select * from vista1;
select * from vista2;
select * from vista3;
select * from vista4;
select * from vista5;
select * from vista6;
select * from vista7;
select * from vista8;
select * from vista9;
select * from vista10;
select * from vista11;
select * from vista12;
select * from vista13;
select * from vista14;
select * from vista15;
select * from vista16;
