CREATE DATABASE functions_triggers
GO
USE functions_triggers

CREATE TABLE Produto (
	Codigo			INT,
	Nome			VARCHAR(50),
	Descricao		VARCHAR(MAX),
	Valor_Unitario	DECIMAL(7,2)
	PRIMARY KEY (Codigo)
)

GO
CREATE TABLE Estoque (
	Codigo_Produto	INT,
	Qtd_Estoque		INT,
	Estoque_Minimo	INT
	PRIMARY KEY (Codigo_Produto)
	FOREIGN KEY (Codigo_Produto) REFERENCES Produto(Codigo)
)

CREATE TABLE Venda (
	Nota_Fiscal		INT		IDENTITY(101, 1),
	Codigo_Produto	INT,
	Quantidade		INT
	PRIMARY KEY (Nota_Fiscal)
	FOREIGN KEY (Codigo_Produto) REFERENCES Produto(Codigo)
)

GO
INSERT INTO Produto VALUES
	(1, 'Lápis','Lápis preto para desenho', 0.35),
	(2, 'Caneta', 'Caneta 4 cores esferográfica', 1.50),
	(3, 'Borracha', 'Borracha branca com capa de plástico', 0.89),
	(4, 'Apontador', 'Apontador com tambor', 0.40),
	(5, 'Branquinho', 'Corretivo líquido', 2.45)

GO
INSERT INTO Estoque VALUES
	(1, 12, 10),
	(2, 15, 10),
	(3, 10, 6),
	(4, 8, 4),
	(5, 10, 4)

CREATE TRIGGER t_insert_venda ON Venda
FOR INSERT
AS
BEGIN
	DECLARE @codigo			INT,
			@quantidade		INT,
			@qtd_estoque	INT,
			@est_minimo		INT

	SET @codigo = (SELECT Codigo_Produto FROM INSERTED)
	SET @quantidade = (SELECT Quantidade FROM INSERTED)
	SET @qtd_estoque = (SELECT Qtd_Estoque FROM Estoque WHERE Codigo_Produto = @codigo)
	SET @est_minimo = (SELECT Estoque_Minimo FROM Estoque WHERE Codigo_Produto = @codigo)

	IF (@qtd_estoque < @quantidade)
	BEGIN 
		ROLLBACK TRANSACTION
		RAISERROR('Quantidade insuficiente no estoque', 16, 1)
	END

	ELSE 
	BEGIN
		SET @qtd_estoque = @qtd_estoque - @quantidade

		UPDATE Estoque
		SET Qtd_Estoque = @qtd_estoque
		WHERE Codigo_Produto = @codigo

		IF (@est_minimo > @qtd_estoque)
		BEGIN
			PRINT('Atenção! O estoque está abaixo do mínimo')
		END
	END
END

CREATE FUNCTION fn_nota_fiscal(@nota INT)
RETURNS @tabela TABLE (
	Nota_fiscal			INT,
	Codigo_Produto		INT,
	Nome_Produto		VARCHAR(50),
	Descricao_Produto	VARCHAR(MAX),
	Valor_Unitario		DECIMAL(7,2),
	Quantidade			INT,
	Valor_Total			DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @tabela
		SELECT v.Nota_Fiscal,
				v.Codigo_Produto,
				p.Nome,
				p.Descricao,
				p.Valor_Unitario,
				v.Quantidade,
				V.Quantidade * P.Valor_Unitario 
		FROM Venda V INNER JOIN Produto p
		ON V.Codigo_Produto = P.Codigo
		WHERE V.Nota_Fiscal = @nota
	RETURN
END


INSERT INTO Venda VALUES
--	(4, 10),
--	(2, 3),
--	(3, 6),
	(1, 2)

SELECT * FROM Produto
SELECT * FROM Estoque
SELECT * FROM Venda

SELECT * FROM dbo.fn_nota_fiscal(105)
