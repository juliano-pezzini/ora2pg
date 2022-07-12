-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_motivo_alta_atend (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
 
ds_motivo_w		varchar(80);


BEGIN 
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
	begin 
 
	select	obter_desc_motivo_alta(cd_motivo_alta) 
	into STRICT	ds_motivo_w 
	from	atendimento_paciente 
	where	nr_atendimento	= nr_atendimento_p;
	 
	end;
end if;
 
return	ds_motivo_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_motivo_alta_atend (nr_atendimento_p bigint) FROM PUBLIC;

