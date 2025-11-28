<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.dao.UsuarioDAO" %>
<%@page import="java.util.List" %>
<%
    // Se a lista não foi carregada pelo servlet, carrega aqui
    if (request.getAttribute("listaUsuarios") == null) {
        try {
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            List lista = usuarioDAO.listarTodos();
            request.setAttribute("listaUsuarios", lista);
        } catch (Exception e) {
            request.setAttribute("listaUsuarios", new java.util.ArrayList());
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Gerir Usuários</title>
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
                    <div class="card" style="border: none; border-top: 3px solid #2c5282;">
                        <div class="card-header text-white" style="background-color: #2c5282;">Novo Usuário</div>
                        <div class="card-body">
                            <form action="usuarios" method="POST" accept-charset="UTF-8">
                                <div class="mb-3">
                                    <label>Nome Completo</label>
                                    <input type="text" name="nome" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label>E-mail</label>
                                    <input type="email" name="email" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label>Matrícula</label>
                                    <input type="text" name="matricula" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label>CPF</label>
                                    <input type="text" name="cpf" class="form-control" required>
                                </div>
                                <button type="submit" class="btn w-100" style="background-color: #2c5282; color: white;">Cadastrar Usuário</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Tabela de Listagem -->
                <div class="col-md-8">
                    <h3 style="color: #1e3a5f;">Usuários Cadastrados</h3>
                    <table class="table table-striped table-hover">
                        <thead style="background-color: #1e3a5f; color: white;">
                            <tr>
                                <th>ID</th>
                                <th>Nome</th>
                                <th>Email</th>
                                <th>Matrícula</th>
                                <th>CPF</th>
                                <th>Ações</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty listaUsuarios}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted">
                                            Nenhum usuário cadastrado.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="usuario" items="${listaUsuarios}">
                                        <tr>
                                            <td>${usuario.id}</td>
                                            <td>${usuario.nome}</td>
                                            <td>${usuario.email}</td>
                                            <td>${usuario.matricula}</td>
                                            <td>${usuario.cpf}</td>
                                            <td>
                                                <a href="usuarios?acao=confirmarDeletar&id=${usuario.id}" 
                                                   class="btn btn-danger btn-sm" 
                                                   title="Deletar usuário">
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