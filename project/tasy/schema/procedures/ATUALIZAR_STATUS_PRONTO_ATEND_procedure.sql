-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_status_pronto_atend (nr_atendimento_p bigint, ie_status_p text, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE

 
/* ie_opcao_p 
	D - desfazer 
	A - Atualizar 
*/
 
 

BEGIN 
 
if (ie_opcao_p = 'A') then 
 
	if (ie_status_p = 'LE') then 
		update 	atendimento_paciente 
		set 	dt_liberacao_enfermagem = clock_timestamp(), 
			nm_usuario = nm_usuario_p 
		where 	nr_atendimento = nr_atendimento_p;
	end if;
 
	if (ie_status_p = 'RM') then 
		update 	atendimento_paciente 
		set 	dt_reavaliacao_medica = clock_timestamp(), 
			nm_usuario = nm_usuario_p 
		where 	nr_atendimento = nr_atendimento_p;
	end if;
 
elsif (ie_opcao_p = 'D') then 
 
	if (ie_status_p = 'LE') then 
		update 	atendimento_paciente 
		set 	dt_liberacao_enfermagem  = NULL, 
			nm_usuario = nm_usuario_p 
		where 	nr_atendimento = nr_atendimento_p;
	end if;
 
	if (ie_status_p = 'RM') then 
		update 	atendimento_paciente 
		set 	dt_reavaliacao_medica  = NULL, 
			nm_usuario = nm_usuario_p 
		where 	nr_atendimento = nr_atendimento_p;
	end if;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_status_pronto_atend (nr_atendimento_p bigint, ie_status_p text, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
