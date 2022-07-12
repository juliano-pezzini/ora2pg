-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_canc_pgto_prest_pck.cancelar_ie_tipo_item_4 ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nr_seq_pp_prest_p pls_pp_prestador.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_seq_baixa_w	titulo_receber_liq.nr_sequencia%type;

c01 CURSOR(	nr_seq_lote_pc		pls_pp_lote.nr_sequencia%type,
		nr_seq_pp_prest_pc	pls_pp_prestador.nr_sequencia%type) FOR
	SELECT	d.cd_estabelecimento,
		pls_util_pck.obter_valor_negativo(c.vl_item) vl_item,
		c.nr_titulo_receber
	from	pls_pp_prest_event_prest a,
		pls_pp_it_prest_event_val b,
		pls_pp_item_lote c,
		titulo_receber d
	where	a.nr_seq_pp_prest = nr_seq_pp_prest_pc
	and	b.nr_seq_prest_even_val = a.nr_seq_pp_prest_even_val
	and	c.nr_seq_lote = nr_seq_lote_pc
	and	c.nr_sequencia = b.nr_seq_item_lote
	and	c.ie_tipo_item = '4'
	and	d.nr_titulo = c.nr_titulo_receber;

BEGIN
-- retorna os titulos a receber vinculados aos itens cancelados

for r_c01_w in c01(nr_seq_lote_p, nr_seq_pp_prest_p) loop

	-- faz o lancamento da baixa com valor negativo (estorno)

	CALL baixa_titulo_receber(	r_c01_w.cd_estabelecimento, pls_pp_lote_pagamento_pck.cd_tipo_receb_pgto_w,
				r_c01_w.nr_titulo_receber, pls_pp_lote_pagamento_pck.nr_seq_trans_fin_rec_pgto_w, 
				r_c01_w.vl_item, clock_timestamp(),
				nm_usuario_p, 0, 
				null, null, 
				0, 0);

	-- busca a sequencia da baixa que foi inserida

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_baixa_w
	from	titulo_receber_liq
	where	nr_titulo = r_c01_w.nr_titulo_receber;

	-- coloca uma observacao no titulo para identificar o motivo do estorno da baixa

	update	titulo_receber_liq
	set	ds_observacao = 'Baixa gerada atraves do cancelamento de pagamento do lote ' || nr_seq_lote_p || ' de pagamento.' || pls_util_pck.enter_w ||
				' Funcao OPS - Pagamentos de Producao Medica (nova).'
	where	nr_sequencia = nr_seq_baixa_w
	and	nr_titulo = r_c01_w.nr_titulo_receber;

	-- atualiza o saldo do titulo

	CALL atualizar_saldo_tit_rec(r_c01_w.nr_titulo_receber, nm_usuario_p);

	commit;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_canc_pgto_prest_pck.cancelar_ie_tipo_item_4 ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nr_seq_pp_prest_p pls_pp_prestador.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
