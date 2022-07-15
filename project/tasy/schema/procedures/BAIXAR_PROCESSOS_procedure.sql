-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_processos (nr_atendimento_p bigint, cd_processo_p bigint, nr_sequencia_p bigint) AS $body$
BEGIN
 
update	processo_atendimento 
set	dt_fim_real	= clock_timestamp(), 
	ie_status	= 'F' 
where	nr_atendimento	= nr_atendimento_p 
and	cd_processo	= cd_processo_p 
and	nr_sequencia	= nr_sequencia_p;
 
 
update	atendimento_paciente 
set	ie_fim_conta	= 'F', 
	dt_fim_conta	= clock_timestamp() 
where	nr_atendimento	= nr_atendimento_p 
and	ie_fim_conta	= 'P' 
and 	(dt_alta IS NOT NULL AND dt_alta::text <> '') 
and 	not exists (SELECT nr_atendimento 
	from 		processo_atendimento 
	where 		nr_atendimento	= nr_atendimento_p 
    and 		coalesce(dt_fim_real::text, '') = '');
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_processos (nr_atendimento_p bigint, cd_processo_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

