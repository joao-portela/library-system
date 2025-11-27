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
                    <h3 class="card-title">Devolução de Livros</h3>
                    <form method="post" action="devolucao" class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">ID Empréstimo</label>
                            <input type="text" name="idEmprestimo" class="form-control">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Matrícula do Usuário</label>
                            <input type="text" name="matricula" class="form-control">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Data Prevista (yyyy-MM-dd)</label>
                            <input type="date" name="dataPrevista" class="form-control">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Data Devolução</label>
                            <input type="date" name="dataDevolucao" class="form-control">
                        </div>
                        <div class="col-12">
                            <button class="btn btn-primary">Registrar Devolução</button>
                            <a href="index.jsp" class="btn btn-secondary">Voltar</a>
                        </div>
                    </form>

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
