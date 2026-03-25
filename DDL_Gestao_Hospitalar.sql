create database Gestao_Hospitalar
character set utf8mb4
collate utf8mb4_0900_ai_ci;

use Gestao_Hospitalar;

-- Criação da tabela de medicos
create table medicos(
id_medico int auto_increment primary key,
nome_medico varchar(100) not null, 
crm varchar(50) unique not null,
especialidade varchar(50) not null
);

-- Criação da tabela de pacientes
create table pacientes(
id_paciente int auto_increment primary key,
nome_paciente varchar(100) not null,
cpf varchar(11) unique not null,
tipo_sanguineo enum('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')
);

-- Criação da tabela de registro das medições de triagem dos pacientes
create table sinais_vitais(
id_sinal int auto_increment primary key,
id_consulta int,
id_paciente int,
frequencia_cardiaca int,
pressao_sistolica int,
temperatura decimal(4,1),
data_medicao timestamp default current_timestamp
);

-- Criação da tabela de consultas
create table consultas(
id_consulta int auto_increment primary key,
id_paciente int,
id_medico int,
data_consulta datetime not null,
status_consulta enum('Agendada', 'Realizada', 'Cancelada') default 'Agendada',
observacoes_pre_triagem text
);

-- Criação da tabela de pedidos dos exames
create table pedidos_exames(
id_pedido int auto_increment primary key,
id_medico int,
id_paciente int,
tipo_exame enum('Sangue', 'Raio-x', 'Tomografia', 'Urina') not null,
data_solicitacao timestamp default current_timestamp,
prazo_conclusao date not null,
status_exame enum('Finalizado', 'Atrasado', 'Cancelado', 'Pendente') default 'Pendente'
);

-- Criação da tabela dos resultados dos exames
create table resultados_exames(
id_resultado int auto_increment primary key,
id_pedido int unique,
descricao_laudo text,
data_finalizacao timestamp default current_timestamp
);

-- Criação da tabela dos prontuarios
create table prontuarios(
id_prontuario int auto_increment primary key,
id_consulta int unique,
diagnostico text not null,
prescricao text,
data_registro timestamp default current_timestamp
);

-- Criação da tabela de medicamentos
create table medicamentos(
id_medicamento int auto_increment primary key,
nome_medicamento varchar(100) not null,
unidade_medida varchar(20) default 'mg'
);

-- Criação da tabela de itens e prescrição
create table itens_prescricao(
id_item int auto_increment primary key,
id_prontuario int,
id_medicamento int,
dosagem varchar(50) not null,
frequencia varchar(50) not null
);

-- Criação da tabela de acompanhamento de evolução dos pacientes
create table evolucao_paciente(
id_evolucao int auto_increment primary key,
id_paciente int,
id_consulta int,
status_progresso enum('Melhora Acentuada', 'Estável', 'Piora', 'Cura/Alta') not null,
necessita_retorno boolean default false,
prazo_retorno_dias int,
observacoes_medicas text
);

-- Criação da tabela de registro de pacientes em estado crítico
create table estado_critico(
id_estado int auto_increment primary key,
id_paciente int,
id_evolucao int,
status_progresso enum('Melhora Acentuada', 'Estável', 'Piora', 'Cura/Alta') not null,
data_alerta timestamp default current_timestamp
);

-- Criação da tabela de registro de alertas de medições de pacientes
create table alertas_criticos(
id_alerta int auto_increment primary key,
id_paciente int,
tipo_alerta varchar(50),
descricao text,
data_alerta timestamp default current_timestamp,
status_atendimento enum('Pendente', 'Em curso', 'Resolvido') default 'Resolvido'
);

-- Criação das Foreign Keys

alter table consultas
add constraint fk_cons_med foreign key (id_medico) references medicos (id_medico),
add constraint fk_cons_pac foreign key (id_paciente) references pacientes (id_paciente);

alter table pedidos_exames
add constraint fk_ped_med foreign key (id_medico) references medicos (id_medico),
add constraint fk_ped_pac foreign key (id_paciente) references pacientes (id_paciente);

alter table sinais_vitais
add constraint fk_sina_cons foreign key (id_consulta) references consultas(id_consulta),
add constraint fk_sina_pac foreign key (id_paciente) references pacientes(id_paciente);

alter table prontuarios
add constraint fk_pron_cons foreign key (id_consulta) references consultas (id_consulta);

alter table evolucao_paciente
add constraint fk_evo_pac foreign key (id_paciente) references pacientes (id_paciente),
add constraint fk_evo_cons foreign key (id_consulta) references consultas (id_consulta);

alter table resultados_exames
add constraint fk_res_ped foreign key (id_pedido) references pedidos_exames (id_pedido);

alter table itens_prescricao
add constraint fk_ip_pron foreign key (id_prontuario) references prontuarios (id_prontuario),
add constraint fk_ip_medi foreign key (id_medicamento) references medicamentos (id_medicamento);

alter table estado_critico
add constraint fk_est_pac foreign key (id_paciente) references pacientes (id_paciente),
add constraint fk_est_evo foreign key (id_evolucao) references evolucao_paciente (id_evolucao);

alter table alertas_criticos
add constraint fk_alert_pac foreign key (id_paciente) references pacientes (id_paciente);

-- Triggers

-- Criação da trigger de monitoramento de conclusão de exames e se estão atrasados
delimiter //
create trigger trg_finalizar_exame
after insert on resultados_exames
for each row
begin
    declare v_prazo date;
    select prazo_conclusao into v_prazo from pedidos_exames where id_pedido = new.id_pedido;

    if new.data_finalizacao > v_prazo then
        update pedidos_exames set status_exame = 'Atrasado' where id_pedido = new.id_pedido;
    else
        update pedidos_exames set status_exame = 'Finalizado' where id_pedido = new.id_pedido;
    end if;
end //
delimiter ;

-- Criação da trigger de registro de alertas no estado do paciente
delimiter //
create trigger trg_alerta_piora
after insert on evolucao_paciente
for each row
begin
    if new.status_progresso = 'Piora' then
        update pacientes 
        set nome_paciente = concat('[ALERTA!]', nome_paciente) 
        where id_paciente = new.id_paciente;
        
        insert into estado_critico (id_paciente, id_evolucao, status_progresso)
        values (new.id_paciente, new.id_evolucao, new.status_progresso);

    end if;
end //
delimiter ;

-- Criação da trigger de registro de alertas criticos quanto a medidadas do paciente
delimiter //
create trigger alerta_critico_automatico
after insert on sinais_vitais
for each row
begin
    -- Lógica de Alerta: Frequência Cardíaca ( < 50 ou > 120 ) ou Febre Alta ( > 39 )
    if new.frequencia_cardiaca < 50 or new.frequencia_cardiaca > 120 or new.temperatura > 39 then
    insert into alertas_criticos (id_paciente, tipo_alerta, descricao, status_atendimento)
        values (new.id_paciente, 'Risco Clínico Médio/Alto', concat('[ALERTA!] Freq. Card: ', new.frequencia_cardiaca, ' bpm | Temp: ', new.temperatura, '°C'), 'Pendente');
    end if;
end //

delimiter ;
