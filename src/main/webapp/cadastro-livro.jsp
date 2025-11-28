<%-- 
    Document   : cadastro-livro
    Created on : Nov 26, 2025, 10:43:53 PM
    Author     : joaop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.dao.LivroDAO" %>
<%@page import="java.util.List" %>
<%
    // Se a lista não foi carregada pelo servlet, carrega aqui
    if (request.getAttribute("listaLivros") == null) {
        try {
            LivroDAO livroDAO = new LivroDAO();
            List lista = livroDAO.listarTodos();
            request.setAttribute("listaLivros", lista);
        } catch (Exception e) {
            request.setAttribute("listaLivros", new java.util.ArrayList());
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Gerir Livros</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    </head>
    <body style="background-color: #f0f4f8;">
        <nav class="navbar mb-4" style="background-color: #1e3a5f;">
            <div class="container d-flex">
                <a class="navbar-brand" href="index.jsp" style="color: white;">Sistema Biblioteca</a>
                <div class="ms-auto">
                    <a href="index.jsp" class="btn btn-sm" style="border: 1px solid white; color: white;" aria-label="Voltar para a página inicial">
                        <i class="bi bi-house"></i>
                        <span class="ms-1">Início</span>
                    </a>
                </div>
            </div>
        </nav>

        <div class="container">
            <div class="row">
                <!-- Formulário de Cadastro -->
                <div class="col-md-4">
                    <div class="card" style="border: none; border-top: 3px solid #1e3a5f;">
                        <div class="card-header text-white" style="background-color: #1e3a5f;">Novo Livro</div>
                        <div class="card-body">
                            <form action="livros" method="POST" accept-charset="UTF-8">
                                <div class="mb-3">
                                    <label>Título</label>
                                    <input type="text" name="titulo" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label>Autor</label>
                                    <input type="text" name="autor" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label>Editora</label>
                                    <input type="text" name="editora" class="form-control">
                                </div>
                                <div class="mb-3">
                                    <label>ISBN</label>
                                    <input type="text" name="isbn" class="form-control">
                                </div>
                                <div class="mb-3">
                                    <label>Quantidade Disponível</label>
                                    <input type="number" name="quantidade" class="form-control" min="0" value="1" required>
                                </div>
                                <button type="submit" class="btn w-100" style="background-color: #1e3a5f; color: white;">Cadastrar Livro</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Tabela de Listagem -->
                <div class="col-md-8">
                    <h3 style="color: #1e3a5f;">Livros Cadastrados</h3>
                    <table class="table table-striped table-hover">
                        <thead style="background-color: #1e3a5f; color: white;">
                            <tr>
                                <th>ID</th>
                                <th>Título</th>
                                <th>Autor</th>
                                <th>Editora</th>
                                <th>ISBN</th>
                                <th>Quantidade</th>
                                <th>Ações</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty listaLivros}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted">Nenhum livro cadastrado.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="livro" items="${listaLivros}">
                                        <tr>
                                            <td>${livro.id}</td>
                                            <td>${livro.titulo}</td>
                                            <td>${livro.autor}</td>
                                            <td>${livro.editora}</td>
                                            <td>${livro.isbn}</td>
                                            <td>${livro.quantidadeDisponivel}</td>
                                            <td>
                                                <a href="livros?acao=confirmarDeletar&id=${livro.id}"
                                                   class="btn btn-danger btn-sm"
                                                   title="Deletar livro">
                                                    <i class="bi bi-trash"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </body>
</html>
