package com.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

import com.dao.DevolucaoDAO;
import com.dao.EmprestimoDAO;
import com.dao.LivroDAO;
import com.dao.UsuarioDAO;
import com.model.Emprestimo;
import com.model.Livro;
import com.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "EmprestimoServlet", urlPatterns = {"/emprestimos"})
public class EmprestimoServlet extends HttpServlet {

    private EmprestimoDAO emprestimoDAO = new EmprestimoDAO();
    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private LivroDAO livroDAO = new LivroDAO();
    private DevolucaoDAO devolucaoDAO = new DevolucaoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Tentar carregar livros do banco; em caso de erro, mostrar mensagem e continuar com lista vazia
        List<Livro> livros = new java.util.ArrayList<>();
        try {
            livros = livroDAO.listarTodos();
        } catch (SQLException e) {
            req.setAttribute("erro", "Não foi possível carregar livros: " + e.getMessage());
        }
        req.setAttribute("listaLivros", livros);

        // carregar lista de empréstimos persistidos
        List<Emprestimo> lista = emprestimoDAO.listarTodos();
        req.setAttribute("listaEmprestimos", lista);

        // possibilidade de mensagem de usuário não encontrado (placard na JSP)
        String matriculaPrefill = req.getParameter("matriculaPrefill");
        if (matriculaPrefill != null && !matriculaPrefill.isEmpty()) {
            req.setAttribute("matriculaPrefill", matriculaPrefill);
            req.setAttribute("usuarioNaoEncontrado", true);
        }

        req.getRequestDispatcher("/fazer-emprestimo.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String matricula = req.getParameter("matricula");
        String livroIdStr = req.getParameter("livroId");

        if (matricula == null || matricula.isEmpty() || livroIdStr == null || livroIdStr.isEmpty()) {
            req.setAttribute("erro", "Matrícula e livro são obrigatórios.");
            doGet(req, resp);
            return;
        }

        try {
            Usuario usuario = usuarioDAO.buscarPorMatricula(matricula);
            if (usuario == null) {
                // Perguntar se deseja cadastrar; retornar para página com flag
                req.setAttribute("usuarioNaoEncontrado", true);
                req.setAttribute("matriculaPrefill", matricula);
                doGet(req, resp);
                return;
            }

            int livroId = Integer.parseInt(livroIdStr);
            Livro livro = livroDAO.buscarPorId(livroId);
            if (livro == null) {
                req.setAttribute("erro", "Livro não encontrado.");
                doGet(req, resp);
                return;
            }

            try {
                boolean possuiPenalidade = devolucaoDAO.usuarioPossuiPenalidade(matricula);
                if (possuiPenalidade) {
                    req.setAttribute("erro", "Usuário possui penalidade por atraso excessivo e não pode realizar empréstimos até regularizar.");
                    doGet(req, resp);
                    return;
                }
            } catch (Exception ex) {
                req.setAttribute("erro", "Não foi possível verificar penalidades do usuário: " + ex.getMessage());
                doGet(req, resp);
                return;
            }

            if (livro.getQuantidadeDisponivel() <= 0) {
                req.setAttribute("erro", "Não há exemplares disponíveis deste livro.");
                doGet(req, resp);
                return;
            }

            // Criar empréstimo em memória
            Emprestimo e = new Emprestimo();
            e.setLivro(livro);
            e.setUsuario(usuario);
            e.setDataEmprestimo(Date.valueOf(LocalDate.now()));
            e.setDataDevolucaoPrevista(Date.valueOf(LocalDate.now().plusDays(7)));

            emprestimoDAO.salvar(e);

            // Atualizar disponibilidade do livro
            int novaQtd = livro.getQuantidadeDisponivel() - 1;
            livroDAO.atualizarQuantidadeDisponivel(livro.getId(), novaQtd);

            resp.sendRedirect("emprestimos");
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
