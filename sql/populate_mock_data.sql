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
('Fernanda Alves', 'fernanda.alves@email.com', '2022003', '890.123.456-77', FALSE, NULL);


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
('Sistemas Operacionais', 'Abraham Silberschatz', 'LTC', '978-8521634461', 3);


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
(2, 6, '2025-11-20', '2025-12-04', NULL);  -- Prazo até 04/12/2025


-- ==========================================================================================
-- ATUALIZAÇÃO: Aplicar bloqueio no usuário Carlos Souza (já inserido como bloqueado)
-- ==========================================================================================
-- O usuário 5 (Carlos Souza) já foi inserido com BLOQUEADO = TRUE e DATA_BLOQUEIO = '2025-11-15'


-- ==========================================================================================
-- RESUMO DOS CENÁRIOS DE TESTE:
-- ==========================================================================================
-- 
-- USUÁRIO 1 (João Silva):
--   - 1 multa ativa de R$ 15,00 (atraso de 10 dias)
--   - Pode fazer novos empréstimos (atraso < 30 dias)
--
-- USUÁRIO 2 (Maria Santos):
--   - 1 multa ativa de R$ 22,50 (atraso de 15 dias)
--   - Pode fazer novos empréstimos (atraso < 30 dias)
--
-- USUÁRIO 3 (Pedro Oliveira):
--   - 1 multa ativa de R$ 30,00 (atraso de 20 dias)
--   - Pode fazer novos empréstimos (atraso < 30 dias)
--
-- USUÁRIO 4 (Ana Costa):
--   - 1 multa paga de R$ 37,50
--   - Pode fazer novos empréstimos normalmente
--
-- USUÁRIO 5 (Carlos Souza - BLOQUEADO):
--   - 2 multas ativas totalizando R$ 220,00 (R$ 102,50 + R$ 117,50)
--   - 2 bloqueios ativos até 17/11 e 19/11/2025
--   - NÃO pode fazer novos empréstimos até desbloqueio
--   - Possui empréstimos com atrasos graves (35 e 45 dias)
--
-- USUÁRIO 6 (Julia Pereira):
--   - 1 multa ativa de R$ 125,00 (atraso de 50 dias)
--   - 1 bloqueio cancelado (liberado administrativamente)
--   - Pode fazer novos empréstimos (bloqueio foi cancelado)
--   - Tem 1 empréstimo ativo sem atraso
--
-- USUÁRIOS 7 e 8 (Roberto Lima e Fernanda Alves):
--   - Sem penalidades
--   - Disponíveis para testes adicionais
--
-- ==========================================================================================