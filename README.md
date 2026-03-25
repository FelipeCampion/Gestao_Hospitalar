# 🏥 Gestão-Hospitalar 🩺💉📊

![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)
![Status](https://img.shields.io/badge/Status-Concluído-brightgreen?style=for-the-badge)

**Sistema de Inteligência Relacional para Gestão Clínica, Automação Laboratorial e Segurança do Paciente.**

Este projeto apresenta uma infraestrutura robusta de banco de dados voltada para a digitalização de fluxos hospitalares. O diferencial aqui é a **camada de monitoramento clínico ativo**, onde o banco de dados não apenas armazena prontuários, mas fiscaliza prazos laboratoriais e sinaliza riscos à vida em tempo real através de gatilhos automáticos.

## 🚀 Arquitetura e Tecnologia

* **Engine:** MySQL 8.0+
* **Conceitos Aplicados:** Relacionamentos N:N (Itens de Prescricao), Integridade Referencial Estrita, Automação via Triggers e Log de Eventos Críticos (Audit Trail).
* **Normalização de Triagem:** Separação estratégica entre Consultas e Sinais Vitais, permitindo um acompanhamento cronológico da evolução do paciente sem sobrecarregar a tabela principal de atendimentos.

---

## Inteligência e Automações Implementadas

### Monitoramento de Sinais Vitais (Vigilância Ativa)
Através da tabela `sinais_vitais` e da trigger `alerta_critico_automatico`, o banco de dados atua como um monitor inteligente:
* **Detecção de Riscos:** Se um valor de frequência cardíaca (< 50 ou > 120 bpm) ou temperatura (> 39°C) for inserido, o sistema gera instantaneamente um registro na tabela `alertas_criticos`.
* **Priorização:** O alerta é criado com status **'Pendente'**, permitindo que dashboards de emergência identifiquem o paciente imediatamente.

### Fluxo Laboratorial Auditado (SLA)
A trigger `trg_finalizar_exame` atua como um auditor de qualidade. Ela compara a data de finalização com o prazo estipulado no pedido. Caso o laboratório entregue o resultado fora da janela prevista, o status é alterado automaticamente para **'Atrasado'**, gerando dados para KPIs de performance hospitalar.

### Algoritmo de Alerta Clínico (Resposta Rápida)
A trigger `trg_alerta_piora` implementa um protocolo de resposta para declínio no quadro de evolução:
* **Sinalização Visual:** Insere a flag `[ALERTA!]` no nome do paciente dinamicamente para destaque em consultas simples.
* **Fila de Triagem:** Alimenta a tabela `estado_critico`, criando uma fila de prioridade baseada estritamente em dados clínicos de evolução.

---

## Como Reproduzir os Testes

1. Execute o script de estrutura (**DDL**) para criar o ecossistema e as chaves estrangeiras.
2. Utilize o script de **DML de Teste** para popular as tabelas base.
3. Simule um risco vital para validar a intelig
