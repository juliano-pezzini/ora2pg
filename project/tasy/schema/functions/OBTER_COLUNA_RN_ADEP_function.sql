-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_coluna_rn_adep (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

						 
ie_retorno_w	  char(1) := 'N';
dt_entrada_w    timestamp;

BEGIN
 
if (coalesce(nr_atendimento_p,0) > 0) then 
 
	select max(dt_entrada) 
	into STRICT  dt_entrada_w 
	from  atendimento_paciente 
	where nr_atendimento = nr_atendimento_p;
 
	select	coalesce(max('S'),'N') 
	into STRICT  ie_retorno_w 
	from	atendimento_paciente where		nr_atendimento_mae = nr_atendimento_p 
	and   dt_entrada > dt_entrada_w LIMIT 1;
  
end if;
 
return	ie_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_coluna_rn_adep (nr_atendimento_p bigint) FROM PUBLIC;

