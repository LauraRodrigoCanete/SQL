SET SERVEROUTPUT ON SIZE 1000000;
SET AUTOCOMMIT OFF;


CREATE OR REPLACE PROCEDURE pr_jefes(p_DNI CHAR) AS
v_dni_jefe Empleados.Jefe%TYPE;
v_nombre Empleados.Nombre%TYPE;
e_no_existe_emp EXCEPTION;

BEGIN
SELECT Jefe INTO v_dni_jefe FROM Empleados WHERE DNI = p_DNI;

IF v_dni_jefe IS NOT NULL THEN
SELECT Nombre INTO v_nombre FROM Empleados WHERE DNI = v_dni_jefe;
DBMS_OUTPUT.PUT_LINE('Nombre: '|| v_nombre || ', DNI: ' || v_dni_jefe);
pr_jefes(v_dni_jefe);
END IF;

EXCEPTION
WHEN e_no_existe_emp THEN
DBMS_OUTPUT.PUT_LINE('No existe ningún empleado con DNI '|| p_DNI);
END;
/
EXECUTE pr_jefes('12345678C');
/
CREATE OR REPLACE PROCEDURE pr_jefes_nr(p_DNI Empleados.DNI%TYPE) IS
    v_vacío CHAR(1) := 'S';
    e EXCEPTION;
   
    CURSOR c_jefes (p_c_dni empleados.dni%TYPE) IS
    WITH recursivo_jefe (jefe) AS (
        SELECT jefe
        FROM Empleados
        WHERE jefe IS NOT NULL AND DNI = p_DNI
        UNION ALL
        SELECT Empleados.jefe
        FROM recursivo_jefe JOIN Empleados ON recursivo_jefe.jefe = Empleados.DNI
        WHERE recursivo_jefe.jefe IS NOT NULL
    )
   
    SELECT recursivo_jefe.jefe dni, Empleados.Nombre nombre
    FROM recursivo_jefe JOIN Empleados ON recursivo_jefe.jefe=Empleados.DNI;
   
BEGIN
    FOR v_dni_nombre IN c_jefes(p_dni) LOOP
        DBMS_OUTPUT.PUT_LINE('Nombre: '|| v_dni_nombre.nombre ||', DNI: ' || v_dni_nombre.dni);
        v_vacío := 'N';
    END LOOP;
   
    IF v_vacío = 'S' THEN RAISE e;
    END IF;
   
EXCEPTION
    WHEN e THEN
        DBMS_OUTPUT.PUT_LINE('No existe ningún empleado con DNI '|| p_DNI);
END;
