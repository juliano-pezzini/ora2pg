-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION exibe_nm_generico_material ( cd_material_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_material	material.ds_material%type;
param		varchar(2);


BEGIN

select	coalesce(max(CASE WHEN vl_parametro='S' THEN 'S'  ELSE 'N' END ), 'N')
into STRICT	param
from	funcao_param_usuario
where	cd_funcao = 42
and	nm_usuario_param = nm_usuario_p
and	nr_sequencia = 17;

if (param = 'S')then
	ds_material := obter_desc_material(obter_material_generico(cd_material_p));
else
	ds_material := obter_desc_material(cd_material_p);
end if;

return ds_material;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION exibe_nm_generico_material ( cd_material_p bigint, nm_usuario_p text) FROM PUBLIC;
