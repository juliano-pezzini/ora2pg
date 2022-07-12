-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_contab_onl_lote_fin_pck.contab_notas_contest ( doc_p INOUT ctb_documento, nm_usuario_p text) AS $body$
DECLARE


	dados_contab_tf_w		ctb_contab_onl_lote_fin_pck.dados_contab_tf;
	nr_tit_rec_gerado_w		titulo_receber.nr_titulo%type;
	nr_tit_pagar_gerado_w		titulo_pagar.nr_titulo%type;
	nr_titulo_w			titulo_pagar.nr_titulo%type;
	cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
	cd_cgc_w			titulo_pagar.cd_cgc%type;
	nm_agrupador_w			agrupador_contabil.nm_atributo%type;
	nr_seq_agrupamento_w		titulo_pagar.nr_titulo%type;
	nr_documento_w			titulo_pagar.nr_titulo%type;
	ie_origem_documento_w		movimento_contabil.ie_origem_documento%type;
	nr_seq_conta_banco_w		titulo_receber_liq.nr_seq_conta_banco%type;
	ie_origem_tit_rec_w		titulo_receber.ie_origem_titulo%type;
	cd_tipo_baixa_w			titulo_pagar_baixa.cd_tipo_baixa%type;
	cd_tipo_recebimento_w		titulo_receber_liq.cd_tipo_recebimento%type;
	nr_seq_pls_lote_contest_w	titulo_receber.nr_seq_pls_lote_contest%type;
	nr_seq_pls_lote_disc_w		titulo_receber.nr_seq_pls_lote_disc%type;
	nr_bordero_w			titulo_receber_liq.nr_bordero%type;
	nr_seq_cobranca_w		titulo_receber_liq.nr_seq_cobranca%type;
	ds_pessoa_w			varchar(80);
	ie_receber_pagar_w		varchar(1);

	
BEGIN

	begin
	select	nr_titulo,
		ie_receber_pagar,
		nr_seq_conta_banco,
		cd_tipo_recebimento,
		ie_origem_titulo,
		cd_tipo_baixa,
		nr_seq_pls_lote_contest,
		nr_seq_pls_lote_disc,
		nr_bordero,
		nr_seq_cobranca
	into STRICT	nr_titulo_w,
		ie_receber_pagar_w,
		nr_seq_conta_banco_w,
		cd_tipo_recebimento_w,
		ie_origem_tit_rec_w,
		cd_tipo_baixa_w,
		nr_seq_pls_lote_contest_w,
		nr_seq_pls_lote_disc_w,
		nr_bordero_w,
		nr_seq_cobranca_w
	from (SELECT	a.nr_titulo nr_titulo,
			'R' ie_receber_pagar,
			a.nr_seq_conta_banco nr_seq_conta_banco,
			a.cd_tipo_recebimento cd_tipo_recebimento,
			b.ie_origem_titulo ie_origem_titulo,
			null cd_tipo_baixa,
			b.nr_seq_pls_lote_contest nr_seq_pls_lote_contest,
			b.nr_seq_pls_lote_disc nr_seq_pls_lote_disc,
			a.nr_bordero nr_bordero,
			a.nr_seq_cobranca nr_seq_cobranca
		from	titulo_receber_liq	a,
			titulo_receber		b
		where	a.nr_titulo		= b.nr_titulo
		and	coalesce(a.ie_lib_caixa,'N')	= 'S'
		and	doc_p.nm_tabela		= 'TITULO_RECEBER_LIQ'
		and	doc_p.nm_atributo	= 'VL_RECEBIDO'
		and	doc_p.nr_documento	= b.nr_titulo
		and	doc_p.nr_seq_doc_compl	= a.nr_sequencia
		group by a.nr_titulo,
			a.nr_seq_conta_banco,
			a.cd_tipo_recebimento,
			b.ie_origem_titulo,
			b.nr_seq_pls_lote_contest,
			b.nr_seq_pls_lote_disc,
			a.nr_bordero,
			a.nr_seq_cobranca
		
union all

		SELECT	a.nr_titulo,
			'R' ie_receber_pagar,
			a.nr_seq_conta_banco,
			a.cd_tipo_recebimento,
			b.ie_origem_titulo,
			null cd_tipo_baixa,
			b.nr_seq_pls_lote_contest,
			b.nr_seq_pls_lote_disc,
			a.nr_bordero,
			a.nr_seq_cobranca
		from	titulo_rec_liq_cc	c,
			titulo_receber_liq	a,
			titulo_receber		b
		where	a.nr_sequencia		= c.nr_seq_baixa
		and	a.nr_titulo		= b.nr_titulo
		and	b.nr_titulo		= c.nr_titulo
		and	doc_p.nm_tabela		= 'TITULO_RECEBER_LIQ'
		and	doc_p.nm_atributo	= 'VL_REC_GLOSA'
		and	doc_p.nr_documento	= b.nr_titulo
		and	doc_p.nr_seq_doc_compl	= a.nr_sequencia
		and	coalesce(a.ie_lib_caixa,'N')	= 'S'
		group by a.nr_titulo,
			a.nr_seq_conta_banco,
			a.cd_tipo_recebimento,
			b.ie_origem_titulo,
			b.nr_seq_pls_lote_contest,
			b.nr_seq_pls_lote_disc,
			a.nr_bordero,
			a.nr_seq_cobranca
		
union all

		select	a.nr_titulo,
			'P' ie_receber_pagar,
			a.nr_seq_conta_banco,
			null cd_tipo_recebimento,
			null ie_origem_titulo,
			a.cd_tipo_baixa,
			b.nr_seq_pls_lote_contest,
			b.nr_seq_pls_lote_disc,
			a.nr_bordero,
			a.nr_seq_escrit
		from	titulo_pagar		b,
			titulo_pagar_baixa	a
		where	a.nr_titulo		= b.nr_titulo
		and	doc_p.nm_tabela		= 'TITULO_PAGAR_BAIXA'
		and	doc_p.nm_atributo	= 'VL_PAGO'
		and	doc_p.nr_documento	= b.nr_titulo
		and	doc_p.nr_seq_doc_compl	= a.nr_sequencia
		and	coalesce(b.ie_status,'D')	= 'D'
		
union all

		select	a.nr_titulo,
			'P' ie_receber_pagar,
			a.nr_seq_conta_banco,
			null cd_tipo_recebimento,
			null ie_origem_titulo,
			a.cd_tipo_baixa,
			b.nr_seq_pls_lote_contest,
			b.nr_seq_pls_lote_disc,
			a.nr_bordero,
			a.nr_seq_escrit
		from	titulo_pagar		b,
			titulo_pagar_baixa	a
		where	a.nr_titulo		= b.nr_titulo
		and	doc_p.nm_tabela		= 'TITULO_PAGAR_BAIXA'
		and	doc_p.nm_atributo	= 'VL_PAG_GLOSA'
		and	doc_p.nr_documento	= b.nr_titulo
		and	doc_p.nr_seq_doc_compl	= a.nr_sequencia
		and	coalesce(b.ie_status,'D')	= 'D'
		
union all

		select	a.nr_titulo,
			'R' ie_receber_pagar,
			null nr_seq_conta_banco,
			null cd_tipo_recebimento,
			a.ie_origem_titulo,
			null cd_tipo_baixa,
			a.nr_seq_pls_lote_contest,
			a.nr_seq_pls_lote_disc,
			null,
			null
		from	titulo_receber	a
		where	doc_p.nm_tabela		= 'TITULO_RECEBER'
		and	doc_p.nm_atributo	= 'VL_TITULO_RECEBER'
		and	doc_p.nr_documento	= a.nr_titulo
		
union all

		select	a.nr_titulo,
			'P' ie_receber_pagar,
			null nr_seq_conta_banco,
			null cd_tipo_recebimento,
			null ie_origem_titulo,
			null cd_tipo_baixa,
			a.nr_seq_pls_lote_contest,
			a.nr_seq_pls_lote_disc,
			a.nr_bordero,
			null
		from	titulo_pagar	a
		where	doc_p.nm_tabela		= 'TITULO_PAGAR'
		and	doc_p.nm_atributo	= 'VL_TITULO_PAGAR'
		and	doc_p.nr_documento	= a.nr_titulo
		and	coalesce(a.ie_status,'D')	= 'D'
		
union all

		select	a.nr_titulo,
			'R' ie_receber_pagar,
			a.nr_seq_conta_banco,
			a.cd_tipo_recebimento,
			b.ie_origem_titulo,
			null cd_tipo_baixa,
			b.nr_seq_pls_lote_contest,
			b.nr_seq_pls_lote_disc,
			a.nr_bordero,
			a.nr_seq_cobranca
		from	titulo_receber_liq	a,
			titulo_receber		b
		where	a.nr_titulo		= b.nr_titulo
		and	coalesce(a.ie_lib_caixa,'N')	= 'S'
		and	doc_p.nm_tabela		= 'TITULO_RECEBER_LIQ'
		and	doc_p.nm_atributo	= 'VL_REC_MAIOR'
		and	doc_p.nr_documento	= b.nr_titulo
		and	doc_p.nr_seq_doc_compl 	= a.nr_sequencia) alias6;
	exception when no_data_found then
	/* Salva a inconsistencia: "Nao foi possivel identificar o movimento de origem." */

	select 	obter_desc_expressao(950251)
	into STRICT	doc_p.ds_inconsistencia
	;
	return;
	end;
	/* Informacoes de acordo com a origem (titulo a pagar, ou a receber).
	   Tambem e utilizado no complemento historico, mas esta fora do if pois e utilizado para contabilizar a transacao financeira */
	if (ie_receber_pagar_w = 'R') then
		nr_tit_rec_gerado_w	:= nr_titulo_w;
	elsif (ie_receber_pagar_w = 'P') then
		nr_tit_pagar_gerado_w	:= nr_titulo_w;
	end if;

	/* Sequencia de agrupamento */

	nm_agrupador_w := coalesce(trim(both obter_agrupador_contabil(doc_p.cd_tipo_lote_contabil)),'NR_TITULO');

	if (nm_agrupador_w = 'NR_TITULO') then
		nr_seq_agrupamento_w := somente_numero(substr(nr_titulo_w, 1, 10));
	end if;

	if (coalesce(nr_seq_agrupamento_w, 0) = 0) then
		nr_seq_agrupamento_w := somente_numero(substr(nr_titulo_w, 1, 10));
	end if;

	/* Informacoes do documento para contabilizacao da transacao financeira*/

	nr_documento_w		:= nr_titulo_w;
	if (ie_receber_pagar_w = 'R') then
		ie_origem_documento_w	:= 3;
	elsif (ie_receber_pagar_w = 'P') then
		ie_origem_documento_w	:= 2;	
	end if;

	/* Define os atributos independente de montar ou nao o complemento, pois pode ocorrer erro se nao houver os campos no vetor dentro da ctb_online_pck*/

	CALL ctb_online_pck.definir_atrib_compl(doc_p.cd_tipo_lote_contabil);

	ds_pessoa_w		:= null;
	
	if (ie_receber_pagar_w = 'R') then
		select	substr(obter_nome_pf_pj(a.cd_pessoa_fisica,a.cd_cgc),1,80)
		into STRICT	ds_pessoa_w
		from	titulo_receber a
		where	a.nr_titulo	= nr_titulo_w;
	elsif (ie_receber_pagar_w = 'P') then
		select	substr(obter_nome_pf_pj(a.cd_pessoa_fisica,a.cd_cgc),1,80),
			a.cd_pessoa_fisica,
			a.cd_cgc
		into STRICT	ds_pessoa_w,
			cd_pessoa_fisica_w,
			cd_cgc_w
		from	titulo_pagar	a
		where	a.nr_titulo	= nr_titulo_w;
	end if;
	CALL ctb_online_pck.set_value_compl_hist('DS_PESSOA', ds_pessoa_w);
	CALL ctb_online_pck.set_value_compl_hist('NR_BORDERO', nr_bordero_w);
	CALL ctb_online_pck.set_value_compl_hist('NR_SEQ_COB_ESCRITURAL', nr_seq_cobranca_w);
	CALL ctb_online_pck.set_value_compl_hist('NR_SEQ_PLS_LOTE_CONTEST', nr_seq_pls_lote_contest_w);
	CALL ctb_online_pck.set_value_compl_hist('NR_SEQ_PLS_LOTE_DISC', nr_seq_pls_lote_disc_w);
	CALL ctb_online_pck.set_value_compl_hist('NR_TITULO_PAGAR', nr_tit_pagar_gerado_w);
	CALL ctb_online_pck.set_value_compl_hist('NR_TITULO_RECEBER', nr_tit_rec_gerado_w);

	dados_contab_tf_w.cd_estab_movto		:= doc_p.cd_estabelecimento;
	dados_contab_tf_w.nr_lote_contabil		:= null;
	dados_contab_tf_w.dt_transacao			:= doc_p.dt_competencia;
	dados_contab_tf_w.cd_conta_contabil		:= null;
	dados_contab_tf_w.cd_centro_custo		:= null;
	dados_contab_tf_w.nr_seq_agrupamento		:= nr_seq_agrupamento_w;
	dados_contab_tf_w.ie_origem_documento		:= ie_origem_documento_w;
	dados_contab_tf_w.nr_seq_conta_banco		:= nr_seq_conta_banco_w;
	dados_contab_tf_w.cd_pessoa_fisica		:= cd_pessoa_fisica_w;
	dados_contab_tf_w.cd_cnpj			:= cd_cgc_w;
	dados_contab_tf_w.cd_setor			:= null;
	dados_contab_tf_w.cd_convenio			:= null;
	dados_contab_tf_w.nr_seq_caixa			:= null;
	dados_contab_tf_w.nr_seq_produto		:= null;
	dados_contab_tf_w.nr_seq_caixa_od		:= null;
	dados_contab_tf_w.cd_tributo			:= null;
	dados_contab_tf_w.nr_seq_bandeira		:= null;
	dados_contab_tf_w.cd_tributo_regra		:= null;
	dados_contab_tf_w.ie_origem_tit_rec		:= ie_origem_tit_rec_w;
	dados_contab_tf_w.nr_seq_banco_od		:= null;
	dados_contab_tf_w.ie_tipo_conta_glosa		:= null;
	dados_contab_tf_w.nr_seq_proj_rec		:= null;
	dados_contab_tf_w.nr_repasse_terceiro		:= null;
	dados_contab_tf_w.cd_estab_inf_movto		:= null;
	dados_contab_tf_w.cd_tipo_baixa			:= cd_tipo_baixa_w;
	dados_contab_tf_w.cd_tipo_recebimento		:= cd_tipo_recebimento_w;
	dados_contab_tf_w.nr_titulo_pagar		:= nr_tit_pagar_gerado_w;
	dados_contab_tf_w.nr_titulo_receber		:= nr_tit_rec_gerado_w;
	dados_contab_tf_w.nr_seq_nota_fiscal		:= null;
	dados_contab_tf_w.nr_seq_trans_fin		:= doc_p.nr_seq_trans_financ;
	dados_contab_tf_w.nm_tabela			:= doc_p.nm_tabela;
	dados_contab_tf_w.nm_atributo			:= doc_p.nm_atributo;
	dados_contab_tf_w.cd_moeda			:= null;
	dados_contab_tf_w.nr_seq_tab_orig		:= doc_p.nr_documento;
	dados_contab_tf_w.doc				:= doc_p;

	ctb_contab_onl_lote_fin_pck.contabiliza_trans_financ(dados_contab_tf_w, nm_usuario_p);

	doc_p 						:= dados_contab_tf_w.doc;

	if (coalesce(doc_p.nr_lote_contabil, 0) <> 0) then
		if (doc_p.nm_tabela = 'TITULO_RECEBER_LIQ') then
			update	titulo_receber_liq	a
			set	a.nr_lote_contabil	= doc_p.nr_lote_contabil
			where	a.nr_titulo 		= doc_p.nr_documento
			and	a.nr_sequencia 		= doc_p.nr_seq_doc_compl;
		elsif (doc_p.nm_tabela = 'TITULO_PAGAR_BAIXA') then
			update	titulo_pagar_baixa	a
			set	a.nr_lote_contabil	= doc_p.nr_lote_contabil
			where	a.nr_titulo		= doc_p.nr_documento
			and	a.nr_sequencia		= doc_p.nr_seq_doc_compl;
		elsif (doc_p.nm_tabela = 'TITULO_RECEBER') then
			update	titulo_receber	a
			set	a.nr_lote_contabil 	= doc_p.nr_lote_contabil
			where	nr_titulo 		= doc_p.nr_documento;
		elsif (doc_p.nm_tabela = 'TITULO_PAGAR') then
			update	titulo_pagar	a
			set	a.nr_lote_contabil 	= doc_p.nr_lote_contabil
			where	nr_titulo 		= doc_p.nr_documento;
		end if;
	end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_contab_onl_lote_fin_pck.contab_notas_contest ( doc_p INOUT ctb_documento, nm_usuario_p text) FROM PUBLIC;
