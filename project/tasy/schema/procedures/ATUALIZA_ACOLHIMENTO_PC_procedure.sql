-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_acolhimento_pc ( nr_atendimento_p bigint, ie_opcao_p text, cd_profissional_p text, nm_usuario_p text) AS $body$
DECLARE

 
dt_alteracao_w	timestamp;


BEGIN 
dt_alteracao_w := clock_timestamp();
 
--INICIAR ACOLHIMENTO 
if (nr_atendimento_p > 0 and ie_opcao_p = 'IA') then 
	update	atendimento_paciente 
	set 	dt_inicio_atendimento = dt_alteracao_w 
	where	nr_atendimento			= nr_atendimento_p;
 
	CALL gerar_atend_escuta(nr_atendimento_p,cd_profissional_p,nm_usuario_p);
	CALL gravar_acao_pc(nr_atendimento_p,dt_alteracao_w,cd_profissional_p,ie_opcao_p,nm_usuario_p);
end if;
 
--DESFAZER INICIO ACOLHIMENTO 
if (nr_atendimento_p > 0 and ie_opcao_p = 'DA') then 
	update	atendimento_paciente 
	set 	dt_inicio_atendimento  = NULL 
	where	nr_atendimento			= nr_atendimento_p;
 
	CALL gravar_acao_pc(nr_atendimento_p,dt_alteracao_w,cd_profissional_p,ie_opcao_p,nm_usuario_p);
end if;
 
--FIM ACOLHIMENTO 
if (nr_atendimento_p > 0 and ie_opcao_p = 'FA') then 
	update	atendimento_paciente 
	set 	dt_fim_triagem = dt_alteracao_w 
	where	nr_atendimento			= nr_atendimento_p;
 
	CALL gravar_acao_pc(nr_atendimento_p,dt_alteracao_w,cd_profissional_p,ie_opcao_p,nm_usuario_p);
end if;
 
--DESFAZER FIM ACOLHIMENTO 
if (nr_atendimento_p > 0 and ie_opcao_p = 'DFA') then 
	update	atendimento_paciente 
	set 	dt_fim_triagem  = NULL 
	where	nr_atendimento			= nr_atendimento_p;
 
	CALL gravar_acao_pc(nr_atendimento_p,dt_alteracao_w,cd_profissional_p,ie_opcao_p,nm_usuario_p);
end if;
 
--INICIAR CONSULTA 
if (nr_atendimento_p > 0 and ie_opcao_p = 'IC') then 
	update	atendimento_paciente 
	set 	dt_atend_medico = dt_alteracao_w 
	where	nr_atendimento = nr_atendimento_p;
 
	CALL gravar_acao_pc(nr_atendimento_p,dt_alteracao_w,cd_profissional_p,ie_opcao_p,nm_usuario_p);
end if;
 
--DESFAZER INICIO CONSULTA 
if (nr_atendimento_p > 0 and ie_opcao_p = 'DC') then 
	update	atendimento_paciente 
	set 	dt_atend_medico  = NULL 
	where	nr_atendimento = nr_atendimento_p;
 
	CALL gravar_acao_pc(nr_atendimento_p,dt_alteracao_w,cd_profissional_p,ie_opcao_p,nm_usuario_p);
end if;
 
--FINALIZAR CONSULTA 
if (nr_atendimento_p > 0 and ie_opcao_p = 'FC') then 
	update	atendimento_paciente 
	set 	dt_fim_consulta = dt_alteracao_w 
	where	nr_atendimento = nr_atendimento_p;
 
	CALL gravar_acao_pc(nr_atendimento_p,dt_alteracao_w,cd_profissional_p,ie_opcao_p,nm_usuario_p);
end if;
 
--DESFAZER FIM CONSULTA 
if (nr_atendimento_p > 0 and ie_opcao_p = 'DFC') then 
	update	atendimento_paciente 
	set 	dt_fim_consulta  = NULL 
	where	nr_atendimento = nr_atendimento_p;
 
	CALL gravar_acao_pc(nr_atendimento_p,dt_alteracao_w,cd_profissional_p,ie_opcao_p,nm_usuario_p);
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_acolhimento_pc ( nr_atendimento_p bigint, ie_opcao_p text, cd_profissional_p text, nm_usuario_p text) FROM PUBLIC;

