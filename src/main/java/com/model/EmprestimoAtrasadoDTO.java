package com.model;

import java.sql.Date;

/**
 * DTO para relatório de empréstimos em atraso
 */
public class EmprestimoAtrasadoDTO {
    private int emprestimoId;
    private String tituloLivro;
    private String nomeUsuario;
    private String matriculaUsuario;
    private Date dataEmprestimo;
    private Date dataDevolucaoPrevista;
    private int diasAtraso;
    
    public EmprestimoAtrasadoDTO() {}
    
    public EmprestimoAtrasadoDTO(int emprestimoId, String tituloLivro, String nomeUsuario, 
                                 String matriculaUsuario, Date dataEmprestimo, 
                                 Date dataDevolucaoPrevista, int diasAtraso) {
        this.emprestimoId = emprestimoId;
        this.tituloLivro = tituloLivro;
        this.nomeUsuario = nomeUsuario;
        this.matriculaUsuario = matriculaUsuario;
        this.dataEmprestimo = dataEmprestimo;
        this.dataDevolucaoPrevista = dataDevolucaoPrevista;
        this.diasAtraso = diasAtraso;
    }
    
    // Getters e Setters
    public int getEmprestimoId() { return emprestimoId; }
    public void setEmprestimoId(int emprestimoId) { this.emprestimoId = emprestimoId; }
    
    public String getTituloLivro() { return tituloLivro; }
    public void setTituloLivro(String tituloLivro) { this.tituloLivro = tituloLivro; }
    
    public String getNomeUsuario() { return nomeUsuario; }
    public void setNomeUsuario(String nomeUsuario) { this.nomeUsuario = nomeUsuario; }
    
    public String getMatriculaUsuario() { return matriculaUsuario; }
    public void setMatriculaUsuario(String matriculaUsuario) { this.matriculaUsuario = matriculaUsuario; }
    
    public Date getDataEmprestimo() { return dataEmprestimo; }
    public void setDataEmprestimo(Date dataEmprestimo) { this.dataEmprestimo = dataEmprestimo; }
    
    public Date getDataDevolucaoPrevista() { return dataDevolucaoPrevista; }
    public void setDataDevolucaoPrevista(Date dataDevolucaoPrevista) { this.dataDevolucaoPrevista = dataDevolucaoPrevista; }
    
    public int getDiasAtraso() { return diasAtraso; }
    public void setDiasAtraso(int diasAtraso) { this.diasAtraso = diasAtraso; }
}
