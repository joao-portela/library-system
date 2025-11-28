package com.db;

import com.utils.ConnectionFactory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Utility main para inspecionar a tabela livros no banco configurado em ConnectionFactory.
 * Execute pela IDE (Run File) ou via Maven: mvn -Dexec.mainClass=com.db.DbInspect exec:java
 */
public class DbInspect {
    public static void main(String[] args) {
        try (Connection conn = ConnectionFactory.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM livros"); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    System.out.println("livros count: " + rs.getInt(1));
                }
            }

            try (PreparedStatement ps = conn.prepareStatement("SELECT id, titulo, quantidade_disponivel FROM livros FETCH FIRST 20 ROWS ONLY"); ResultSet rs = ps.executeQuery()) {
                System.out.println("--- sample rows ---");
                while (rs.next()) {
                    System.out.printf("id=%d | titulo=%s | quantidade_disponivel=%d\n", rs.getInt("id"), rs.getString("titulo"), rs.getInt("quantidade_disponivel"));
                }
            }
        } catch (Exception e) {
            System.err.println("Erro conectando ao DB: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
