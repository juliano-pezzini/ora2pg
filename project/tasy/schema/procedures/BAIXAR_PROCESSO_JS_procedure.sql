-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_processo_js ( nr_sequencia_p bigint, nr_atendimento_p bigint, dt_fim_real_p timestamp, nm_usuario_p text) AS $body$
BEGIN
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
 
	update	processo_atendimento 
	set	dt_fim_real 	= clock_timestamp(), 
		ie_status 	= 'F' 
	where	nr_sequencia 	= nr_sequencia_p 
	and	coalesce(dt_fim_real::text, '') = '';
	commit;
 
 
	update	atendimento_paciente 
	set 	ie_fim_conta = 'F', 
		dt_fim_conta 	= clock_timestamp() 
	where 	nr_atendimento = nr_atendimento_p 
	and 	ie_fim_conta = 'P' 
	and 	(dt_alta IS NOT NULL AND dt_alta::text <> '') 
	and 	not exists (	SELECT	nr_atendimento 
				from 	processo_atendimento 
				where 	nr_atendimento = nr_atendimento_p 
				and 	coalesce(dt_fim_real::text, '') = '');
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_processo_js ( nr_sequencia_p bigint, nr_atendimento_p bigint, dt_fim_real_p timestamp, nm_usuario_p text) FROM PUBLIC;
