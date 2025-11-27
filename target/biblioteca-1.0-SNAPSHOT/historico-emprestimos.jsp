<%@page contentType="text/html" pageEncoding="UTF-8" import="com.dao.DevolucaoDAO,com.model.Devolucao,java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Histórico de Empréstimos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <div class="card shadow">
                <div class="card-body">
                    <h3 class="card-title">Histórico de Empréstimos</h3>
                    <div class="mb-3">
                        <a href="index.jsp" class="btn btn-secondary">Voltar</a>
                    </div>
                    <%
                        String papel = (String) session.getAttribute("papel");
                        String matricula = (String) session.getAttribute("matricula");
                        DevolucaoDAO dao = new DevolucaoDAO();
                        List<Devolucao> lista = null;
                        if ("admin".equals(papel)) {
                            lista = dao.buscarTodos();
                        } else if (matricula != null) {
                            lista = dao.buscarPorUsuario(matricula);
                        }
                    %>

                    <% if (lista == null || lista.isEmpty()) { %>
                        <div class="alert alert-info">Nenhum registro encontrado.</div>
                    <% } else { %>
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>ID Empréstimo</th>
                                    <th>Matrícula</th>
                                    <th>Data Devolução</th>
                                    <th>Dias Atraso</th>
                                    <th>Valor Multa</th>
                                    <th>Penalidade</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Devolucao d : lista) { %>
                                <tr>
                                    <td><%= d.getId() %></td>
                                    <td><%= d.getIdEmprestimo() %></td>
                                    <td><%= d.getMatriculaUsuario() %></td>
                                    <td><%= d.getDataDevolucao() %></td>
                                    <td><%= d.getDiasAtraso() %></td>
                                    <td>R$ <%= String.format("%.2f", d.getValorMulta()) %></td>
                                    <td><%= d.isPenalidadeAplicada() ? "Sim" : "Não" %></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
            </div>
        </div>
    </body>
</html>
