SET SERVEROUTPUT ON SIZE 1000000;
SET AUTOCOMMIT OFF;

CREATE OR REPLACE PROCEDURE pr_comprobar_poblaciones IS

v_poblacion_varias_provincias "C�digos postales".provincia%TYPE;

BEGIN

SELECT poblaci�n
INTO v_poblacion_varias_provincias
FROM "C�digos postales"
group by poblaci�n
having count(provincia) > 1;

RAISE TOO_MANY_ROWS;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No hay dos o m�s provincias que 
		compartan la misma poblaci�n.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('A la poblaci�n ' || 
		v_poblacion_varias_provincias || 
		' no le corresponde siempre la misma provincia.');
END;
/
CALL pr_comprobar_poblaciones();
/
INSERT INTO "C�digos postales" VALUES ('41008','Arganda','Sevilla');
CALL pr_comprobar_poblaciones();
ROLLBACK;
