/*Exercício
Dada a database abaixo, criar uma procedure que receba idProduto, nome,
valor e tipo(e para entrada e s para saída) e determine se vai para a tabela 
de compras (entrada) ou de vendas (saída). Não há necessidade de usar 
Try..Catch 
 
CREATE TABLE produto(
idProduto INT NOT NULL,
nome VARCHAR(100),
valor DECIMAL(7,2),
tipo CHAR(1) DEFAULT('e')
PRIMARY KEY (idProduto))
 
CREATE TABLE compra(
codigo INT NOT NULL,
produto INT NOT NULL,
qtd INT NOT NULL,
vl_total DECIMAL(7,2)
 
PRIMARY KEY (codigo, produto)
FOREIGN KEY (produto) REFERENCES produto (idProduto))
 
CREATE TABLE venda(
codigo INT NOT NULL,
produto INT NOT NULL,
qtd INT NOT NULL,
vl_total DECIMAL(7,2)
 
PRIMARY KEY (codigo, produto)
FOREIGN KEY (produto) REFERENCES produto (idProduto)) */

CREATE DATABASE query_dinamica
GO
USE query_dinamica

CREATE TABLE produto(
idProduto INT NOT NULL,
nome VARCHAR(100),
valor DECIMAL(7,2),
tipo CHAR(1) DEFAULT('e')
PRIMARY KEY (idProduto))
 
CREATE TABLE compra(
codigo INT NOT NULL,
produto INT NOT NULL,
qtd INT NOT NULL,
vl_total DECIMAL(7,2)
PRIMARY KEY (codigo, produto)
FOREIGN KEY (produto) REFERENCES produto (idProduto))
 
CREATE TABLE venda(
codigo INT NOT NULL,
produto INT NOT NULL,
qtd INT NOT NULL,
vl_total DECIMAL(7,2)
PRIMARY KEY (codigo, produto)
FOREIGN KEY (produto) REFERENCES produto (idProduto))

GO
CREATE PROCEDURE sp_insere_produto (@idProduto INT, @nome VARCHAR(100), 
			@valor DECIMAL(7,2), @qtd INT, @tipo CHAR(1))
AS
	DECLARE @tabela         VARCHAR(10),
            @query_produto  VARCHAR(MAX),
            @query_tipo     VARCHAR(MAX),
			@cont_produto	INT,
			@codigo			INT

	IF (LOWER(@tipo) != 'e' AND LOWER(@tipo) != 's')
	BEGIN
		RAISERROR('Tipo inválido, use ''e'' (para entrada) ou ''s'' (para saída)', 16, 1)
		RETURN
	END

    IF (LOWER(@tipo) = 'e')
    BEGIN
        SET @tabela = 'compra'

		SET @codigo = (SELECT MAX(codigo)+1 FROM compra)
		IF (@codigo IS NULL)
		BEGIN
			SET @codigo = 1
		END
    END
    ELSE
    BEGIN
        IF (LOWER(@tipo) = 's')
        BEGIN
            SET @tabela = 'venda'

			SET @codigo = (SELECT MAX(codigo)+1 FROM venda)
			IF (@codigo IS NULL)
			BEGIN
				SET @codigo = 1
			END
        END
    END

	SET @cont_produto = (SELECT COUNT(*) FROM produto WHERE idProduto = @idProduto)
	IF (@cont_produto = 0)
	BEGIN
		SET @query_produto = 'INSERT INTO produto VALUES (' 
								+ CAST(@idProduto AS VARCHAR(5)) + ','''  + @nome + ''',' 
								+ CAST(@valor AS VARCHAR(7)) + ',''' + @tipo + ''')'
	END

    SET @query_tipo = 'INSERT INTO ' + @tabela + ' VALUES (' 
							+ CAST(@codigo AS VARCHAR(5)) + ','
							+ CAST(@idProduto AS VARCHAR(5)) + ',' 
							+ CAST(@qtd AS VARCHAR(5)) + ',' 
							+ CAST((@qtd * @valor) AS VARCHAR(7)) + ')'
    
	EXEC (@query_produto)
	EXEC (@query_tipo)

GO
EXEC sp_insere_produto 101, 'PS5', 4199.99, 5, 'e'
EXEC sp_insere_produto 102, 'TV', 2700, 3, 's'
-- EXEC sp_insere_produto 101, 'PS5', 4499.99, 2, 's'
-- EXEC sp_insere_produto 105, 'Notebook', 1850, 4, 'f'  
