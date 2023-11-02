--Autores: Laura Rodrigo y Leonardo Mac�as
/abolish
/sql
create table programadores(dni string primary key, nombre string, direcci�n string, tel�fono string);
insert into programadores values('1','Jacinto','Jazm�n 4','91-8888888');
insert into programadores values('2','Herminia','Rosa 4','91-7777777');
insert into programadores values('3','Calixto','Clavel 3','91-1231231');
insert into programadores values('4','Teodora','Petunia 3','91-6666666');

create table analistas(dni string primary key, nombre string, direcci�n string, tel�fono string);
insert into analistas values('4','Teodora','Petunia 3','91-6666666');
insert into analistas values('5','Evaristo','Luna 1','91-1111111');
insert into analistas values('6','Luciana','J�piter 2','91-8888888');
insert into analistas values('7','Nicodemo','Plut�n 3',NULL);

create table distribuci�n(c�digoPr string, dniEmp string, horas int, primary key (c�digoPr, dniEmp));
insert into distribuci�n values('P1','1',10);
insert into distribuci�n values('P1','2',40);
insert into distribuci�n values('P1','4',5);
insert into distribuci�n values('P2','4',10);
insert into distribuci�n values('P3','1',10);
insert into distribuci�n values('P3','3',40);
insert into distribuci�n values('P3','4',5);
insert into distribuci�n values('P3','5',30);
insert into distribuci�n values('P4','4',20);
insert into distribuci�n values('P4','5',10);

create table proyectos(c�digo string primary key, descripci�n string, dniDir string);
insert into proyectos values('P1','N�mina','4');
insert into proyectos values('P2','Contabilidad','4');
insert into proyectos values('P3','Producci�n','5');
insert into proyectos values('P4','Clientes','5');
insert into proyectos values('P5','Ventas','6');

--1
CREATE VIEW vista1 AS SELECT programadores.dni FROM programadores UNION SELECT analistas.dni FROM analistas;

--2
CREATE VIEW vista2 AS SELECT programadores.dni FROM programadores INTERSECT SELECT analistas.dni FROM analistas;

--3
CREATE VIEW vista3 AS SELECT dni FROM vista1 EXCEPT (SELECT dniEmp FROM distribuci�n UNION SELECT dniDir FROM proyectos);

--4
CREATE VIEW vista4 AS SELECT * FROM (SELECT c�digo FROM proyectos) EXCEPT SELECT * FROM( SELECT c�digoPr FROM distribuci�n WHERE dniEmp IN (SELECT dni FROM analistas));

--5
create or replace view analistas_no_programadores as select dni from analistas except select dni from programadores;
create or replace view vista5(dni) as select dni from analistas_no_programadores intersect select dniDir from proyectos;

--6
create or replace view dni_proyecto_horas as select descripci�n, dniEmp, horas from distribuci�n join proyectos on c�digo = c�digoPr;
create or replace view vista6(descripci�n, nombre, horas) as select descripci�n, nombre, horas from dni_proyecto_horas join programadores on dniEmp = dni;

--7
create or replace view empleados as select * from analistas union select * from programadores;
create or replace view empleados_2 as select * from analistas union select * from programadores;
create or replace view vista7(tel�fono) as select empleados.tel�fono from empleados, empleados_2 where empleados.dni != empleados_2.dni and empleados.tel�fono = empleados_2.tel�fono;

--8
create or replace view vista8(dni) as select programadores.dni from programadores natural join analistas;

--9
create or replace view vista9(dni, horas) as
select dniEmp, sum(horas) from distribuci�n group by dniEmp;

--10
create or replace view vistaEmp as
select * from analistas union select * from programadores;

create or replace view vista10(dni, nombre,proyecto) as
select dni, nombre, c�digoPr from vistaEmp left join distribuci�n on dni=dniEmp;

--11
create or replace view vista11(dni, nombre) as
select dni, nombre from vistaEmp where tel�fono is null;

--12

create or replace view empleados_y_proyecto as select * from vistaEmp left join distribuci�n on dniEmp = dni;

create or replace view num_proyectos_empleado(dni, cantidad_proyectos) as
select dni, count(c�digoPr) from empleados_y_proyecto group by dni having count(c�digoPr) <> 0;

create or replace view empleados_horas_cantidad_aux as
select * from vista9 natural join num_proyectos_empleado;

create or replace view cociente_horas_proyecto_por_empleado (dni, n�mero1) as
select dni, horas / cantidad_proyectos from
empleados_horas_cantidad_aux;

--Calculamos el otro lado de la desigualdad, es un dato cte para todos los emp
create or replace view datos_proyectos(c�digoPr, horasPr, empPr) as
select c�digoPr, sum(horas), count(*) from distribuci�n group by c�digoPr;

create or replace view cociente_general(n�mero2) as
select avg(horasPr / empPr) from datos_proyectos;

create or replace view vista12 (dni) as 
select dni from cociente_horas_proyecto_por_empleado, cociente_general where n�mero1 < n�mero2;

--13

create or replace view dni_evaristo(dni_evar) as select dni from vistaEmp where nombre = 'Evaristo';

create or replace view beta(c�digoPr) as
select c�digoPr from distribuci�n join dni_evaristo on dniEmp = dni_evar;

create or replace view vista13(dni) as
select * from (select dniEmp, c�digoPr from distribuci�n) division select * from beta;

--14

create or replace view alfa(dniEmp, c�digoPr) as
select dniEmp, c�digoPr from distribuci�n;

create or replace view par�ntesis1(dniEmp, c�digoPr) as
select *
from (select dniEmp from alfa), beta;

create or replace view par�ntesis2(dniEmp) as
select dniEmp
from (select * from par�ntesis1 except select * from alfa);

create or replace view vista14(dni) as
select dniEmp from alfa except select * from par�ntesis2;

--15
create or replace view proyectosEvaristo(c�digoPr) as 
select c�digoPr from distribuci�n join vistaEmp on dniEmp = (select * from dni_evaristo); 

create or replace view compisEvaristo(dniEmp) as
select dniEmp from distribuci�n where 
c�digoPr in (select * from proyectosEvaristo);

create or replace view vista15(c�digoPr, dni, horas) as
select c�digoPr, dniEmp, 1.2*horas from
distribuci�n where dniEmp not in (select * from compisEvaristo);

--16

create or replace view vista16(nombre) as (
  
with dniRecursivo(dni) as (
select * from dni_evaristo
union
select distribuci�n.dniEmp from distribuci�n, dniRecursivo, proyectos
where proyectos.dniDir
= dniRecursivo.dni and distribuci�n.c�digoPr = proyectos.c�digo
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
