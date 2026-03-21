use Gestao_Hospitalar;

-- Inserindo dados base
insert into medicos (nome_medico, crm, especialidade) values ('Dr. Lucas Silva', '12345-SP', 'Cardiologia');
insert into pacientes (nome_paciente, cpf, tipo_sanguineo) values ('Felipe Souza', '12345678901', 'O+');

-- Simulação de Consulta
insert into consultas (id_paciente, id_medico, data_consulta, status_consulta) 
values (1, 1, now(), 'Realizada');

-- Teste da trigger trg_alerta_piora
-- Vamos inserir uma evolução indicando "Piora"
insert into evolucao_paciente (id_paciente, id_consulta, status_progresso, observacoes_medicas)
values (1, 1, 'Piora', 'Paciente apresentou arritmia súbita.');

-- Verificação do resultado
-- O nome do paciente deve ter mudado e a tabela estado_critico deve ter um registro
select nome_paciente from pacientes where id_paciente = 1;
select * from estado_critico;

-- Teste da trigger trg_finalizar_exame
-- Criando um pedido de exame com prazo para "ontem" (para testar o status 'Atrasado')
insert into pedidos_exames (id_medico, id_paciente, tipo_exame, prazo_conclusao, status_exame)
values (1, 1, 'Sangue', '2026-03-20', 'Pendente');

-- Finalizando o exame hoje (id_pedido 1)
insert into resultados_exames (id_pedido, descricao_laudo) 
values (1, 'Hemograma completo sem alterações graves.');

-- Verificação de status e se mudou sozinho para 'Atrasado'
select status_exame from pedidos_exames where id_pedido = 1;
