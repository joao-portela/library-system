package com.model;

/**
 * DTO para relatório de livros mais emprestados
 */
public class LivroRelatorioDTO {
    private int livroId;
    private String titulo;
    private String autor;
    private String editora;
    private int totalEmprestimos;
    
    public LivroRelatorioDTO() {}
    
    public LivroRelatorioDTO(int livroId, String titulo, String autor, String editora, int totalEmprestimos) {
        this.livroId = livroId;
        this.titulo = titulo;
        this.autor = autor;
        this.editora = editora;
        this.totalEmprestimos = totalEmprestimos;
    }
    
    // Getters e Setters
    public int getLivroId() { return livroId; }
    public void setLivroId(int livroId) { this.livroId = livroId; }
    
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    
    public String getAutor() { return autor; }
    public void setAutor(String autor) { this.autor = autor; }
    
    public String getEditora() { return editora; }
    public void setEditora(String editora) { this.editora = editora; }
    
    public int getTotalEmprestimos() { return totalEmprestimos; }
    public void setTotalEmprestimos(int totalEmprestimos) { this.totalEmprestimos = totalEmprestimos; }
}
