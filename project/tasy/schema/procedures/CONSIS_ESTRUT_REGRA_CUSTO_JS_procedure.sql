-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consis_estrut_regra_custo_js ( cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, cd_material_p bigint, ds_erro_p INOUT text, ds_texto_p INOUT text) AS $body$
BEGIN

	ds_erro_p := consis_estrut_regra_ccusto_js(cd_grupo_material_p, cd_subgrupo_material_p, cd_classe_material_p, cd_material_p, ds_erro_p);
	ds_texto_p := obter_texto_tasy(44501, wheb_usuario_pck.get_nr_seq_idioma);

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consis_estrut_regra_custo_js ( cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, cd_material_p bigint, ds_erro_p INOUT text, ds_texto_p INOUT text) FROM PUBLIC;

