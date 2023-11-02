SET SERVEROUTPUT ON SIZE 1000000;

CREATE OR REPLACE PROCEDURE pr_empleados_tlf (p_telefono IN Teléfonos.teléfono%TYPE) IS
v_dni Empleados.dni%TYPE;
v_nombre Empleados.nombre%TYPE;
BEGIN

SELECT nombre, dni
INTO v_nombre, v_dni
from Empleados natural join Teléfonos
where teléfono = p_telefono;

DBMS_OUTPUT.PUT_LINE('El empleado con el teléfono ' || p_telefono || ' es: ' || v_nombre || ', con DNI: ' || v_dni || '.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el empleado con el teléfono ' || p_telefono || '.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Hay más de un empleado con el teléfono ' || p_telefono || '.');

END;
/
CALL pr_empleados_tlf('666666666');
CALL pr_empleados_tlf('611111111');
CALL pr_empleados_tlf('913333333');