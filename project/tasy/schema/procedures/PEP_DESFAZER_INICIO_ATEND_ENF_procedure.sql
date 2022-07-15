-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_desfazer_inicio_atend_enf (nr_atendimento_p bigint) AS $body$
BEGIN
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
 
	update atendimento_paciente 
	set   dt_inicio_atendimento  = NULL, 
		ie_status_pa = 'NA' 
	where  nr_atendimento = nr_atendimento_p;
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_desfazer_inicio_atend_enf (nr_atendimento_p bigint) FROM PUBLIC;

