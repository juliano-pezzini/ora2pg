-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_ops_custo_per_capita_v (dt_mes_competencia, ie_tipo_segurado, vl_custo, qt_beneficiarios, cd_estabelecimento) AS select	dt_mes_competencia,
	ie_tipo_segurado,
	vl_custo,
	qt_beneficiarios,
	cd_estabelecimento
FROM	(
	select	z.dt_mes_competencia,
		z.ie_tipo_segurado,
		max((	select	count(*)
			from	pls_segurado s
			where	coalesce(dt_rescisao,z.dt_mes_competencia) >= z.dt_mes_competencia
			and	dt_liberacao is not null
			and	dt_contratacao <= z.dt_mes_competencia
			and	ie_tipo_segurado = z.ie_tipo_segurado
		)) qt_beneficiarios,
		sum(vl_item) vl_custo,
		z.cd_estabelecimento
	from (
		select	pkg_date_utils.start_of(d.dt_mes_competencia,'MONTH') dt_mes_competencia,
			a.ie_tipo_segurado,
			coalesce(a.vl_conta,0) + coalesce(a.vl_reembolso,0) + coalesce(a.vl_ressarcir,0) + coalesce(a.vl_recurso,0) - coalesce(a.vl_coparticipacao,0) vl_item,
			d.cd_estabelecimento
		from	pls_ar_dados_v a,
			pls_ar_lote d
		where	d.nr_sequencia = a.nr_seq_lote
		and	ie_tipo_segurado in ('B', 'A', 'P', 'R', 'T')) z
	group by z.dt_mes_competencia,
		 z.ie_tipo_segurado,
		 z.cd_estabelecimento
	) alias13;

