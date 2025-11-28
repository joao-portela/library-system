/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.model;
public class Usuario {
    private int id;
    private String nome;
    private String cpf;
    private String matricula;
    private String email;
    private boolean bloqueado;
    private java.sql.Date dataBloqueio;
    
    public Usuario() {}

    public Usuario(int id, String cpf, String email, String matricula, String nome) {
        this.nome = nome;
        this.matricula = matricula;
        this.email = email;
        this.cpf = cpf;
        this.id = id;
    }
    
    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    
    public String getCPF() { return cpf; }
    public String getCpf() { return cpf; } // Getter alternativo para compatibilidade com EL
    public void setCPF(String cpf) { this.cpf = cpf; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getMatricula() { return matricula; }
    public void setMatricula(String matricula) { this.matricula = matricula; }
    
    public boolean isBloqueado() { return bloqueado; }
    public void setBloqueado(boolean bloqueado) { this.bloqueado = bloqueado; }
    
    public java.sql.Date getDataBloqueio() { return dataBloqueio; }
    public void setDataBloqueio(java.sql.Date dataBloqueio) { this.dataBloqueio = dataBloqueio; }
}
