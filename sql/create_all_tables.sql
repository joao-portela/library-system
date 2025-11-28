-- create_all_tables.sql
-- Cria as tabelas principais do sistema: USUARIOS, LIVROS, EMPRESTIMOS
-- Atenção: Apache Derby não suporta IF NOT EXISTS em CREATE TABLE.
-- Se as tabelas já existirem, remova-as antes de rodar ou execute o script apenas nas novas bases.

-- ==========================
-- Tabela: USUARIOS
-- ==========================
CREATE TABLE USUARIOS (
    ID INT GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) PRIMARY KEY,
    NOME VARCHAR(200) NOT NULL,
    EMAIL VARCHAR(150),
    MATRICULA VARCHAR(50) UNIQUE,
    CPF VARCHAR(20),
    BLOQUEADO BOOLEAN DEFAULT FALSE,
    DATA_BLOQUEIO DATE
);


-- ==========================
-- Tabela: LIVROS
-- ==========================
CREATE TABLE LIVROS (
    ID INT GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) PRIMARY KEY,
    TITULO VARCHAR(255) NOT NULL,
    AUTOR VARCHAR(150),
    EDITORA VARCHAR(150),
    ISBN VARCHAR(50),
    QUANTIDADE_DISPONIVEL INT DEFAULT 0
);


-- ==========================
-- Tabela: EMPRESTIMOS
-- ==========================
CREATE TABLE EMPRESTIMOS (
    ID INT GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) PRIMARY KEY,
    LIVRO_ID INT NOT NULL,
    USUARIO_ID INT NOT NULL,
    DATA_EMPRESTIMO DATE NOT NULL,
    DATA_DEVOLUCAO_PREVISTA DATE NOT NULL,
    DATA_DEVOLUCAO_REAL DATE
);

ALTER TABLE EMPRESTIMOS ADD CONSTRAINT FK_EMPRESTIMOS_LIVRO FOREIGN KEY (LIVRO_ID) REFERENCES LIVROS(ID);
ALTER TABLE EMPRESTIMOS ADD CONSTRAINT FK_EMPRESTIMOS_USUARIO FOREIGN KEY (USUARIO_ID) REFERENCES USUARIOS(ID);


-- ==========================
-- Tabela: PENALIDADES
-- ==========================
CREATE TABLE PENALIDADES (
    ID BIGINT GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) PRIMARY KEY,
    USUARIO_ID INT NOT NULL,
    TIPO VARCHAR(30) NOT NULL,
    DATA_INICIO DATE NOT NULL,
    DATA_FIM DATE,
    VALOR DECIMAL(10,2) DEFAULT 0.0,
    STATUS VARCHAR(20) DEFAULT 'ATIVA',
    MOTIVO_DESCRICAO VARCHAR(500),
    DIAS_ATRASO INT DEFAULT 0
);

ALTER TABLE PENALIDADES ADD CONSTRAINT FK_PENALIDADES_USUARIO FOREIGN KEY (USUARIO_ID) REFERENCES USUARIOS(ID);


-- ==========================
-- Observações
-- - Ajuste tamanhos de VARCHAR conforme suas necessidades.
-- - Rode este script com o utilitário `ij` do Apache Derby ou via sua ferramenta de administração.
-- - Se for rodar em um ambiente com tabelas já existentes, remova-as antes ou use uma estratégia de migração.
-- ==========================
