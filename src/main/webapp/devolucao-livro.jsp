<%@page contentType="text/html" pageEncoding="UTF-8" import="com.model.Devolucao"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Devolução de Livros</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <div class="card shadow">
                <div class="card-body">
                    <div class="mt-4">
                        <% String erro = (String) request.getAttribute("erro"); %>
                        <% if (erro != null) { %>
                        <div class="alert alert-danger"><%= erro %></div>
                        <% } %>

                        <% Devolucao resultado = (Devolucao) request.getAttribute("resultado"); %>
                        <% if (resultado != null) { %>
                        <div class="card mt-3">
                            <div class="card-body">
                                <h5>Resumo da Devolução</h5>
                                <table class="table">
                                    <tr><th>ID Devolução</th><td><%= resultado.getId() %></td></tr>
                                    <tr><th>ID Empréstimo</th><td><%= resultado.getIdEmprestimo() %></td></tr>
                                    <tr><th>Matrícula</th><td><%= resultado.getMatriculaUsuario() %></td></tr>
                                    <tr><th>Data Devolução</th><td><%= resultado.getDataDevolucao() %></td></tr>
                                    <tr><th>Dias Atraso</th><td><%= resultado.getDiasAtraso() %></td></tr>
                                    <tr><th>Valor Multa</th><td>R$ <%= String.format("%.2f", resultado.getValorMulta()) %></td></tr>
                                    <tr><th>Penalidade</th><td><%= resultado.isPenalidadeAplicada() ? "Sim" : "Não" %></td></tr>
                                </table>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
