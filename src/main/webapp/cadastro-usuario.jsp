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
    <body>
        <nav class="navbar navbar-dark bg-dark mb-4">
            <div class="container d-flex">
                <a class="navbar-brand" href="index.jsp">Sistema Biblioteca</a>
                <div class="ms-auto">
                    <a href="index.jsp" class="btn btn-outline-light btn-sm" aria-label="Voltar para a página inicial">
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
                    <div class="card">
                        <div class="card-header bg-success text-white">Novo Usuário</div>
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
                                <button type="submit" class="btn btn-success w-100">Cadastrar Usuário</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Tabela de Listagem -->
                <div class="col-md-8">
                    <h3>Usuários Cadastrados</h3>
                    <table class="table table-striped table-hover">
                        <thead class="table-dark">
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