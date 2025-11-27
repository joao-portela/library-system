package com.model;

import java.time.LocalDate;

public class Devolucao {
    private Long id;
    private Long idEmprestimo;
    private String matriculaUsuario;
    private LocalDate dataDevolucao;
    private int diasAtraso;
    private double valorMulta;
    private boolean penalidadeAplicada;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getIdEmprestimo() {
        return idEmprestimo;
    }

    public void setIdEmprestimo(Long idEmprestimo) {
        this.idEmprestimo = idEmprestimo;
    }

    public String getMatriculaUsuario() {
        return matriculaUsuario;
    }

    public void setMatriculaUsuario(String matriculaUsuario) {
        this.matriculaUsuario = matriculaUsuario;
    }

    public LocalDate getDataDevolucao() {
        return dataDevolucao;
    }

    public void setDataDevolucao(LocalDate dataDevolucao) {
        this.dataDevolucao = dataDevolucao;
    }

    public int getDiasAtraso() {
        return diasAtraso;
    }

    public void setDiasAtraso(int diasAtraso) {
        this.diasAtraso = diasAtraso;
    }

    public double getValorMulta() {
        return valorMulta;
    }

    public void setValorMulta(double valorMulta) {
        this.valorMulta = valorMulta;
    }

    public boolean isPenalidadeAplicada() {
        return penalidadeAplicada;
    }

    public void setPenalidadeAplicada(boolean penalidadeAplicada) {
        this.penalidadeAplicada = penalidadeAplicada;
    }
}
