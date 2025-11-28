/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dao;

import com.model.Emprestimo;
import com.model.Livro;
import com.model.Usuario;
import com.utils.ConnectionFactory;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO persistente para empréstimos usando Java DB (Derby).
 */
public class EmprestimoDAO {

	public Emprestimo salvar(Emprestimo e) {
		String sql = "INSERT INTO EMPRESTIMOS (LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL) VALUES (?,?,?,?,?)";
		try (Connection conn = ConnectionFactory.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			ps.setInt(1, e.getLivro().getId());
			ps.setInt(2, e.getUsuario().getId());
			ps.setDate(3, e.getDataEmprestimo() != null ? e.getDataEmprestimo() : Date.valueOf(java.time.LocalDate.now()));
			ps.setDate(4, e.getDataDevolucaoPrevista() != null ? e.getDataDevolucaoPrevista() : Date.valueOf(java.time.LocalDate.now().plusDays(7)));
			if (e.getDataDevolucaoReal() != null) {
				ps.setDate(5, e.getDataDevolucaoReal());
			} else {
				ps.setNull(5, Types.DATE);
			}

			ps.executeUpdate();
			try (ResultSet rs = ps.getGeneratedKeys()) {
				if (rs.next()) {
					e.setId(rs.getInt(1));
				}
			}
			return e;
		} catch (SQLException ex) {
			throw new RuntimeException(ex);
		}
	}

	public List<Emprestimo> listarTodos() {
		String sql = "SELECT ID, LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL FROM EMPRESTIMOS ORDER BY DATA_EMPRESTIMO DESC";
		List<Emprestimo> resultado = new ArrayList<>();
		try (Connection conn = ConnectionFactory.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql);
			 ResultSet rs = ps.executeQuery()) {

			LivroDAO livroDAO = new LivroDAO();
			UsuarioDAO usuarioDAO = new UsuarioDAO();

			while (rs.next()) {
				Emprestimo e = new Emprestimo();
				e.setId(rs.getInt("ID"));
				int idLivro = rs.getInt("LIVRO_ID");
				int idUsuario = rs.getInt("USUARIO_ID");
				Livro l = livroDAO.buscarPorId(idLivro);
				Usuario u = usuarioDAO.buscarPorId(idUsuario);
				e.setLivro(l);
				e.setUsuario(u);
				e.setDataEmprestimo(rs.getDate("DATA_EMPRESTIMO"));
				e.setDataDevolucaoPrevista(rs.getDate("DATA_DEVOLUCAO_PREVISTA"));
				e.setDataDevolucaoReal(rs.getDate("DATA_DEVOLUCAO_REAL"));
				resultado.add(e);
			}
			return resultado;
		} catch (SQLException ex) {
			throw new RuntimeException(ex);
		}
	}

	public List<Emprestimo> listarPorMatricula(String matricula) {
		// Reutiliza UsuarioDAO para localizar usuário e então busca por id_usuario
		try {
			UsuarioDAO usuarioDAO = new UsuarioDAO();
			Usuario usuario = usuarioDAO.buscarPorMatricula(matricula);
			List<Emprestimo> res = new ArrayList<>();
			if (usuario == null) return res;

			String sql = "SELECT ID, LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL FROM EMPRESTIMOS WHERE USUARIO_ID = ? ORDER BY DATA_EMPRESTIMO DESC";
			try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
				ps.setInt(1, usuario.getId());
				try (ResultSet rs = ps.executeQuery()) {
					LivroDAO livroDAO = new LivroDAO();
					while (rs.next()) {
						Emprestimo e = new Emprestimo();
						e.setId(rs.getInt("ID"));
						int idLivro = rs.getInt("LIVRO_ID");
						Livro l = livroDAO.buscarPorId(idLivro);
						e.setLivro(l);
						e.setUsuario(usuario);
						e.setDataEmprestimo(rs.getDate("DATA_EMPRESTIMO"));
						e.setDataDevolucaoPrevista(rs.getDate("DATA_DEVOLUCAO_PREVISTA"));
						e.setDataDevolucaoReal(rs.getDate("DATA_DEVOLUCAO_REAL"));
						res.add(e);
					}
				}
			}
			return res;
		} catch (SQLException ex) {
			throw new RuntimeException(ex);
		}
	}

	public Emprestimo buscarPorId(int id) {
		String sql = "SELECT ID, LIVRO_ID, USUARIO_ID, DATA_EMPRESTIMO, DATA_DEVOLUCAO_PREVISTA, DATA_DEVOLUCAO_REAL FROM EMPRESTIMOS WHERE ID = ?";
		try (Connection conn = ConnectionFactory.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
					if (rs.next()) {
						Emprestimo e = new Emprestimo();
						e.setId(rs.getInt("ID"));
						int idLivro = rs.getInt("LIVRO_ID");
						int idUsuario = rs.getInt("USUARIO_ID");
						LivroDAO livroDAO = new LivroDAO();
						UsuarioDAO usuarioDAO = new UsuarioDAO();
						Livro l = livroDAO.buscarPorId(idLivro);
						Usuario u = usuarioDAO.buscarPorId(idUsuario);
						e.setLivro(l);
						e.setUsuario(u);
						e.setDataEmprestimo(rs.getDate("DATA_EMPRESTIMO"));
						e.setDataDevolucaoPrevista(rs.getDate("DATA_DEVOLUCAO_PREVISTA"));
						e.setDataDevolucaoReal(rs.getDate("DATA_DEVOLUCAO_REAL"));
						return e;
					}
			}
			return null;
		} catch (SQLException ex) {
			throw new RuntimeException(ex);
		}
	}

}
