/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.controller;

import com.dao.LivroDAO;
import com.model.Livro;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
// Atualizado para jakarta (versões novas do Netbeans/GlassFish)
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author joaop
 */
@WebServlet(name = "LivroServlet", urlPatterns = {"/livros"})
public class LivroServlet extends HttpServlet {

    private LivroDAO livroDAO = new LivroDAO();

    // O método doGet é chamado quando acessamos a URL /livros pelo navegador
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            // 1. Chama o DAO para buscar todos os livros do banco
                String acao = req.getParameter("acao");

                // Confirmação de deleção
                if ("confirmarDeletar".equals(acao)) {
                    String idStr = req.getParameter("id");
                    if (idStr != null && !idStr.isEmpty()) {
                        try {
                            int id = Integer.parseInt(idStr);
                            Livro livro = livroDAO.buscarPorId(id);
                            if (livro != null) {
                                req.setAttribute("livro", livro);
                                req.getRequestDispatcher("/confirmar-deletar-livro.jsp").forward(req, resp);
                                return;
                            }
                        } catch (NumberFormatException | SQLException e) {
                            throw new ServletException("Erro ao buscar livro", e);
                        }
                    }
                }

                // Deleção confirmada
                if ("deletar".equals(acao)) {
                    String idStr = req.getParameter("id");
                    if (idStr != null && !idStr.isEmpty()) {
                        try {
                            int id = Integer.parseInt(idStr);
                            livroDAO.deletar(id);
                            resp.sendRedirect("livros");
                            return;
                        } catch (NumberFormatException | SQLException e) {
                            throw new ServletException("Erro ao deletar livro", e);
                        }
                    }
                }

                try {
                    // 1. Chama o DAO para buscar todos os livros do banco
                    List<Livro> lista = livroDAO.listarTodos();

                    // 2. Coloca a lista dentro da requisição para o JSP poder ler
                    req.setAttribute("listaLivros", lista);

                    // 3. Encaminha para a página JSP que vai desenhar a tabela
                    req.getRequestDispatcher("/cadastro-livro.jsp").forward(req, resp);

                } catch (SQLException e) {
                    throw new ServletException("Erro ao buscar livros", e);
                }
    }

    // O método doPost é chamado quando o formulário de cadastro é enviado
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        // 1. Pega os dados que vieram dos campos do formulário HTML
        String titulo = req.getParameter("titulo");
        String autor = req.getParameter("autor");
        String editora = req.getParameter("editora");
        String isbn = req.getParameter("isbn");
        
        // Tratamento simples para evitar erro se a quantidade vier vazia
        String qtdStr = req.getParameter("quantidade");
        int qtd = (qtdStr != null && !qtdStr.isEmpty()) ? Integer.parseInt(qtdStr) : 0;

        // 2. Cria o objeto Livro
        Livro livro = new Livro(titulo, autor, editora, isbn, qtd);

        try {
            // 3. Manda o DAO salvar no banco
            livroDAO.salvar(livro);
            
            // 4. Redireciona de volta para a lista (chama o doGet novamente)
            resp.sendRedirect("livros");
            
        } catch (SQLException e) {
            throw new ServletException("Erro ao salvar livro", e);
        }
    }
}