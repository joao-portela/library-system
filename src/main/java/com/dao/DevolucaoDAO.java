package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.model.Devolucao;
import com.utils.ConnectionFactory;

public class DevolucaoDAO {

    public double calcularMulta(LocalDate dataPrevista, LocalDate dataDevolucao) {
        if (dataDevolucao == null || dataPrevista == null) {
            return 0.0;
        }
        int dias = (int) java.time.temporal.ChronoUnit.DAYS.between(dataPrevista, dataDevolucao);
        if (dias <= 0) {
            return 0.0;
        }
        double multaPorDia = 1.5;
        double valor = dias * multaPorDia;
        if (dias > 30) {
            valor += 50.0;
        }
        return valor;
    }

    public Devolucao registrarDevolucao(Devolucao devolucao) {
        String insertSql = "INSERT INTO devolucoes (id_emprestimo, matricula_usuario, data_devolucao, dias_atraso, valor_multa, penalidade_aplicada) VALUES (?,?,?,?,?,?)";
        String updateEmprestimoSql = "UPDATE emprestimos SET data_devolucao_real = ? WHERE id = ?";
        String selectLivroSql = "SELECT livro_id FROM emprestimos WHERE id = ?";
        String updateLivroSql = "UPDATE livros SET quantidade_disponivel = quantidade_disponivel + 1 WHERE id = ?";

        try (Connection conn = ConnectionFactory.getConnection()) {
            try {
                conn.setAutoCommit(false);

                try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setLong(1, devolucao.getIdEmprestimo() != null ? devolucao.getIdEmprestimo() : 0L);
                    ps.setString(2, devolucao.getMatriculaUsuario());
                    if (devolucao.getDataDevolucao() != null) {
                        ps.setDate(3, java.sql.Date.valueOf(devolucao.getDataDevolucao()));
                    } else {
                        ps.setNull(3, java.sql.Types.DATE);
                    }
                    ps.setInt(4, devolucao.getDiasAtraso());
                    ps.setDouble(5, devolucao.getValorMulta());
                    ps.setBoolean(6, devolucao.isPenalidadeAplicada());
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            devolucao.setId(rs.getLong(1));
                        }
                    }
                }

                if (devolucao.getIdEmprestimo() != null && devolucao.getIdEmprestimo() > 0) {
                    try (PreparedStatement ps2 = conn.prepareStatement(updateEmprestimoSql)) {
                        if (devolucao.getDataDevolucao() != null) {
                            ps2.setDate(1, java.sql.Date.valueOf(devolucao.getDataDevolucao()));
                        } else {
                            ps2.setNull(1, java.sql.Types.DATE);
                        }
                        ps2.setLong(2, devolucao.getIdEmprestimo());
                        ps2.executeUpdate();
                    }

                    Integer livroId = null;
                    try (PreparedStatement ps3 = conn.prepareStatement(selectLivroSql)) {
                        ps3.setLong(1, devolucao.getIdEmprestimo());
                        try (ResultSet rs = ps3.executeQuery()) {
                            if (rs.next()) {
                                livroId = rs.getInt(1);
                            }
                        }
                    }
                    if (livroId != null) {
                        try (PreparedStatement ps4 = conn.prepareStatement(updateLivroSql)) {
                            ps4.setInt(1, livroId);
                            ps4.executeUpdate();
                        }
                    }
                }

                conn.commit();
                return devolucao;
            } catch (Exception e) {
                try { conn.rollback(); } catch (Exception ex) {}
                throw new RuntimeException(e);
            } finally {
                try { conn.setAutoCommit(true); } catch (Exception ex) {}
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public List<Devolucao> buscarPorUsuario(String matricula) {
        String sql = "SELECT id, id_emprestimo, matricula_usuario, data_devolucao, dias_atraso, valor_multa, penalidade_aplicada FROM devolucoes WHERE matricula_usuario = ? ORDER BY data_devolucao DESC";
        List<Devolucao> resultado = new ArrayList<>();
        try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, matricula);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Devolucao d = new Devolucao();
                    d.setId(rs.getLong("id"));
                    d.setIdEmprestimo(rs.getLong("id_emprestimo"));
                    d.setMatriculaUsuario(rs.getString("matricula_usuario"));
                    Object obj = rs.getObject("data_devolucao");
                    if (obj instanceof java.sql.Date) {
                        d.setDataDevolucao(((java.sql.Date) obj).toLocalDate());
                    }
                    d.setDiasAtraso(rs.getInt("dias_atraso"));
                    d.setValorMulta(rs.getDouble("valor_multa"));
                    d.setPenalidadeAplicada(rs.getBoolean("penalidade_aplicada"));
                    resultado.add(d);
                }
            }
            return resultado;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public List<Devolucao> buscarTodos() {
        String sql = "SELECT id, id_emprestimo, matricula_usuario, data_devolucao, dias_atraso, valor_multa, penalidade_aplicada FROM devolucoes ORDER BY data_devolucao DESC";
        List<Devolucao> resultado = new ArrayList<>();
        try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Devolucao d = new Devolucao();
                d.setId(rs.getLong("id"));
                d.setIdEmprestimo(rs.getLong("id_emprestimo"));
                d.setMatriculaUsuario(rs.getString("matricula_usuario"));
                Object obj = rs.getObject("data_devolucao");
                if (obj instanceof java.sql.Date) {
                    d.setDataDevolucao(((java.sql.Date) obj).toLocalDate());
                }
                d.setDiasAtraso(rs.getInt("dias_atraso"));
                d.setValorMulta(rs.getDouble("valor_multa"));
                d.setPenalidadeAplicada(rs.getBoolean("penalidade_aplicada"));
                resultado.add(d);
            }
            return resultado;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public boolean usuarioPossuiPenalidade(String matricula) {
        String sql = "SELECT COUNT(1) AS qtd FROM devolucoes WHERE matricula_usuario = ? AND penalidade_aplicada = TRUE";
        try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, matricula);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("qtd") > 0;
                }
            }
            return false;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
