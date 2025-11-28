-- ==========================
-- INSERINDO USUÁRIOS DE TESTE
-- ==========================
INSERT INTO USUARIOS (NOME, EMAIL, MATRICULA, CPF, BLOQUEADO, DATA_BLOQUEIO) VALUES
('João Silva', 'joao.silva@email.com', '2021001', '123.456.789-00', FALSE, NULL),
('Maria Santos', 'maria.santos@email.com', '2021002', '234.567.890-11', FALSE, NULL),
('Pedro Oliveira', 'pedro.oliveira@email.com', '2021003', '345.678.901-22', FALSE, NULL),
('Ana Costa', 'ana.costa@email.com', '2021004', '456.789.012-33', FALSE, NULL),
('Carlos Souza - BLOQUEADO', 'carlos.souza@email.com', '2021005', '567.890.123-44', TRUE, '2025-11-15'),
('Julia Pereira', 'julia.pereira@email.com', '2022001', '678.901.234-55', FALSE, NULL),
('Roberto Lima', 'roberto.lima@email.com', '2022002', '789.012.345-66', FALSE, NULL),
('Fernanda Alves', 'fernanda.alves@email.com', '2022003', '890.123.456-77', FALSE, NULL),
('Lucas Martins', 'lucas.martins@email.com', '2023001', '901.234.567-88', FALSE, NULL),
('Camila Ferreira', 'camila.ferreira@email.com', '2023002', '012.345.678-99', FALSE, NULL),
('Rafael Cardoso', 'rafael.cardoso@email.com', '2023003', '123.456.780-10', FALSE, NULL),
('Patricia Mendes', 'patricia.mendes@email.com', '2023004', '234.567.891-21', FALSE, NULL),
('Gabriel Rocha', 'gabriel.rocha@email.com', '2024001', '345.678.902-32', FALSE, NULL),
('Beatriz Moura', 'beatriz.moura@email.com', '2024002', '456.789.013-43', FALSE, NULL),
('Felipe Barbosa', 'felipe.barbosa@email.com', '2024003', '567.890.124-54', FALSE, NULL);


-- ==========================
-- INSERINDO LIVROS
-- ==========================
INSERT INTO LIVROS (TITULO, AUTOR, EDITORA, ISBN, QUANTIDADE_DISPONIVEL) VALUES
('Clean Code', 'Robert C. Martin', 'Prentice Hall', '978-0132350884', 3),
('Design Patterns', 'Erich Gamma', 'Addison-Wesley', '978-0201633610', 2),
('Java: Como Programar', 'Paul Deitel', 'Pearson', '978-8543004792', 5),
('Algoritmos', 'Thomas H. Cormen', 'Campus', '978-8535236996', 4),
('Engenharia de Software', 'Ian Sommerville', 'Pearson', '978-8579361081', 3),
('Estruturas de Dados', 'Michael T. Goodrich', 'Bookman', '978-8582604380', 4),
('Banco de Dados', 'Abraham Silberschatz', 'Campus', '978-8535287646', 2),
('Redes de Computadores', 'Andrew S. Tanenbaum', 'Pearson', '978-8582605592', 3),
('Inteligência Artificial', 'Stuart Russell', 'Campus', '978-8535237016', 2),
('Sistemas Operacionais', 'Abraham Silberschatz', 'LTC', '978-8521634461', 3),
('Python para Análise de Dados', 'Wes McKinney', 'Novatec', '978-8575226476', 4),
('Arquitetura Limpa', 'Robert C. Martin', 'Alta Books', '978-8550804606', 3),
('Domain-Driven Design', 'Eric Evans', 'Alta Books', '978-8550800653', 2),
('Padrões de Projeto', 'Freeman e Freeman', 'Alta Books', '978-8576081746', 3),
('Git e GitHub', 'Fernando Anselmo', 'Casa do Código', '978-8594188014', 5),
('Docker para Desenvolvedores', 'Rafael Gomes', 'Casa do Código', '978-8594188762', 3),
('Microservices Patterns', 'Chris Richardson', 'Manning', '978-1617294549', 2),
('Kubernetes Básico', 'Brendan Burns', 'Novatec', '978-8575228326', 2),
('Web Scraping com Python', 'Ryan Mitchell', 'Novatec', '978-8575227411', 3),
('Machine Learning', 'Sebastian Raschka', 'Packt', '978-1789955750', 2);


-- ==========================================================================================
-- CENÁRIO 1: Empréstimos DEVOLVIDOS COM ATRASO LEVE (< 30 dias) - Apenas multa
-- ==========================================================================================

-- Atraso de 10 dias - Multa: R$ 15,00
INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES
(1, 1, '2025-10-01', '2025-10-15', '2025-10-25');

INSERT INTO PENALIDADES (USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, VALOR, STATUS, MOTIVO_DESCRICAO, DIAS_ATRASO) VALUES
(1, 'MULTA', '2025-10-25', NULL, 15.00, 'ATIVA', 'Multa por atraso de 10 dias na devolução do livro (Empréstimo #1)', 10);

-- Atraso de 15 dias - Multa: R$ 22,50
INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES
(2, 2, '2025-09-20', '2025-10-04', '2025-10-19');

INSERT INTO PENALIDADES (USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, VALOR, STATUS, MOTIVO_DESCRICAO, DIAS_ATRASO) VALUES
(2, 'MULTA', '2025-10-19', NULL, 22.50, 'ATIVA', 'Multa por atraso de 15 dias na devolução do livro (Empréstimo #2)', 15);

-- Atraso de 20 dias - Multa: R$ 30,00
INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES
(3, 3, '2025-09-15', '2025-09-29', '2025-10-19');

INSERT INTO PENALIDADES (USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, VALOR, STATUS, MOTIVO_DESCRICAO, DIAS_ATRASO) VALUES
(3, 'MULTA', '2025-10-19', NULL, 30.00, 'ATIVA', 'Multa por atraso de 20 dias na devolução do livro (Empréstimo #3)', 20);

-- Atraso de 25 dias - Multa: R$ 37,50 (PAGA)
INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES
(4, 4, '2025-09-10', '2025-09-24', '2025-10-19');

INSERT INTO PENALIDADES (USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, VALOR, STATUS, MOTIVO_DESCRICAO, DIAS_ATRASO) VALUES
(4, 'MULTA', '2025-10-19', NULL, 37.50, 'PAGA', 'Multa por atraso de 25 dias na devolução do livro (Empréstimo #4)', 25);


-- ==========================================================================================
-- CENÁRIO 2: Empréstimos DEVOLVIDOS COM ATRASO GRAVE (> 30 dias) - Multa + Bloqueio
-- ==========================================================================================

-- Atraso de 35 dias - Multa: R$ 102,50 (R$ 1,50 x 35 + R$ 50,00) + Bloqueio de 30 dias
INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES
(5, 5, '2025-09-01', '2025-09-15', '2025-10-20');

INSERT INTO PENALIDADES (USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, VALOR, STATUS, MOTIVO_DESCRICAO, DIAS_ATRASO) VALUES
(5, 'MULTA', '2025-10-20', NULL, 102.50, 'ATIVA', 'Multa por atraso de 35 dias na devolução do livro (Empréstimo #5)', 35);

INSERT INTO PENALIDADES (USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, VALOR, STATUS, MOTIVO_DESCRICAO, DIAS_ATRASO) VALUES
(5, 'BLOQUEIO_TEMPORARIO', '2025-10-20', '2025-11-19', 0.00, 'ATIVA', 'Bloqueio temporário de 30 dias por atraso superior a 30 dias (35 dias) na devolução (Empréstimo #5)', 35);

-- Atraso de 45 dias - Multa: R$ 117,50 + Bloqueio ainda ativo (até 10/12/2025)
INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES
(6, 5, '2025-08-20', '2025-09-03', '2025-10-18');

INSERT INTO PENALIDADES (USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, VALOR, STATUS, MOTIVO_DESCRICAO, DIAS_ATRASO) VALUES
(5, 'MULTA', '2025-10-18', NULL, 117.50, 'ATIVA', 'Multa por atraso de 45 dias na devolução do livro (Empréstimo #6)', 45);

INSERT INTO PENALIDADES (USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, VALOR, STATUS, MOTIVO_DESCRICAO, DIAS_ATRASO) VALUES
(5, 'BLOQUEIO_TEMPORARIO', '2025-10-18', '2025-11-17', 0.00, 'ATIVA', 'Bloqueio temporário de 30 dias por atraso superior a 30 dias (45 dias) na devolução (Empréstimo #6)', 45);

-- Atraso de 50 dias - Multa: R$ 125,00 + Bloqueio (Cancelado administrativamente)
INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES
(1, 6, '2025-08-15', '2025-08-29', '2025-10-18');

INSERT INTO PENALIDADES (USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, VALOR, STATUS, MOTIVO_DESCRICAO, DIAS_ATRASO) VALUES
(6, 'MULTA', '2025-10-18', NULL, 125.00, 'ATIVA', 'Multa por atraso de 50 dias na devolução do livro (Empréstimo #7)', 50);

INSERT INTO PENALIDADES (USUARIO_ID, TIPO, DATA_INICIO, DATA_FIM, VALOR, STATUS, MOTIVO_DESCRICAO, DIAS_ATRASO) VALUES
(6, 'BLOQUEIO_TEMPORARIO', '2025-10-18', '2025-11-17', 0.00, 'CANCELADA', 'Bloqueio temporário de 30 dias por atraso superior a 30 dias (50 dias) na devolução (Empréstimo #7) - CANCELADO', 50);


-- ==========================================================================================
-- CENÁRIO 3: Empréstimos ATIVOS sem atraso
-- ==========================================================================================
INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES
(2, 6, '2025-11-20', '2025-12-04', NULL),  -- Prazo até 04/12/2025
(3, 7, '2025-11-22', '2025-12-06', NULL),  -- Prazo até 06/12/2025
(4, 8, '2025-11-23', '2025-12-07', NULL),  -- Prazo até 07/12/2025
(7, 9, '2025-11-24', '2025-12-08', NULL),  -- Prazo até 08/12/2025
(8, 10, '2025-11-25', '2025-12-09', NULL),  -- Prazo até 09/12/2025
(11, 11, '2025-11-26', '2025-12-10', NULL),  -- Prazo até 10/12/2025
(12, 12, '2025-11-21', '2025-12-05', NULL),  -- Prazo até 05/12/2025
(13, 13, '2025-11-27', '2025-12-11', NULL),  -- Prazo até 11/12/2025
(15, 14, '2025-11-26', '2025-12-10', NULL),  -- Prazo até 10/12/2025
(16, 15, '2025-11-25', '2025-12-09', NULL);  -- Prazo até 09/12/2025


-- ==========================================================================================
-- CENÁRIO 4: Empréstimos ATIVOS COM ATRASO (ainda não devolvidos)
-- ==========================================================================================
INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES
(9, 1, '2025-11-01', '2025-11-15', NULL),  -- 13 dias de atraso
(10, 2, '2025-10-25', '2025-11-08', NULL),  -- 20 dias de atraso
(14, 3, '2025-10-20', '2025-11-03', NULL),  -- 25 dias de atraso
(17, 7, '2025-10-10', '2025-10-24', NULL),  -- 35 dias de atraso (atraso grave!)
(18, 8, '2025-10-05', '2025-10-19', NULL);  -- 40 dias de atraso (atraso grave!)


-- ==========================================================================================
-- CENÁRIO 5: Empréstimos DEVOLVIDOS no prazo ou antes (histórico positivo)
-- ==========================================================================================
INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES
(1, 9, '2025-10-01', '2025-10-15', '2025-10-12'),   -- Devolvido 3 dias antes
(2, 10, '2025-10-05', '2025-10-19', '2025-10-18'),  -- Devolvido 1 dia antes
(3, 11, '2025-10-10', '2025-10-24', '2025-10-24'),  -- Devolvido no prazo
(4, 12, '2025-09-15', '2025-09-29', '2025-09-28'),  -- Devolvido 1 dia antes
(5, 13, '2025-09-20', '2025-10-04', '2025-10-01'),  -- Devolvido 3 dias antes
(6, 14, '2025-10-15', '2025-10-29', '2025-10-25'),  -- Devolvido 4 dias antes
(7, 15, '2025-10-20', '2025-11-03', '2025-11-03'),  -- Devolvido no prazo
(11, 1, '2025-09-05', '2025-09-19', '2025-09-19'),  -- Devolvido no prazo
(12, 2, '2025-09-10', '2025-09-24', '2025-09-22'),  -- Devolvido 2 dias antes
(13, 3, '2025-08-25', '2025-09-08', '2025-09-07');  -- Devolvido 1 dia antes


-- ==========================================================================================
-- CENÁRIO 6: Empréstimos múltiplos do mesmo usuário (usuários muito ativos)
-- ==========================================================================================
-- João Silva (usuario 1) - 5 empréstimos históricos adicionais
INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES
(15, 1, '2025-08-01', '2025-08-15', '2025-08-14'),
(16, 1, '2025-08-20', '2025-09-03', '2025-09-02'),
(17, 1, '2025-09-10', '2025-09-24', '2025-09-24'),
(18, 1, '2025-09-25', '2025-10-09', '2025-10-08');

-- Maria Santos (usuario 2) - 4 empréstimos históricos adicionais
INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES
(19, 2, '2025-08-05', '2025-08-19', '2025-08-18'),
(20, 2, '2025-08-25', '2025-09-08', '2025-09-07'),
(11, 2, '2025-09-15', '2025-09-29', '2025-09-29');

-- Pedro Oliveira (usuario 3) - 3 empréstimos históricos adicionais
INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES
(12, 3, '2025-08-10', '2025-08-24', '2025-08-23'),
(13, 3, '2025-09-01', '2025-09-15', '2025-09-14');


-- ==========================================================================================
-- CENÁRIO 7: Livros populares (mais emprestados para teste de relatórios)
-- ==========================================================================================
-- Clean Code (livro 1) - já tem vários empréstimos, adicionar mais
INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES
(1, 10, '2025-07-01', '2025-07-15', '2025-07-14'),
(1, 11, '2025-07-20', '2025-08-03', '2025-08-02'),
(1, 12, '2025-08-10', '2025-08-24', '2025-08-23'),
(1, 13, '2025-09-01', '2025-09-15', '2025-09-14');

-- Design Patterns (livro 2) - adicionar mais empréstimos
INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES
(2, 11, '2025-07-05', '2025-07-19', '2025-07-18'),
(2, 12, '2025-08-01', '2025-08-15', '2025-08-14'),
(2, 13, '2025-09-05', '2025-09-19', '2025-09-18');

-- Java: Como Programar (livro 3) - adicionar mais empréstimos
INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES
(3, 9, '2025-07-10', '2025-07-24', '2025-07-23'),
(3, 10, '2025-08-05', '2025-08-19', '2025-08-18'),
(3, 14, '2025-09-10', '2025-09-24', '2025-09-23'),
(3, 15, '2025-10-01', '2025-10-15', '2025-10-14');


