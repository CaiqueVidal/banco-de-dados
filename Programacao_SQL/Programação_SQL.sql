-- Fazer um algoritmo que, dado 1 número, mostre se é múltiplo de 2,3,5 ou nenhum deles
DECLARE @valor INT,
		@mult BIT
SET @valor = 30
SET	@mult = 0

PRINT @valor

IF (@valor%2 = 0)
BEGIN
	PRINT 'É multiplo de 2'
	SET @mult = 1
END
IF (@valor%3 = 0)
BEGIN
	PRINT 'É multiplo de 3'
	SET @mult = 1
END
IF (@valor%5 = 0)
BEGIN
	PRINT 'É multiplo de 5'
	SET @mult = 1
END
IF (@mult = 0)
BEGIN
	PRINT 'Não é multiplo dos números 2, 3 ou 5'
END


-- Fazer um algoritmo que, dados 3 números, mostre o maior e o menor
DECLARE @valor1 INT,
		@valor2 INT,
		@valor3 INT,
		@maior INT,
		@menor INT
SET @valor1 = 10
SET @valor2 = 30
SET @valor3 = 20

IF (@valor1 > @valor2 AND @valor1 > @valor3)
BEGIN
	SET @maior = @valor1
	IF(@valor2 > @valor3)
	BEGIN
		SET @menor = @valor3
	END
	ELSE
	BEGIN
		SET @menor = @valor2
	END
END
ELSE
IF (@valor2 > @valor3)
BEGIN
	SET @maior = @valor2
	IF(@valor1 > @valor3)
	BEGIN
		SET @menor = @valor3
	END
	ELSE
	BEGIN
		SET @menor = @valor1
	END
END
ELSE
BEGIN
	SET @maior = @valor3
	IF(@valor1 > @valor2)
		BEGIN
			SET @menor = @valor2
		END
		ELSE
		BEGIN
			SET @menor = @valor1
		END
END

PRINT 'Maior valor -> ' + CAST(@maior AS VARCHAR(5))
PRINT 'Menor valor -> ' + CAST(@menor AS VARCHAR(5))


-- Fazer um algoritmo que calcule os 15 primeiros termos da série de Fibonacci e a soma dos 15 primeiros termos
DECLARE @termo INT,
		@soma INT,
		@numAnterior INT,
		@numAtual INT,
		@numPosterior INT,
		@quantidade INT
SET @termo = 0
SET @soma = 0
SET @numAnterior = 0
SET @numAtual = 1
SET @quantidade = 15

WHILE (@termo <= @quantidade)
BEGIN
	SET @numPosterior = @numAnterior + @numAtual
	SET @numAtual = @numAnterior
	SET @numAnterior = @numPosterior
	IF (@termo != 0)
	BEGIN
		PRINT @numAtual
	END
	SET @soma = @soma + @numAtual
	SET @termo = @termo +1
END
PRINT 'Soma dos '+CAST(@quantidade AS VARCHAR(2))+' primeiros termos -> ' + CAST(@soma AS VARCHAR(10))


-- Fazer um algoritmo que separa uma frase, imprimindo todas as letras em maiúsculo e, depois imprimindo todas em minúsculo
DECLARE @frase VARCHAR(50),
		@tamanho INT
SET @tamanho = 0
SET @frase = 'Hello World'

WHILE(@tamanho <= LEN(@frase))
BEGIN
	SET @tamanho = @tamanho + 1
	PRINT UPPER(SUBSTRING(@frase, @tamanho,1))
END

SET @tamanho = 0
WHILE(@tamanho <= LEN(@frase))
BEGIN
	SET @tamanho = @tamanho + 1
	PRINT LOWER(SUBSTRING(@frase, @tamanho,1))
END


-- Fazer um algoritmo que verifica, dada uma palavra, se é, ou não, palíndromo
DECLARE @palavra VARCHAR(20),
		@cond BIT,
		@aux INT
SET @aux = 1
SET @cond = 1
SET @palavra = 'Reviver'

WHILE(@aux <= FLOOR(LEN(@palavra)/2))
BEGIN
	IF (SUBSTRING(@palavra, @aux, 1) != SUBSTRING(@palavra, LEN(@palavra)-(@aux-1), 1))
	BEGIN
		SET	@cond = 0
	END
	SET @aux = @aux + 1
END

IF (@cond = 0)
BEGIN
	PRINT 'Não é palíndromo'
END
ELSE
BEGIN
	PRINT 'É palíndromo'
END


-- Fazer um algoritmo que, dado um CPF diga se é válido
DECLARE @cpf CHAR(11),
		@valido BIT,
		@cont INT,
		@res INT,
		@aux1 INT,
		@aux2 INT

SET @valido = 1
SET @cpf = '42604255014'
SET @cont =1

SET @res = 0
SET @aux1 = (CAST(SUBSTRING(@cpf, 11, 1) AS INT))

WHILE (@cont <11)
BEGIN
	SET	@aux2 = (CAST(SUBSTRING(@cpf, @cont, 1) AS INT))
	SET @cont = @cont + 1
	IF (@aux1 = @aux2)
	BEGIN
		SET @res = @res + 1
	END
END
IF (@res = 10)
BEGIN
	SET @valido = 0
END

SET @aux1 = 1
WHILE (@valido = 1 AND @aux1 <= 2)
BEGIN
	SET @cont = 1
	SET @res = 0

	WHILE (@cont <= 8+@aux1)
	BEGIN
	SET	@res = @res + (CAST(SUBSTRING(@cpf, @cont, 1) AS INT) * ((10+@aux1)-@cont))
	SET @cont = @cont + 1
	END

	IF(@res%11 < 2)
	BEGIN
		SET @res = 0
	END
	ELSE

	BEGIN
		SET @res = 11-(@res%11)
	END

	IF(SUBSTRING(@cpf, (9+@aux1), 1) != @res)
	BEGIN
		SET @valido = 0
	END

	SET @aux1 = @aux1 + 1	
END

IF (@valido = 1)
BEGIN 
	PRINT 'CPF válido'
END
ELSE
BEGIN
	PRINT 'CPF inválido'
END

