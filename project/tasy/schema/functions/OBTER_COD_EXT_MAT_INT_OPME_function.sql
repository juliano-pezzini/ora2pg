-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cod_ext_mat_int_opme (cd_material_tasy_p bigint, ie_sistema_externo_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_sistema_externo_p	= Sistema externo de integração OPME(Dom=3635)
I	= Inpart
P	= OpmeNexo
*/
cd_sistema_externo_w		varchar(255);


BEGIN
	select	max(cd_codigo)
	into STRICT	cd_sistema_externo_w
	from	material_sistema_externo
	where	cd_material = cd_material_tasy_p
	and 	ie_sistema = ie_sistema_externo_p;

	return	cd_sistema_externo_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cod_ext_mat_int_opme (cd_material_tasy_p bigint, ie_sistema_externo_p text) FROM PUBLIC;
