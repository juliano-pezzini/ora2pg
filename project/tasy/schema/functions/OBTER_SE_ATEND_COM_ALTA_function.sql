-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atend_com_alta ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w		varchar(1) := 'N';
cd_motivo_alta_w	bigint;
ie_alta_especial_w	varchar(1) := 'N';

BEGIN
if (coalesce(nr_atendimento_p,0) > 0) then 
 
	select	coalesce(max(cd_motivo_alta),0) 
	into STRICT	cd_motivo_alta_w 
	from 	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_p 
	and	(dt_alta IS NOT NULL AND dt_alta::text <> '');
	 
	if (coalesce(cd_motivo_alta_w,0) > 0) then 
		 
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
		into STRICT	ds_retorno_w 
		from	motivo_alta 
		where	cd_motivo_alta = cd_motivo_alta_w 
		and	coalesce(ie_alta_especial,'N') = 'S';
			 
	end if;
 
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atend_com_alta ( nr_atendimento_p bigint) FROM PUBLIC;

