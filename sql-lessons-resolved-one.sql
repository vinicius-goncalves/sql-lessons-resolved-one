/*
You can find these lessons on the page: https://docente.ifrn.edu.br/nickersonferreira/disciplinas/programacao-com-acesso-a-banco-de-dados-3o-ano/lista-de-exercicios-sql/view
*/
CREATE TABLE IF NOT EXISTS precos(
 `ID_NF` TINYINT UNSIGNED NOT NULL,
 `ID_ITEM` TINYINT UNSIGNED NOT NULL, 
 `COD_PROD` TINYINT UNSIGNED NOT NULL, 
 `VALOR_UNIT` DECIMAL(4,2) NOT NULL,
 `DESCONTO` TINYINT UNSIGNED DEFAULT 0);
 
 /* 
 Some 'precos' inserted here;
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
	ROUND(((VALOR_UNIT - VALOR_UNIT * (DESCONTO/100))) * QUANTIDADE, 2) 
		AS '[$] Total vendidos com desconto', (VALOR_UNIT * QUANTIDADE) AS '[X] Total vendidos sem desconto' FROM precos;

/*
Pesquise o valor total das NF e ordene o resultado do maior valor para o menor. As 
colunas presentes no resultado da consulta são: ID_NF, VALOR_TOTAL. OBS: O 
VALOR_TOTAL é obtido pela fórmula: ∑ QUANTIDADE * VALOR_UNIT. Agrupe o 
resultado da consulta por ID_NF
*/

#SELECT ID_NF, AS VALOR_TOTAL  FROM precos;

SELECT * FROM precos;

SELECT ID_NF, COUNT(*), VALOR_UNIT * QUANTIDADE AS VALOR_TOTAL FROM precos GROUP BY ID_NF ORDER BY VALOR_TOTAL DESC;

/*
Pesquise o valor vendido das NF e ordene o resultado do maior valor para o menor. As 
colunas presentes no resultado da consulta são: ID_NF, VALOR_VENDIDO. OBS: O 
VALOR_TOTAL é obtido pela fórmula: ∑ QUANTIDADE * VALOR_UNIT. O 
VALOR_VENDIDO é igual a ∑ VALOR_UNIT - (VALOR_UNIT*(DESCONTO/100)). Agrupe 
o resultado da consulta por ID_NF.
*/

SELECT * FROM precos;
SELECT 
	ID_NF, 
	SUM(ROUND(VALOR_UNIT - (VALOR_UNIT * (DESCONTO/100)), 2) * QUANTIDADE) AS 'VALOR_VENDIDO (com desconto)', 
	SUM(VALOR_UNIT * QUANTIDADE) AS 'VALOR_TOTAL' FROM precos GROUP BY ID_NF ORDER BY VALOR_TOTAL DESC; 
    
/*
Consulte o produto que mais vendeu no geral. As colunas presentes no resultado da 
consulta são: COD_PROD, QUANTIDADE. Agrupe o resultado da consulta por 
COD_PROD
*/

SELECT * FROM precos;
SELECT COD_PROD, SUM(QUANTIDADE) AS 'MAIS_VENDIDO' FROM precos GROUP BY COD_PROD ORDER BY MAIS_VENDIDO DESC LIMIT 1;

/*
Consulte as NF que foram vendidas mais de 10 unidades de pelo menos um produto. 
As colunas presentes no resultado da consulta são: ID_NF, COD_PROD, QUANTIDADE.
Agrupe o resultado da consulta por ID_NF, COD_PROD.
*/

#?
SELECT * FROM precos;
SELECT ID_NF, COD_PROD, QUANTIDADE FROM precos WHERE QUANTIDADE > 10;

/*
Pesquise o valor total das NF, onde esse valor seja maior que 500, e ordene o 
resultado do maior valor para o menor. As colunas presentes no resultado da consulta 
são: ID_NF, VALOR_TOT. OBS: O VALOR_TOTAL é obtido pela fórmula: ∑ QUANTIDADE 
* VALOR_UNIT. Agrupe o resultado da consulta por ID_NF
*/

SELECT * FROM precos;

SELECT ID_NF, SUM(VALOR_UNIT * QUANTIDADE) AS 'VALOR_TOTAL' FROM precos GROUP BY ID_NF HAVING VALOR_TOTAL > 500;

/*
Qual o valor médio dos descontos dados por produto. As colunas presentes no 
resultado da consulta são: COD_PROD, MEDIA. Agrupe o resultado da consulta por 
COD_PROD.
*/

SELECT * FROM precos;
SELECT ID_NF, SUM(VALOR_UNIT * QUANTIDADE) FROM precos GROUP BY ID_NF;
#?
SELECT COD_PROD, ROUND(AVG((VALOR_UNIT - VALOR_UNIT * (DESCONTO / 100))), 2) AS 'MEDIA' FROM precos GROUP BY COD_PROD;

/*
Quais as NF que possuem mais de 3 itens vendidos. As colunas presentes no resultado 
da consulta são: ID_NF, QTD_ITENS. OBS:: NÃO ESTÁ RELACIONADO A QUANTIDADE 
VENDIDA DO ITEM E SIM A QUANTIDADE DE ITENS POR NOTA FISCAL. Agrupe o 
resultado da consulta por ID_NF.
*/

SELECT * FROM precos;
#?
SELECT ID_NF, ID_ITEM FROM precos WHERE ID_ITEM > 3 GROUP BY ID_NF;

#--------------------------------------

/*
Crie uma base de dados Universidade com as tabelas a seguir:
Alunos (MAT, nome, endereço, cidade)
Disciplinas (COD_DISC, nome_disc, carga_hor)
Professores (COD_PROF, nome, endereço, cidade)
Turma (COD_DISC, COD_TURMA, COD_PROF, ANO, horário)
 COD_DISC referencia Disciplinas
 COD_PROF referencia Professores
Histórico (MAT, COD_DISC, COD_TURMA, COD_PROF, ANO, frequência, nota)
 MAT referencia Alunos
 COD_DISC, COD_TURMA, COD_PROF, ANO referencia Turma
*/
CREATE TABLE IF NOT EXISTS alunos(`MAT` INT UNIQUE KEY, `nome` VARCHAR(255), enedereço VARCHAR(255), cidade VARCHAR(255));
CREATE TABLE IF NOT EXISTS disciplinas(`COD_DISC` INT UNIQUE KEY, `nome_disc` VARCHAR(255), `carga_hor` VARCHAR(255));
CREATE TABLE IF NOT EXISTS professores(`COD_PROF` INT UNIQUE KEY, `nome` VARCHAR(255), `endereço` VARCHAR(255), `cidade` VARCHAR(255));
CREATE TABLE IF NOT EXISTS turma(`COD_DISC` VARCHAR(255), `COD_TURMA` INT UNIQUE KEY, `COD_PROF` INT UNIQUE KEY, horario DATE);
CREATE TABLE IF NOT EXISTS historico(`MAT` INT UNIQUE KEY, `COD_DISC` INT UNIQUE KEY, COD_TURMA INT UNIQUE KEY, COD_PROF INT UNIQUE KEY, ANO DATE);

INSERT INTO alunos VALUES (2015010101, 'JOSE DE ALENCAR', 'RUA DAS ALMAS', 'NATAL'),
(2015010102, 'JOÃO JOSÉ', 'AVENIDA RUY CARNEIRO', 'JOÃO PESSOA'),
(2015010103, 'MARIA JOAQUINA', 'RUA CARROSSEL', 'RECIFE'),
(2015010104, 'MARIA DAS DORES', 'RUA DAS LADEIRAS', 'FORTALEZA'),
(2015010105, 'JOSUÉ CLAUDINO DOS SANTOS', 'CENTRO', 'NATAL'),
(2015010106, 'JOSUÉLISSON CLAUDINO DOS SANTOS', 'CENTRO', 'NATAL');

ALTER TABLE disciplinas MODIFY COLUMN `COD_DISC` VARCHAR(255);

INSERT INTO disciplinas VALUES ('BD', 'BANCO DE DADOS', 100),
('POO', 'PROGRAMAÇÃO COM ACESSO A BANCO DE DADOS', 100),
('WEB', 'AUTORIA WEB', 50),
('ENG', 'ENGENHARIA DE SOFTWARE', 80);

INSERT INTO professores VALUES (212131, 'NICKERSON FERREIRA', 'RUA MANAÍRA', 'JOÃO PESSOA'),
(122135, 'ADORILSON BEZERRA', 'AVENIDA SALGADO FILHO', 'NATAL'),
(192011, 'DIEGO OLIVEIRA', 'AVENIDA ROBERTO FREIRE', 'NATAL');

ALTER TABLE turma MODIFY COLUMN horario VARCHAR(255);

ALTER TABLE turma ADD COLUMN ano TINYINT UNSIGNED;
ALTER TABLE turma MODIFY COLUMN COD_TURMA VARCHAR(255);
ALTER TABLE turma DROP INDEX COD_TURMA;
ALTER TABLE turma DROP INDEX COD_PROF;
SHOW INDEX FROM turma;

DESCRIBE turma;

INSERT INTO turma VALUES 
('BD', 2, 212131, 2015, '13H-14H'),
('POO', 1, 192011, 2015, '08H-09H'),
('WEB', 1, 192011, 2015, '07H-08H'),
('ENG', 1, 122135, 2015, '10H-11H');

/*
a) Encontre a MAT dos alunos com nota em BD em 2015 menor que 5 (obs: BD = 
código da disciplinas).
b) Encontre a MAT e calcule a média das notas dos alunos na disciplina de POO 
em 2015.
c) Encontre a MAT e calcule a média das notas dos alunos na disciplina de POO 
em 2015 e que esta média seja superior a 6.
d) Encontre quantos alunos não são de Natal
*/