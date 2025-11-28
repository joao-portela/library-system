package com.controller;

import com.dao.LivroDAO;
import com.model.Livro;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet(name = "LivroServlet", urlPatterns = {"/livros"})
public class LivroServlet extends HttpServlet {

    private LivroDAO livroDAO = new LivroDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
                    List<Livro> lista = livroDAO.listarTodos();

                    req.setAttribute("listaLivros", lista);

                    req.getRequestDispatcher("/cadastro-livro.jsp").forward(req, resp);

                } catch (SQLException e) {
                    throw new ServletException("Erro ao buscar livros", e);
                }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String titulo = req.getParameter("titulo");
        String autor = req.getParameter("autor");
        String editora = req.getParameter("editora");
        String isbn = req.getParameter("isbn");
        
        String qtdStr = req.getParameter("quantidade");
        int qtd = (qtdStr != null && !qtdStr.isEmpty()) ? Integer.parseInt(qtdStr) : 0;

        Livro livro = new Livro(titulo, autor, editora, isbn, qtd);

        try {
            livroDAO.salvar(livro);
            
            resp.sendRedirect("livros");
            
        } catch (SQLException e) {
            throw new ServletException("Erro ao salvar livro", e);
        }
    }
}