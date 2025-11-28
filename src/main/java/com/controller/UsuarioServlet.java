/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller;

import com.dao.UsuarioDAO;
import com.model.Usuario;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "UsuarioServlet", urlPatterns = {"/usuarios"})
public class UsuarioServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String acao = req.getParameter("acao");
        
        // Verifica se é uma requisição de confirmação de deleção
        if ("confirmarDeletar".equals(acao)) {
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    Usuario usuario = usuarioDAO.buscarPorId(id);
                    if (usuario != null) {
                        req.setAttribute("usuario", usuario);
                        req.getRequestDispatcher("/confirmar-deletar-usuario.jsp").forward(req, resp);
                        return;
                    }
                } catch (NumberFormatException | SQLException e) {
                    throw new ServletException("Erro ao buscar usuário", e);
                }
            }
        }
        
        // Verifica se é uma requisição de deleção confirmada
        if ("deletar".equals(acao)) {
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    usuarioDAO.deletar(id);
                    resp.sendRedirect("usuarios");
                    return;
                } catch (NumberFormatException | SQLException e) {
                    throw new ServletException("Erro ao deletar usuário", e);
                }
            }
        }
        
        // Listagem normal
        try {
            List<Usuario> lista = usuarioDAO.listarTodos();
            req.setAttribute("listaUsuarios", lista);
            req.getRequestDispatcher("/cadastro-usuario.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Erro ao listar usuários", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String nome = req.getParameter("nome");
        String email = req.getParameter("email");
        String matricula = req.getParameter("matricula");
        String cpf = req.getParameter("cpf");

        Usuario usuario = new Usuario();
        usuario.setNome(nome);
        usuario.setEmail(email);
        usuario.setMatricula(matricula);
        usuario.setCPF(cpf);

        try {
            usuarioDAO.salvar(usuario);
            resp.sendRedirect("usuarios");
        } catch (SQLException e) {
            throw new ServletException("Erro ao cadastrar usuário", e);
        }
    }
}