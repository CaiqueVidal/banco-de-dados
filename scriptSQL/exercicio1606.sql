CREATE DATABASE exercicio1606
GO
USE exercicio1606

CREATE TABLE Autores (
	cod				INT				NOT NULL		IDENTITY(10001, 1),
	nome			VARCHAR(40)		NOT NULL,
	pais			VARCHAR(20),
	biografia		VARCHAR(50)
	PRIMARY KEY (cod)
)

CREATE TABLE Clientes (
	cod				INT				NOT NULL		IDENTITY(1001, 1),
	nome			VARCHAR(40)		NOT NULL,
	logradouro		VARCHAR(40),
	numero			INT,
	telefone		CHAR(9)
	PRIMARY KEY (cod)
)

CREATE TABLE Corredores (
	cod				INT				NOT NULL		IDENTITY(3251, 1),
	tipo			VARCHAR(20)		NOT NULL
	PRIMARY KEY (cod)
)

GO

CREATE TABLE Livros (
	cod				INT				NOT NULL		IDENTITY(1, 1),
	nome			VARCHAR(50)		NOT NULL,
	cod_autor		INT				NOT NULL,
	pag				INT				NOT NULL,
	idioma			VARCHAR(20)		NOT NULL,
	cod_corredor	INT				NOT NULL
	PRIMARY KEY (cod)
	FOREIGN KEY (cod_autor) REFERENCES Autores(cod),
	FOREIGN KEY (cod_corredor) REFERENCES Corredores(cod)
)

GO

CREATE TABLE Emprestimo (
	cod_cli			INT				NOT NULL,
	cod_livro		INT				NOT NULL,
	data			DATE			NOT NULL
	PRIMARY KEY (cod_cli, cod_livro)
	FOREIGN KEY (cod_cli) REFERENCES Clientes(cod),
	FOREIGN KEY (cod_livro) REFERENCES Livros(cod)
)

GO

INSERT INTO Autores VALUES 
	('Ramez E. Elmasri', 'EUA', 'Professor da Universidade do Texas'),
	('Andrew Tannenbaum', 'Holanda', 'Desenvolvedor do Minix'),
	('Diva Marília Flemming', 'Brasil', 'Professora Adjunta da UFSC'),
	('David Halliday', 'EUA', 'Ph.D. da University of Pittsburgh'),
	('Marco Antonio Furlan de Souza', 'Brasil', 'Prof. do IMT'),
	('Alfredo Steinbruch', 'Brasil', 'Professor de Matemática da UFRS e da PUCRS')

INSERT INTO Clientes VALUES
	('Luis Augusto', 'R. 25 de Março', 250, '996529632'),
	('Maria Luisa', 'R. XV de Novembro', 890, '998526541'),
	('Claudio Batista', 'R. Anhaia', 112, '996547896'),
	('Wilson Mendes', 'R. do Hipódromo', 1250, '991254789'),
	('Ana Maria', 'R. Augusta', 896, '999365589'),
	('Cinthia Souza', 'R. Voluntários da Pátria', 1023, '984256398'),
	('Luciano Britto', NULL, NULL, '995678556'),
	('Antônio do Valle', 'R. Sete de Setembro', 1894, NULL)

INSERT INTO Corredores VALUES
	('Informática'),
	('Matemática'),
	('Física'),
	('Química')

GO

INSERT INTO Livros (cod_autor, cod_corredor, nome, pag, idioma) VALUES
	(10001, 3251, 'Sistemas de Banco de dados', 720, 'Português'), 
	(10002, 3251, 'Sistemas Operacionais Modernos', 580, 'Português'), 
	(10003, 3252, 'Calculo A', 290, 'Português'),
	(10004, 3253, 'Fundamentos de Física I', 185, 'Português'), 
	(10005, 3251, 'Algoritmos e Lógica de Programação', 90, 'Português'), 
	(10006, 3252, 'Geometria Analítica', 75, 'Português'),
	(10004, 3253, 'Fundamentos de Física II', 150, 'Português'), 
	(10002, 3251, 'Redes de Computadores', 493, 'Inglês'),
	(10002, 3251, 'Organização Estruturada de Computadores', 576, 'Português')

GO

INSERT INTO Emprestimo (cod_cli, data, cod_livro) VALUES 
	(1001, '2012-05-10 00:00:00.000', 1),
	(1001, '2012-05-10 00:00:00.000', 2),
	(1001, '2012-05-10 00:00:00.000', 8),
	(1002, '2012-05-11 00:00:00.000', 4),
	(1002, '2012-05-11 00:00:00.000', 7),
	(1003, '2012-05-12 00:00:00.000', 3),
	(1004, '2012-05-14 00:00:00.000', 5),
	(1001, '2012-05-15 00:00:00.000', 9)


-- Fazer uma consulta que retorne o nome do cliente e a data do empréstimo formatada padrão BR (dd/mm/yyyy)
SELECT c.nome,
		CONVERT(CHAR(10), p.data,103) AS data
FROM Clientes c, Emprestimo p
WHERE c.cod = p.cod_cli
GROUP BY c.nome, p.data


-- Fazer uma consulta que retorne Nome do autor e Quantos livros foram escritos por Cada autor, ordenado pelo número de livros. 
-- Se o nome do autor tiver mais de 25 caracteres, mostrar só os 13 primeiros.*/
SELECT CASE WHEN (LEN(a.nome) > 25) THEN
			SUBSTRING(a.nome, 1, 13)
		ELSE 
			a.nome
		END AS nome,
		COUNT(l.cod_autor) AS quantidade
FROM Autores a INNER JOIN Livros l
ON a.cod = l.cod_autor
GROUP BY a.nome
ORDER BY quantidade


-- Fazer uma consulta que retorne o nome do autor e o país de origem do livro com maior número de páginas cadastrados no sistema
SELECT a.nome, a.pais
FROM Autores a, Livros l
WHERE a.cod = l.cod_autor 
	AND l.pag IN 
	(SELECT MAX(pag)
	FROM Livros)


-- Fazer uma consulta que retorne nome e endereço concatenado dos clientes que tem livros emprestados
SELECT DISTINCT c.nome,
		c.logradouro+', '+CAST(c.numero AS VARCHAR(5)) AS endereço
FROM Clientes c, Emprestimo e
WHERE c.cod = e.cod_cli


/*
Nome dos Clientes, sem repetir e, concatenados como
enderço_telefone, o logradouro, o numero e o telefone) dos
clientes que Não pegaram livros. Se o logradouro e o 
número forem nulos e o telefone não for nulo, mostrar só o telefone. 
Se o telefone for nulo e o logradouro e o número não forem nulos, mostrar só logradouro e número. 
Se os três existirem, mostrar os três.
O telefone deve estar mascarado XXXXX-XXXX
*/
SELECT DISTINCT c.nome,
		CASE WHEN ((c.logradouro IS NULL ) AND (c.numero IS NULL)) THEN
			SUBSTRING(c.telefone,1,5)+'-'+SUBSTRING(c.telefone,6,9)
		WHEN (c.telefone IS NULL) THEN
			c.logradouro+', '+CAST(c.numero AS VARCHAR(5))
		ELSE
			c.logradouro+', '+CAST(c.numero AS VARCHAR(5))+' - '+SUBSTRING(c.telefone,1,5)+'-'+SUBSTRING(c.telefone,6,9)
		END AS endereço_telefone
FROM Clientes c LEFT OUTER JOIN Emprestimo e
ON c.cod = e.cod_cli
WHERE e.cod_cli IS NULL


-- Fazer uma consulta que retorne Quantos livros não foram emprestados
SELECT COUNT(l.cod) total_nao_emprestados
FROM Livros l LEFT OUTER JOIN Emprestimo e
ON e.cod_livro = l.cod
WHERE e.cod_livro IS NULL


-- Fazer uma consulta que retorne Nome do Autor, Tipo do corredor e quantos livros, ordenados por quantidade de livro
SELECT a.nome, c.tipo, COUNT(l.cod_corredor) quantidade
FROM Autores a INNER JOIN Livros l
ON a.cod = l.cod_autor
INNER JOIN Corredores c
ON c.cod = l.cod_corredor
GROUP BY a.nome, c.tipo
ORDER BY quantidade


-- Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do cliente, o nome do livro, o total de dias que cada um está com o livro e,
-- uma coluna que apresente, caso o número de dias seja superior a 4, apresente 'Atrasado', caso contrário, apresente 'No Prazo'
SELECT c.nome AS cliente,
		l.nome AS livro,
		DATEDIFF(DAY, e.data, '18/05/2012') AS total_dias,
		CASE WHEN (DATEDIFF(DAY, e.data, '18/05/2012') > 4) THEN
			'Atrasado'
		ELSE
			'No prazo'
		END AS situação
FROM Clientes c INNER JOIN Emprestimo e
ON c.cod = e.cod_cli
INNER JOIN Livros L
ON l.cod = e.cod_livro


-- Fazer uma consulta que retorne cod de corredores, tipo de corredores e quantos livros tem em cada corredor
SELECT c.cod, c.tipo, COUNT(l.cod_corredor) quantidade
FROM Corredores c LEFT OUTER JOIN Livros l
ON c.cod = l.cod_corredor
GROUP BY c.cod, c.tipo


-- Fazer uma consulta que retorne o Nome dos autores cuja quantidade de livros cadastrado é maior ou igual a 2.
SELECT a.nome
FROM Autores a,Livros l
WHERE a.cod = l.cod_autor
GROUP BY a.nome
HAVING COUNT(l.cod_autor) >= 2


-- Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do cliente, o nome do livro dos empréstimos que tem 7 dias ou mais
SELECT		c.nome AS cliente,
			l.nome AS livro
FROM		Clientes c, Livros l, emprestimo e
WHERE		c.cod = e.cod_cli AND
			l.cod = e.cod_livro
GROUP BY	c.nome, l.nome, e.data
HAVING		(DATEDIFF(DAY, e.data, '18/05/2012') >=7)