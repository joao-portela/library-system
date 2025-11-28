package com.model;

/**
 * DTO para relatório de usuários com mais empréstimos
 */
public class UsuarioRelatorioDTO {
    private int usuarioId;
    private String nome;
    private String matricula;
    private String email;
    private int totalEmprestimos;
    
    public UsuarioRelatorioDTO() {}
    
    public UsuarioRelatorioDTO(int usuarioId, String nome, String matricula, String email, int totalEmprestimos) {
        this.usuarioId = usuarioId;
        this.nome = nome;
        this.matricula = matricula;
        this.email = email;
        this.totalEmprestimos = totalEmprestimos;
    }
    
    // Getters e Setters
    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }
    
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    
    public String getMatricula() { return matricula; }
    public void setMatricula(String matricula) { this.matricula = matricula; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public int getTotalEmprestimos() { return totalEmprestimos; }
    public void setTotalEmprestimos(int totalEmprestimos) { this.totalEmprestimos = totalEmprestimos; }
}
