<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Confirmar Exclusão de Usuário</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    </head>
    <body>
        <nav class="navbar navbar-dark bg-dark mb-4">
            <div class="container">
                <a class="navbar-brand" href="index.jsp">Sistema Biblioteca</a>
            </div>
        </nav>

        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header bg-danger text-white">
                            <h5 class="mb-0"><i class="bi bi-exclamation-triangle"></i> Confirmar Exclusão</h5>
                        </div>
                        <div class="card-body">
                            <p class="alert alert-warning">
                                <strong>Atenção!</strong> Esta ação não pode ser desfeita.
                            </p>
                            
                            <p>Tem certeza que deseja deletar o seguinte usuário?</p>
                            
                            <table class="table table-bordered">
                                <tr>
                                    <th width="30%">ID:</th>
                                    <td>${usuario.id}</td>
                                </tr>
                                <tr>
                                    <th>Nome:</th>
                                    <td>${usuario.nome}</td>
                                </tr>
                                <tr>
                                    <th>Email:</th>
                                    <td>${usuario.email}</td>
                                </tr>
                                <tr>
                                    <th>Matrícula:</th>
                                    <td>${usuario.matricula}</td>
                                </tr>
                                <tr>
                                    <th>CPF:</th>
                                    <td>${usuario.cpf}</td>
                                </tr>
                            </table>
                            
                            <div class="d-flex gap-2 mt-4">
                                <form action="usuarios" method="GET" style="display: inline;">
                                    <input type="hidden" name="acao" value="deletar">
                                    <input type="hidden" name="id" value="${usuario.id}">
                                    <button type="submit" class="btn btn-danger">
                                        <i class="bi bi-trash"></i> Sim, Deletar
                                    </button>
                                </form>
                                <a href="usuarios" class="btn btn-secondary">
                                    <i class="bi bi-x-circle"></i> Cancelar
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

