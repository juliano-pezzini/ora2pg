-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mov_mens_pck.gerar_titulos ( nr_seq_lote_p pls_mov_mens_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

nr_titulo_pagar_w	titulo_pagar.nr_titulo%type;
dt_contabil_w		pls_mensalidade.dt_referencia%type;
C01 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_vencimento,
		a.dt_vencimento,
		a.vl_vencimento,
		c.cd_cgc
	from	pls_mov_mens_operador_venc	a,
		pls_mov_mens_operadora		b,
		pls_congenere			c
	where	b.nr_sequencia	= a.nr_seq_mov_operadora
	and	c.nr_sequencia	= b.nr_seq_congenere
	and	b.nr_seq_lote	= nr_seq_lote_p;

BEGIN
CALL pls_mov_mens_pck.carregar_dados_lote_regra(nr_seq_lote_p);

if (current_setting('pls_mov_mens_pck.pls_mov_mens_regra_w')::pls_mov_mens_regra%coalesce(rowtype.cd_moeda::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1076946); --Moeda não informada na regra utilizada para geração do lote!
end if;

if (current_setting('pls_mov_mens_pck.pls_mov_mens_regra_w')::pls_mov_mens_regra%coalesce(rowtype.nr_seq_trans_fin_baixa::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1076947); --Transação financeira de baixa não informada na regra utilizada para geração do lote!
end if;

if (current_setting('pls_mov_mens_pck.pls_mov_mens_regra_w')::pls_mov_mens_regra%coalesce(rowtype.nr_seq_trans_fin_contab::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1076948); --Transação financeira contábil não informada na regra utilizada para geração do lote!
end if;

for r_c01_w in C01 loop
	begin
	
	select	max(e.dt_referencia)
	into STRICT	dt_contabil_w
	from	pls_mensalidade_seg_item	a,
		pls_mov_mens_benef_item		b,
		pls_mov_mens_benef		c,
		pls_mov_mens_operadora		o,
		pls_mov_mens_operador_venc	l,
		pls_mensalidade_segurado	s,
		pls_mensalidade			e
	where	b.nr_seq_item_mens		= a.nr_sequencia
	and	b.nr_seq_mov_benef		= c.nr_sequencia
	and	c.nr_seq_mov_operadora		= o.nr_sequencia
	and	o.nr_sequencia			= l.nr_seq_mov_operadora
	and	a.nr_seq_mensalidade_seg	= s.nr_sequencia
	and	s.nr_seq_mensalidade		= e.nr_sequencia
	and	o.nr_seq_lote			= nr_seq_lote_p;
	
	insert	into	titulo_pagar(	nr_titulo, cd_estabelecimento, dt_atualizacao,
		nm_usuario, dt_emissao, dt_vencimento_original,
		dt_vencimento_atual, dt_contabil, vl_titulo, vl_saldo_titulo,
		vl_saldo_juros, vl_saldo_multa, cd_moeda,
		tx_juros, tx_multa, cd_tipo_taxa_juro,
		cd_tipo_taxa_multa, ie_situacao, ie_origem_titulo,
		ie_tipo_titulo, cd_cgc, nr_seq_trans_fin_baixa,
		nr_seq_trans_fin_contab)
	values (	nextval('titulo_pagar_seq'), cd_estabelecimento_p, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), r_c01_w.dt_vencimento,
		r_c01_w.dt_vencimento, dt_contabil_w, r_c01_w.vl_vencimento, r_c01_w.vl_vencimento,
		0, 0, current_setting('pls_mov_mens_pck.pls_mov_mens_regra_w')::pls_mov_mens_regra%rowtype.cd_moeda,
		0, 0, 1,
		1, 'A', '26',
		10, r_c01_w.cd_cgc, current_setting('pls_mov_mens_pck.pls_mov_mens_regra_w')::pls_mov_mens_regra%rowtype.nr_seq_trans_fin_baixa,
		current_setting('pls_mov_mens_pck.pls_mov_mens_regra_w')::pls_mov_mens_regra%rowtype.nr_seq_trans_fin_contab)
	returning nr_titulo into nr_titulo_pagar_w;
	
	CALL atualizar_inclusao_tit_pagar(nr_titulo_pagar_w,nm_usuario_p);
	
	update	pls_mov_mens_operador_venc
	set	nr_titulo_pagar	= nr_titulo_pagar_w,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= r_c01_w.nr_seq_vencimento;
	
	CALL CALL pls_mov_mens_pck.gerar_titulo_pagar_classif(nr_titulo_pagar_w, nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p);
	
	CALL gerar_tributo_titulo(nr_titulo_pagar_w, nm_usuario_p, 'N', null, null, null, null, null, cd_estabelecimento_p, null);
	
	end;
end loop;

update	pls_mov_mens_lote
set	dt_geracao_titulo	= clock_timestamp(),
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= nr_seq_lote_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mov_mens_pck.gerar_titulos ( nr_seq_lote_p pls_mov_mens_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
