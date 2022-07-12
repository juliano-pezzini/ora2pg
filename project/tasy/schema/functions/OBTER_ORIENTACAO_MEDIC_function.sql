-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_orientacao_medic ( cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000);
ds_reacao_w	varchar(4000);
ds_orientacao_w	varchar(4000);
IE_exibe_rec_padrao_W	varchar(1);


BEGIN

select	substr(max(ds_orientacao_usuario),1,4000)
into STRICT		ds_orientacao_w
from		material
where	cd_material	= cd_material_p
and		ie_gravar_obs_prescr in ('S','R');

select	substr(max(CASE WHEN position('<html' in b.ds_reacao)=0 THEN  b.ds_reacao  ELSE html_to_str_grid(b.ds_reacao) END ),1,200)
into STRICT	ds_reacao_w
from	material_reacao b,
	material a
where	a.cd_material	= b.cd_material
and	a.cd_material	= cd_material_p
and	a.ie_gravar_obs_prescr in ('S','E');

if (ds_orientacao_w IS NOT NULL AND ds_orientacao_w::text <> '') then
	IE_exibe_rec_padrao_W := OBTER_PARAM_USUARIO(924, 506, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, 0, IE_exibe_rec_padrao_W);
	if (IE_exibe_rec_padrao_W = 'S') then
		ds_retorno_w	:= Substr(obter_desc_expressao(294894) || ': '||ds_orientacao_w,1,4000);
	else
		ds_retorno_w	:= substr(ds_orientacao_w,1,4000);
	end if;
end if;

if (ds_reacao_w IS NOT NULL AND ds_reacao_w::text <> '') and (length(ds_retorno_w) < 3950 or coalesce(ds_retorno_w::text, '') = '') then
	if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
		ds_retorno_w	:= ds_retorno_w||chr(13)||chr(10);
	end if;
	ds_retorno_w	:= substr(ds_retorno_w||obter_desc_expressao(729528),1,4000);
	ds_retorno_w	:= substr(ds_retorno_w||substr(ds_reacao_w,1,4000-length(ds_retorno_w)),1,4000);
end if;

return substr(ds_retorno_w,1,4000);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_orientacao_medic ( cd_material_p bigint) FROM PUBLIC;
