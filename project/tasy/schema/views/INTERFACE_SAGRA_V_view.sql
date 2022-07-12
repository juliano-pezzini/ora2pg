-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW interface_sagra_v (cd_tipo, ds_ident, vl_zero, cd_mat, nr_hosp, cd_sist, vl_fixo, cnpj, data, vl_espaco, nome, vl_fixo2, vl_unit, qt_quant, nr_reg, ds_mat, dt_movimento_estoque, cd_local_estoque, cd_grupo_material, cd_subgrupo_material, cd_lote_fabricacao, dt_validade, cd_unidade_medida_consumo, ie_tipo_movimento) AS select	1			cd_tipo,
	'HE'			ds_ident,
	0			vl_zero,
	null			cd_mat,
	null			nr_hosp,
	null			cd_sist,
	'VEMAC'			vl_fixo,
	'607779010001'		cnpj,
	LOCALTIMESTAMP			data,
	' '			vl_espaco,
	'Hospital Santa Paula SA'	nome,
	'Venda'			vl_fixo2,
	null			vl_unit,
	null			qt_quant,
	null			nr_reg,
	null			ds_mat,
	null			dt_movimento_estoque,
	0			cd_local_estoque,
	0			cd_grupo_material,
	0			cd_subgrupo_material,
	' '			cd_lote_fabricacao,
	LOCALTIMESTAMP			dt_validade,
	' '			cd_unidade_medida_consumo,
	' '			ie_tipo_movimento


union all

select	5			cd_tipo,
	'VE'			ds_ident,
	0			vl_zero,
	m.cd_material		cd_mat,
	01			nr_hosp,
	substr(obter_dados_material_estab(m.cd_material,m.cd_estabelecimento,'CSA'),1,20) cd_sist,
	'VEMAC'			vl_fixo,
	'607779010001'		cnpj,
	LOCALTIMESTAMP			data,
	' '			vl_espaco,
	'Hospital Santa Paula SA'	nome,
	'Venda'			vl_fixo2,
	p.vl_preco_venda		vl_unit,
	CASE WHEN m.cd_acao=1 THEN m.qt_movimento  ELSE m.qt_movimento * -1 END  qt_quant,
	0			nr_reg,
	substr(b.ds_material,1,100)	ds_mat,
	m.dt_movimento_estoque	dt_movimento_estoque,
	m.cd_local_estoque		cd_local_estoque,
	e.cd_grupo_material	cd_grupo_material,
	e.cd_subgrupo_material	cd_subgrupo_material,
	m.cd_lote_fabricacao,
	m.dt_validade,
	substr(obter_dados_material_estab(m.cd_material,m.cd_estabelecimento,'UMS'),1,30) cd_unidade_medida_consumo,
	CASE WHEN m.cd_acao=1 THEN substr(obter_dados_operacao_estoque(m.cd_operacao_estoque,'E'),1,1)  ELSE 'E' END  ie_tipo_movimento
from 	movimento_estoque_v m,
	preco_material	p,
	material b,
	estrutura_material_v e
where	b.ie_tipo_material in (2,3,4)
and	p.cd_material		= m.cd_material
and	p.cd_material		= b.cd_material
and	e.cd_material		= m.cd_material
and	m.cd_operacao_estoque	in (5,17,51,1,2,4,6,7,86)
and	m.qt_movimento		<> 0
and	m.ie_origem_documento	<> 5
and	p.cd_tab_preco_mat	= 90
and	p.dt_inicio_vigencia	=
	(select	max(x.dt_inicio_vigencia)
	from	preco_material x
	where	x.cd_tab_preco_mat	= 90
	and	x.cd_material		= p.cd_material);

