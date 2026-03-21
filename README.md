🏥 Gestão-Hospitalar 🩺💉📊
Sistema de Inteligência Relacional para Gestão Clínica, Automação Laboratorial e Segurança do Paciente.

Este projeto apresenta uma infraestrutura robusta de banco de dados voltada para a digitalização de fluxos hospitalares. O diferencial aqui é a camada de monitoramento clínico ativo, onde o banco de dados não apenas armazena prontuários, mas fiscaliza prazos laboratoriais e sinaliza riscos à vida em tempo real.

Arquitetura e Tecnologia
Engine: MySQL 8.0+

Conceitos Aplicados: Relacionamentos N:N (Prescrições), Integridade Referencial Estrita, Automação via Triggers e Log de Eventos Críticos.

Foco: Segurança do paciente, eficiência laboratorial e rastreabilidade de diagnósticos.

Inteligência e Automações Implementadas
Fluxo Laboratorial Preditivo (Triggers)
Monitoramento de SLA: Através da trigger trg_finalizar_exame, o sistema atua como um auditor de qualidade. Ele compara a data_finalizacao com o prazo_conclusao. Caso o laboratório atrase, o status do exame é alterado para 'Atrasado' sem intervenção humana, permitindo a extração de KPIs de eficiência.

Algoritmo de Alerta Clínico (Segurança do Paciente)
A trigger trg_alerta_piora implementa um protocolo de resposta rápida:

Sinalização Visual: Altera dinamicamente o nome_paciente inserindo a flag [ALERTA!], garantindo que qualquer consulta simples ao banco destaque o paciente em risco.

Audit Trail de Risco: Alimenta automaticamente a tabela estado_critico, criando uma fila de prioridade para a equipe de triagem baseada na última evolução médica registrada.

Estrutura de Dados Avançada
Normalização de Prescrições: Implementação de tabela intermediária (itens_prescricao) para gerenciar múltiplos medicamentos por prontuário, garantindo a organização da farmácia hospitalar.

Ciclo de Evolução: Suporte ao acompanhamento contínuo do paciente (Follow-up), permitindo analisar se os tratamentos aplicados estão resultando em 'Melhora' ou 'Piora'.

Como Reproduzir os Testes
Execute o script de estrutura (DDL) para criar o ecossistema hospitalar.

Utilize o script de DML de Teste para inserir um médico, um paciente e uma consulta.

Simule uma falha clínica inserindo uma evolução com status 'Piora':

SQL
INSERT INTO evolucao_paciente (id_paciente, id_consulta, status_progresso) 
VALUES (1, 1, 'Piora');
Valide a automação verificando o alerta no cadastro:

SQL
SELECT nome_paciente FROM pacientes WHERE id_paciente = 1;
