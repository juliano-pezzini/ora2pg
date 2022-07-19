-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_tit_terceiros_evento ( nr_seq_lote_p bigint, nr_seq_pag_prest_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

						 
ie_natureza_w			varchar(5);
vl_movimento_w			double precision;
nr_sequencia_w			bigint;
nr_novo_titulo_w		bigint;
nr_seq_prestador_w		bigint;
cd_tipo_taxa_juro_cp_w		bigint;
cd_tipo_taxa_multa_cp_w		bigint;
cd_tipo_taxa_juro_cr_w		bigint;
cd_tipo_taxa_multa_cr_w		bigint;
cd_tipo_portador_w		bigint;
cd_portador_w			bigint;
nr_seq_trans_tit_pagar_w	bigint;
nr_seq_classe_titulo_w		bigint;
nr_seq_classe_tit_pagar_w	bigint;
nr_seq_regra_fixo_w		bigint;
nr_seq_trans_fin_baixa_w	bigint;
nr_seq_trans_fin_contab_w	bigint;
tx_juros_w			double precision;
tx_multa_w			double precision;
tx_juros_cp_w			double precision;
tx_multa_cp_w			double precision;
tx_juros_cr_w			double precision;
tx_multa_cr_w			double precision;
cd_moeda_cp_w			integer;
cd_moeda_cr_w			integer;
dt_movimento_w			timestamp;
nr_seq_conta_banco_w		bigint;
ie_bloqueto_w			varchar(1);
qt_dia_venc_w			bigint;
dt_competencia_w		timestamp;
tx_juros_pj_cr_w		double precision;
tx_multa_pj_cr_w		double precision;
nr_seq_classe_tit_eve_w		bigint;
ds_observacao_w			varchar(4000);
cd_pf_titulo_pagar_w		pls_evento_movimento.cd_pf_titulo_pagar%type;
cd_cgc_titulo_pagar_w		pls_evento_movimento.cd_cgc_titulo_pagar%type;
ie_titulo_pagar_w		varchar(1);
ie_tipo_evento_w		pls_evento.ie_tipo_evento%type;
dt_vencimento_w			timestamp;
nr_seq_lote_pgto_w		pls_evento_movimento.nr_seq_lote_pgto%type;

-- Só gerar título onde o movimentação for de título 
C01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.nr_seq_prestador, 
		coalesce(a.dt_venc_titulo,a.dt_movimento), 
		a.vl_movimento, 
		b.ie_natureza,	-- D = Desconto,	P = Provento 
		a.nr_seq_regra_fixo, 
		nr_seq_classe_tit_rec, 
		a.ds_observacao, 
		a.cd_pf_titulo_pagar, 
		a.cd_cgc_titulo_pagar, 
		a.nr_seq_trans_fin_baixa, 
		a.nr_seq_trans_fin_contab, 
		b.ie_tipo_evento, 
		a.nr_seq_lote_pgto 
	from	pls_evento_movimento	a, 
		pls_evento		b 
	where	a.nr_seq_evento		= b.nr_sequencia 
	and	a.nr_seq_lote		= nr_seq_lote_p 
	and	coalesce(a.ie_cancelamento::text, '') = '' 
	and (exists (SELECT	1 
			from	pls_pagamento_item 	y, 
				pls_pagamento_prestador	x 
			where	x.nr_sequencia = y.nr_seq_pagamento 
			and	y.nr_sequencia = a.nr_seq_pagamento_item 
			and	x.nr_sequencia = nr_seq_pag_prest_p) or 
		coalesce(nr_seq_pag_prest_p::text, '') = '') -- Se informar o parâmetro gera os títulos apenas para os itens do pagamento prestador. 
	and	((a.cd_pf_titulo_pagar IS NOT NULL AND a.cd_pf_titulo_pagar::text <> '') or (a.cd_cgc_titulo_pagar IS NOT NULL AND a.cd_cgc_titulo_pagar::text <> ''));


BEGIN 
begin 
select	a.cd_moeda_padrao, 
	a.cd_tipo_taxa_juro, 
	a.cd_tipo_taxa_multa, 
	a.pr_juro_padrao, 
	a.pr_multa_padrao, 
	a.pr_juro_pj, 
	a.pr_multa_pj, 
	a.cd_tipo_portador, 
	a.cd_portador 
into STRICT	cd_moeda_cr_w, 
	cd_tipo_taxa_juro_cr_w, 
	cd_tipo_taxa_multa_cr_w, 
	tx_juros_cr_w, 
	tx_multa_cr_w, 
	tx_juros_pj_cr_w, 
	tx_multa_pj_cr_w, 
	cd_tipo_portador_w, 
	cd_portador_w 
from	parametro_contas_receber a 
where	a.cd_estabelecimento	= cd_estabelecimento_p;
exception 
	when no_data_found then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(184268);
end;
	 
begin 
select	a.cd_moeda_padrao, 
	a.cd_tipo_taxa_juro, 
	a.cd_tipo_taxa_multa, 
	a.pr_juro_padrao, 
	a.pr_multa_padrao 
into STRICT	cd_moeda_cp_w, 
	cd_tipo_taxa_juro_cp_w, 
	cd_tipo_taxa_multa_cp_w, 
	tx_juros_cp_w, 
	tx_multa_cp_w 
from	parametros_contas_pagar a 
where	a.cd_estabelecimento	= cd_estabelecimento_p;
exception 
	when no_data_found then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(184269);
end;
 
open C01;
loop 
fetch C01 into	 
	nr_sequencia_w, 
	nr_seq_prestador_w, 
	dt_movimento_w, 
	vl_movimento_w, 
	ie_natureza_w, 
	nr_seq_regra_fixo_w, 
	nr_seq_classe_tit_eve_w, 
	ds_observacao_w, 
	cd_pf_titulo_pagar_w, 
	cd_cgc_titulo_pagar_w, 
	nr_seq_trans_fin_baixa_w, 
	nr_seq_trans_fin_contab_w, 
	ie_tipo_evento_w, 
	nr_seq_lote_pgto_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	-- Buscar a data de vencimento lá do pagamentos de produção médica, 
	select	max(b.dt_vencimento) 
	into STRICT	dt_vencimento_w 
	from	pls_pag_prest_vencimento	b, 
		pls_pagamento_prestador  	a 
	where	a.nr_sequencia			= b.nr_seq_pag_prestador 
	and	a.nr_seq_prestador		= nr_seq_prestador_w 
	and	a.nr_seq_lote			= nr_seq_lote_pgto_w;
	 
	if (dt_vencimento_w IS NOT NULL AND dt_vencimento_w::text <> '') then 
		dt_movimento_w	:= dt_vencimento_w;
	end if;
	 
	select	max(a.nr_seq_classe_titulo), 
		max(a.nr_seq_classe_tit_pagar), 
		coalesce(nr_seq_trans_fin_baixa_w, max(a.nr_seq_trans_fin_baixa)), 
		coalesce(nr_seq_trans_fin_contab_w, max(a.nr_seq_trans_fin_contab)), 
		max(a.qt_dia_venc) 
	into STRICT	nr_seq_classe_titulo_w, 
		nr_seq_classe_tit_pagar_w, 
		nr_seq_trans_fin_baixa_w, 
		nr_seq_trans_fin_contab_w, 
		qt_dia_venc_w 
	from	pls_evento_regra_fixo a 
	where	a.nr_sequencia	= nr_seq_regra_fixo_w;	
	 
	if (qt_dia_venc_w IS NOT NULL AND qt_dia_venc_w::text <> '') and (qt_dia_venc_w > 0) and (qt_dia_venc_w < 32) then 
		 
		select	trunc(dt_competencia, 'month') 
		into STRICT	dt_competencia_w 
		from	pls_lote_evento 
		where	nr_sequencia	= nr_seq_lote_p;
		 
		if (to_char(last_day(dt_competencia_w),'dd') < qt_dia_venc_w) then 
			dt_movimento_w		:= to_date(to_char(last_day(dt_competencia_w),'dd') || '/' || to_char(dt_competencia_w,'mm/yyyy'));
		else 
			dt_movimento_w		:= to_date(qt_dia_venc_w || '/' || to_char(dt_competencia_w,'mm/yyyy'));
		end if;
		 
		if (trunc(dt_movimento_w,'dd') < trunc(clock_timestamp(),'dd')) then 
			if (to_char(last_day(add_months(dt_competencia_w,1)), 'dd') < qt_dia_venc_w) then 
				dt_movimento_w	:= add_months(to_date(to_char(last_day(add_months(dt_competencia_w,1)), 'dd') || '/' || to_char(dt_competencia_w,'mm/yyyy')),1);
			else 
				dt_movimento_w	:= add_months(to_date(qt_dia_venc_w || '/' || to_char(dt_competencia_w,'mm/yyyy')),1);
			end if;
		end if;
	end if;
	 
	-- OS 874176 - jtonon - Se a Natureza do evento for de 'Desconto' e o Tipo do evento for 'Financeiro' 
	if (ie_natureza_w = 'D') and (ie_tipo_evento_w = 'F') then 
		vl_movimento_w	:= abs(vl_movimento_w);
	end if;
	 
	if (coalesce(vl_movimento_w,0) > 0) then 
		select	nextval('titulo_pagar_seq') 
		into STRICT	nr_novo_titulo_w 
		;
			 
		insert into titulo_pagar(nr_titulo, 
			nm_usuario, 
			dt_atualizacao, 
			cd_estabelecimento, 
			vl_titulo, 
			vl_saldo_titulo, 
			dt_emissao, 
			dt_contabil, 
			dt_vencimento_original, 
			dt_vencimento_atual, 
			vl_saldo_juros, 
			vl_saldo_multa, 
			cd_moeda, 
			cd_tipo_taxa_juro, 
			cd_tipo_taxa_multa, 
			tx_juros, 
			tx_multa, 
			ie_origem_titulo, 
			ie_tipo_titulo, 
			ie_situacao, 
			cd_pessoa_fisica, 
			cd_cgc, 
			ie_pls, 
			nr_lote_contabil, 
			ds_observacao_titulo, 
			nr_seq_classe, 
			nr_seq_trans_fin_baixa, 
			nr_seq_trans_fin_contab, 
			nr_seq_pls_pag_prest) 
		values (nr_novo_titulo_w, 
			nm_usuario_p, 
			clock_timestamp(), 
			cd_estabelecimento_p, 
			abs(vl_movimento_w), 
			abs(vl_movimento_w), 
			trunc(clock_timestamp(),'dd'), 
			trunc(dt_movimento_w,'dd'), 
			trunc(dt_movimento_w,'dd'), 
			trunc(dt_movimento_w,'dd'), 
			0, 
			0, 
			cd_moeda_cp_w, 
			cd_tipo_taxa_juro_cp_w, 
			cd_tipo_taxa_multa_cp_w, 
			tx_juros_cp_w, 
			tx_multa_cp_w, 
			'18', -- OPS - Ocorrência financeira 
			'23', -- Fatura 
			'A', 
			cd_pf_titulo_pagar_w, 
			cd_cgc_titulo_pagar_w, 
			'S', 
			0, 
			coalesce(ds_observacao_w, 'Título gerado pela função OPS - Controle de Eventos e Ocorrências Financeiras'), 
			nr_seq_classe_tit_pagar_w, 
			nr_seq_trans_fin_baixa_w, 
			nr_seq_trans_fin_contab_w, 
			nr_seq_pag_prest_p);
			 
		CALL atualizar_inclusao_tit_pagar(nr_novo_titulo_w, nm_usuario_p);
			 
		update	pls_evento_movimento 
		set	nr_titulo_pagar	= nr_novo_titulo_w 
		where	nr_sequencia	= nr_sequencia_w;	
	end if;
	end;
end loop;
close C01;
 
if (nr_novo_titulo_w IS NOT NULL AND nr_novo_titulo_w::text <> '') then 
	update	pls_lote_evento 
	set	dt_titulos_terceiros	= clock_timestamp() 
	where	nr_sequencia		= nr_seq_lote_p;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_tit_terceiros_evento ( nr_seq_lote_p bigint, nr_seq_pag_prest_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

