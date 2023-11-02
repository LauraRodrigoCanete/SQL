--T2
-- APARTADO 1
SET AUTOCOMMIT OFF;


-- APARTADO 2
UPDATE cuentas SET saldo = saldo + 200 WHERE numero = 123;

COMMIT;

--APARTADO 3
UPDATE cuentas SET saldo = saldo + 200 WHERE numero = 456;

UPDATE cuentas SET saldo = saldo + 400 WHERE numero = 123;

--APARTADO 4
UPDATE cuentas SET saldo=saldo+100;
COMMIT;

UPDATE cuentas SET saldo = saldo+100; 
COMMIT;

