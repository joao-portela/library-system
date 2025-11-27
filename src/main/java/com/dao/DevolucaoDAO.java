package com.dao;

import com.model.Devolucao;
import com.utils.ConnectionFactory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

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
        String sql = "INSERT INTO devolucoes (id_emprestimo, matricula_usuario, data_devolucao, dias_atraso, valor_multa, penalidade_aplicada) VALUES (?,?,?,?,?,?)";
        try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, devolucao.getIdEmprestimo() != null ? devolucao.getIdEmprestimo() : 0L);
            ps.setString(2, devolucao.getMatriculaUsuario());
            ps.setObject(3, devolucao.getDataDevolucao());
            ps.setInt(4, devolucao.getDiasAtraso());
            ps.setDouble(5, devolucao.getValorMulta());
            ps.setBoolean(6, devolucao.isPenalidadeAplicada());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    devolucao.setId(rs.getLong(1));
                }
            }
            return devolucao;
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
}
