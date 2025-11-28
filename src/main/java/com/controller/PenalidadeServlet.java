package com.controller;

import com.dao.PenalidadeDAO;
import com.dao.UsuarioDAO;
import com.model.Penalidade;
import com.model.Penalidade.StatusPenalidade;
import com.model.Usuario;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet para gerenciar penalidades dos usuários
 */
@WebServlet(name = "PenalidadeServlet", urlPatterns = {"/penalidades"})
public class PenalidadeServlet extends HttpServlet {

    private PenalidadeDAO penalidadeDAO = new PenalidadeDAO();
    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if (action == null) {
            action = "listar";
        }
        
        try {
            switch (action) {
                case "listar":
                    listarPenalidades(req, resp);
                    break;
                case "usuario":
                    listarPenalidadesPorUsuario(req, resp);
                    break;
                case "bloqueados":
                    listarUsuariosBloqueados(req, resp);
                    break;
                default:
                    listarPenalidades(req, resp);
                    break;
            }
        } catch (Exception e) {
            req.setAttribute("erro", "Erro ao processar requisição: " + e.getMessage());
            req.getRequestDispatcher("/gerenciar-penalidades.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        try {
            switch (action) {
                case "pagar":
                    pagarMulta(req, resp);
                    break;
                case "cancelar":
                    cancelarPenalidade(req, resp);
                    break;
                case "desbloquear":
                    desbloquearUsuario(req, resp);
                    break;
                case "expirar":
                    expirarBloqueios(req, resp);
                    break;
                default:
                    resp.sendRedirect("penalidades");
                    break;
            }
        } catch (Exception e) {
            req.setAttribute("erro", "Erro ao processar ação: " + e.getMessage());
            req.getRequestDispatcher("/gerenciar-penalidades.jsp").forward(req, resp);
        }
    }

    private void listarPenalidades(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        List<Penalidade> penalidades = penalidadeDAO.buscarTodas();
        req.setAttribute("penalidades", penalidades);
        req.getRequestDispatcher("/gerenciar-penalidades.jsp").forward(req, resp);
    }

    private void listarPenalidadesPorUsuario(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int usuarioId = Integer.parseInt(idStr);
            Usuario usuario = usuarioDAO.buscarPorId(usuarioId);
            List<Penalidade> penalidades = penalidadeDAO.buscarPorUsuario(usuarioId);
            
            req.setAttribute("usuario", usuario);
            req.setAttribute("penalidades", penalidades);
            req.setAttribute("totalMultas", penalidadeDAO.calcularTotalMultasPendentes(usuarioId));
        }
        req.getRequestDispatcher("/gerenciar-penalidades.jsp").forward(req, resp);
    }

    private void listarUsuariosBloqueados(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        List<Usuario> usuariosBloqueados = usuarioDAO.listarBloqueados();
        req.setAttribute("usuariosBloqueados", usuariosBloqueados);
        req.getRequestDispatcher("/gerenciar-penalidades.jsp").forward(req, resp);
    }

    private void pagarMulta(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            Long id = Long.parseLong(idStr);
            penalidadeDAO.pagarMulta(id);
            req.setAttribute("sucesso", "Multa marcada como paga com sucesso!");
        }
        resp.sendRedirect("penalidades");
    }

    private void cancelarPenalidade(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            Long id = Long.parseLong(idStr);
            penalidadeDAO.cancelarPenalidade(id);
            req.setAttribute("sucesso", "Penalidade cancelada com sucesso!");
        }
        resp.sendRedirect("penalidades");
    }

    private void desbloquearUsuario(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String idStr = req.getParameter("usuarioId");
        if (idStr != null && !idStr.isEmpty()) {
            int usuarioId = Integer.parseInt(idStr);
            
            // Desbloquear usuário
            usuarioDAO.desbloquearUsuario(usuarioId);
            
            // Expirar bloqueios ativos
            List<Penalidade> penalidades = penalidadeDAO.buscarAtivasPorUsuario(usuarioId);
            for (Penalidade p : penalidades) {
                if (p.isBloqueio()) {
                    penalidadeDAO.atualizarStatus(p.getId(), StatusPenalidade.EXPIRADA);
                }
            }
            
            req.setAttribute("sucesso", "Usuário desbloqueado com sucesso!");
        }
        resp.sendRedirect("penalidades?action=bloqueados");
    }

    private void expirarBloqueios(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int qtd = penalidadeDAO.expirarBloqueiosVencidos();
        req.setAttribute("sucesso", qtd + " bloqueio(s) expirado(s) com sucesso!");
        resp.sendRedirect("penalidades");
    }
}
