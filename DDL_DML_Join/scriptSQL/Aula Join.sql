INSERT INTO  users (name, username, email) VALUES
	('Joao', 'Ti_joao', 'joao@empresa.com')

INSERT INTO projects (name, description, date) VALUES
	('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PC`s', '12/09/2014')
SELECT u.id, u.name, u.email, p.id, p.name, p.description
FROM users u INNER JOIN users_has_projects uhs
ON u.id = uhs.users_id
INNER JOIN projects p
ON p.id = uhs.projects_id
WHERE p.name = 'Re-Folha'


SELECT name
FROM projects p LEFT OUTER JOIN users_has_projects uhp
ON p.id = uhp.projects_id
WHERE uhp.users_id IS NULL

SELECT name
FROM users u LEFT OUTER JOIN users_has_projects uhp
ON u.id = uhp.users_id
WHERE uhp.projects_id IS NULL
