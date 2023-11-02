--1A)
CREATE TABLE pedidos (
  c�digo CHAR(6) PRIMARY KEY, 
  fecha  CHAR(10), 
  importe NUMBER(6,2), 
  cliente   CHAR(20),
  notas CHAR(1024),
  especial CHAR(1),
  CHECK (especial IN ('S','N')),
  CHECK(fecha LIKE '__/__/____')
  );
  
  CREATE TABLE contiene(
  pedido CHAR(6) REFERENCES pedidos(c�digo),
  plato CHAR(20),
  precio NUMBER(6,2) DEFAULT 0,
  unidades NUMBER(2,0) DEFAULT 0,
  PRIMARY KEY(pedido, plato),
  CHECK(precio >= 0 AND unidades >= 0)
  );
  
  CREATE TABLE auditor�a (
  operaci�n CHAR(6),
  tabla CHAR(50),
  fecha CHAR(10),
  hora CHAR(8),
  CHECK(fecha LIKE '__/__/____'),
  CHECK(hora LIKE '__:__:__')
  );
  
  INSERT INTO PEDIDOS VALUES ('0', '18/11/2022', 10, 'Laura Mac�as', '', 'S');
  INSERT INTO AUDITOR�A VALUES ('INSERT', 'PEDIDOS', '18/11/2022', '13:25:00');
  INSERT INTO CONTIENE VALUES ('0', 'Tortilla de patata', 5, 2);
  INSERT INTO AUDITOR�A VALUES ('INSERT', 'CONTIENE', '18/11/2022', '13:25:00');

  INSERT INTO PEDIDOS VALUES ('1', '18/11/2022', 52.8, 'Leonardo Rodrigo', 'Esto es una nota', 'N');
  INSERT INTO AUDITOR�A VALUES ('INSERT', 'PEDIDOS', '18/11/2022', '13:30:00');
  INSERT INTO CONTIENE VALUES ('1', 'Jam�n', 50, 1);
  INSERT INTO AUDITOR�A VALUES ('INSERT', 'CONTIENE', '18/11/2022', '13:30:00');
  INSERT INTO CONTIENE VALUES ('1', 'Pan', 2.8, 1);
  INSERT INTO AUDITOR�A VALUES ('INSERT', 'CONTIENE', '18/11/2022', '13:33:00');
  
--1B)
  CREATE OR REPLACE TRIGGER tr_pedidos
  AFTER INSERT OR UPDATE OR DELETE ON pedidos
  --STATEMENT POR DEFECTO
  DECLARE
  v_operaci�n CHAR(6) := 'INSERT';
  BEGIN
  IF UPDATING THEN
    v_operaci�n := 'UPDATE';
  ELSIF DELETING THEN
    v_operaci�n := 'DELETE';
  END IF;
  
  INSERT INTO AUDITOR�A VALUES (v_operaci�n, 'PEDIDOS', to_char(sysdate,'dd/mm/yyyy'),  to_char(sysdate,'hh:mi:ss'));

  END;
  
  INSERT INTO PEDIDOS VALUES ('2', '18/11/2022', 1, 'Fernando S�enz', '', 'S');
  UPDATE PEDIDOS SET notas = 'Esto se ha a�adido m�s tarde' WHERE c�digo = '2';
  DELETE FROM PEDIDOS WHERE c�digo = '2';
  
--2
  CREATE OR REPLACE TRIGGER tr_contiene
  AFTER INSERT OR UPDATE OR DELETE ON contiene
  FOR EACH ROW
  DECLARE
  v_importe CHAR(6);
  v_pedido CHAR(6);
  BEGIN
  
  IF UPDATING OR INSERTING THEN
  SELECT importe
  INTO v_importe
  FROM PEDIDOS
  WHERE c�digo = :NEW.pedido;
  
  ELSE
  SELECT importe
  INTO v_importe
  FROM PEDIDOS
  WHERE c�digo = :OLD.pedido;
  END IF;

  IF UPDATING THEN
    IF :OLD.pedido <> :NEW.pedido THEN
        UPDATE PEDIDOS SET importe = importe - (:OLD.precio*:OLD.unidades)  where c�digo = :OLD.pedido; 
        v_importe := v_importe + :NEW.precio*:NEW.unidades;
    ELSE
        v_importe := v_importe - :OLD.precio*:OLD.unidades + :NEW.precio*:NEW.unidades;
    END IF;
    v_pedido := :NEW.pedido;
  ELSIF INSERTING THEN
    v_importe := v_importe + :NEW.precio*:NEW.unidades;
    v_pedido := :NEW.pedido;
  ELSIF DELETING THEN
    v_importe :=  v_importe - :OLD.precio*:OLD.unidades;
    v_pedido := :OLD.pedido;
  END IF;

  UPDATE PEDIDOS SET importe = v_importe where c�digo = v_pedido;  
  
  END;
  
  INSERT INTO CONTIENE VALUES ('0', 'Gazpacho', 4.5, 2);
  DELETE FROM CONTIENE WHERE pedido = '1' AND plato = 'Pan';
