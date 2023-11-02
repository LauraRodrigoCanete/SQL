@'C:\Users\usuario_local\Downloads\crear_tablas.sql'

SET SERVEROUTPUT ON SIZE 1000000;

DECLARE
subtype t_sueldo is BINARY_INTEGER range 900 .. 5000 NOT NULL;
v_sueldo t_sueldo := 1000;

BEGIN
SELECT Sueldo
INTO v_sueldo
FROM Empleados
WHERE DNI = '12345678L';

-- La variable v_sueldo toma el valor 1500 (se puede ver descomentando la línea de abajo)
--DBMS_OUTPUT.put_line(v_sueldo);
--Por tanto, si la multiplicamos por 4 nos salimos del rango, obteniendo un error
--v_sueldo := 4*v_sueldo;

v_sueldo := 1.1*v_sueldo;
--UPDATE Empleados
--SET Sueldo = v_sueldo
--WHERE DNI = '12345678L';
END;

SELECT * FROM Empleados;

ROLLBACK;
