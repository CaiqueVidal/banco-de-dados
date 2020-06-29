CREATE DATABASE exercicio2306
GO
USE exercicio2306

CREATE TABLE cliente (
	cpf				CHAR(11)		NOT NULL,
	nome			VARCHAR(20)		NOT NULL,
	telefone		CHAR(8)			NOT NULL
	PRIMARY KEY (cpf)
)

CREATE TABLE fornecedor (
	ID				INT				NOT NULL,
	nome			VARCHAR(20)		NOT NULL,
	logradouro		VARCHAR(20)		NOT NULL,
	numero			INT				NOT NULL,
	complemento		VARCHAR(10)		NOT NULL,
	cidade			VARCHAR(20)
	PRIMARY KEY(ID)
)

GO

CREATE TABLE produto (
	codigo			INT				NOT NULL,
	descricao		VARCHAR(40)		NOT NULL,
	fornecedor		INT,
	preco			DECIMAL(7,2)	NOT NULL
	PRIMARY KEY (codigo)
	FOREIGN KEY (fornecedor) REFERENCES fornecedor(ID)
)

GO

CREATE TABLE venda (
	codigo			INT				NOT NULL,
	produto			INT				NOT NULL,
	cliente			CHAR(11)		NOT NULL,
	quantidade		INT				NOT NULL,
	valor_total		DECIMAL(7,2)	NOT NULL,
	data			DATE			NOT NULL
	PRIMARY KEY (codigo, produto, cliente, data)
	FOREIGN KEY (produto) REFERENCES produto(codigo),
	FOREIGN KEY (cliente) REFERENCES cliente(cpf)
)

GO

INSERT INTO cliente VALUES 
	('25186533710', 'Maria Antonia', '87652314'),
	('34578909290', 'Julio Cesar', '82736541'),
	('79182639800', 'Paulo Cesar', '90765273'),
	('87627315416', 'Luiz Carlos', '61289012'),
	('36587498700', 'Paula Carla', '23547888')

INSERT INTO fornecedor VALUES
	(1, 'LG', 'Rod. Bandeirantes', 70000, 'Km 70', 'Itapeva'),
	(2, 'Asus', 'Av. Nações Unidas', 10206, 'Sala 225', 'São Paulo'),
	(3, 'AMD', 'Av. Nações Unidas', 10206, 'Sala 1095', 'São Paulo'),
	(4, 'Leadership', 'Av. Nações Unidas', 10206, 'Sala 87', 'São Paulo'),
	(5, 'Inno', 'Av. Nações Unidas', 10206, 'Sala 34', 'São Paulo'),
	(6, 'Kingston', 'Av. Nações Unidas', 10206, 'Sala 18', 'São Paulo')

GO

INSERT INTO produto VALUES
	(1, 'Monitor 19 pol.', 1, 449.99),
	(2, 'Zenfone', 2, 1599.99),
	(3, 'Gravador de DVD - Sata', 1, 99.99),
	(4, 'Leitor de CD', 1, 49.99),
	(5, 'Processador - Ryzen 5', 3, 599.99),
	(6, 'Mouse', 4, 19.99),
	(7, 'Teclado', 4, 25.99),
	(8, 'Placa de Video - RTX 2060', 2, 2399.99),
	(9, 'Pente de Memória 4GB DDR 4 2400 MHz', 5, 259.99)

GO

INSERT INTO venda VALUES
	(1, 1, '25186533710', 1, 449.99, '2009-09-03'),
	(1, 4, '25186533710', 1, 49.99, '2009-09-03'),
	(1, 5, '25186533710', 1, 349.99, '2009-09-03'),
	(2, 6, '79182639800', 4, 79.96, '2009-09-06'),
	(3, 3, '87627315416', 1, 99.99, '2009-09-06'),
	(3, 7, '87627315416', 1, 25.99, '2009-09-06'),
	(3, 8, '87627315416', 1, 599.99, '2009-09-06'),
	(4, 2, '34578909290', 2, 1399.98, '2009-09-08')

GO

--Quantos produtos não foram vendidos ?
SELECT COUNT(p.codigo) As não_vendidos
FROM produto p LEFT OUTER JOIN venda v
ON p.codigo = v.produto
WHERE v.produto IS NULL


--Nome do produto, Nome do fornecedor, count() do produto nas vendas
SELECT p.descricao AS nome,
		 f.nome AS fornecedor, 
		 COUNT(v.produto) * v.quantidade AS quantidade_vendida
FROM  fornecedor f INNER JOIN produto p 
ON f.ID = p.fornecedor
LEFT OUTER JOIN venda v
ON p.codigo = v.produto
GROUP BY v.quantidade, p.descricao, f.nome
ORDER BY v.quantidade DESC


--Nome do cliente e Quantos produtos cada um comprou ordenado pela quantidade  --XXXX
SELECT c.nome, 
		SUM(v.quantidade) AS quantidade_comprada
FROM cliente c, venda v
Where c.cpf = v.cliente
GROUP BY c.nome, v.quantidade
ORDER BY quantidade_comprada DESC


--Nome do produto e Quantidade de vendas do produto com menor valor do catálogo de produtos
SELECT p.descricao,
		COUNT(v.produto) AS quantidade_vendas
FROM produto p INNER JOIN venda v
ON p.codigo = v.produto
WHERE p.preco IN (
SELECT MIN (preco) 
FROM produto)
GROUP BY p.descricao


--Nome do Fornecedor e Quantos produtos cada um fornece
SELECT f.nome,
		COUNT(p.fornecedor) AS quantidade_produto
FROM fornecedor f, produto p
WHERE f.ID = p.fornecedor
GROUP BY f.nome
ORDER BY quantidade_produto DESC


--Considerando que hoje é 20/10/2009, consultar o código da compra, nome do cliente, telefone do cliente e quantos dias da data da compra
SELECT DISTINCT v.codigo AS cod_venda,
		c.nome AS cliente,
		c.telefone,
		DATEDIFF(DAY, v.data, '20/10/2009') AS dias_atrás
FROM venda v, cliente c
WHERE c.cpf = v.cliente


--CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do cliente e quantidade que comprou mais de 2 produtos
SELECT SUBSTRING(c.cpf, 1, 3) + '.' + SUBSTRING(c.cpf, 4, 3) + '.' 
		+ SUBSTRING(c.cpf, 7, 3) + '-' + SUBSTRING(c.cpf, 10, 2) AS cpf,
		c.nome,
		COUNT(v.produto) * v.quantidade AS quantidade_produtos
FROM cliente c, venda v
WHERE c.cpf = v.cliente
GROUP BY cpf, c.nome, v.quantidade
HAVING COUNT(v.produto) > 2


--CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do Cliente e Soma do valor_total gasto
SELECT SUBSTRING(c.cpf, 1, 3) + '.' + SUBSTRING(c.cpf, 4, 3) + '.' 
		+ SUBSTRING(c.cpf, 7, 3) + '-' + SUBSTRING(c.cpf, 10, 2) AS cpf,
		c.nome,
		SUM(v.valor_total) AS total_gasto
FROM cliente c, venda v
WHERE c.cpf = v.cliente
GROUP BY cpf, c.nome
ORDER BY total_gasto DESC


--Código da compra, data da compra em formato (DD/MM/AAAA) e uma coluna, chamada dia_semana, que escreva o dia da semana por extenso.
--Exemplo: Caso dia da semana 1, escrever domingo. Caso 2, escrever segunda-feira, assim por diante, até caso dia 7, escrever sábado
SELECT DISTINCT	v.codigo,
		CONVERT(CHAR, v.data, 103) AS data,
		DATENAME(WEEKDAY, v.data) AS dia_semana
FROM venda v