/* Exerc�cio 1 -
a)Fazer uma Function que verifique, na tabela produtos (codigo, nome, valor unit�rio e qtd estoque)
Quantos produtos est�o com estoque abaixo de um valor de entrada

b)Fazer uma function que liste o c�digo, o nome e a quantidade dos produtos que est�o com o estoque 
abaixo de um valor de entrada
*/

CREATE DATABASE udf
GO
USE udf

CREATE TABLE produtos (
	codigo			INT,
	nome			VARCHAR(50),
	valor_unitario	DECIMAL(6,2),
	qtd_estoque		INT	
	PRIMARY KEY (codigo)
)

GO
INSERT INTO produtos VALUES
	(1, 'L�pis', 0.35, 12),
	(2, 'Caneta', 1.50, 15),
	(3, 'Borracha', 0.89, 10),
	(4, 'Apontador', 0.40, 8),
	(5, 'Branquinho', 2.45, 10)

GO
CREATE FUNCTION fn_qtd_estoque(@qtd INT)
RETURNS INT
AS
BEGIN
	SELECT @qtd = COUNT(qtd_estoque) FROM produtos WHERE qtd_estoque < @qtd
	RETURN (@qtd)
END

CREATE FUNCTION fn_lista_estoque(@qtd INT)
RETURNS @tabela TABLE(
	codigo			INT,
	nome			VARCHAR(50),
	valor_unitario	DECIMAL(6,2),
	qtd_estoque		INT
)
AS
BEGIN
	INSERT @tabela 
		SELECT * FROM produtos
		WHERE qtd_estoque < @qtd

	RETURN
END

GO
SELECT dbo.fn_qtd_estoque(12) AS Qtd_abaixo
SELECT * FROM dbo.fn_lista_estoque(12)
GO
-------------------------------------------------------------------
/*3) A partir das tabelas abaixo, fa�a:
Funcion�rio (C�digo, Nome, Sal�rio)
Dependendente (C�digo_Funcion�rio, Nome_Dependente, Sal�rio_Dependente)

a) Uma Function que Retorne uma tabela:
(Nome_Funcion�rio, Nome_Dependente, Sal�rio_Funcion�rio, Sal�rio_Dependente)

b) Uma Scalar Function que Retorne a soma dos Sal�rios dos dependentes, mais a do funcion�rio. */

CREATE TABLE Funcionario (
	Codigo	INT,
	Nome	VARCHAR(50),
	Salario	DECIMAL(7,2)
	PRIMARY KEY (Codigo)
)

GO
CREATE TABLE Dependente (
	Codigo_Funcionario	INT,
	Nome_Dependente		VARCHAR(50),
	Salario_Dependente	DECIMAL(7,2)
	PRIMARY KEY (Codigo_Funcionario)
	FOREIGN KEY (Codigo_Funcionario) REFERENCES Funcionario(Codigo)
)

INSERT INTO Funcionario VALUES
	(1, 'Fulano', 2000.0),
	(2, 'Beltrano', 4000.0),
	(3, 'Sicrano', 2500.0)

GO
INSERT INTO Dependente VALUES
	(1, 'Maria', 400.0),
	(2, 'Jos�', 600.0)

GO
CREATE FUNCTION fn_nomes_salarios()
RETURNS @tabela TABLE(
	Nome_Funcion�rio	VARCHAR(50),
	Nome_Dependente		VARCHAR(50),
	Sal�rio_Funcion�rio	DECIMAL(7,2),
	Sal�rio_Dependente	DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @tabela
		SELECT f.Nome,
				d.Nome_Dependente,
				f.Salario,
				d.Salario_Dependente
		FROM Funcionario f LEFT OUTER JOIN Dependente d
		ON f.Codigo = d.Codigo_Funcionario

	RETURN
END

CREATE FUNCTION fn_soma_salarios()
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @soma	DECIMAL(7,2),
			@soma2	DECIMAL(7,2)
	
	SELECT @soma = SUM(Salario) FROM Funcionario
	SELECT @soma2 = SUM(Salario_Dependente) FROM Dependente
	SET @soma = @soma + @soma2
	RETURN @soma
END

GO
SELECT * FROM dbo.fn_nomes_salarios()
SELECT dbo.fn_soma_salarios() AS Total_Sal�rios