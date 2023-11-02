--T1

--APARTADO 1
CREATE TABLE cuentas (
numero number primary key,
 saldo number not null
 );

INSERT INTO cuentas VALUES (123, 400);
INSERT INTO cuentas VALUES (456, 300);
COMMIT;

SET AUTOCOMMIT OFF;

UPDATE cuentas SET saldo = saldo + 100 WHERE numero = 123;

COMMIT;

-- APARTADO 2
UPDATE cuentas SET saldo = saldo + 100 WHERE numero = 123;

COMMIT;

--APARTADO 3
UPDATE cuentas SET saldo = saldo + 100 WHERE numero = 123;

UPDATE cuentas SET saldo = saldo + 300 WHERE numero = 456;

COMMIT;

--APARTADO 4
ALTER SESSION SET ISOLATION_LEVEL = SERIALIZABLE;

SELECT SUM(saldo) FROM cuentas;

SELECT SUM(saldo) FROM cuentas;

ALTER SESSION SET ISOLATION_LEVEL = READ COMMITTED;

SELECT SUM(saldo) FROM cuentas;

SELECT SUM(saldo) FROM cuentas;

