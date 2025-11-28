package com.model;

import java.time.LocalDate;

/**
 * Representa uma penalidade aplicada a um usuário por atraso na devolução
 */
public class Penalidade {
    
    public enum TipoPenalidade {
        MULTA,
        BLOQUEIO_TEMPORARIO
    }
    
    public enum StatusPenalidade {
        ATIVA,
        PAGA,
        CANCELADA,
        EXPIRADA
    }
    
    private Long id;
    private int usuarioId;
    private TipoPenalidade tipo;
    private LocalDate dataInicio;
    private LocalDate dataFim;
    private double valor;
    private StatusPenalidade status;
    private String motivoDescricao;
    private int diasAtraso;

    // Construtores
    public Penalidade() {}

    public Penalidade(int usuarioId, TipoPenalidade tipo, LocalDate dataInicio, 
                     LocalDate dataFim, double valor, String motivoDescricao, int diasAtraso) {
        this.usuarioId = usuarioId;
        this.tipo = tipo;
        this.dataInicio = dataInicio;
        this.dataFim = dataFim;
        this.valor = valor;
        this.status = StatusPenalidade.ATIVA;
        this.motivoDescricao = motivoDescricao;
        this.diasAtraso = diasAtraso;
    }

    // Getters e Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }

    public TipoPenalidade getTipo() {
        return tipo;
    }

    public void setTipo(TipoPenalidade tipo) {
        this.tipo = tipo;
    }

    public LocalDate getDataInicio() {
        return dataInicio;
    }

    public void setDataInicio(LocalDate dataInicio) {
        this.dataInicio = dataInicio;
    }

    public LocalDate getDataFim() {
        return dataFim;
    }

    public void setDataFim(LocalDate dataFim) {
        this.dataFim = dataFim;
    }

    public double getValor() {
        return valor;
    }

    public void setValor(double valor) {
        this.valor = valor;
    }

    public StatusPenalidade getStatus() {
        return status;
    }

    public void setStatus(StatusPenalidade status) {
        this.status = status;
    }

    public String getMotivoDescricao() {
        return motivoDescricao;
    }

    public void setMotivoDescricao(String motivoDescricao) {
        this.motivoDescricao = motivoDescricao;
    }

    public int getDiasAtraso() {
        return diasAtraso;
    }

    public void setDiasAtraso(int diasAtraso) {
        this.diasAtraso = diasAtraso;
    }

    // Métodos auxiliares
    public boolean isAtiva() {
        return status == StatusPenalidade.ATIVA;
    }

    public boolean isExpirada() {
        return dataFim != null && LocalDate.now().isAfter(dataFim);
    }

    public boolean isBloqueio() {
        return tipo == TipoPenalidade.BLOQUEIO_TEMPORARIO;
    }

    public boolean isMulta() {
        return tipo == TipoPenalidade.MULTA;
    }
}
