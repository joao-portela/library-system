package com.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author joaop
 */
public class ConnectionFactory {
    // Configuração para Java DB (Apache Derby) - Padrão do NetBeans/GlassFish
    // Derby usa UTF-8 por padrão, não precisa especificar encoding na URL
    private static final String CLIENT_URL = "jdbc:derby://localhost:1527/biblioteca;create=true";
    private static final String USER = "bibliotecario";
    private static final String PASS = "1234";
    private static final String EMBED_URL = "jdbc:derby:biblioteca;create=true";

    public static Connection getConnection() {
        SQLException lastSqlEx = null;

        // 1) Tenta conectar via Client (Network Server)
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection(CLIENT_URL, USER, PASS);
            setDefaultSchema(conn);
            return conn;
        } catch (ClassNotFoundException | SQLException clientEx) {
            if (clientEx instanceof SQLException) lastSqlEx = (SQLException) clientEx;
            // continua para tentar embedded
        }

        // 2) Fallback: tenta Embedded
        try {
            Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
            Connection conn = DriverManager.getConnection(EMBED_URL);
            setDefaultSchema(conn);
            return conn;
        } catch (ClassNotFoundException | SQLException embeddedEx) {
            if (embeddedEx instanceof SQLException) lastSqlEx = (SQLException) embeddedEx;
        }

        StringBuilder msg = new StringBuilder();
        msg.append("Erro na conexão com o banco de dados. Verifique se o Derby Network Server está rodando em localhost:1527 ou se o driver embedded está disponível.\n");
        if (lastSqlEx != null) msg.append("Detalhe: ").append(lastSqlEx.getMessage());
        msg.append("\nPara iniciar o Derby Network Server com seu derbyrun.jar, por exemplo:\n");
        msg.append("java -jar C:\\Users\\fmart\\Downloads\\glassfish-7.0.25\\glassfish7\\javadb\\lib\\derbyrun.jar server start\n");
        throw new RuntimeException(msg.toString(), lastSqlEx);
    }

    private static void setDefaultSchema(Connection conn) {
        if (conn == null) return;
        String schemaUser = USER != null ? USER.toUpperCase() : null;
        try (Statement st = conn.createStatement()) {
            if (schemaUser != null) {
                try {
                    st.execute("SET SCHEMA " + schemaUser);
                    return;
                } catch (SQLException ex) {
                    // schema do usuário não existe, tenta APP
                }
            }
            try {
                st.execute("SET SCHEMA APP");
            } catch (SQLException ex) {
                // se falhar também, ignora — a aplicação pode usar schema qualificado
            }
        } catch (SQLException ignore) {
            // não é crítico; a conexão já foi obtida ou o erro será reportado na tentativa de conexão
        }
    }
}
