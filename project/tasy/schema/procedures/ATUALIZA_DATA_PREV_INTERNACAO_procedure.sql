-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_data_prev_internacao ( nr_seq_agenda_p bigint, nr_atendimento_p bigint, ie_funcao_p bigint, nm_usuario_p text) AS $body$
DECLARE

					 
dt_chegada_prev_w	timestamp;
ie_atualiza_gestao_w	varchar(1);
ie_atualiza_datas_w	varchar(1);
/* 
	1 - Gestão de vagas 
	2 - Pacientes em fila de epera 
*/
					

BEGIN 
ie_atualiza_datas_w := obter_param_usuario(1002, 124, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_atualiza_datas_w);
 
if	((coalesce(nr_seq_agenda_p,0) > 0) or (coalesce(nr_atendimento_p,0) > 0)) and (coalesce(ie_atualiza_datas_w,'N') = 'S') then 
	 
	if (coalesce(ie_funcao_p,0) = 1) then -- Gestão de Vagas 
	 
		select	max(dt_prevista) 
		into STRICT	dt_chegada_prev_w 
		from	gestao_vaga 
		where	nr_seq_agenda 		= nr_seq_agenda_p 
		or	nr_atendimento		= nr_atendimento_p;
			 
		update	agenda_paciente 
		set	dt_chegada_prev		= dt_chegada_prev_w 
		where	nr_sequencia 		= nr_seq_agenda_p 
		or	nr_atendimento		= nr_atendimento_p;
			commit;
		update	paciente_espera 
		set	dt_prevista_internacao 	= dt_chegada_prev_w 
		where	nr_seq_agenda 		= nr_seq_agenda_p 
		or	nr_atendimento		= nr_atendimento_p;
			commit;
		 
	elsif (coalesce(ie_funcao_p,0) = 2) then -- Pacientes em fila de espera 
 
		ie_atualiza_gestao_w := obter_param_usuario(895, 27, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_atualiza_gestao_w);	
		 
		select	max(dt_prevista_internacao) 
		into STRICT	dt_chegada_prev_w 
		from	paciente_espera 
		where	nr_seq_agenda 		= nr_seq_agenda_p 
		or	nr_atendimento		= nr_atendimento_p;
		 
		update	agenda_paciente 
		set	dt_chegada_prev		= dt_chegada_prev_w 
		where	nr_sequencia 		= nr_seq_agenda_p 
		or	nr_atendimento		= nr_atendimento_p;
			commit;
		if (coalesce(ie_atualiza_gestao_w,'N') = 'S') then 
		 
			update	gestao_vaga 
			set	dt_prevista 		= dt_chegada_prev_w 
			where	nr_seq_agenda 		= nr_seq_agenda_p 
			or	nr_atendimento		= nr_atendimento_p;
			commit;
		end if;
		 
	end if;
	 
 
 
commit;
end if;	
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_data_prev_internacao ( nr_seq_agenda_p bigint, nr_atendimento_p bigint, ie_funcao_p bigint, nm_usuario_p text) FROM PUBLIC;

