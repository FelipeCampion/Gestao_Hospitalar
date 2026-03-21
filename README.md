# 🏥 Gestão-Hospitalar 🩺💉📊

![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)
![Status](https://img.shields.io/badge/Status-Concluído-brightgreen?style=for-the-badge)

**Sistema de Inteligência Relacional para Gestão Clínica, Automação Laboratorial e Segurança do Paciente.**

Este projeto apresenta uma infraestrutura robusta de banco de dados voltada para a digitalização de fluxos hospitalares. O diferencial aqui é a **camada de monitoramento clínico ativo**, onde o banco de dados não apenas armazena prontuários, mas fiscaliza prazos laboratoriais e sinaliza riscos à vida em tempo real através de gatilhos automáticos.

## Arquitetura e Tecnologia

* **Engine:** MySQL 8.0+
* **Conceitos Aplicados:** Relacionamentos N:N (Itens de Prescrição), Integridade Referencial Estrita, Automação via Triggers e Log de Eventos Críticos (Audit Trail).
* **Foco:** Segurança do paciente, conformidade com prazos (SLA) e rastreabilidade de diagnósticos.

---

## Inteligência e Automações Implementadas

### Fluxo Laboratorial Auditado (Triggers)
* **Monitoramento de SLA:** Através da trigger `trg_finalizar_exame`, o sistema atua como um auditor de qualidade. Ele compara a data de finalização com o prazo estipulado no pedido. Caso o laboratório entregue o resultado fora da janela prevista, o status é alterado automaticamente para **'Atrasado'**, permitindo a geração de indicadores de performance (KPIs) hospitalares.

### Algoritmo de Alerta Clínico (Segurança do Paciente)
A trigger `trg_alerta_piora` implementa um protocolo de resposta rápida para casos de declínio clínico:
* **Sinalização Visual de Risco:** Altera dinamicamente o registro do paciente inserindo a flag `[ALERTA!]` no nome, garantindo que qualquer consulta ao banco destaque visualmente o paciente em risco para a recepção e enfermagem.
* **Triagem Automática:** Alimenta simultaneamente a tabela `estado_critico`, criando uma fila de prioridade para a equipe médica baseada estritamente em dados de evolução inseridos no prontuário.

### Gestão Estruturada de Medicamentos
* **Normalização de Farmácia:** Implementação de relacionamento entre medicamentos e prontuários via tabela `itens_prescricao`, permitindo múltiplas dosagens e frequências por atendimento, evitando erros de medicação e facilitando o controle de estoque.

---

## Como Reproduzir os Testes

1.  Execute o script de estrutura (**DDL**) para criar o ecossistema hospitalar e as regras de negócio.
2.  Utilize o script de **DML de Teste** para popular médicos e pacientes.
3.  Simule um alerta de risco inserindo uma evolução com status de piora:
4.  Valide a inteligência do banco executando as consultas:

```sql
INSERT INTO evolucao_paciente (id_paciente, id_consulta, status_progresso) 
VALUES (1, 1, 'Piora');

-- Verificar fila de triagem crítica
SELECT * FROM estado_critico;

-- Verificar sinalização no cadastro
SELECT nome_paciente FROM pacientes WHERE id_paciente = 1;
