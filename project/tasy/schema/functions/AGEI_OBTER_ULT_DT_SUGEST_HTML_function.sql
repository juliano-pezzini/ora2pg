-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION agei_obter_ult_dt_sugest_html ( nr_seq_ageint_p bigint) RETURNS timestamp AS $body$
DECLARE

 
dt_retorno_w	timestamp;			
			 

BEGIN 
 
select max(a.hr_agenda) 
into STRICT	dt_retorno_w 
FROM agenda_integrada_item d, agenda c, ageint_lib_usuario b, ageint_sugestao_horarios a
LEFT OUTER JOIN pessoa_fisica e ON (a.cd_pessoa_fisica = e.cd_pessoa_Fisica)
WHERE a.nr_seq_ageint_lib 	= b.nr_sequencia and b.nr_seq_ageint   	= nr_seq_ageint_p and a.cd_agenda     	= c.cd_agenda and a.nr_seq_item    	= d.nr_sequencia;
 
return	dt_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION agei_obter_ult_dt_sugest_html ( nr_seq_ageint_p bigint) FROM PUBLIC;
