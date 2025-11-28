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
        /* Estilo universitário moderno - Azul/Branco */
        body { background: #f0f4f8; color: #1e3a5f; font-family: Arial, sans-serif; }
        .container { max-width: 1000px; margin: 20px auto; }
        h1, h2 { font-weight: normal; color: #1e3a5f; margin: 0 0 10px 0; }
        /* Cards com estilo universitário */
        .card { border: none; border-top: 3px solid #1e3a5f; border-radius: 0; background: #fff; box-shadow: 0 2px 4px rgba(0,0,0,0.1) !important; }
        .card-body { padding: 12px; }
        /* Cabeçalhos de seção */
        .section-title { font-size: 1.1rem; margin-bottom: 8px; border-bottom: 1px solid #3182ce; padding-bottom: 6px; color: #1e3a5f; }
        /* Estatísticas */
        .stat-card .card-body { text-align: center; }
        .stat-card i { display: block; margin-bottom: 6px; color: #1e3a5f; }
        /* Tabelas */
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid #ddd; padding: 6px 8px; text-align: left; }
        thead th { background: #1e3a5f; color: white; font-weight: normal; }
        tr:nth-child(even) { background: #f0f4f8; }
        /* Badges */
        .badge { background: #2c5282 !important; color: white !important; border-radius: 3px; padding: 3px 6px; font-size: 0.9em; }
        /* Botões */
        .btn { background: #1e3a5f; color: white; border: none; padding: 6px 10px; text-decoration: none; display: inline-block; }
        .btn:hover { background: #2c5282; color: white; }
        .btn-secondary { background: #2c5282; }
        .btn-primary { background: #1e3a5f; }
        .btn-outline-primary { background: white; color: #1e3a5f; border: 1px solid #1e3a5f; }
        .btn-outline-primary:hover { background: #1e3a5f; color: white; }
        .btn-outline-success { background: white; color: #2c5282; border: 1px solid #2c5282; }
        .btn-outline-success:hover { background: #2c5282; color: white; }
        .btn-outline-danger { background: white; color: #c53030; border: 1px solid #c53030; }
        .btn-outline-danger:hover { background: #c53030; color: white; }
        .d-flex { display: flex; }
        .gap-2 > * { margin-right: 8px; }
        .mb-4 { margin-bottom: 16px; }
        .mt-4 { margin-top: 16px; }
        .text-muted { color: #2c5282; }
    </style>
</head>
<body style="background-color: #f0f4f8;">
    <div class="container mt-4">
        <!-- Cabeçalho -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 style="color: #1e3a5f;"><i class="bi bi-graph-up"></i> Relatórios Administrativos</h1>
            <a href="<%= request.getContextPath() %>/" class="btn" style="background-color: #2c5282; color: white;">
                <i class="bi bi-house"></i> Voltar ao Menu
            </a>
        </div>

        <!-- Estatísticas Gerais -->
        <c:if test="${not empty totalLivros || not empty totalUsuarios}">
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card stat-card text-center shadow-sm">
                        <div class="card-body">
                            <i class="bi bi-book" style="font-size: 2rem; color: #1e3a5f;"></i>
                            <h3 class="mt-2">${totalLivros}</h3>
                            <p class="text-muted mb-0">Total de Livros</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card text-center shadow-sm">
                        <div class="card-body">
                            <i class="bi bi-people" style="font-size: 2rem; color: #2c5282;"></i>
                            <h3 class="mt-2">${totalUsuarios}</h3>
                            <p class="text-muted mb-0">Total de Usuários</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card text-center shadow-sm">
                        <div class="card-body">
                            <i class="bi bi-clock-history" style="font-size: 2rem; color: #3182ce;"></i>
                            <h3 class="mt-2">${totalEmprestimosAtivos}</h3>
                            <p class="text-muted mb-0">Empréstimos Ativos</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card text-center shadow-sm">
                        <div class="card-body">
                            <i class="bi bi-exclamation-triangle" style="font-size: 2rem; color: #c53030;"></i>
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
                            <i class="bi bi-book-fill" style="color: #1e3a5f;"></i> Livros Mais Emprestados
                        </h2>
                        <div class="table-responsive">
                            <table class="table table-hover table-striped">
                                <thead style="background-color: #1e3a5f; color: white;">
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
                            <i class="bi bi-person-fill" style="color: #2c5282;"></i> Usuários com Mais Empréstimos
                        </h2>
                        <div class="table-responsive">
                            <table class="table table-hover table-striped">
                                <thead style="background-color: #2c5282; color: white;">
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
                            <i class="bi bi-exclamation-triangle-fill" style="color: #c53030;"></i> Empréstimos em Atraso
                        </h2>
                        <c:choose>
                            <c:when test="${not empty emprestimosEmAtraso}">
                                <div class="alert" style="background-color: #ebf8ff; color: #1e3a5f; border: 1px solid #3182ce;">
                                    <i class="bi bi-exclamation-circle"></i> 
                                    <strong>Atenção!</strong> Existem ${emprestimosEmAtraso.size()} empréstimo(s) em atraso.
                                </div>
                                <div class="table-responsive">
                                    <table class="table table-hover table-striped">
                                        <thead style="background-color: #c53030; color: white;">
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
