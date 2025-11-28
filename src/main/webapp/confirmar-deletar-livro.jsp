<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Confirmar Exclusão de Livro</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    </head>
    <body style="background-color: #f0f4f8;">
        <nav class="navbar mb-4" style="background-color: #1e3a5f;">
            <div class="container">
                <a class="navbar-brand" href="index.jsp" style="color: white;">Sistema Biblioteca</a>
            </div>
        </nav>

        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card" style="border: none; border-top: 3px solid #c53030;">
                        <div class="card-header text-white" style="background-color: #c53030;">
                            <h5 class="mb-0"><i class="bi bi-exclamation-triangle"></i> Confirmar Exclusão</h5>
                        </div>
                        <div class="card-body">
                            <p class="alert alert-warning">
                                <strong>Atenção!</strong> Esta ação não pode ser desfeita.
                            </p>
                            
                            <p>Tem certeza que deseja deletar o seguinte livro?</p>
                            
                            <table class="table table-bordered">
                                <tr>
                                    <th width="30%">ID:</th>
                                    <td>${livro.id}</td>
                                </tr>
                                <tr>
                                    <th>Título:</th>
                                    <td>${livro.titulo}</td>
                                </tr>
                                <tr>
                                    <th>Autor:</th>
                                    <td>${livro.autor}</td>
                                </tr>
                                <tr>
                                    <th>Editora:</th>
                                    <td>${livro.editora}</td>
                                </tr>
                                <tr>
                                    <th>ISBN:</th>
                                    <td>${livro.isbn}</td>
                                </tr>
                                <tr>
                                    <th>Quantidade:</th>
                                    <td>${livro.quantidadeDisponivel}</td>
                                </tr>
                            </table>
                            
                            <div class="d-flex gap-2 mt-4">
                                <form action="livros" method="GET" style="display: inline;">
                                    <input type="hidden" name="acao" value="deletar">
                                    <input type="hidden" name="id" value="${livro.id}">
                                    <button type="submit" class="btn btn-danger">
                                        <i class="bi bi-trash"></i> Sim, Deletar
                                    </button>
                                </form>
                                <a href="livros" class="btn btn-secondary">
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
