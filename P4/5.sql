SET SERVEROUTPUT ON SIZE 1000000;
SET AUTOCOMMIT OFF;

CREATE OR REPLACE PROCEDURE pr_empleados_CP IS
v_num_empleados NUMBER := 0;
v_suma_sueldo Empleados.sueldo%TYPE := 0;
v_total_empleados NUMBER := 0;
BEGIN

FOR v_cp IN (SELECT DISTINCT "C�digo postal" FROM Domicilios NATURAL JOIN Empleados ORDER BY "C�digo postal") LOOP

    DBMS_OUTPUT.PUT_LINE('C�digo postal: ' || v_cp."C�digo postal");
    
    FOR v_empleado IN (SELECT nombre, calle, sueldo FROM Empleados NATURAL JOIN domicilios WHERE "C�digo postal" = v_cp."C�digo postal" ) LOOP

            DBMS_OUTPUT.PUT_LINE(v_empleado.nombre || ', ' || v_empleado.calle || ', ' || v_empleado.sueldo);
            v_num_empleados := v_num_empleados + 1;
            v_suma_sueldo := v_suma_sueldo + v_empleado.sueldo;
    END LOOP;
            DBMS_OUTPUT.PUT_LINE('N� empleados: ' || v_num_empleados || ', Sueldo medio: ' || v_suma_sueldo / v_num_empleados);
            v_total_empleados := v_total_empleados + v_num_empleados;
            
            v_num_empleados := 0;
            v_suma_sueldo := 0;
END LOOP;

DBMS_OUTPUT.PUT_LINE('Total empleados: ' || v_total_empleados);

END;
/
CALL pr_empleados_CP();