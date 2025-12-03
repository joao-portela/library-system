================================================================================
                     SISTEMA DE BIBLIOTECA - README
================================================================================

DESCRICAO
---------
Sistema web para gerenciamento de biblioteca desenvolvido em Java utilizando
Jakarta EE 10, Apache Derby como banco de dados e GlassFish como servidor 
de aplicacao.

Funcionalidades principais:
- Cadastro e gerenciamento de usuarios
- Cadastro e gerenciamento de livros
- Controle de emprestimos e devolucoes
- Gerenciamento de penalidades
- Geracao de relatorios


REQUISITOS
----------
- Apache NetBeans IDE (versao 17 ou superior recomendada)
- Java JDK 11 ou superior
- GlassFish Server (pode ser configurado pelo NetBeans)


CONFIGURACAO NO NETBEANS
------------------------
1. Abrir o projeto:
   - File > Open Project
   - Selecione a pasta do projeto (library-system)
   - O NetBeans reconhecera automaticamente como projeto Maven

2. Configurar o servidor GlassFish:
   - Aba Services > Servers > clique direito > Add Server
   - Selecione GlassFish Server e siga o assistente
   - Se necessario, faca download do GlassFish pelo proprio NetBeans

3. Associar o projeto ao servidor:
   - Clique direito no projeto > Properties > Run
   - Em "Server", selecione o GlassFish configurado


CONFIGURACAO DO BANCO DE DADOS
------------------------------
O sistema utiliza Apache Derby (Java DB) com as seguintes configuracoes:

  Host: localhost
  Porta: 1527
  Banco: biblioteca
  Usuario: bibliotecario
  Senha: 1234

1. Iniciar o Java DB pelo NetBeans:
   - Aba Services > Databases > Java DB
   - Clique direito > Start Server

2. Criar o banco e as tabelas:
   - Clique direito em Java DB > Create Database
   - Nome: biblioteca | Usuario: bibliotecario | Senha: 1234
   - Conecte ao banco criado e execute os scripts:
     - sql/create_all_tables.sql
     - sql/populate_mock_data.sql (opcional - dados de teste)


EXECUTANDO O PROJETO
--------------------
1. Certifique-se de que o Java DB esta rodando (Services > Java DB)

2. Execute o projeto:
   - Clique direito no projeto > Run
   - Ou pressione F6

3. O NetBeans ira:
   - Compilar o projeto automaticamente
   - Iniciar o GlassFish (se nao estiver rodando)
   - Fazer o deploy da aplicacao
   - Abrir o navegador na pagina inicial


ACESSO
------
Apos o deploy, a aplicacao estara disponivel em:

  http://localhost:8080/biblioteca-1.0-SNAPSHOT/


ESTRUTURA DO PROJETO
--------------------
src/main/java/com/
  controller/    - Servlets (controle de requisicoes HTTP)
  dao/           - Data Access Objects (acesso ao banco de dados)
  model/         - Entidades e DTOs
  utils/         - Utilitarios (conexao com banco, etc.)

src/main/webapp/
  *.jsp          - Paginas JSP
  css/           - Estilos CSS
  WEB-INF/       - Configuracoes da aplicacao web

sql/
  create_all_tables.sql    - Script para criacao das tabelas
  populate_mock_data.sql   - Dados de teste


SOLUCAO DE PROBLEMAS
--------------------
- Erro de conexao com banco: verifique se o Java DB esta iniciado
- Erro 404: confirme que o deploy foi realizado (aba Output do NetBeans)
- Tabelas nao encontradas: execute o script create_all_tables.sql


================================================================================
