-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_ops_receita_v (dt_mes_competencia, dt_mes_competencia_ref, cd_estabelecimento, ds_tipo_beneficiario, ds_tipo_pessoa, ds_abrangencia, vl_receitas) AS select	substr(pkg_date_formaters.to_varchar(dt_mes_competencia,'shortDate',wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario),1,30) dt_mes_competencia,
	dt_mes_competencia dt_mes_competencia_ref,
	cd_estabelecimento,
	ds_tipo_beneficiario,
	ds_tipo_pessoa,
	ds_abrangencia,
	sum(vl_receitas) vl_receitas
FROM (
	select	pkg_date_utils.start_of(d.dt_mes_competencia,'MONTH') dt_mes_competencia,
		a.cd_estabelecimento,
		substr(obter_valor_dominio(2406,s.ie_tipo_segurado),1,30) ds_tipo_beneficiario,
		substr(CASE WHEN coalesce(c.cd_cgc_estipulante,'X')='X' THEN 'PJ'  ELSE 'PF' END ,1,30) ds_tipo_pessoa,
		substr(obter_valor_dominio(1667,p.ie_abrangencia),1,30) ds_abrangencia,
		coalesce(a.vl_mensalidade,0) + coalesce(a.vl_faturado,0) + coalesce(a.vl_taxa,0) vl_receitas
	from	pls_ar_dados_v a,
		pls_ar_lote d,
		pls_segurado s,
		pls_contrato c,
		pls_plano p
	where	d.nr_sequencia = a.nr_seq_lote
	and	s.nr_sequencia = a.nr_seq_segurado
	and	c.nr_sequencia = a.nr_seq_contrato
	and	p.nr_sequencia = a.nr_seq_plano
	order by a.nr_seq_segurado) alias13
group by dt_mes_competencia,
	 cd_estabelecimento,
	 ds_tipo_beneficiario,
	 ds_tipo_pessoa,
	 ds_abrangencia;
