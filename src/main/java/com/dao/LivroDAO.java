/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao;

import com.model.Livro;
import com.utils.ConnectionFactory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author joaop
 */
public class LivroDAO {
     public void salvar(Livro livro) throws SQLException {
        String sql = "INSERT INTO livros (titulo, autor, editora, isbn, quantidade_disponivel) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, livro.getTitulo());
            stmt.setString(2, livro.getAutor());
            stmt.setString(3, livro.getEditora());
            stmt.setString(4, livro.getIsbn());
            stmt.setInt(5, livro.getQuantidadeDisponivel());
            
            stmt.execute();
        }
    }

    public List<Livro> listarTodos() throws SQLException {
        List<Livro> livros = new ArrayList<>();
        String sql = "SELECT * FROM livros";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Livro l = new Livro();
                l.setId(rs.getInt("id"));
                l.setTitulo(rs.getString("titulo"));
                l.setAutor(rs.getString("autor"));
                l.setEditora(rs.getString("editora"));
                l.setIsbn(rs.getString("isbn"));
                l.setQuantidadeDisponivel(rs.getInt("quantidade_disponivel"));
                livros.add(l);
            }
        }
        return livros;
    }
    
    // Método auxiliar para buscar disponibilidade
    public Livro buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM livros WHERE id = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Livro l = new Livro();
                    l.setId(rs.getInt("id"));
                    l.setTitulo(rs.getString("titulo"));
                    l.setQuantidadeDisponivel(rs.getInt("quantidade_disponivel"));
                    // setar outros campos...
                    return l;
                }
            }
        }
        return null;
    }
}
