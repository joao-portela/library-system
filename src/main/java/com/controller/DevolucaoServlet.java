package com.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

import com.dao.DevolucaoDAO;
import com.model.Devolucao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "DevolucaoServlet", urlPatterns = {"/devolucao"})
public class DevolucaoServlet extends HttpServlet {

    private DevolucaoDAO dao = new DevolucaoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idEmpStr = req.getParameter("idEmprestimo");
        if (idEmpStr != null && !idEmpStr.isEmpty()) {
            try {
                Long idEmp = Long.parseLong(idEmpStr);
                com.model.Devolucao d = dao.buscarPorEmprestimo(idEmp);
                if (d != null) {
                    req.setAttribute("resultado", d);
                }
            } catch (NumberFormatException ex) {
                // ignorar formato inválido e apenas mostrar a página
            } catch (Exception ex) {
                // se DAO lançar, ignore aqui e deixe a página tratar erro
                req.setAttribute("erro", "Erro ao carregar devolução: " + ex.getMessage());
            }
        }
        req.getRequestDispatcher("/devolucao-livro.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idEmprestimoStr = req.getParameter("idEmprestimo");
        String matricula = req.getParameter("matricula");
        String dataDevStr = req.getParameter("dataDevolucao");
        LocalDate dataDevolucao = null;
        try {
            if (dataDevStr != null && !dataDevStr.isEmpty()) {
                dataDevolucao = LocalDate.parse(dataDevStr);
            }
        } catch (DateTimeParseException e) {
            req.setAttribute("erro", "Data inválida");
            req.getRequestDispatcher("/devolucao-livro.jsp").forward(req, resp);
            return;
        }

        Long idEmprestimo = null;
        try {
            if (idEmprestimoStr != null && !idEmprestimoStr.isEmpty()) {
                idEmprestimo = Long.parseLong(idEmprestimoStr);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("erro", "ID de empréstimo inválido");
            req.getRequestDispatcher("/devolucao-livro.jsp").forward(req, resp);
            return;
        }

        String dataPrevistaStr = req.getParameter("dataPrevista");
        LocalDate dataPrevista = null;
        if (dataPrevistaStr != null && !dataPrevistaStr.isEmpty()) {
            try {
                dataPrevista = LocalDate.parse(dataPrevistaStr);
            } catch (DateTimeParseException ex) {
                dataPrevista = null;
            }
        }

        int diasAtraso = 0;
        double valorMulta = 0.0;
        boolean penalidade = false;

        if (dataDevolucao != null && dataPrevista != null) {
            diasAtraso = (int) java.time.temporal.ChronoUnit.DAYS.between(dataPrevista, dataDevolucao);
            if (diasAtraso < 0) {
                diasAtraso = 0;
            }
            valorMulta = dao.calcularMulta(dataPrevista, dataDevolucao);
            penalidade = diasAtraso > 30;
        }

        Devolucao devolucao = new Devolucao();
        devolucao.setIdEmprestimo(idEmprestimo);
        devolucao.setMatriculaUsuario(matricula);
        devolucao.setDataDevolucao(dataDevolucao);
        devolucao.setDiasAtraso(diasAtraso);
        devolucao.setValorMulta(valorMulta);
        devolucao.setPenalidadeAplicada(penalidade);

        try {
            Devolucao salvo = dao.registrarDevolucao(devolucao);
            req.setAttribute("resultado", salvo);
        } catch (Exception e) {
            req.setAttribute("erro", "Erro ao registrar devolução: " + e.getMessage());
        }

        req.getRequestDispatcher("/devolucao-livro.jsp").forward(req, resp);
    }
}
