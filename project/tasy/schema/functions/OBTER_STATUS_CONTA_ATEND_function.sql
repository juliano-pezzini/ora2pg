-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_conta_atend ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
				 
nr_interno_conta_w 	bigint:= 0;		
ds_retorno_w		varchar(255);	
				 

BEGIN 
 
ds_retorno_w := '';
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
 
	SELECT	max(NR_INTERNO_CONTA) 
	into STRICT	nr_interno_conta_w 
	FROM	CONTA_PACIENTE 
	WHERE	NR_ATENDIMENTO = nr_atendimento_p;
 
	ds_retorno_w := substr(obter_status_conta(nr_interno_conta_w, 'D'),1,255);
	 
end if;
 
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_conta_atend ( nr_atendimento_p bigint) FROM PUBLIC;
