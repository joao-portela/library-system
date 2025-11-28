package com.controller;

import com.dao.RelatorioDAO;
import com.model.EmprestimoAtrasadoDTO;
import com.model.LivroRelatorioDTO;
import com.model.UsuarioRelatorioDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet para geração de relatórios administrativos
 */
@WebServlet("/relatorios")
public class RelatorioServlet extends HttpServlet {
    
    private RelatorioDAO relatorioDAO = new RelatorioDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String tipoRelatorio = request.getParameter("tipo");
        
        try {
            // Se nenhum tipo específico foi solicitado, carrega todos os relatórios
            if (tipoRelatorio == null || tipoRelatorio.isEmpty()) {
                carregarTodosRelatorios(request);
            } else {
                // Carrega relatório específico
                switch (tipoRelatorio) {
                    case "livros":
                        carregarRelatorioLivros(request);
                        break;
                    case "usuarios":
                        carregarRelatorioUsuarios(request);
                        break;
                    case "atrasos":
                        carregarRelatorioAtrasos(request);
                        break;
                    default:
                        carregarTodosRelatorios(request);
                }
            }
            
            // Encaminha para a página JSP
            request.getRequestDispatcher("/relatorios.jsp").forward(request, response);
            
        } catch (SQLException e) {
            throw new ServletException("Erro ao gerar relatórios", e);
        }
    }
    
    /**
     * Carrega todos os relatórios
     */
    private void carregarTodosRelatorios(HttpServletRequest request) throws SQLException {
        // Obtém estatísticas gerais
        int[] stats = relatorioDAO.obterEstatisticasGerais();
        request.setAttribute("totalLivros", stats[0]);
        request.setAttribute("totalUsuarios", stats[1]);
        request.setAttribute("totalEmprestimosAtivos", stats[2]);
        request.setAttribute("totalEmprestimosAtrasados", stats[3]);
        
        // Obtém top 10 de cada relatório
        List<LivroRelatorioDTO> livrosMaisEmprestados = relatorioDAO.obterLivrosMaisEmprestados(10);
        request.setAttribute("livrosMaisEmprestados", livrosMaisEmprestados);
        
        List<UsuarioRelatorioDTO> usuariosComMaisEmprestimos = relatorioDAO.obterUsuariosComMaisEmprestimos(10);
        request.setAttribute("usuariosComMaisEmprestimos", usuariosComMaisEmprestimos);
        
        List<EmprestimoAtrasadoDTO> emprestimosEmAtraso = relatorioDAO.obterEmprestimosEmAtraso();
        request.setAttribute("emprestimosEmAtraso", emprestimosEmAtraso);
    }
    
    /**
     * Carrega apenas relatório de livros
     */
    private void carregarRelatorioLivros(HttpServletRequest request) throws SQLException {
        String limiteParam = request.getParameter("limite");
        int limite = (limiteParam != null && !limiteParam.isEmpty()) ? Integer.parseInt(limiteParam) : 10;
        
        List<LivroRelatorioDTO> livrosMaisEmprestados = relatorioDAO.obterLivrosMaisEmprestados(limite);
        request.setAttribute("livrosMaisEmprestados", livrosMaisEmprestados);
        request.setAttribute("tipoRelatorio", "livros");
    }
    
    /**
     * Carrega apenas relatório de usuários
     */
    private void carregarRelatorioUsuarios(HttpServletRequest request) throws SQLException {
        String limiteParam = request.getParameter("limite");
        int limite = (limiteParam != null && !limiteParam.isEmpty()) ? Integer.parseInt(limiteParam) : 10;
        
        List<UsuarioRelatorioDTO> usuariosComMaisEmprestimos = relatorioDAO.obterUsuariosComMaisEmprestimos(limite);
        request.setAttribute("usuariosComMaisEmprestimos", usuariosComMaisEmprestimos);
        request.setAttribute("tipoRelatorio", "usuarios");
    }
    
    /**
     * Carrega apenas relatório de atrasos
     */
    private void carregarRelatorioAtrasos(HttpServletRequest request) throws SQLException {
        List<EmprestimoAtrasadoDTO> emprestimosEmAtraso = relatorioDAO.obterEmprestimosEmAtraso();
        request.setAttribute("emprestimosEmAtraso", emprestimosEmAtraso);
        request.setAttribute("tipoRelatorio", "atrasos");
    }
}
