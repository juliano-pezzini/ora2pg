-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ar_gerar_resultado_pck.rateio_desp_contab_prop ( nr_seq_lote_p pls_ar_lote.nr_sequencia%type, nr_seq_desp_contab_p pls_ar_despesa_contab_lote.nr_sequencia%type, ie_tipo_despesa_p pls_ar_despesa_contab_lote.ie_tipo_despesa%type, vl_despesa_p pls_ar_despesa_contab_lote.vl_despesa%type, vl_base_mensalidade_p pls_ar_despesa_contab_lote.vl_base_mensalidade%type, qt_regra_p integer, dt_fim_p pls_ar_lote.dt_fim%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
BEGIN

	begin
	insert into pls_ar_despesa_contabil(nr_sequencia,
		nm_usuario,
		nm_usuario_nrec,
		dt_atualizacao,
		dt_atualizacao_nrec,
		cd_estabelecimento,
		nr_seq_lote,
		vl_despesa,
		ie_tipo_despesa,
		nr_seq_segurado,
		nr_seq_desp_contabil,
		nr_seq_plano,
		ie_tipo_segurado,
		ie_tipo_vinculo_operadora,
		nr_seq_contrato,
		nr_seq_pagador,
		nr_seq_intercambio,
		ie_preco,
		ie_regulamentacao,
		ie_tipo_contratacao,
		nr_seq_faixa_etaria,
		ie_situacao_trabalhista,
		nr_seq_congenere_repasse,
		ie_tipo_contrato,
		nr_seq_grupo_intercambio,
		vl_mensalidade)
	SELECT	nextval('pls_ar_despesa_contabil_seq'),
		nm_usuario_p,
		nm_usuario_p,
		clock_timestamp(),
		clock_timestamp(),
		cd_estabelecimento_p,
		nr_seq_lote_p,
		trunc((((t.vl_item * 100) / vl_base_mensalidade_p) * vl_despesa_p) / 100,2) vl_despesa,
		ie_tipo_despesa_p,
		t.nr_seq_segurado,
		nr_seq_desp_contab_p,
		t.nr_seq_plano,
		t.ie_tipo_segurado,
		t.ie_tipo_vinculo_operadora,
		t.nr_seq_contrato,
		t.nr_seq_pagador,
		t.nr_seq_intercambio,
		t.ie_preco,
		t.ie_regulamentacao,
		t.ie_tipo_contratacao,
		t.nr_seq_faixa_etaria,
		t.ie_situacao_trabalhista,
		t.nr_seq_congenere_repasse,
		t.ie_tipo_contrato,
		t.nr_seq_grupo_intercambio,
		t.vl_item
	from	(	SELECT	x.nr_seq_segurado,
				x.nr_seq_plano,
				x.ie_tipo_segurado,
				x.ie_tipo_vinculo_operadora,
				x.nr_seq_contrato,
				x.nr_seq_pagador,
				x.nr_seq_intercambio,
				x.ie_preco,
				x.ie_regulamentacao,
				x.ie_tipo_contratacao,
				x.nr_seq_faixa_etaria,
				x.ie_situacao_trabalhista,
				x.nr_seq_congenere_repasse,
				x.ie_tipo_contrato,
				x.nr_seq_grupo_intercambio,
				sum(x.vl_item) vl_item
			from	pls_ar_mensalidade		x,
				pls_segurado			y
			where	y.nr_sequencia	= x.nr_seq_segurado
			and	x.nr_seq_lote	= nr_seq_lote_p
			and	(y.dt_liberacao IS NOT NULL AND y.dt_liberacao::text <> '')
			and	y.dt_contratacao <= dt_fim_p
			and	((coalesce(y.dt_rescisao::text, '') = '') or (y.dt_rescisao > dt_fim_p))
			and	((qt_regra_p = 0) or (exists (select	1
					from	pls_ar_desp_contab_regra x
					where	x.nr_seq_ar_desp_contab	= nr_seq_desp_contab_p
					and	x.ie_tipo_segurado	= y.ie_tipo_segurado)))
			group by x.nr_seq_segurado,
				x.nr_seq_plano,
				x.ie_tipo_segurado,
				x.ie_tipo_vinculo_operadora,
				x.nr_seq_contrato,
				x.nr_seq_pagador,
				x.nr_seq_intercambio,
				x.ie_preco,
				x.ie_regulamentacao,
				x.ie_tipo_contratacao,
				x.nr_seq_faixa_etaria,
				x.ie_situacao_trabalhista,
				x.nr_seq_congenere_repasse,
				x.ie_tipo_contrato,
				x.nr_seq_grupo_intercambio) t;
	commit;
	exception
		when no_data_found then null;
	end;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ar_gerar_resultado_pck.rateio_desp_contab_prop ( nr_seq_lote_p pls_ar_lote.nr_sequencia%type, nr_seq_desp_contab_p pls_ar_despesa_contab_lote.nr_sequencia%type, ie_tipo_despesa_p pls_ar_despesa_contab_lote.ie_tipo_despesa%type, vl_despesa_p pls_ar_despesa_contab_lote.vl_despesa%type, vl_base_mensalidade_p pls_ar_despesa_contab_lote.vl_base_mensalidade%type, qt_regra_p integer, dt_fim_p pls_ar_lote.dt_fim%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
