package com.dao;

import com.model.EmprestimoAtrasadoDTO;
import com.model.LivroRelatorioDTO;
import com.model.UsuarioRelatorioDTO;
import com.utils.ConnectionFactory;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para geração de relatórios administrativos
 */
public class RelatorioDAO {
    
    /**
     * Obtém os livros mais emprestados
     * @param limite Número máximo de registros a retornar
     * @return Lista de livros ordenados por número de empréstimos (decrescente)
     */
    public List<LivroRelatorioDTO> obterLivrosMaisEmprestados(int limite) throws SQLException {
        List<LivroRelatorioDTO> resultado = new ArrayList<>();
        String sql = "SELECT l.ID, l.TITULO, l.AUTOR, l.EDITORA, COUNT(e.ID) AS TOTAL_EMPRESTIMOS " +
                     "FROM LIVROS l " +
                     "INNER JOIN EMPRESTIMOS e ON l.ID = e.LIVRO_ID " +
                     "GROUP BY l.ID, l.TITULO, l.AUTOR, l.EDITORA " +
                     "ORDER BY TOTAL_EMPRESTIMOS DESC " +
                     "FETCH FIRST ? ROWS ONLY";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limite);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LivroRelatorioDTO dto = new LivroRelatorioDTO(
                        rs.getInt("ID"),
                        rs.getString("TITULO"),
                        rs.getString("AUTOR"),
                        rs.getString("EDITORA"),
                        rs.getInt("TOTAL_EMPRESTIMOS")
                    );
                    resultado.add(dto);
                }
            }
        }
        return resultado;
    }
    
    /**
     * Obtém os usuários com mais empréstimos
     * @param limite Número máximo de registros a retornar
     * @return Lista de usuários ordenados por número de empréstimos (decrescente)
     */
    public List<UsuarioRelatorioDTO> obterUsuariosComMaisEmprestimos(int limite) throws SQLException {
        List<UsuarioRelatorioDTO> resultado = new ArrayList<>();
        String sql = "SELECT u.ID, u.NOME, u.MATRICULA, u.EMAIL, COUNT(e.ID) AS TOTAL_EMPRESTIMOS " +
                     "FROM USUARIOS u " +
                     "INNER JOIN EMPRESTIMOS e ON u.ID = e.USUARIO_ID " +
                     "GROUP BY u.ID, u.NOME, u.MATRICULA, u.EMAIL " +
                     "ORDER BY TOTAL_EMPRESTIMOS DESC " +
                     "FETCH FIRST ? ROWS ONLY";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limite);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UsuarioRelatorioDTO dto = new UsuarioRelatorioDTO(
                        rs.getInt("ID"),
                        rs.getString("NOME"),
                        rs.getString("MATRICULA"),
                        rs.getString("EMAIL"),
                        rs.getInt("TOTAL_EMPRESTIMOS")
                    );
                    resultado.add(dto);
                }
            }
        }
        return resultado;
    }
    
    /**
     * Obtém os empréstimos em atraso (não devolvidos e com data de devolução prevista vencida)
     * @return Lista de empréstimos em atraso ordenados por dias de atraso (decrescente)
     */
    public List<EmprestimoAtrasadoDTO> obterEmprestimosEmAtraso() throws SQLException {
        List<EmprestimoAtrasadoDTO> resultado = new ArrayList<>();
        
        // Busca empréstimos onde data_devolucao_real é NULL e data_devolucao_prevista < hoje
        String sql = "SELECT e.ID, l.TITULO, u.NOME, u.MATRICULA, " +
                     "e.DATA_EMPRESTIMO, e.DATA_DEVOLUCAO_PREVISTA " +
                     "FROM EMPRESTIMOS e " +
                     "INNER JOIN LIVROS l ON e.LIVRO_ID = l.ID " +
                     "INNER JOIN USUARIOS u ON e.USUARIO_ID = u.ID " +
                     "WHERE e.DATA_DEVOLUCAO_REAL IS NULL " +
                     "AND e.DATA_DEVOLUCAO_PREVISTA < CURRENT_DATE " +
                     "ORDER BY e.DATA_DEVOLUCAO_PREVISTA ASC";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            LocalDate hoje = LocalDate.now();
            
            while (rs.next()) {
                Date dataDevolucaoPrevista = rs.getDate("DATA_DEVOLUCAO_PREVISTA");
                LocalDate dataPrevisao = dataDevolucaoPrevista.toLocalDate();
                
                // Calcula os dias de atraso usando Java Time API
                int diasAtraso = (int) java.time.temporal.ChronoUnit.DAYS.between(dataPrevisao, hoje);
                
                EmprestimoAtrasadoDTO dto = new EmprestimoAtrasadoDTO(
                    rs.getInt("ID"),
                    rs.getString("TITULO"),
                    rs.getString("NOME"),
                    rs.getString("MATRICULA"),
                    rs.getDate("DATA_EMPRESTIMO"),
                    dataDevolucaoPrevista,
                    diasAtraso
                );
                resultado.add(dto);
            }
        }
        return resultado;
    }
    
    /**
     * Obtém estatísticas gerais do sistema
     * @return Array com [totalLivros, totalUsuarios, totalEmprestimosAtivos, totalEmprestimosAtrasados]
     */
    public int[] obterEstatisticasGerais() throws SQLException {
        int[] stats = new int[4];
        
        try (Connection conn = ConnectionFactory.getConnection()) {
            // Total de livros
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM LIVROS");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats[0] = rs.getInt(1);
                }
            }
            
            // Total de usuários
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM USUARIOS");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats[1] = rs.getInt(1);
                }
            }
            
            // Total de empréstimos ativos (não devolvidos)
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COUNT(*) FROM EMPRESTIMOS WHERE DATA_DEVOLUCAO_REAL IS NULL");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats[2] = rs.getInt(1);
                }
            }
            
            // Total de empréstimos atrasados
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT COUNT(*) FROM EMPRESTIMOS WHERE DATA_DEVOLUCAO_REAL IS NULL " +
                    "AND DATA_DEVOLUCAO_PREVISTA < CURRENT_DATE");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats[3] = rs.getInt(1);
                }
            }
        }
        
        return stats;
    }
}
