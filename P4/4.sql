SET SERVEROUTPUT ON SIZE 1000000;
SET AUTOCOMMIT OFF;

CREATE OR REPLACE PROCEDURE pr_comprobar_poblaciones IS

v_poblacion_varias_provincias "Códigos postales".provincia%TYPE;

BEGIN

SELECT población
INTO v_poblacion_varias_provincias
FROM "Códigos postales"
group by población
having count(provincia) > 1;

RAISE TOO_MANY_ROWS;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No hay dos o más provincias que 
		compartan la misma población.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('A la población ' || 
		v_poblacion_varias_provincias || 
		' no le corresponde siempre la misma provincia.');
END;
/
CALL pr_comprobar_poblaciones();
/
INSERT INTO "Códigos postales" VALUES ('41008','Arganda','Sevilla');
CALL pr_comprobar_poblaciones();
ROLLBACK;
