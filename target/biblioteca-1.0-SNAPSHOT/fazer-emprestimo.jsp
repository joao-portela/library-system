<%-- 
    Document   : fazer-emprestimo
    Created on : Nov 26, 2025, 10:44:23 PM
    Author     : joaop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.dao.LivroDAO" %>
<%@page import="java.util.List" %>
<%
    // Se a lista de livros não veio do servlet, carrega diretamente do DAO (torna o JSP autossuficiente)
    if (request.getAttribute("listaLivros") == null) {
        try {
            LivroDAO livroDAO = new LivroDAO();
            List lista = livroDAO.listarTodos();
            request.setAttribute("listaLivros", lista);
        } catch (Exception e) {
            request.setAttribute("listaLivros", new java.util.ArrayList());
            request.setAttribute("erro", "Não foi possível carregar livros: " + e.getMessage());
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Realizar Empréstimo</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    </head>
    <body>
        <nav class="navbar navbar-dark bg-dark mb-4">
                <div class="container d-flex">
                <a class="navbar-brand" href="<%= request.getContextPath() %>/">Sistema Biblioteca</a>
                <div class="ms-auto">
                    <a href="<%= request.getContextPath() %>/" class="btn btn-outline-light btn-sm" aria-label="Voltar para a página inicial">
                        <i class="bi bi-house"></i>
                        <span class="ms-1">Início</span>
                    </a>
                </div>
            </div>
        </nav>

        <div class="container">
            <div class="row">
                <div class="col-md-5">
                    <div class="card">
                        <div class="card-header bg-success text-white">Registrar Empréstimo</div>
                        <div class="card-body">
                            <c:if test="${not empty usuarioNaoEncontrado}">
                                <div class="alert alert-warning">
                                    Usuário não encontrado. Deseja cadastrar? <a href="<%= request.getContextPath() %>/usuarios" class="btn btn-sm btn-primary ms-2">Cadastrar Usuário</a>
                                </div>
                            </c:if>

                            <c:if test="${not empty erro}">
                                <div class="alert alert-danger">${erro}</div>
                            </c:if>

                            <form action="emprestimos" method="POST" accept-charset="UTF-8">
                                <div class="mb-3">
                                    <label>Matrícula do Usuário</label>
                                    <input type="text" name="matricula" class="form-control" value="${matriculaPrefill}" required>
                                </div>
                                <div class="mb-3">
                                    <label>Livro</label>
                                    <select name="livroId" class="form-select" required>
                                        <option value="">-- Selecionar --</option>
                                        <c:forEach var="livro" items="${listaLivros}">
                                            <c:choose>
                                                <c:when test="${livro.quantidadeDisponivel > 0}">
                                                    <option value="${livro.id}">${livro.titulo} — ${livro.autor} (Disponíveis: ${livro.quantidadeDisponivel})</option>
                                                </c:when>
                                                <c:otherwise>
                                                    <option value="${livro.id}" disabled>${livro.titulo} — Indisponível</option>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-success">Registrar Empréstimo</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-md-7">
                    <h4>Empréstimos Recentes</h4>
                    <div class="row row-cols-1 g-3">
                        <c:forEach var="emp" items="${listaEmprestimos}">
                            <div class="col">
                                <div class="card">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h5 class="card-title mb-1">${emp.livro.titulo}</h5>
                                                <p class="mb-1 text-muted small">Autor: ${emp.livro.autor} — Usuário: ${emp.usuario.nome} (${emp.usuario.matricula})</p>
                                                <p class="mb-0 small">Emprestado: ${emp.dataEmprestimo} — Previsto: ${emp.dataDevolucaoPrevista}</p>
                                            </div>
                                            <div class="text-end">
                                                <c:choose>
                                                    <c:when test="${not empty emp.dataDevolucaoReal}">
                                                        <span class="badge bg-success">Devolvido</span>
                                                    </c:when>
                                                        <c:otherwise>
                                                            <!-- Não tente acessar pageContext.request.time (não existe).
                                                                 Se precisar checar vencimento/atraso, calcule no servlet e
                                                                 forneça um atributo (por exemplo: hojeMillis) ou use
                                                                 System.currentTimeMillis() num scriptlet aqui.
                                                            -->
                                                            <span class="badge bg-warning text-dark">Em aberto</span>
                                                            <!-- Botão para iniciar devolução: preenche id do empréstimo e matrícula -->
                                                            <c:if test="${empty emp.dataDevolucaoReal}">
                                                                <form method="post" action="devolucao" class="mt-2" onsubmit="return confirm('Confirma devolução deste empréstimo?');">
                                                                    <input type="hidden" name="idEmprestimo" value="${emp.id}" />
                                                                    <input type="hidden" name="matricula" value="${emp.usuario.matricula}" />
                                                                    <input type="hidden" name="dataPrevista" value="${emp.dataDevolucaoPrevista}" />
                                                                    <input type="hidden" name="dataDevolucao" value="<%= java.time.LocalDate.now() %>" />
                                                                    <button type="submit" class="btn btn-sm btn-primary">Devolver</button>
                                                                </form>
                                                            </c:if>
                                                        </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty listaEmprestimos}">
                            <div class="col">
                                <div class="alert alert-info">Nenhum empréstimo registrado.</div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
