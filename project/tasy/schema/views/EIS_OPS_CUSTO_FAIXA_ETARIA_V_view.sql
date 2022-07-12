-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_ops_custo_faixa_etaria_v (dt_mes_competencia, dt_mes_competencia_param, cd_estabelecimento, vl_item, ds_faixa_etaria) AS select	dt_mes_competencia,
	dt_mes_competencia_param,
	cd_estabelecimento,
	vl_item,
	substr(pls_obter_seq_faixa_etaria(ds_idade,nr_seq_faixa,'D'), 1,30) ds_faixa_etaria
FROM	(
	select	pkg_date_utils.start_of(d.dt_mes_competencia,'MONTH') dt_mes_competencia,
		d.dt_mes_competencia dt_mes_competencia_param,
		a.cd_estabelecimento,
		a.ie_tipo_segurado,
		coalesce(a.vl_conta,0) + coalesce(a.vl_reembolso,0) + coalesce(a.vl_ressarcir,0) + coalesce(a.vl_recurso,0) - coalesce(a.vl_coparticipacao,0) vl_item,
		s.nr_sequencia nr_seq_segurado,
		p.cd_pessoa_fisica,
		p.dt_nascimento,
		trunc(pkg_date_utils.get_DiffDate(p.dt_nascimento, LOCALTIMESTAMP, 'YEAR')) ds_idade,
			(	
			select	max(w.nr_sequencia)
			from 	pls_faixa_etaria w
			where 	w.ie_tipo_faixa_etaria = 'IG'
			and 	w.ie_situacao = 'A'
			and	w.cd_estabelecimento = a.cd_estabelecimento
			) nr_seq_faixa
	from	pls_ar_dados_v a,
		pls_ar_lote d,
		pls_segurado s,
		pessoa_fisica p
	where	d.nr_sequencia = a.nr_seq_lote
	and	s.nr_sequencia = a.nr_seq_segurado
	and	p.cd_pessoa_fisica = s.cd_pessoa_fisica
	) alias12;

