-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ptu_movimento_unisanta_v (nr_seq_benef, nr_seq_lote, cd_unimed, cd_empresa, cd_familia, cd_dependencia, cd_digito_verificador, nm_benef, dt_nascimento, ie_sexo, ie_estado_civil, dt_inclusao_uni, qt_periodo_inclu, dt_exclusao_uni, qt_periodo_exclusao, cd_unimed_empresa, cd_unimed_atend, cd_tabela_preco, ie_comissao_corretor, dt_termino_carencia, ie_abrangencia, cd_carteirinha_unimed) AS select	d.nr_sequencia				nr_seq_benef,
	a.nr_sequencia				nr_seq_lote,
	d.cd_unimed				cd_unimed,
	c.cd_empresa_origem 			cd_empresa,
	d.cd_familia				cd_familia,
	d.cd_dependencia			cd_dependencia,
	0					cd_digito_verificador,
	d.nm_beneficiario 			nm_benef,
	d.dt_nascimento				dt_nascimento,
	d.ie_sexo				ie_sexo,
	d.ie_estado_civil			ie_estado_civil,
	d.dt_inclusao 				dt_inclusao_uni,
	d.dt_inclusao				qt_periodo_inclu,
	d.dt_exclusao 				dt_exclusao_uni,
	d.dt_exclusao				qt_periodo_exclusao,
	d.cd_unimed 				cd_unimed_empresa,
	d.cd_unimed 				cd_unimed_atend,
	cd_plano				cd_tabela_preco,
	'N' 					ie_comissao_corretor,
	d.dt_ultima_carencia			dt_termino_carencia,
	d.ie_area_abrangencia			ie_abrangencia,
	lpad(d.cd_unimed,4,'0')||d.cd_usuario_plano	cd_carteirinha_unimed
FROM	ptu_mov_produto_benef		d,
	ptu_mov_produto_empresa		c,
	ptu_movimentacao_produto	b,
	ptu_mov_produto_lote		a
where	d.nr_seq_empresa		= c.nr_sequencia
and	c.nr_seq_mov_produto		= b.nr_sequencia
and	b.nr_seq_lote			= a.nr_sequencia;
