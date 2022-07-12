-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_paciente_processo (nr_seq_processo_p bigint) RETURNS varchar AS $body$
DECLARE

				 
nm_paciente_w	varchar(60);
				

BEGIN 
if (nr_seq_processo_p IS NOT NULL AND nr_seq_processo_p::text <> '') then 
 
	select	obter_pessoa_atendimento(nr_atendimento,'N') 
	into STRICT	nm_paciente_w 
	from	adep_processo 
	where	nr_sequencia = nr_seq_processo_p;
 
end if;
 
return nm_paciente_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_paciente_processo (nr_seq_processo_p bigint) FROM PUBLIC;
