<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Relatórios Administrativos - Sistema Biblioteca</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .stat-card {
            transition: transform 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .table-responsive {
            margin-top: 20px;
        }
        .badge-atraso {
            font-size: 0.9em;
        }
        .report-section {
            margin-bottom: 40px;
        }
        .section-title {
            border-bottom: 3px solid #0d6efd;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container mt-4">
        <!-- Cabeçalho -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1><i class="bi bi-graph-up"></i> Relatórios Administrativos</h1>
            <a href="<%= request.getContextPath() %>/" class="btn btn-secondary">
                <i class="bi bi-house"></i> Voltar ao Menu
            </a>
        </div>

        <!-- Estatísticas Gerais -->
        <c:if test="${not empty totalLivros || not empty totalUsuarios}">
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card stat-card text-center shadow-sm">
                        <div class="card-body">
                            <i class="bi bi-book text-primary" style="font-size: 2rem;"></i>
                            <h3 class="mt-2">${totalLivros}</h3>
                            <p class="text-muted mb-0">Total de Livros</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card text-center shadow-sm">
                        <div class="card-body">
                            <i class="bi bi-people text-success" style="font-size: 2rem;"></i>
                            <h3 class="mt-2">${totalUsuarios}</h3>
                            <p class="text-muted mb-0">Total de Usuários</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card text-center shadow-sm">
                        <div class="card-body">
                            <i class="bi bi-clock-history text-info" style="font-size: 2rem;"></i>
                            <h3 class="mt-2">${totalEmprestimosAtivos}</h3>
                            <p class="text-muted mb-0">Empréstimos Ativos</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card text-center shadow-sm">
                        <div class="card-body">
                            <i class="bi bi-exclamation-triangle text-danger" style="font-size: 2rem;"></i>
                            <h3 class="mt-2">${totalEmprestimosAtrasados}</h3>
                            <p class="text-muted mb-0">Empréstimos Atrasados</p>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Relatório: Livros Mais Emprestados -->
        <c:if test="${not empty livrosMaisEmprestados}">
            <div class="report-section">
                <div class="card shadow">
                    <div class="card-body">
                        <h2 class="section-title">
                            <i class="bi bi-book-fill text-primary"></i> Livros Mais Emprestados
                        </h2>
                        <div class="table-responsive">
                            <table class="table table-hover table-striped">
                                <thead class="table-primary">
                                    <tr>
                                        <th>#</th>
                                        <th>Título</th>
                                        <th>Autor</th>
                                        <th>Editora</th>
                                        <th class="text-center">Total de Empréstimos</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="livro" items="${livrosMaisEmprestados}" varStatus="status">
                                        <tr>
                                            <td><strong>${status.index + 1}º</strong></td>
                                            <td>${livro.titulo}</td>
                                            <td>${livro.autor}</td>
                                            <td>${livro.editora}</td>
                                            <td class="text-center">
                                                <span class="badge bg-primary">${livro.totalEmprestimos}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <c:if test="${empty livrosMaisEmprestados}">
                            <div class="alert alert-info">
                                <i class="bi bi-info-circle"></i> Nenhum empréstimo registrado ainda.
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Relatório: Usuários com Mais Empréstimos -->
        <c:if test="${not empty usuariosComMaisEmprestimos}">
            <div class="report-section">
                <div class="card shadow">
                    <div class="card-body">
                        <h2 class="section-title">
                            <i class="bi bi-person-fill text-success"></i> Usuários com Mais Empréstimos
                        </h2>
                        <div class="table-responsive">
                            <table class="table table-hover table-striped">
                                <thead class="table-success">
                                    <tr>
                                        <th>#</th>
                                        <th>Nome</th>
                                        <th>Matrícula</th>
                                        <th>Email</th>
                                        <th class="text-center">Total de Empréstimos</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="usuario" items="${usuariosComMaisEmprestimos}" varStatus="status">
                                        <tr>
                                            <td><strong>${status.index + 1}º</strong></td>
                                            <td>${usuario.nome}</td>
                                            <td>${usuario.matricula}</td>
                                            <td>${usuario.email}</td>
                                            <td class="text-center">
                                                <span class="badge bg-success">${usuario.totalEmprestimos}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <c:if test="${empty usuariosComMaisEmprestimos}">
                            <div class="alert alert-info">
                                <i class="bi bi-info-circle"></i> Nenhum empréstimo registrado ainda.
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Relatório: Empréstimos em Atraso -->
        <c:if test="${not empty emprestimosEmAtraso || tipoRelatorio eq 'atrasos'}">
            <div class="report-section">
                <div class="card shadow">
                    <div class="card-body">
                        <h2 class="section-title">
                            <i class="bi bi-exclamation-triangle-fill text-danger"></i> Empréstimos em Atraso
                        </h2>
                        <c:choose>
                            <c:when test="${not empty emprestimosEmAtraso}">
                                <div class="alert alert-warning">
                                    <i class="bi bi-exclamation-circle"></i> 
                                    <strong>Atenção!</strong> Existem ${emprestimosEmAtraso.size()} empréstimo(s) em atraso.
                                </div>
                                <div class="table-responsive">
                                    <table class="table table-hover table-striped">
                                        <thead class="table-danger">
                                            <tr>
                                                <th>ID</th>
                                                <th>Livro</th>
                                                <th>Usuário</th>
                                                <th>Matrícula</th>
                                                <th>Data Empréstimo</th>
                                                <th>Devolução Prevista</th>
                                                <th class="text-center">Dias em Atraso</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="atraso" items="${emprestimosEmAtraso}">
                                                <tr>
                                                    <td>${atraso.emprestimoId}</td>
                                                    <td>${atraso.tituloLivro}</td>
                                                    <td>${atraso.nomeUsuario}</td>
                                                    <td>${atraso.matriculaUsuario}</td>
                                                    <td>
                                                        <fmt:formatDate value="${atraso.dataEmprestimo}" pattern="dd/MM/yyyy"/>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${atraso.dataDevolucaoPrevista}" pattern="dd/MM/yyyy"/>
                                                    </td>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${atraso.diasAtraso > 7}">
                                                                <span class="badge bg-danger badge-atraso">${atraso.diasAtraso} dias</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-warning text-dark badge-atraso">${atraso.diasAtraso} dias</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-success">
                                    <i class="bi bi-check-circle"></i> Não há empréstimos em atraso no momento!
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Botões de Ações -->
        <div class="card shadow mb-4">
            <div class="card-body">
                <h5 class="card-title">Ações</h5>
                <div class="d-flex gap-2 flex-wrap">
                    <a href="<%= request.getContextPath() %>/relatorios" class="btn btn-primary">
                        <i class="bi bi-arrow-clockwise"></i> Atualizar Todos os Relatórios
                    </a>
                    <a href="<%= request.getContextPath() %>/relatorios?tipo=livros" class="btn btn-outline-primary">
                        <i class="bi bi-book"></i> Ver Apenas Livros
                    </a>
                    <a href="<%= request.getContextPath() %>/relatorios?tipo=usuarios" class="btn btn-outline-success">
                        <i class="bi bi-people"></i> Ver Apenas Usuários
                    </a>
                    <a href="<%= request.getContextPath() %>/relatorios?tipo=atrasos" class="btn btn-outline-danger">
                        <i class="bi bi-exclamation-triangle"></i> Ver Apenas Atrasos
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
