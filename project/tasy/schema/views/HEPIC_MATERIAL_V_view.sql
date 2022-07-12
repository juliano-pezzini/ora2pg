-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hepic_material_v (cd_material, ds_material, nr_registro_anvisa, nr_registro_ms, cd_brasindice, cd_tiss, valor_ult_compra, custo_medio) AS SELECT 	a.cd_material,
			a.ds_material,
			a.nr_registro_anvisa,
			a.nr_registro_ms,
			d.cd_medicamento cd_brasindice,
			tiss_obter_cod_brasindice(d.cd_apresentacao, d.cd_laboratorio, d.cd_medicamento) cd_tiss,
			obter_valor_ultima_compra('2',360,a.cd_material,'','') valor_ult_compra,
			obter_ult_custo_medio_mat('2', a.cd_material) custo_medio
     FROM subgrupo_material c, classe_material b, material a
LEFT OUTER JOIN material_brasindice d ON (a.cd_material = d.cd_material)
WHERE a.cd_classe_material = b.cd_classe_material AND b.cd_subgrupo_material = c.cd_subgrupo_material;
