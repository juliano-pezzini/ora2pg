-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_contab_onl_lote_fin_pck.contabiliza_movimento ( dados_contab_p INOUT dados_contab, nm_usuario_p text) AS $body$
DECLARE


	ctb_movimento_doc_w		ctb_online_pck.ctb_movimento_doc;
	nr_lote_contabil_w		lote_contabil.nr_lote_contabil%type;
	dt_atualizacao_saldo_w		timestamp;
	ds_erro_w			varchar(255) := null;

	
BEGIN

	/* Atribui os valores passados para a variavel que e utilizada no ctb_online_pck*/

	ctb_movimento_doc_w.nr_seq_agrupamento		:= dados_contab_p.nr_seq_agrupamento;
	ctb_movimento_doc_w.cd_centro_custo		:= dados_contab_p.cd_centro_custo;
	ctb_movimento_doc_w.vl_movimento		:= dados_contab_p.vl_movimento;
	ctb_movimento_doc_w.dt_movimento		:= dados_contab_p.dt_movimento;
	ctb_movimento_doc_w.cd_estabelecimento		:= dados_contab_p.cd_estabelecimento;
	ctb_movimento_doc_w.cd_tipo_lote_contabil	:= dados_contab_p.cd_tipo_lote_contabil;
	ctb_movimento_doc_w.cd_historico		:= dados_contab_p.cd_historico;
	ctb_movimento_doc_w.cd_conta_credito		:= dados_contab_p.cd_conta_cred;
	ctb_movimento_doc_w.cd_conta_debito		:= dados_contab_p.cd_conta_deb;
	ctb_movimento_doc_w.ds_compl_historico		:= dados_contab_p.ds_compl_historico;
	ctb_movimento_doc_w.nr_seq_trans_fin		:= dados_contab_p.nr_seq_trans_fin;
	ctb_movimento_doc_w.cd_cnpj			:= dados_contab_p.cd_cnpj;
	ctb_movimento_doc_w.cd_pessoa_fisica		:= dados_contab_p.cd_pessoa_fisica;
	ctb_movimento_doc_w.nm_tabela			:= dados_contab_p.nm_tabela;
	ctb_movimento_doc_w.nm_atributo			:= dados_contab_p.nm_atributo;
	ctb_movimento_doc_w.nr_seq_tab_orig		:= dados_contab_p.nr_documento;
	ctb_movimento_doc_w.nr_seq_doc_compl		:= dados_contab_p.nr_seq_doc_compl;
	ctb_movimento_doc_w.nr_doc_analitico		:= dados_contab_p.nr_doc_analitico;
	ctb_movimento_doc_w.ie_transitorio		:= dados_contab_p.ie_transitorio;
	ctb_movimento_doc_w.ie_origem_documento		:= dados_contab_p.ie_origem_documento;
	ctb_movimento_doc_w.nr_seq_info			:= dados_contab_p.nr_seq_info_ctb;

	/* Obtem o lote contabil e armazena o numero dele*/

	nr_lote_contabil_w := ctb_online_pck.get_lote_contabil(	dados_contab_p.cd_tipo_lote_contabil,
								dados_contab_p.cd_estabelecimento,
								dados_contab_p.dt_movimento,
								nm_usuario_p);
	ctb_movimento_doc_w.nr_lote_contabil := nr_lote_contabil_w;
	
	/* Desatualiza o lote antes de gravar novos movimentos */

	begin
	select  dt_atualizacao_saldo
	into STRICT    dt_atualizacao_saldo_w
	from    lote_contabil
	where   nr_lote_contabil = nr_lote_contabil_w;
	exception
	when others then
		dt_atualizacao_saldo_w := null;
	end;

	if (dt_atualizacao_saldo_w IS NOT NULL AND dt_atualizacao_saldo_w::text <> '') then
		ctb_desatualizar_lote(nr_lote_contabil_w, nm_usuario_p,ds_erro_w);
	end if;

	/* Grava o movimento */

	ctb_movimento_doc_w := ctb_online_pck.ctb_gravar_movto(ctb_movimento_doc_w, nm_usuario_p, 'S', 'S', 'S');

	/* Passa o numero do lote contabil para o dados_contab */

	dados_contab_p.nr_lote_contabil         := ctb_movimento_doc_w.nr_lote_contabil;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_contab_onl_lote_fin_pck.contabiliza_movimento ( dados_contab_p INOUT dados_contab, nm_usuario_p text) FROM PUBLIC;