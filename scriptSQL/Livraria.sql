CREATE DATABASE Livraria
GO
USE Livraria


CREATE TABLE Livro (
	Codigo_Livro		INT				NOT NULL,
	Nome				VARCHAR(100),
	Lingua				VARCHAR(50),	
	Ano					INT
	PRIMARY KEY (Codigo_Livro)
)

CREATE TABLE Autor (
	Codigo_Autor		INT				NOT NULL,
	Nome				VARCHAR(100),
	Nascimento			DATE,	
	Pais				VARCHAR(50),
	Biografia			VARCHAR(MAX)
	PRIMARY KEY (Codigo_Autor)
)

CREATE TABLE Edicoes (
	ISBN				INT				NOT NULL,
	Preco				DECIMAL(7,2),
	Ano					INT,	
	Num_Paginas			INT,
	Qtd_Estoque			INT
	PRIMARY KEY (ISBN)
)

CREATE TABLE Editora (
	Codigo_Editora		INT				NOT NULL,
	Nome				VARCHAR(50),
	Logradouro			VARCHAR(255),	
	Numero				INT,
	CEP					CHAR(8),
	Telefone			CHAR(11)
	PRIMARY KEY (Codigo_Editora)
)

GO

CREATE TABLE Livro_Autor (
	LivroCodigo_Livro		INT			NOT NULL,
	AutorCodigo_Autor		INT			NOT NULL
	PRIMARY KEY (LivroCodigo_Livro, AutorCodigo_Autor)
	FOREIGN KEY (LivroCodigo_Livro) REFERENCES Livro(Codigo_Livro),
	FOREIGN KEY (AutorCodigo_Autor) REFERENCES Autor(Codigo_Autor)
)

CREATE TABLE Livro_Edicoes_Editora (
	EdicoesISBN				INT			NOT NULL,
	EditoraCodigo_Editora	INT			NOT NULL,
	LivroCodigo_Livro		INT			NOT NULL
	PRIMARY KEY (EdicoesISBN, EditoraCodigo_Editora, LivroCodigo_Livro),
	FOREIGN KEY (EdicoesISBN) REFERENCES Edicoes(ISBN),
	FOREIGN KEY (EditoraCodigo_Editora) REFERENCES Editora(Codigo_Editora),
	FOREIGN KEY (LivroCodigo_Livro) REFERENCES Livro(Codigo_Livro)
)

GO
EXEC sp_rename 'dbo.Edicoes.Ano', 'AnoEdicao', 'column'


ALTER TABLE		Editora
ALTER COLUMN	Nome VARCHAR(30)


ALTER TABLE		Autor
DROP COLUMN		Nascimento	

ALTER TABLE		Autor
ADD				Ano INT

GO
INSERT INTO Livro VALUES
	(1001, 'CCNA 4.1', 'PT-BR', 2015),
	(1002, 'HTML 5', 'PT-BR', 2017),	(1003, 'Redes de Computadores', 'EN', 2010),	(1004, 'Android em Ação', 'PT-BR', 2018)

INSERT INTO Autor VALUES
	(10001, 'Inácio da Silva', 'Brasil', 'Programador WEB desde 1995', 1975),
	(10002, 'Andrew Tannenbaum', 'EUA', 'Chefe do Departamento de Sistemas de Computação da Universidade de Vrij', 1944),
	(10003, 'Luis Rocha', 'Brasil', 'Programador Mobile desde 2000', 1967),
	(10004, 'David Halliday', 'EUA', 'Físico PH.D desde 1941', 1916)


INSERT INTO Livro_Autor VALUES
	(1001, 10001),
	(1002, 10003),
	(1003, 10002),
	(1004, 10003)
	

INSERT INTO Edicoes VALUES
	(0130661023, 189.99, 2018, 653, 10)

GO
UPDATE Autor
	SET Biografia = 'Chefe do Departamento de Sistemas de Computação da Universidade de Vrije'
	WHERE Codigo_Autor = 10002


UPDATE Edicoes
	SET Qtd_Estoque = Qtd_Estoque - 2
	WHERE ISBN = 0130661023


DELETE Autor
	WHERE Codigo_Autor = 10004
