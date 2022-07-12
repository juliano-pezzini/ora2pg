-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_consumo_matmed_offline_v (cd_centro_custo, cd_material, dt_mesano_referencia, cd_estabelecimento, cd_local_estoque, ie_consignado, qt_estoque, vl_estoque, cd_grupo_material, ds_grupo_material, cd_subgrupo_material, ds_subgrupo_material, cd_classe_material, ds_classe_material, ds_material, ds_centro_custo, ds_local_estoque, vl_custo_medio, ie_curva_abc, cd_operacao_estoque, ds_operacao_estoque, ie_tipo_requisicao, ds_tipo_requisicao, nm_estabelecimento) AS select	a.cd_centro_custo,
	a.cd_material cd_material,
	a.dt_mesano_referencia,
	a.cd_estabelecimento,
	a.cd_local_estoque,
	CASE WHEN coalesce(o.ie_consignado,0)=0 THEN 'N'  ELSE 'S' END  ie_consignado,
	--decode(o.ie_consumo, 'A', a.qt_estoque, 'D', a.qt_estoque * -1, 0) qt_estoque,
	a.qt_consumo qt_estoque,
	coalesce(CASE WHEN o.ie_consumo='A' THEN  a.vl_estoque WHEN o.ie_consumo='D' THEN  a.vl_estoque * -1  ELSE 0 END ,0) vl_estoque,
	g.cd_grupo_material,
	g.ds_grupo_material,
	s.cd_subgrupo_material,
	s.ds_subgrupo_material,
	c.cd_classe_material,
	c.ds_classe_material,
	substr(e.ds_material,1,100) ds_material,
	substr(b.ds_centro_custo,1,100) ds_centro_custo,
	substr(l.ds_local_estoque,1,100) ds_local_estoque,
	obter_custo_medio_material(a.cd_estabelecimento, a.dt_mesano_referencia, a.cd_material) vl_custo_medio,
	substr(obter_curva_abc_estab(a.cd_estabelecimento, a.cd_material, 'N',a.dt_mesano_referencia),1,1) ie_curva_abc,
	a.cd_operacao_estoque,
	substr(o.ds_operacao,1,100) ds_operacao_estoque,
	o.ie_tipo_requisicao,
	substr(obter_valor_dominio(21,o.ie_tipo_requisicao),1,100) ds_tipo_requisicao,
	SUBSTR(obter_nome_estabelecimento(a.cd_estabelecimento),1,255) nm_estabelecimento
	--a.cd_acao,
	--decode(a.cd_acao,2,'Estorno','Inclusão') ds_acao
	--a.dt_movimento_estoque
FROM subgrupo_material s, operacao_estoque o, local_estoque l, grupo_material g, material e, classe_material c, resumo_movto_estoque a
LEFT OUTER JOIN centro_custo b ON (a.cd_centro_custo = b.cd_centro_custo)
WHERE a.cd_material = e.cd_material and a.cd_operacao_estoque = o.cd_operacao_estoque  and a.cd_local_estoque = l.cd_local_estoque and o.ie_consumo in ('A','D') and e.cd_classe_material = c.cd_classe_material and c.cd_subgrupo_material = s.cd_subgrupo_material and s.cd_grupo_material = g.cd_grupo_material;

