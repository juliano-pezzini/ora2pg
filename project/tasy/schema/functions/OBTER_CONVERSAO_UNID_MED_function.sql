-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conversao_unid_med (cd_material_p bigint, cd_unid_med_p text) RETURNS bigint AS $body$
DECLARE



qt_retorno_w		double precision;
cd_unid_med_cons_w	varchar(30);
cd_estabelecimento_w	smallint := wheb_usuario_pck.get_cd_estabelecimento;


BEGIN

select	upper(substr(obter_dados_material_estab(cd_material,cd_estabelecimento_W,'UMS'),1,30))
into STRICT	cd_unid_med_cons_w
from	material
where	cd_material = cd_material_p;

if (cd_unid_med_cons_w = upper(cd_unid_med_p)) then
	qt_retorno_w := 1;
else
	select	coalesce(max(qt_conversao),0)
	into STRICT	qt_retorno_w
	from	material_conversao_unidade
	where	cd_material = cd_material_p
	and	upper(cd_unidade_medida) = upper(cd_unid_med_p);
end if;

return qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conversao_unid_med (cd_material_p bigint, cd_unid_med_p text) FROM PUBLIC;
