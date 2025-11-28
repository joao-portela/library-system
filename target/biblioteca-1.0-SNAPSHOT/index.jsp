 
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sistema Biblioteca</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body style="background-color: #f0f4f8;">
        <div class="container mt-5 text-center">
            <div class="card shadow" style="border: none; border-top: 4px solid #1e3a5f;">
                <div class="card-body">
                    <h1 class="card-title mb-4" style="color: #1e3a5f;">Bem-vindo à Biblioteca</h1>
                    <p class="lead" style="color: #2c5282;">Selecione uma opção abaixo:</p>
                    
                    <div class="d-grid gap-2 col-6 mx-auto">
                        <a href="<%= request.getContextPath() %>/usuarios" class="btn btn-lg" style="background-color: #1e3a5f; color: white;">Gerir Usuários</a>
                        <!-- Aponta para os servlets para que os atributos sejam preparados antes do JSP -->
                        <a href="<%= request.getContextPath() %>/livros" class="btn btn-lg" style="background-color: #2c5282; color: white;">Gerir Livros</a>
                        <a href="<%= request.getContextPath() %>/emprestimos" class="btn btn-lg" style="background-color: #3182ce; color: white;">Gerenciar Empréstimos</a>
                        <a href="<%= request.getContextPath() %>/penalidades" class="btn btn-lg" style="background-color: #1e3a5f; color: white;">Gerenciar Penalidades</a>
                        <a href="<%= request.getContextPath() %>/relatorios" class="btn btn-lg" style="background-color: #2c5282; color: white;">Relatórios Administrativos</a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
