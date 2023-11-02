SET SERVEROUTPUT ON SIZE 1000000;

CREATE OR REPLACE PROCEDURE pr_empleados_tlf (p_telefono IN Tel�fonos.tel�fono%TYPE) IS
v_dni Empleados.dni%TYPE;
v_nombre Empleados.nombre%TYPE;
BEGIN

SELECT nombre, dni
INTO v_nombre, v_dni
from Empleados natural join Tel�fonos
where tel�fono = p_telefono;

DBMS_OUTPUT.PUT_LINE('El empleado con el tel�fono ' || p_telefono || ' es: ' || v_nombre || ', con DNI: ' || v_dni || '.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontr� el empleado con el tel�fono ' || p_telefono || '.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Hay m�s de un empleado con el tel�fono ' || p_telefono || '.');

END;
/
CALL pr_empleados_tlf('666666666');
CALL pr_empleados_tlf('611111111');
CALL pr_empleados_tlf('913333333');