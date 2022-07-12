-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_medic_fracionado ( nr_seq_horario_p bigint) RETURNS char AS $body$
DECLARE

 
ds_retorno_w	varchar(1);

BEGIN
 
if (nr_seq_horario_p IS NOT NULL AND nr_seq_horario_p::text <> '') then	 
	select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
		into STRICT ds_retorno_w 
	from gedi_medic_atend 
	where	nr_seq_horario = nr_seq_horario_p;
	 
	return ds_retorno_w;
end if;
 
return 'N';
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_medic_fracionado ( nr_seq_horario_p bigint) FROM PUBLIC;

