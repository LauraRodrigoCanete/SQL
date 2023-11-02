--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET SERVEROUTPUT ON SIZE 1000000;
SET DEFINE ON;
SET ECHO OFF;
SET VERIFY OFF;
DEF v_evento='Circo';
DEF v_fila='1';
DEF v_columna='2';
VARIABLE v_error CHAR(20)
/
DECLARE
  v_existe VARCHAR(20) DEFAULT NULL;
BEGIN
  SELECT COUNT(*) INTO v_existe FROM butacas WHERE evento='&v_evento' AND fila='&v_fila' AND columna='&v_columna';
  IF v_existe<>'0' THEN 
    SELECT COUNT(*) INTO v_existe FROM reservas WHERE evento='&v_evento' AND fila='&v_fila' AND columna='&v_columna';
    IF v_existe='0' THEN
      DBMS_OUTPUT.PUT_LINE('INFO: Se intenta reservar.');
      :v_error:='false';
    ELSE
      DBMS_OUTPUT.PUT_LINE('ERROR: La localidad ya está reservada.');
      :v_error:='true';
    END IF;
  ELSE
    DBMS_OUTPUT.PUT_LINE('ERROR: No existe esa localidad.');
    :v_error:='true';
  END IF;
END;
/
COLUMN SCRIPT_COL NEW_VALUE SCRIPT
SELECT DECODE(TRIM(:v_error),'false','"C:\Users\usuario_local\Downloads\preguntar.sql"','"C:\Users\usuario_local\Downloads\no_preguntar.sql"') AS SCRIPT_COL from dual;
-- v_error es true si ya había reserva o no existe la butaca
PRINT :v_error
--PROMPT 'Valor script: '&SCRIPT
@ &SCRIPT
-- v_confirmar contiene 'n' si ha habido error o el usuario ha decidido no continuar con la reserva. Contendrá 's' si el usuario quiere continuar con la reserva. El usuario debe responder si se le pregunta con 's' o 'n'
PROMPT &v_confirmar
/
BEGIN
  IF '&v_confirmar'='s' AND :v_error='false' THEN
    INSERT INTO reservas VALUES (Seq_Reservas.NEXTVAL,'&v_evento','&v_fila','&v_columna');
    DBMS_OUTPUT.PUT_LINE('INFO: Localidad reservada.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('INFO: No se ha reservado la localidad.');
  END IF;
END;
/
COMMIT;
