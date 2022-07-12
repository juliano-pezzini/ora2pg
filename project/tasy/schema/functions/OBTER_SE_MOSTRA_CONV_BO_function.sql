-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_mostra_conv_bo (cd_convenio_p bigint) RETURNS varchar AS $body$
DECLARE

			 
ds_retorno_w		varchar(01);
cd_estabelecimento_w	smallint := wheb_usuario_pck.get_cd_estabelecimento;


BEGIN 
if (coalesce(cd_convenio_p,0) > 0) then 
	begin 
	select	ie_utiliza_conv_bo 
	into STRICT	ds_retorno_w 
	from	convenio_estabelecimento 
	where	cd_convenio 		= cd_convenio_p 
	and	cd_estabelecimento 	= cd_estabelecimento_w;
	exception 
	when others then 
		ds_retorno_w := 'S';
	end;
end if;
 
return	coalesce(ds_retorno_w,'S');
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_mostra_conv_bo (cd_convenio_p bigint) FROM PUBLIC;

