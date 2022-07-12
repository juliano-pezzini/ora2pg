-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_mat_conversao_conv ( cd_convenio_p bigint, cd_material_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
C - Código;
D - Descrição;
*/
cd_mat_convenio_w	varchar(20);
ds_mat_convenio_w	varchar(100);
ds_retorno_w		varchar(100);
ie_escape_w		varchar(1)	:= 'N';


BEGIN
if (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') and (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	begin
	select	max(cd_material_convenio),
		max(ds_material_convenio)
	into STRICT	cd_mat_convenio_w,
		ds_mat_convenio_w
	from	conversao_material_convenio
	where	cd_convenio		= cd_convenio_p
	and	cd_material		= cd_material_p;

	exception
		when others then
		ie_escape_w	:= 'S';
	end;

	if (ie_opcao_p = 'C') then
		ds_retorno_w	:= cd_mat_convenio_w;
	else
		ds_retorno_w	:= ds_mat_convenio_w;
	end if;
end if;

return	ds_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_mat_conversao_conv ( cd_convenio_p bigint, cd_material_p bigint, ie_opcao_p text) FROM PUBLIC;

