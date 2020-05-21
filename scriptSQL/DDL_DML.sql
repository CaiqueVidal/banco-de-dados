CREATE DATABASE DDL_DML
GO
USE DDL_DML

CREATE TABLE projects(
	id				INT             NOT NULL		IDENTITY(10001, 1),
	name			VARCHAR(45)		NOT NULL,
	description		VARCHAR(45)		NULL,
	date			VARCHAR(45)		NOT NULL		CHECK(date > '01/09/2014')
	PRIMARY KEY(id)
)

CREATE TABLE users(
	id				INT				NOT NULL		IDENTITY(1, 1),
	name			VARCHAR(45)		NOT NULL,
	username		VARCHAR(45)		NOT NULL,
	password		VARCHAR(45)		NULL			DEFAULT('123mudar'),
	email			VARCHAR(45)		NULL,
	CONSTRAINT uniq_username UNIQUE(username),
	PRIMARY KEY(id)
)

CREATE TABLE users_has_projects(
	users_id		INT				NOT NULL,
	projects_id		INT				NOT NULL
	PRIMARY KEY(users_id, projects_id)
	FOREIGN KEY(users_id) REFERENCES users(id),
	FOREIGN KEY(projects_id) REFERENCES projects (id)
)

GO

ALTER TABLE users
DROP CONSTRAINT uniq_username

ALTER TABLE users
ALTER COLUMN		username VARCHAR(10)

ALTER TABLE users
ALTER COLUMN		password VARCHAR(08)

GO

INSERT INTO users (name, username, email) VALUES
	('Maria', 'Rh_maria','maria@empresa.com')
INSERT INTO users (name, username, password, email) VALUES
	('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com')
INSERT INTO users (name, username, email) VALUES
	('Ana', 'Rh_ana', 'ana@empresa.com'),
	('Clara', 'Ti_clara','clara@empresa.com')
INSERT INTO users (name, username, password, email) VALUES
	('Aparecido', 'Rh_apareci', '55@!cido','aparecido@empresa.com')


INSERT INTO projects (name, description, date) VALUES
	('Re-folha', 'Refatoração das Folhas', '05/09/2014'),
	('Manutenção PC´s', 'Manutenção PC´s', '06/09/2014'),
	('Auditoria', NULL, '07/09/2014')

INSERT INTO users_has_projects VALUES
	(1, 10001),
	(5, 10001),
	(3, 10003),
	(4, 10002),
	(2, 10002)

GO

UPDATE projects
	SET date = '12/09/2014'
	WHERE id = 10002

UPDATE users
	SET username = 'Rh_cido'
	WHERE name = 'Aparecido'

UPDATE users
	SET password = '888@*'
	WHERE name = 'Maria' AND password = '123mudar'

DELETE users_has_projects
	WHERE users_id = 2

ALTER TABLE projects
	ADD	budget		DECIMAL(7,2) NULL

GO

UPDATE projects
	SET budget = 5750.00
	WHERE id = 10001

UPDATE projects
	SET budget = 7850.00
	WHERE id = 10002

UPDATE projects
	SET budget = 9530.00
	WHERE id = 10003

GO

SELECT 
	username, 
	password
	FROM users
	WHERE name = 'Ana'

SELECT
	id,
	budget,
	CAST(budget * 1.25 AS DECIMAL(7,2)) AS hypothetical_value
	FROM projects

SELECT 
	id, 
	name, 
	email 
	FROM users
	WHERE password = '123mudar'

SELECT
	id, 
	name
	FROM projects
	WHERE budget BETWEEN 2000.00 AND 8000.00 