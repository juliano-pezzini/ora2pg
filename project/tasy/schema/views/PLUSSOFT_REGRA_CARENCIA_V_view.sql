-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW plussoft_regra_carencia_v (nr_seq_proposta, nr_seq_carencia, nr_seq_tipo_carencia, ds_carencia, qt_dias, cd_beneficiario, nr_seq_regra_padrao, ds_regra, qt_dias_padrao) AS select	a.nr_seq_proposta		nr_seq_proposta,
		c.nr_sequencia			nr_seq_carencia,
		c.nr_seq_tipo_carencia		nr_seq_tipo_carencia,
		substr(d.ds_carencia,1,255) 	ds_carencia,
		coalesce((	select	x.qt_dias
			FROM 	pls_carencia x
			where 	x.nr_seq_pessoa_proposta = a.nr_sequencia
			and 	x.nr_seq_tipo_carencia = c.nr_seq_tipo_carencia),c.qt_dias) qt_dias,
		a.cd_beneficiario		cd_beneficiario,
		c.nr_seq_regra_padrao		nr_seq_regra_padrao,
		g.ds_regra			ds_regra,
		c.qt_dias			qt_dias_padrao
	from	pls_tipo_carencia		d,
		pls_carencia			c,
		pls_plano			b,
		pls_proposta_beneficiario	a,
		pls_proposta_adesao		e,
		pls_regra_carencia_padrao	f,
		pls_regra_carencia		g
	where	a.nr_seq_plano			= b.nr_sequencia
	and	c.nr_seq_plano			= b.nr_sequencia
	and	c.nr_seq_tipo_carencia		= d.nr_sequencia
	and	a.nr_seq_proposta		= e.nr_sequencia
	and	d.ie_cpt			= 'N'
	and	f.nr_sequencia			= c.nr_seq_regra_padrao
	and	g.nr_sequencia			= f.nr_seq_regra
	and	e.dt_inicio_proposta between coalesce(c.dt_inicio_vig_plano,e.dt_inicio_proposta) and coalesce(c.dt_fim_vig_plano,e.dt_inicio_proposta)
	group by 	a.nr_seq_proposta,
			c.nr_sequencia,
			c.nr_seq_tipo_carencia,
			d.ds_carencia,
			c.qt_dias,
			a.cd_beneficiario,
			c.nr_seq_regra_padrao,
			g.ds_regra,
			a.nr_sequencia
	
union all

	select	a.nr_seq_proposta		nr_seq_proposta,
		c.nr_sequencia			nr_seq_carencia,
		c.nr_seq_tipo_carencia		nr_seq_tipo_carencia,
		substr(d.ds_carencia,1,255) 	ds_carencia,
		coalesce((	select	x.qt_dias
			from 	pls_carencia x
			where 	x.nr_seq_pessoa_proposta = a.nr_sequencia
			and 	x.nr_seq_tipo_carencia = c.nr_seq_tipo_carencia),c.qt_dias) qt_dias,
		a.cd_beneficiario		cd_beneficiario,
		c.nr_seq_regra_padrao		nr_seq_regra_padrao,
		null				ds_regra,
		c.qt_dias			qt_dias_padrao
	from	pls_tipo_carencia		d,
		pls_carencia			c,
		pls_plano			b,
		pls_proposta_beneficiario	a,
		pls_proposta_adesao		e
	where	a.nr_seq_plano			= b.nr_sequencia
	and	c.nr_seq_plano			= b.nr_sequencia
	and	c.nr_seq_tipo_carencia		= d.nr_sequencia
	and	a.nr_seq_proposta		= e.nr_sequencia
	and	d.ie_cpt			= 'N'
	and	c.nr_seq_regra_padrao		is null
	and	e.dt_inicio_proposta between coalesce(c.dt_inicio_vig_plano,e.dt_inicio_proposta) and coalesce(c.dt_fim_vig_plano,e.dt_inicio_proposta)
	group by 	a.nr_seq_proposta,
			c.nr_sequencia,
			c.nr_seq_tipo_carencia,
			d.ds_carencia,
			c.qt_dias,
			a.cd_beneficiario,
			c.nr_seq_regra_padrao,
			a.nr_sequencia
	order by 	nr_seq_proposta,
			nr_seq_carencia,
			nr_seq_tipo_carencia;

