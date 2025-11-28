package com.dao;

import com.model.Penalidade;
import com.model.Penalidade.StatusPenalidade;
import com.model.Penalidade.TipoPenalidade;
import com.utils.ConnectionFactory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para gerenciar penalidades aplicadas aos usuários
 */
public class PenalidadeDAO {

    /**
     * Registra uma nova penalidade no banco de dados
     */
    public Penalidade registrar(Penalidade penalidade) throws SQLException {
        String sql = "INSERT INTO penalidades (usuario_id, tipo, data_inicio, data_fim, valor, status, motivo_descricao, dias_atraso) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, penalidade.getUsuarioId());
            stmt.setString(2, penalidade.getTipo().name());
            stmt.setObject(3, penalidade.getDataInicio());
            stmt.setObject(4, penalidade.getDataFim());
            stmt.setDouble(5, penalidade.getValor());
            stmt.setString(6, penalidade.getStatus().name());
            stmt.setString(7, penalidade.getMotivoDescricao());
            stmt.setInt(8, penalidade.getDiasAtraso());
            
            stmt.executeUpdate();
            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    penalidade.setId(rs.getLong(1));
                }
            }
            
            return penalidade;
        }
    }

    /**
     * Busca todas as penalidades ativas de um usuário
     */
    public List<Penalidade> buscarAtivasPorUsuario(int usuarioId) throws SQLException {
        String sql = "SELECT * FROM penalidades WHERE usuario_id = ? AND status = 'ATIVA' ORDER BY data_inicio DESC";
        List<Penalidade> penalidades = new ArrayList<>();
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    penalidades.add(extrairPenalidade(rs));
                }
            }
        }
        
        return penalidades;
    }

    /**
     * Busca todas as penalidades de um usuário
     */
    public List<Penalidade> buscarPorUsuario(int usuarioId) throws SQLException {
        String sql = "SELECT * FROM penalidades WHERE usuario_id = ? ORDER BY data_inicio DESC";
        List<Penalidade> penalidades = new ArrayList<>();
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    penalidades.add(extrairPenalidade(rs));
                }
            }
        }
        
        return penalidades;
    }

    /**
     * Busca todas as penalidades do sistema
     */
    public List<Penalidade> buscarTodas() throws SQLException {
        String sql = "SELECT * FROM penalidades ORDER BY data_inicio DESC";
        List<Penalidade> penalidades = new ArrayList<>();
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                penalidades.add(extrairPenalidade(rs));
            }
        }
        
        return penalidades;
    }

    /**
     * Verifica se o usuário tem bloqueio ativo
     */
    public boolean usuarioTemBloqueioAtivo(int usuarioId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM penalidades WHERE usuario_id = ? AND tipo = 'BLOQUEIO_TEMPORARIO' " +
                     "AND status = 'ATIVA' AND (data_fim IS NULL OR data_fim >= CURRENT_DATE)";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        
        return false;
    }

    /**
     * Verifica se o usuário tem multas pendentes
     */
    public boolean usuarioTemMultasPendentes(int usuarioId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM penalidades WHERE usuario_id = ? AND tipo = 'MULTA' " +
                     "AND status = 'ATIVA'";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        
        return false;
    }

    /**
     * Calcula o total de multas pendentes de um usuário
     */
    public double calcularTotalMultasPendentes(int usuarioId) throws SQLException {
        String sql = "SELECT SUM(valor) FROM penalidades WHERE usuario_id = ? AND tipo = 'MULTA' " +
                     "AND status = 'ATIVA'";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        }
        
        return 0.0;
    }

    /**
     * Atualiza o status de uma penalidade
     */
    public void atualizarStatus(Long id, StatusPenalidade novoStatus) throws SQLException {
        String sql = "UPDATE penalidades SET status = ? WHERE id = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, novoStatus.name());
            stmt.setLong(2, id);
            stmt.executeUpdate();
        }
    }

    /**
     * Marca uma multa como paga
     */
    public void pagarMulta(Long id) throws SQLException {
        atualizarStatus(id, StatusPenalidade.PAGA);
    }

    /**
     * Cancela uma penalidade
     */
    public void cancelarPenalidade(Long id) throws SQLException {
        atualizarStatus(id, StatusPenalidade.CANCELADA);
    }

    /**
     * Expira bloqueios temporários vencidos
     */
    public int expirarBloqueiosVencidos() throws SQLException {
        String sql = "UPDATE penalidades SET status = 'EXPIRADA' WHERE tipo = 'BLOQUEIO_TEMPORARIO' " +
                     "AND status = 'ATIVA' AND data_fim < CURRENT_DATE";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            return stmt.executeUpdate();
        }
    }

    /**
     * Busca penalidade por ID
     */
    public Penalidade buscarPorId(Long id) throws SQLException {
        String sql = "SELECT * FROM penalidades WHERE id = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extrairPenalidade(rs);
                }
            }
        }
        
        return null;
    }

    /**
     * Extrai um objeto Penalidade do ResultSet
     */
    private Penalidade extrairPenalidade(ResultSet rs) throws SQLException {
        Penalidade p = new Penalidade();
        p.setId(rs.getLong("id"));
        p.setUsuarioId(rs.getInt("usuario_id"));
        p.setTipo(TipoPenalidade.valueOf(rs.getString("tipo")));
        
        Object dataInicio = rs.getObject("data_inicio");
        if (dataInicio instanceof java.sql.Date) {
            p.setDataInicio(((java.sql.Date) dataInicio).toLocalDate());
        }
        
        Object dataFim = rs.getObject("data_fim");
        if (dataFim instanceof java.sql.Date) {
            p.setDataFim(((java.sql.Date) dataFim).toLocalDate());
        }
        
        p.setValor(rs.getDouble("valor"));
        p.setStatus(StatusPenalidade.valueOf(rs.getString("status")));
        p.setMotivoDescricao(rs.getString("motivo_descricao"));
        p.setDiasAtraso(rs.getInt("dias_atraso"));
        
        return p;
    }
}
