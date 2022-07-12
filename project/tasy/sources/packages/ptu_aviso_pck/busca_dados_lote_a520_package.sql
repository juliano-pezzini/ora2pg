-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_aviso_pck.busca_dados_lote_a520 (nr_seq_lote_p ptu_lote_aviso.nr_sequencia%type, dados_a520_p INOUT dados_lote_a520_t) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Varre o lote, levantando os dados inciais para a geracao do mesmo
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


dados_w		dados_lote_a520_t;


BEGIN


-- dados iniciais do lote em si

select	max(a.ie_processo),
	max(a.ie_tipo_data),
	trunc(max(a.dt_referencia_inicio)),
	fim_dia(max(a.dt_referencia_fim)),
	max(a.cd_estabelecimento),
	max(a.nr_seq_regra),
	max((	select	coalesce(max(x.ie_novo_pos_estab),'N')
		from	pls_visible_false	x
		where	x.cd_estabelecimento	= a.cd_estabelecimento)),
	max((	select	max(coalesce(x.ie_geracao_aviso_cobr, 'PO'))
		from	pls_parametros		x
		where	x.cd_estabelecimento	= a.cd_estabelecimento)),
	max((	select 	coalesce(max(x.ie_via_acesso_mult), 'N')
		from	pls_parametro_faturamento	x
		where	x.cd_estabelecimento =	a.cd_estabelecimento))
into STRICT	dados_w.ie_processo,
	dados_w.ie_tipo_data,
	dados_w.dt_referencia_inicio,
	dados_w.dt_referencia_fim,
	dados_w.cd_estabelecimento,
	dados_w.nr_seq_regra,
	dados_w.ie_novo_pos_estab,
	dados_w.ie_geracao_aviso_cobr,
	dados_w.ie_via_acesso_mult
from	ptu_lote_aviso	a
where	a.nr_sequencia	= nr_seq_lote_p;

-- Dados dos filtros adicionais

select	count(nr_seq_conta),
	count(nr_seq_protocolo),
	count(cd_guia_referencia)
into STRICT	dados_w.qt_conta_adic,
	dados_w.qt_prot_adic,
	dados_w.qt_guia_ref_adic
from	ptu_lote_aviso_adic
where	nr_seq_lote = nr_seq_lote_p;

-- Dados das excecoes

select	count(nr_seq_conta),
	count(nr_seq_protocolo),
	count(cd_guia_referencia)
into STRICT	dados_w.qt_conta_exce,
	dados_w.qt_prot_exce,
	dados_w.qt_guia_ref_exce
from	ptu_lote_aviso_excecao
where	nr_seq_lote = nr_seq_lote_p;

dados_w.nr_seq_lote := nr_seq_lote_p;

dados_a520_p := dados_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_aviso_pck.busca_dados_lote_a520 (nr_seq_lote_p ptu_lote_aviso.nr_sequencia%type, dados_a520_p INOUT dados_lote_a520_t) FROM PUBLIC;