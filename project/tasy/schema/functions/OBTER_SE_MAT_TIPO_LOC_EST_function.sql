-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_mat_tipo_loc_est (cd_material_p bigint, ie_tipo_local_est_p text) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1);

/*
ie_tipo_local_est_p
'P' - Prestador
'O' - Operadora
'F' - Farmacia
'D' - Distribuidora
*/
BEGIN

if (ie_tipo_local_est_p = 'P') then
	select	coalesce(max(ie_prestador),'N')
	into STRICT	ie_retorno_w
	from	material_tipo_local_est a
	where	a.cd_material	= cd_material_p;
elsif (ie_tipo_local_est_p = 'O') then
	select	coalesce(max(ie_operadora),'N')
	into STRICT	ie_retorno_w
	from	material_tipo_local_est a
	where	a.cd_material	= cd_material_p;
elsif (ie_tipo_local_est_p = 'F') then
	select	coalesce(max(ie_farmacia),'N')
	into STRICT	ie_retorno_w
	from	material_tipo_local_est a
	where	a.cd_material	= cd_material_p;
elsif (ie_tipo_local_est_p = 'D') then
	select	coalesce(max(ie_distribuidora),'N')
	into STRICT	ie_retorno_w
	from	material_tipo_local_est a
	where	a.cd_material	= cd_material_p;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_mat_tipo_loc_est (cd_material_p bigint, ie_tipo_local_est_p text) FROM PUBLIC;

