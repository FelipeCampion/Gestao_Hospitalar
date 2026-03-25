use Gestao_Hospitalar;

-- 1. Inserindo Médicos e Medicamentos básicos
insert into medicos (nome_medico, crm, especialidade) values 
('Dr. Lucas Silva', '12345-SP', 'Cardiologia'),
('Dra. Ana Costa', '54321-RJ', 'Clínica Geral');

insert into medicamentos (nome_medico, unidade_medida) values 
('Dipirona', '500mg'),
('Amoxicilina', '875mg');

-- 2. Inserindo Pacientes
insert into pacientes (nome_paciente, cpf, tipo_sanguineo) values 
('Marcos Oliveira', '11122233344', 'O+'),
('Julia Santos', '55566677788', 'A-');

-- 3. Criando Consultas (Base para tudo)
insert into consultas (id_paciente, id_medico, data_consulta, status_consulta) values 
(1, 1, now(), 'Realizada'),
(2, 2, now(), 'Agendada');

-- TESTE 1: Trigger de Alerta Crítico (Sinais Vitais)
insert into sinais_vitais (id_consulta, id_paciente, frequencia_cardiaca, pressao_sistolica, temperatura) 
values (1, 1, 130, 150, 39.8); 

-- TESTE 2: Trigger de Alerta de Piora (Evolução)
insert into evolucao_paciente (id_paciente, id_consulta, status_progresso, observacoes_medicas)
values (2, 2, 'Piora', 'Paciente apresenta fadiga extrema e febre persistente.');

-- TESTE 3: Trigger de Exame Atrasado
insert into pedidos_exames (id_medico, id_paciente, tipo_exame, prazo_conclusao, status_exame)
values (1, 1, 'Sangue', '2026-03-24', 'Pendente'); -- Prazo passado

insert into resultados_exames (id_pedido, descricao_laudo, data_finalizacao)
values (1, 'Hemograma completo sem alterações significativas.', now());
