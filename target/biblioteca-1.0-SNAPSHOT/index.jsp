<%-- 
    Document   : index
    Created on : Nov 26, 2025, 10:25:45 PM
    Author     : joaop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sistema Biblioteca</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container mt-5 text-center">
            <div class="card shadow">
                <div class="card-body">
                    <h1 class="card-title mb-4">Bem-vindo à Biblioteca</h1>
                    <p class="lead">Selecione uma opção abaixo:</p>
                    
                    <div class="d-grid gap-2 col-6 mx-auto">
                        <a href="<%= request.getContextPath() %>/usuarios" class="btn btn-primary btn-lg">Gerir Usuários</a>
                        <!-- Aponta para os servlets para que os atributos sejam preparados antes do JSP -->
                        <a href="<%= request.getContextPath() %>/livros" class="btn btn-primary btn-lg">Gerir Livros</a>
                        <a href="<%= request.getContextPath() %>/emprestimos" class="btn btn-success btn-lg">Realizar Empréstimo</a>
                        <a href="<%= request.getContextPath() %>/devolucao" class="btn btn-warning btn-lg">Devolver Livro</a>
                        <a href="<%= request.getContextPath() %>/historico-emprestimos.jsp" class="btn btn-info btn-lg text-white">Histórico Empréstimos</a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
