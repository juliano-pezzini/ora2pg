-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_ops_custo_autorizado_v (dt_competencia, dt_competencia_param, cd_estabelecimento, ds_tipo_item, nr_seq_guia, nr_seq_item, ds_item, vl_item, qt_autorizada, vl_custo) AS select	--pkg_date_formaters.to_varchar(pkg_date_utils.start_of(dt_autorizacao,'MONTH',0),'shortDate',wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario) dt_competencia,
	pkg_date_utils.start_of(dt_autorizacao, 'MONTH', 0) dt_competencia,
	pkg_date_utils.start_of(dt_autorizacao, 'MONTH', 0) dt_competencia_param,
	cd_estabelecimento,
	ds_tipo_item,
	nr_seq_guia,
	nr_seq_item,
	ds_item,
	vl_item,	
	qt_autorizada,
	vl_custo
FROM (
	select	g.dt_autorizacao,
		g.cd_estabelecimento,
		substr(obter_desc_expressao(296422),1,255) ds_tipo_item,
		g.nr_sequencia nr_seq_guia,
		p.nr_sequencia nr_seq_item,
		substr(obter_descricao_procedimento(p.cd_procedimento,p.ie_origem_proced),1,255) ds_item,
		p.vl_procedimento vl_item,	
		p.qt_autorizada qt_autorizada,
		p.vl_procedimento * p.qt_autorizada vl_custo
	from	pls_guia_plano g,
		pls_guia_plano_proc p
	where	p.nr_seq_guia = g.nr_sequencia
	and	p.qt_autorizada <> coalesce(p.qt_utilizado,0)
	and	p.qt_autorizada > 0
	
union all

	select	g.dt_autorizacao,
		g.cd_estabelecimento,
		substr(obter_desc_expressao(292952),1,255) ds_tipo_item,
		g.nr_sequencia nr_seq_guia,
		m.nr_sequencia nr_seq_item,
		substr(pls_obter_desc_material(m.nr_seq_material),1,255) ds_item,
		m.vl_material vl_item,
		m.qt_autorizada qt_autorizada,
		m.vl_material * m.qt_autorizada vl_custo
	from	pls_guia_plano g,
		pls_guia_plano_mat m
	where	m.nr_seq_guia = g.nr_sequencia
	and	m.qt_autorizada <> coalesce(m.qt_utilizado,0)
	and	m.qt_autorizada > 0
	) alias12;

