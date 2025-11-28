/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.utils;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Logger;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class InicializadorBD implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(InicializadorBD.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("Iniciando verificação do Banco de Dados...");
        
        try (Connection conn = ConnectionFactory.getConnection()) {
            
            // 1. Criar Tabela Usuários se não existir
            if (!tabelaExiste(conn, "USUARIOS")) {
                String sql = "CREATE TABLE usuarios ("
                        + "id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), "
                        + "nome VARCHAR(100) NOT NULL, "
                        + "email VARCHAR(100), "
                        + "matricula VARCHAR(20) NOT NULL UNIQUE"
                        + ")";
                executarSql(conn, sql);
                LOGGER.info("Tabela USUARIOS criada com sucesso.");
                
                // Inserir usuário Admin/Padrão para facilitar para o professor
                String sqlInsert = "INSERT INTO usuarios (nome, email, matricula) VALUES ('Admin', 'admin@biblioteca.com', 'admin')";
                executarSql(conn, sqlInsert);
                LOGGER.info("Usuário ADMIN inserido.");
            }

            // Garantir colunas de bloqueio em USUARIOS (compatibilidade com versões antigas)
            if (tabelaExiste(conn, "USUARIOS")) {
                if (!colunaExiste(conn, "USUARIOS", "BLOQUEADO")) {
                    try {
                        executarSql(conn, "ALTER TABLE usuarios ADD bloqueado BOOLEAN DEFAULT FALSE");
                        LOGGER.info("Coluna BLOQUEADO adicionada à tabela USUARIOS.");
                    } catch (SQLException ex) {
                        LOGGER.warning("Não foi possível adicionar coluna BLOQUEADO: " + ex.getMessage());
                    }
                }
                if (!colunaExiste(conn, "USUARIOS", "DATA_BLOQUEIO")) {
                    try {
                        executarSql(conn, "ALTER TABLE usuarios ADD data_bloqueio DATE");
                        LOGGER.info("Coluna DATA_BLOQUEIO adicionada à tabela USUARIOS.");
                    } catch (SQLException ex) {
                        LOGGER.warning("Não foi possível adicionar coluna DATA_BLOQUEIO: " + ex.getMessage());
                    }
                }
            }

            // 2. Criar Tabela Livros se não existir
            if (!tabelaExiste(conn, "LIVROS")) {
                String sql = "CREATE TABLE livros ("
                        + "id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), "
                        + "titulo VARCHAR(150) NOT NULL, "
                        + "autor VARCHAR(100) NOT NULL, "
                        + "editora VARCHAR(100), "
                        + "isbn VARCHAR(20) UNIQUE, "
                        + "quantidade_disponivel INT DEFAULT 0"
                        + ")";
                executarSql(conn, sql);
                LOGGER.info("Tabela LIVROS criada com sucesso.");
                
                // Inserir livros de exemplo
                executarSql(conn, "INSERT INTO livros (titulo, autor, editora, isbn, quantidade_disponivel) VALUES ('Java para Iniciantes', 'Professor Java', 'Tech Books', '123456', 5)");
                executarSql(conn, "INSERT INTO livros (titulo, autor, editora, isbn, quantidade_disponivel) VALUES ('Arquitetura Limpa', 'Robert Martin', 'Alta Books', '987654', 3)");
            }

            // 3. Criar Tabela Empréstimos se não existir
            if (!tabelaExiste(conn, "EMPRESTIMOS")) {
                String sql = "CREATE TABLE emprestimos ("
                        + "id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), "
                        + "livro_id INT NOT NULL, "
                        + "usuario_id INT NOT NULL, "
                        + "data_emprestimo DATE NOT NULL, "
                        + "data_devolucao_prevista DATE NOT NULL, "
                        + "data_devolucao_real DATE, "
                        + "FOREIGN KEY (livro_id) REFERENCES livros(id), "
                        + "FOREIGN KEY (usuario_id) REFERENCES usuarios(id)"
                        + ")";
                executarSql(conn, sql);
                LOGGER.info("Tabela EMPRESTIMOS criada com sucesso.");
            }
            
            // 4. Criar Tabela Devolucoes se não existir
            if (!tabelaExiste(conn, "DEVOLUCOES")) {
                String sqlDev = "CREATE TABLE devolucoes ("
                        + "id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), "
                        + "id_emprestimo INT, "
                        + "matricula_usuario VARCHAR(50), "
                        + "data_devolucao DATE, "
                        + "dias_atraso INT, "
                        + "valor_multa DOUBLE, "
                        + "penalidade_aplicada BOOLEAN DEFAULT FALSE, "
                        + "FOREIGN KEY (id_emprestimo) REFERENCES emprestimos(id)"
                        + ")";
                executarSql(conn, sqlDev);
                LOGGER.info("Tabela DEVOLUCOES criada com sucesso.");
            }

            // 5. Criar tabela Penalidades se não existir
            if (!tabelaExiste(conn, "PENALIDADES")) {
                String sqlPen = "CREATE TABLE penalidades ("
                        + "id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1), "
                        + "usuario_id INT NOT NULL, "
                        + "tipo VARCHAR(30) NOT NULL, "
                        + "data_inicio DATE NOT NULL, "
                        + "data_fim DATE, "
                        + "valor DECIMAL(10,2) DEFAULT 0.0, "
                        + "status VARCHAR(20) DEFAULT 'ATIVA', "
                        + "motivo_descricao VARCHAR(500), "
                        + "dias_atraso INT DEFAULT 0, "
                        + "FOREIGN KEY (usuario_id) REFERENCES usuarios(id)"
                        + ")";
                try {
                    executarSql(conn, sqlPen);
                    LOGGER.info("Tabela PENALIDADES criada com sucesso.");
                } catch (SQLException ex) {
                    LOGGER.warning("Não foi possível criar tabela PENALIDADES: " + ex.getMessage());
                }
            }
            
        } catch (Exception e) {
            LOGGER.severe("Erro ao inicializar banco de dados: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Nada a fazer quando desliga
    }

    // Método auxiliar para verificar se tabela existe (Derby armazena nomes em MAIÚSCULO)
    private boolean tabelaExiste(Connection conn, String nomeTabela) throws SQLException {
        DatabaseMetaData meta = conn.getMetaData();
        try (ResultSet rs = meta.getTables(null, null, nomeTabela.toUpperCase(), null)) {
            return rs.next();
        }
    }

    // Método auxiliar para verificar se uma coluna existe em uma tabela (case-insensitive)
    private boolean colunaExiste(Connection conn, String nomeTabela, String nomeColuna) throws SQLException {
        DatabaseMetaData meta = conn.getMetaData();
        try (ResultSet rs = meta.getColumns(null, null, nomeTabela.toUpperCase(), nomeColuna.toUpperCase())) {
            return rs.next();
        }
    }

    // Método auxiliar para rodar SQL
    private void executarSql(Connection conn, String sql) throws SQLException {
        try (Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
        }
    }
}
