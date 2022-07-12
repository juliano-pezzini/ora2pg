-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_alergias_med_plan ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_alergia_w 	varchar(4000);
ds_retorno_w	varchar(4000) := null;
ds_agente_w		varchar(4000) := null;

C01 CURSOR FOR
	SELECT	distinct coalesce(ds_ficha_tecnica,ds_dcb,ds_dcb_mat,ds_material,ds_classe_mat,ds_medic_nao_cad,ds_alergeno,ds_familia_mat) ds_agente
	from	alergia_plan_medic_v
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	order 	by 1;


BEGIN

open c01;
loop
fetch	c01 into
	ds_alergia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	if (ds_alergia_w IS NOT NULL AND ds_alergia_w::text <> '')then
		if (substr(ds_alergia_w, -1) = '.') then
			ds_alergia_w := substr(ds_alergia_w, 1, length(ds_alergia_w) -1);
		end if;
		if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
			ds_retorno_w := ds_retorno_w  || '|';
		end if;
	ds_retorno_w := ds_retorno_w || ds_alergia_w;
	end if;
end loop;
close C01;

if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
	ds_retorno_w := ds_retorno_w || '.';
end if;
	

return	ds_retorno_w;
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_alergias_med_plan ( cd_pessoa_fisica_p text) FROM PUBLIC;
