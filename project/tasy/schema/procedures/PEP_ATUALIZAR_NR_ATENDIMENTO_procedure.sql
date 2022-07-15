-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_atualizar_nr_atendimento ( nr_atendimento_p bigint, cd_evolucao_p bigint, nr_sequencia_p bigint, ie_abap_p text, nm_usuario_p text ) AS $body$
BEGIN

if (ie_abap_p = '9370') then --Evolucao
	begin
	update 	evolucao_paciente
	set 	nr_atendimento 		= nr_atendimento_p,
		dt_atualizacao  	= clock_timestamp(),
		cd_setor_atendimento 	= Obter_Setor_Atendimento(nr_atendimento_p),
		nm_usuario 		= nm_usuario_p
        where 	cd_evolucao 		= cd_evolucao_p;	
	
	end;
elsif (ie_abap_p = '9466') then
	begin
	
	update 	evolucao_paciente
	set 	nr_atendimento 		= nr_atendimento_p,
		cd_setor_atendimento 	= Obter_Setor_Atendimento(nr_atendimento_p)
        where 	cd_evolucao 		= cd_evolucao_p;	
	
	end;	
else
	begin
	
	update 	qua_evento_paciente
        set   	nr_atendimento = nr_atendimento_p,
		dt_atualizacao = clock_timestamp(), 
		nm_usuario     = nm_usuario_p
        where 	nr_sequencia   = nr_sequencia_p;
	
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_atualizar_nr_atendimento ( nr_atendimento_p bigint, cd_evolucao_p bigint, nr_sequencia_p bigint, ie_abap_p text, nm_usuario_p text ) FROM PUBLIC;

