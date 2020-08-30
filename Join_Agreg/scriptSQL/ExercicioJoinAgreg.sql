CREATE DATABASE JoinAgreg
GO
USE JoinAgreg

CREATE TABLE Cliente (
	Codigo				INT				NOT NULL	IDENTITY(33601, 1),
	Nome				VARCHAR(40)		NOT NULL,
	Endereco			VARCHAR(40)		NOT NULL,
	Numero_Porta		INT				NOT NULL,
	Telefone			CHAR(9)			NOT NULL,
	Data_Nascimento		DATE			NOT NULL
	PRIMARY KEY (Codigo)
)

CREATE TABLE Fornecedores (
	Codigo				INT				NOT NULL	IDENTITY(1001, 1),
	Nome				VARCHAR(40)		NOT NULL,
	Atividade			VARCHAR(40)		NOT NULL,
	Telefone			CHAR(9)		NOT NULL
	PRIMARY KEY (Codigo)
)

CREATE TABLE Produto (
	Codigo				INT				NOT NULL	IDENTITY(1, 1),
	Nome				VARCHAR(40)		NOT NULL,
	Valor_Unitario		DECIMAL(7,2)	NOT NULL,
	Quantidade_Estoque	INT				NOT NULL,
	Descricao			VARCHAR(MAX)	NOT NULL,
	Codigo_Fornecedor	INT				NOT NULL
	PRIMARY KEY (Codigo)
	FOREIGN KEY (Codigo_Fornecedor) REFERENCES Fornecedores(Codigo)
)


CREATE TABLE Pedido (
	Codigo_Pedido		INT				NOT NULL,
	Codigo_Cliente		INT				NOT NULL,
	Codigo_Produto		INT				NOT NULL,
	Quantidade			INT				NOT NULL,
	Previsao_Entrega	DATE			NOT NULL
	PRIMARY KEY (Codigo_Pedido, Codigo_Cliente, Codigo_Produto)
	FOREIGN KEY (Codigo_Cliente) REFERENCES Cliente(Codigo),
	FOREIGN KEY (Codigo_Produto) REFERENCES Produto(Codigo)
)

GO

INSERT INTO Cliente VALUES 
	('Maria Clara', 'R. 1° de Abril', 870, '96325874', '1990-04-15 00:00:00.000'),
	('Alberto Souza', 'R. XV de Novembro', 987, '95873625', '1975-12-25 00:00:00.000'),
	('Sonia Silva', 'R. Voluntários da Pátria', 1152, '75418596', '1944-06-03 00:00:00.000'),
	('José Sobrinho', 'Av. Paulista', 250, '85236547', '1982-10-12 00:00:00.000'),
	('Carlos Camargo', 'Av. Tiquatira', 9652, '75896325', '1975-02-27 00:00:00.000')

INSERT INTO Fornecedores VALUES
	('Estrela', 'Brinquedo', '41525898'),
	('Lacta', 'Chocolate', '42698596'),
	('Asus', 'Informática', '52014596'),
	('Tramontina', 'Utensílios Domésticos', '50563985'),
	('Grow', 'Brinquedos', '47896325'),
	('Mattel', 'Bonecos', '59865898')


INSERT INTO Produto VALUES
	('Banco Imobiliário', 65.00, 15, 'Versão Super Luxo', 1001),
	('Puzzle 5000 peças', 50.00, 5, 'Mapas Mundo', 1005),
	('Faqueiro', 350.00, 0, '120 peças', 1004),
	('Jogo para churrasco', 75.00, 3, '7 peças', 1004),
	('Eee Pc', 750.00, 29, 'Netbook com 4 Gb de HD', 1003),
	('Detetive', 49.00, 0, 'Nova Versão do Jogo', 1001),
	('Chocolate com Paçoquinha', 6.00, 0, 'Barra', 1002),
	('Galak', 5.00, 65, 'Barra', 1002)

INSERT INTO Pedido VALUES
	(99001, 33601, 1, 1, '2017-07-07 00:00:00.000'),
	(99001, 33601, 2, 1, '2017-07-07 00:00:00.000'),
	(99001, 33601, 8, 3, '2017-07-07 00:00:00.000'),
	(99002, 33602, 2, 1, '2017-07-09 00:00:00.000'),
	(99002, 33602, 4, 3, '2017-07-09 00:00:00.000'),
	(99003, 33605, 5, 1, '2017-07-15 00:00:00.000')

GO

--Codigo do produto, nome do produto, quantidade em estoque,
--uma coluna dizendo se está baixo, bom ou confortável,
--uma coluna dizendo o quanto precisa comprar para que o estoque fique minimamente confortável

SELECT Codigo, Nome, Quantidade_Estoque,
		CASE WHEN ( Quantidade_Estoque > 20 ) THEN 
			'Confortável'
		WHEN ( quantidade_estoque >= 10 ) THEN 
			'Bom'
		ELSE
			'Baixo'
		END AS Status_Estoque,
		CASE WHEN (Quantidade_Estoque < 21) THEN
			 (21 - Quantidade_Estoque) 
		END AS Necessário_Para_Confortável
FROM Produto


--Consultar o nome e o telefone dos fornecedores que não tem produtos cadastrados
SELECT	f.Nome, 
		SUBSTRING(f.telefone,1,4)+'-'+SUBSTRING(f.telefone,4,4) as Telefone
FROM Fornecedores f LEFT OUTER JOIN Produto p
ON f.Codigo = p.Codigo_Fornecedor
WHERE p.Codigo_Fornecedor IS NULL


--Consultar o nome e o telefone dos clientes que não tem pedidos cadastrados
SELECT	c.Nome,
		SUBSTRING(c.telefone,1,4)+'-'+SUBSTRING(c.telefone,4,4) as Telefone
FROM Cliente c LEFT OUTER JOIN Pedido p
ON c.Codigo = p.Codigo_Cliente
WHERE p.Codigo_Cliente is NULL


--Considerando a data do sistema, consultar o nome do cliente, 
--endereço concatenado com o número de porta
--o código do pedido e quantos dias faltam para a data prevista para a entrega
--criar, também, uma coluna que escreva ABAIXO para menos de 25 dias de previsão de entrega,
--ADEQUADO entre 25 e 30 dias e ACIMA para previsão superior a 30 dias
--as linhas de saída não devem se repetir e ordenar pela quantidade de dias
SELECT	c.nome,
		c.Endereco+', '+CAST(c.Numero_Porta AS CHAR(5)) AS Endereço_Completo,
		p.Codigo_Pedido,
		DATEDIFF(DAY, GETDATE(), p.Previsao_Entrega) AS Dias_Para_Entrega,
		CASE 
			WHEN ( DATEDIFF(DAY, GETDATE(), p.Previsao_Entrega) < 25 ) THEN
				'ABAIXO'
			WHEN ( DATEDIFF(DAY, GETDATE(), p.Previsao_Entrega)  <= 30 ) THEN
				'ADEQUADO'
			ELSE
				'ACIMA'
		END AS Status_Previsão_Entrega
FROM Cliente c INNER JOIN Pedido p
ON c.Codigo = p.Codigo_Cliente
ORDER BY DATEDIFF(DAY, GETDATE(), p.Previsao_Entrega)


--Consultar o Nome do cliente, o código do pedido, 
--a soma do gasto do cliente no pedido e a quantidade de produtos por pedido
--ordenar pelo nome do cliente
SELECT	c.Nome,
		p.Codigo_Pedido,
		(p.Quantidade * pr.Valor_Unitario) AS Total,
		p.Quantidade
FROM Cliente c, Pedido p, Produto pr
WHERE	c.Codigo = p.Codigo_Cliente
		AND pr.Codigo = p.Codigo_Produto
ORDER BY c.Nome


--Consultar o Código e o nome do Fornecedor e 
--a contagem de quantos produtos ele fornece
SELECT	f.Codigo,
		f.Nome,
		COUNT(p.Nome) AS Total 
FROM Fornecedores f INNER JOIN Produto p
ON f.Codigo = p.Codigo_Fornecedor
GROUP BY f.Codigo, f.Nome


--Consultar o nome e o telefone dos clientes que tem menos de 2 compras feitas
--A query não deve considerar quem fez 2 compras
SELECT	c.Nome,
		SUBSTRING(c.telefone,1,4)+'-'+SUBSTRING(c.telefone,4,4) as Telefone
FROM Cliente c LEFT OUTER JOIN Pedido p
ON c.Codigo = p.Codigo_Cliente
GROUP BY c.Nome, c.Telefone
HAVING COUNT(p.codigo_cliente) < 2


--Consultar o Codigo do pedido que tem o maior valor unitário de produto
SELECT p.Codigo_Pedido
FROM Pedido p INNER JOIN Produto pr
ON p.Codigo_Produto = pr.Codigo
WHERE pr.Valor_Unitario = (
	SELECT MAX(Valor_Unitario)
	FROM Produto)


--Consultar o Codigo_Pedido, o Nome do cliente e o valor total da compra do pedido
--O valor total se dá pela somatória de valor_Unitário * quantidade comprada
SELECT  p.Codigo_Pedido,
		c.Nome,
        SUM(p.Quantidade * pr.Valor_Unitario) AS Total
FROM Cliente c, Pedido p, Produto pr
WHERE   c.Codigo = p.Codigo_Cliente
        AND pr.Codigo = p.Codigo_Produto
GROUP BY c.Nome, p.Codigo_Pedido