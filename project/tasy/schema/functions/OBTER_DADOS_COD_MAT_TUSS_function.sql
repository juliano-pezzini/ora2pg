-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_cod_mat_tuss ( cd_material_tuss_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/* ie_opcao_p
	S - Sequência do material TUSS
*/
ds_retorno_w			varchar(255);


BEGIN

if (ie_opcao_p = 'S') then
	select	max(nr_sequencia)
	into STRICT	ds_retorno_w
	from	tuss_material_item
	where	cd_material_tuss = cd_material_tuss_p
	and	coalesce(dt_final_vigencia::text, '') = '';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_cod_mat_tuss ( cd_material_tuss_p text, ie_opcao_p text) FROM PUBLIC;
