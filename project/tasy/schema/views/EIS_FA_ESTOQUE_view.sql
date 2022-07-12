-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_fa_estoque (cd_material, ds_material, cd_grupo_material, ds_grupo_material, cd_subgrupo_material, ds_subgrupo_material, cd_classe_material, ds_classe_material, qt_material, dt_mes_referencia) AS select	cd_material,
	substr(ds_material,1,150) ds_material,
	cd_grupo_material,
	ds_grupo_material,
	cd_subgrupo_material,
	ds_subgrupo_material,
	cd_classe_material,
	ds_classe_material,
	1 qt_material,
	LOCALTIMESTAMP dt_mes_referencia
FROM	estrutura_material_v;
