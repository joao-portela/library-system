/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author joaop
 */
public class ConnectionFactory {
    // Configuração para Java DB (Apache Derby) - Padrão do NetBeans/GlassFish
    private static final String URL = "jdbc:derby://localhost:1527/biblioteca;create=true";
    private static final String USER = "bibliotecario";
    private static final String PASS = "1234";

    public static Connection getConnection() {
        try {
            // Carrega o driver do Java DB (Client Driver)
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException("Erro na conexão com o banco de dados: " + e.getMessage(), e);
        }
    }
}
