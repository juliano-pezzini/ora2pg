-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pc_obter_convenio (nr_atendimento_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE


retorno_w 		convenio.ds_convenio%type := '';
cd_convenio_w	convenio.cd_convenio%type := 0;
ds_convenio_w	convenio.ds_convenio%type := '';


BEGIN
	
	select coalesce(a.cd_convenio, 0)
	into STRICT cd_convenio_w
	from 	Atend_categoria_convenio a
	where a.nr_atendimento		= nr_atendimento_p
		  and a.dt_inicio_vigencia	= 
		 (SELECT max(dt_inicio_vigencia)
				 from Atend_categoria_convenio b
			     where nr_atendimento	= nr_atendimento_p);
	
	if (ie_tipo_p = 'C') then
		retorno_w := cd_convenio_w;
	elsif (ie_tipo_p = 'D') then
		
		select max(ds_convenio)
		into STRICT ds_convenio_w
		from CONVENIO where cd_convenio = cd_convenio_w;
		
		retorno_w := ds_convenio_w;
	end if;

	return retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pc_obter_convenio (nr_atendimento_p bigint, ie_tipo_p text) FROM PUBLIC;

