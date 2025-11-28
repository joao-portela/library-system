<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciar Penalidades - Sistema de Biblioteca</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1, h2 {
            color: #333;
        }
        .menu {
            margin-bottom: 20px;
            padding: 10px;
            background: #007bff;
            border-radius: 5px;
        }
        .menu a {
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            margin-right: 10px;
            display: inline-block;
            background: #0056b3;
            border-radius: 3px;
        }
        .menu a:hover {
            background: #004494;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th {
            background-color: #007bff;
            color: white;
            padding: 10px;
            text-align: left;
        }
        td {
            padding: 8px;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .btn {
            padding: 8px 12px;
            margin: 2px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            color: white;
            font-size: 14px;
        }
        .btn-success {
            background-color: #28a745;
        }
        .btn-success:hover {
            background-color: #218838;
        }
        .btn-danger {
            background-color: #dc3545;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }
        .btn-warning {
            background-color: #ffc107;
            color: #333;
        }
        .btn-warning:hover {
            background-color: #e0a800;
        }
        .btn-info {
            background-color: #17a2b8;
        }
        .btn-info:hover {
            background-color: #138496;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .alert-warning {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-ativa {
            background-color: #dc3545;
            color: white;
        }
        .status-paga {
            background-color: #28a745;
            color: white;
        }
        .status-cancelada {
            background-color: #6c757d;
            color: white;
        }
        .status-expirada {
            background-color: #ffc107;
            color: #333;
        }
        .tipo-multa {
            color: #dc3545;
            font-weight: bold;
        }
        .tipo-bloqueio {
            color: #fd7e14;
            font-weight: bold;
        }
        .stats {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .stat-card {
            flex: 1;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 5px;
            border-left: 4px solid #007bff;
        }
        .stat-card h3 {
            margin: 0 0 10px 0;
            color: #666;
            font-size: 14px;
        }
        .stat-card .value {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Gerenciar Penalidades</h1>
        
        <div class="menu">
            <a href="index.jsp">Início</a>
            <a href="penalidades">Todas Penalidades</a>
            <a href="penalidades?action=bloqueados">Usuários Bloqueados</a>
            <a href="emprestimos">Empréstimos</a>
        </div>

        <c:if test="${not empty sucesso}">
            <div class="alert alert-success">${sucesso}</div>
        </c:if>

        <c:if test="${not empty erro}">
            <div class="alert alert-danger">${erro}</div>
        </c:if>

        <c:if test="${not empty aviso}">
            <div class="alert alert-warning">${aviso}</div>
        </c:if>

        <!-- Lista de Usuários Bloqueados -->
        <c:if test="${not empty usuariosBloqueados}">
            <h2>Usuários Bloqueados</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nome</th>
                        <th>Matrícula</th>
                        <th>CPF</th>
                        <th>Email</th>
                        <th>Data Bloqueio</th>
                        <th>Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="usuario" items="${usuariosBloqueados}">
                        <tr>
                            <td>${usuario.id}</td>
                            <td>${usuario.nome}</td>
                            <td>${usuario.matricula}</td>
                            <td>${usuario.cpf}</td>
                            <td>${usuario.email}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty usuario.dataBloqueio}">
                                        ${usuario.dataBloqueio}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="penalidades?action=usuario&id=${usuario.id}" class="btn btn-info">Ver Penalidades</a>
                                <form method="post" action="penalidades" style="display:inline;">
                                    <input type="hidden" name="action" value="desbloquear">
                                    <input type="hidden" name="usuarioId" value="${usuario.id}">
                                    <button type="submit" class="btn btn-success" 
                                            onclick="return confirm('Deseja desbloquear este usuário?')">
                                        Desbloquear
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>

        <!-- Detalhes do Usuário -->
        <c:if test="${not empty usuario}">
            <h2>Penalidades do Usuário: ${usuario.nome}</h2>
            <div class="stats">
                <div class="stat-card">
                    <h3>Matrícula</h3>
                    <div class="value">${usuario.matricula}</div>
                </div>
                <div class="stat-card">
                    <h3>Total de Multas Pendentes</h3>
                    <div class="value">R$ <fmt:formatNumber value="${totalMultas}" pattern="#,##0.00" /></div>
                </div>
                <div class="stat-card">
                    <h3>Status</h3>
                    <div class="value">
                        <c:choose>
                            <c:when test="${usuario.bloqueado}">
                                <span style="color: #dc3545;">BLOQUEADO</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #28a745;">ATIVO</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Lista de Penalidades -->
        <c:if test="${not empty penalidades}">
            <h2>
                <c:choose>
                    <c:when test="${not empty usuario}">
                        Histórico de Penalidades
                    </c:when>
                    <c:otherwise>
                        Todas as Penalidades do Sistema
                    </c:otherwise>
                </c:choose>
            </h2>
            
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Usuário ID</th>
                        <th>Tipo</th>
                        <th>Data Início</th>
                        <th>Data Fim</th>
                        <th>Dias Atraso</th>
                        <th>Valor</th>
                        <th>Status</th>
                        <th>Motivo</th>
                        <th>Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="penalidade" items="${penalidades}">
                        <tr>
                            <td>${penalidade.id}</td>
                            <td>${penalidade.usuarioId}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${penalidade.tipo == 'MULTA'}">
                                        <span class="tipo-multa">MULTA</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="tipo-bloqueio">BLOQUEIO</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                ${penalidade.dataInicio}
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty penalidade.dataFim}">
                                        ${penalidade.dataFim}
                                    </c:when>
                                    <c:otherwise>
                                        -
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${penalidade.diasAtraso}</td>
                            <td>R$ <fmt:formatNumber value="${penalidade.valor}" pattern="#,##0.00" /></td>
                            <td>
                                <span class="status-badge status-${penalidade.status.toString().toLowerCase()}">
                                    ${penalidade.status}
                                </span>
                            </td>
                            <td style="max-width: 300px;">${penalidade.motivoDescricao}</td>
                            <td>
                                <c:if test="${penalidade.status == 'ATIVA'}">
                                    <c:if test="${penalidade.tipo == 'MULTA'}">
                                        <form method="post" action="penalidades" style="display:inline;">
                                            <input type="hidden" name="action" value="pagar">
                                            <input type="hidden" name="id" value="${penalidade.id}">
                                            <button type="submit" class="btn btn-success" 
                                                    onclick="return confirm('Confirmar pagamento da multa?')">
                                                Pagar
                                            </button>
                                        </form>
                                    </c:if>
                                    <form method="post" action="penalidades" style="display:inline;">
                                        <input type="hidden" name="action" value="cancelar">
                                        <input type="hidden" name="id" value="${penalidade.id}">
                                        <button type="submit" class="btn btn-danger" 
                                                onclick="return confirm('Cancelar esta penalidade?')">
                                            Cancelar
                                        </button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>

        <c:if test="${empty penalidades and empty usuariosBloqueados}">
            <div class="alert alert-warning">
                Nenhuma penalidade encontrada no sistema.
            </div>
        </c:if>

        <div style="margin-top: 20px;">
            <form method="post" action="penalidades" style="display:inline;">
                <input type="hidden" name="action" value="expirar">
                <button type="submit" class="btn btn-warning">
                    Expirar Bloqueios Vencidos
                </button>
            </form>
        </div>
    </div>
</body>
</html>
