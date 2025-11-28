/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.model.Usuario;
import com.utils.ConnectionFactory;

public class UsuarioDAO {

    public void salvar(Usuario usuario) throws SQLException {
        String sqlWithCpf = "INSERT INTO usuarios (nome, email, matricula, cpf) VALUES (?, ?, ?, ?)";
        String sqlWithoutCpf = "INSERT INTO usuarios (nome, email, matricula) VALUES (?, ?, ?)";

        try (Connection conn = ConnectionFactory.getConnection()) {
            boolean hasCpfColumn = false;
            // Detectar se a tabela possui a coluna 'cpf' (case-insensitive)
            try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM usuarios WHERE 1=0");
                 ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData md = rs.getMetaData();
                for (int i = 1; i <= md.getColumnCount(); i++) {
                    String label = md.getColumnLabel(i);
                    if (label != null && label.equalsIgnoreCase("cpf")) {
                        hasCpfColumn = true;
                        break;
                    }
                }
            } catch (SQLException e) {
                // Problema ao inspecionar metadata; assumimos ausência da coluna e prosseguimos
                hasCpfColumn = false;
            }

            String sql = hasCpfColumn ? sqlWithCpf : sqlWithoutCpf;
            try (PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, usuario.getNome());
                stmt.setString(2, usuario.getEmail());
                stmt.setString(3, usuario.getMatricula());
                if (hasCpfColumn) {
                    stmt.setString(4, usuario.getCPF());
                }

                stmt.executeUpdate();

                // Recupera o ID gerado pelo banco
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        usuario.setId(generatedKeys.getInt(1));
                    }
                }
            }
        }
    }

    public List<Usuario> listarTodos() throws SQLException {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT * FROM usuarios";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(getIntSafe(rs, "id"));
                u.setNome(getStringSafe(rs, "nome"));
                u.setEmail(getStringSafe(rs, "email"));
                u.setMatricula(getStringSafe(rs, "matricula"));
                u.setCPF(getStringSafe(rs, "cpf"));
                usuarios.add(u);
            }
        }
        return usuarios;
    }

    public Usuario buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM usuarios WHERE id = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(getIntSafe(rs, "id"));
                    u.setNome(getStringSafe(rs, "nome"));
                    u.setEmail(getStringSafe(rs, "email"));
                    u.setMatricula(getStringSafe(rs, "matricula"));
                    u.setCPF(getStringSafe(rs, "cpf"));
                    return u;
                }
            }
        }
        return null;
    }

    public Usuario buscarPorMatricula(String matricula) throws SQLException {
        String sql = "SELECT * FROM usuarios WHERE matricula = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, matricula);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(getIntSafe(rs, "id"));
                    u.setNome(getStringSafe(rs, "nome"));
                    u.setEmail(getStringSafe(rs, "email"));
                    u.setMatricula(getStringSafe(rs, "matricula"));
                    u.setCPF(getStringSafe(rs, "cpf"));
                    return u;
                }
            }
        }
        return null;
    }

    // Helpers para leitura tolerante de nomes de coluna (ignora diferenças de case/quoting)
    private String getStringSafe(ResultSet rs, String desired) {
        try {
            String label = resolveColumnLabel(rs, desired);
            if (label != null) return rs.getString(label);
        } catch (SQLException e) {
            // ignore and return null
        }
        return null;
    }

    private int getIntSafe(ResultSet rs, String desired) {
        try {
            String label = resolveColumnLabel(rs, desired);
            if (label != null) return rs.getInt(label);
        } catch (SQLException e) {
            // ignore
        }
        return 0;
    }

    private String resolveColumnLabel(ResultSet rs, String desired) throws SQLException {
        ResultSetMetaData md = rs.getMetaData();
        int cols = md.getColumnCount();
        for (int i = 1; i <= cols; i++) {
            String label = md.getColumnLabel(i);
            if (label != null && label.equalsIgnoreCase(desired)) return label;
        }
        return null;
    }

    public void deletar(int id) throws SQLException {
        String sql = "DELETE FROM usuarios WHERE id = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }
}
