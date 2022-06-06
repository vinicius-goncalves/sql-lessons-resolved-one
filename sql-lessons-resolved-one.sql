CREATE TABLE IF NOT EXISTS precos(
 `ID_NF` TINYINT UNSIGNED NOT NULL,
 `ID_ITEM` TINYINT UNSIGNED NOT NULL, 
 `COD_PROD` TINYINT UNSIGNED NOT NULL, 
 `VALOR_UNIT` DECIMAL(4,2) NOT NULL,
 `DESCONTO` TINYINT UNSIGNED DEFAULT 0);
 
 /* 
 Some 'precos' inserted here
 */

INSERT INTO precos VALUES
(1, 4, 4, 10.00, 1, NULL),
(1, 5, 5, 30.00, 1, NULL),
(2, 1, 3, 15.00, 4, NULL),
(2, 2, 4, 10.00, 5, NULL),
(2, 3, 5, 30.00, 7, NULL),
(3, 1, 1, 25.00, 5, NULL),
(3, 2, 4, 10.00, 4, NULL),
(3, 3, 5, 30.00, 5, NULL),
(3, 4, 2, 13.50, 7, NULL),
(4, 1, 5, 30.00, 10, 15),
(4, 2, 4, 10.00, 12, 5),
(4, 3, 1, 25.00, 13, 5),
(4, 4, 2, 13.50, 15, 5),
(5, 1, 3, 15.00, 3, NULL),
(5, 2, 5, 30.00, 6, NULL),
(5, 2, 5, 30.00, 6, NULL), 
(6, 1, 1, 25.00, 22, 15), 
(6, 2, 3, 15.00, 25, 20), 
(7, 1, 1, 25.00, 10, 3), 
(7, 2, 2, 13.50, 10, 4), 
(7, 3, 3, 15.00, 10, 4), 
(7, 4, 5, 30.00, 10, 1);

SELECT * FROM precos;

/*
Pesquise os itens que foram vendidos sem desconto. As colunas presentes no 
resultado da consulta são: ID_NF, ID_ITEM, COD_PROD E VALOR_UNIT
*/

#-- First resolution
SELECT ID_NF, ID_ITEM, COD_PROD, VALOR_UNIT FROM precos WHERE desconto IS NULL;

#-- Second resolution
SELECT ID_NF, ID_ITEM, COD_PROD, VALOR_UNIT, 
	CASE
		WHEN desconto IS NULL THEN 'Desconto NÃO aplicado'
        ELSE 'Desconto aplicado'
	END 'Resultado do desconto'
FROM precos;

#-- Third -resolution
SELECT *, IF(desconto IS NULL, "SIM", "NÃO") FROM precos;

#SELECT ID_NF, ID_ITEM, COD_PROD, VALOR_UNIT, DESCONTO FROM precos WHERE desconto IS NULL;

/*
Pesquise os itens que foram vendidos com desconto. As colunas presentes no 
resultado da consulta são: ID_NF, ID_ITEM, COD_PROD, VALOR_UNIT E O VALOR 
VENDIDO. OBS: O valor vendido é igual ao VALOR_UNIT -
(VALOR_UNIT*(DESCONTO/100))
*/

SELECT *, ROUND((VALOR_UNIT - VALOR_UNIT * (DESCONTO / 100)), 2) AS `Preço final` FROM precos WHERE desconto IS NOT NULL;

/*
Altere o valor do desconto (para zero) de todos os registros onde este campo é nulo.
*/

SELECT * FROM precos WHERE desconto IS NULL;

UPDATE precos SET desconto = 0 WHERE desconto IS NULL;

SELECT * FROM precos;

/*
Pesquise os itens que foram vendidos. As colunas presentes no resultado da consulta 
são: ID_NF, ID_ITEM, COD_PROD, VALOR_UNIT, VALOR_TOTAL, DESCONTO, 
VALOR_VENDIDO. OBS: O VALOR_TOTAL é obtido pela fórmula: QUANTIDADE * 
VALOR_UNIT. O VALOR_VENDIDO é igual a VALOR_UNIT -
(VALOR_UNIT*(DESCONTO/100))
*/

SELECT *, VALOR_UNIT * QUANTIDADE AS `[$] Total vendidos` FROM precos;

SELECT *, 
	ROUND(((VALOR_UNIT - VALOR_UNIT * (VALOR_UNIT/100))) * QUANTIDADE, 2) 
		AS '[$] Total vendidos com desconto', (VALOR_UNIT * QUANTIDADE) `[X] Total vendidos sem desconto` FROM precos;

/*
Pesquise o valor total das NF e ordene o resultado do maior valor para o menor. As 
colunas presentes no resultado da consulta são: ID_NF, VALOR_TOTAL. OBS: O 
VALOR_TOTAL é obtido pela fórmula: ∑ QUANTIDADE * VALOR_UNIT. Agrupe o 
resultado da consulta por ID_NF
*/

#SELECT ID_NF, AS VALOR_TOTAL  FROM precos;

SELECT * FROM precos;


SELECT ID_NF, COUNT(*), VALOR_UNIT * QUANTIDADE AS VALOR_TOTAL FROM precos GROUP BY ID_NF ORDER BY VALOR_TOTAL DESC;








