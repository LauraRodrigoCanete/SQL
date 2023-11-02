CREATE TABLE butacas(id number(8) primary key,
 evento varchar(30),
fila varchar(10),
 columna varchar(10)) ;
CREATE TABLE reservas(id number(8) primary key,
 evento varchar(30),
fila varchar(10),
columna varchar(10)) ;
CREATE SEQUENCE Seq_Butacas INCREMENT BY 1 START WITH 1 NOMAXVALUE;
CREATE SEQUENCE Seq_Reservas INCREMENT BY 1 START WITH 1 NOMAXVALUE;

INSERT INTO butacas VALUES (Seq_Butacas.NEXTVAL,'Circo','1','1');
INSERT INTO butacas VALUES (Seq_Butacas.NEXTVAL,'Circo','1','2');
INSERT INTO butacas VALUES (Seq_Butacas.NEXTVAL,'Circo','1','3'); 
COMMIT;

@ C:\Users\usuario_local\Downloads\reservar.sql