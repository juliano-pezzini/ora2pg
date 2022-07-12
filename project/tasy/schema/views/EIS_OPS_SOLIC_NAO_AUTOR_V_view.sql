-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_ops_solic_nao_autor_v (dt_solicitacao, cd_estabelecimento, ds_tipo_item, nr_seq_guia, nr_seq_prestador, nm_prestador, nr_seq_item, ds_item, vl_item, qt_negada, vl_negado) AS select	pkg_date_utils.start_of(dt_solicitacao, 'MONTH', 0) dt_solicitacao,
	cd_estabelecimento,
	ds_tipo_item,
	nr_seq_guia,
	nr_seq_prestador,
	nm_prestador,
	nr_seq_item,
	ds_item,
	vl_item,
	qt_negada,
	vl_negado
FROM	(
	select	g.dt_solicitacao,
		g.cd_estabelecimento,
		substr(obter_desc_expressao(296422),1,255) ds_tipo_item,
		g.nr_sequencia nr_seq_guia,
		g.nr_seq_prestador,
		substr(pls_obter_dados_prestador(g.nr_seq_prestador,'N'),1,255) nm_prestador,
		p.nr_sequencia nr_seq_item,
		substr(obter_descricao_procedimento(p.cd_procedimento,p.ie_origem_proced),1,255) ds_item,
		p.vl_procedimento vl_item,
		p.qt_solicitada - p.qt_autorizada qt_negada,
		p.vl_procedimento * (p.qt_solicitada - coalesce(p.qt_autorizada,0)) vl_negado
	from	pls_guia_plano g,
		pls_guia_plano_proc p,
		pls_auditoria a,
		pls_auditoria_item i
	where	g.nr_sequencia = p.nr_seq_guia
	and	g.nr_sequencia = a.nr_seq_guia
	and	a.nr_sequencia = i.nr_seq_auditoria
	and	p.nr_sequencia = i.nr_seq_proc_origem
	and	g.ie_estagio not in ('4','7','8','11','12')
	and	p.qt_solicitada > coalesce(p.qt_autorizada,0)
	and	p.qt_solicitada > 0
	
union all

	select	g.dt_solicitacao,
		g.cd_estabelecimento,
		substr(obter_desc_expressao(292952),1,255) ds_tipo_item,
		g.nr_sequencia nr_seq_guia,
		g.nr_seq_prestador,
		substr(pls_obter_dados_prestador(g.nr_seq_prestador,'N'),1,255) nm_prestador,
		m.nr_sequencia nr_seq_item,
		substr(pls_obter_desc_material(m.nr_seq_material),1,255) ds_item,
		m.vl_material vl_item,
		m.qt_solicitada - coalesce(m.qt_autorizada,0)  qt_autorizada,
		m.vl_material * (m.qt_solicitada - coalesce(m.qt_autorizada,0)) vl_negado
	from	pls_guia_plano g,
		pls_guia_plano_mat m,
		pls_auditoria a, 
		pls_auditoria_item i	
	where	g.nr_sequencia = m.nr_seq_guia
	and	g.nr_sequencia = a.nr_seq_guia
	and	a.nr_sequencia = i.nr_seq_auditoria
	and	m.nr_sequencia = i.nr_seq_mat_origem
	and	g.ie_estagio not in ('4','7','8','11','12')
	and	m.qt_solicitada > coalesce(m.qt_autorizada,0)
	and	m.qt_solicitada > 0
	
union all

	select	g.dt_solicitacao,
		g.cd_estabelecimento,
		substr(obter_desc_expressao(296422),1,255) ds_tipo_item,
		g.nr_sequencia nr_seq_guia,
		g.nr_seq_prestador,
		substr(pls_obter_dados_prestador(g.nr_seq_prestador,'N'),1,255) nm_prestador,
		p.nr_sequencia nr_seq_item,
		substr(obter_descricao_procedimento(p.cd_procedimento,p.ie_origem_proced),1,255) ds_item,
		p.vl_procedimento vl_item,
		p.qt_solicitada - p.qt_autorizada qt_negada,
		p.vl_procedimento * (p.qt_solicitada - coalesce(p.qt_autorizada,0)) vl_negado
	from	pls_guia_plano g,
		pls_guia_plano_proc p
	where	g.nr_sequencia = p.nr_seq_guia
	and	g.ie_estagio in ('4')
	and	p.qt_solicitada > coalesce(p.qt_autorizada,0)
	and	p.qt_solicitada > 0
	
union all

	select	g.dt_solicitacao,
		g.cd_estabelecimento,
		substr(obter_desc_expressao(292952),1,255) ds_tipo_item,
		g.nr_sequencia nr_seq_guia,
		g.nr_seq_prestador,
		substr(pls_obter_dados_prestador(g.nr_seq_prestador,'N'),1,255) nm_prestador,
		m.nr_sequencia nr_seq_item,
		substr(pls_obter_desc_material(m.nr_seq_material),1,255) ds_item,
		m.vl_material vl_item,
		m.qt_solicitada - coalesce(m.qt_autorizada,0)  qt_autorizada,
		m.vl_material * (m.qt_solicitada - coalesce(m.qt_autorizada,0)) vl_negado
	from	pls_guia_plano g,
		pls_guia_plano_mat m	
	where	g.nr_sequencia = m.nr_seq_guia
	and	g.ie_estagio in ('4')
	and	m.qt_solicitada > coalesce(m.qt_autorizada,0)
	and	m.qt_solicitada > 0
	) alias43;
