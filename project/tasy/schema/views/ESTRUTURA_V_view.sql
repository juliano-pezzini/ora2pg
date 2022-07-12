-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW estrutura_v (cd_grupo_material, ds_grupo_material, cd_subgrupo_material, ds_subgrupo_material, cd_classe_material, ds_classe_material) AS select	a.cd_grupo_material,
	a.ds_grupo_material,
	b.cd_subgrupo_material,
	b.ds_subgrupo_material,
	c.cd_classe_material,
	c.ds_classe_material
FROM	grupo_material a,
	subgrupo_material b,
	classe_material c
where	a.cd_grupo_material = b.cd_grupo_material
and	b.cd_subgrupo_material = c.cd_subgrupo_material;

