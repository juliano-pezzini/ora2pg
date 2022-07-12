-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_canc_pgto_prest_pck.estornar_prest_evento_valor ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nr_seq_pp_prest_p pls_pp_prestador.nr_sequencia%type, nr_seq_pp_prest_estor_p pls_pp_prestador.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_nr_pr_ev_val_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_prest_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_evento_w	pls_util_cta_pck.t_number_table;
tb_vl_acao_negativo_w	pls_util_cta_pck.t_number_table;
tb_vl_glosa_w		pls_util_cta_pck.t_number_table;
tb_vl_item_w		pls_util_cta_pck.t_number_table;
tb_vl_liquido_w		pls_util_cta_pck.t_number_table;
tb_vl_tributo_w		pls_util_cta_pck.t_number_table;
tb_nr_pr_ev_val_est_w	pls_util_cta_pck.t_number_table;

c01 CURSOR(	nr_seq_pp_prest_pc	pls_pp_prestador.nr_sequencia%type) FOR
	SELECT	b.nr_sequencia,
		b.nr_seq_prestador,
		b.nr_seq_evento,
		b.vl_acao_negativo * -1,
		b.vl_glosa * -1,
		b.vl_item * -1,
		b.vl_liquido * -1,
		b.vl_tributo * -1
	from	pls_pp_prest_event_prest a,
		pls_pp_prest_evento_valor b
	where	a.nr_seq_pp_prest = nr_seq_pp_prest_pc
	and	b.nr_sequencia = a.nr_seq_pp_prest_even_val;


BEGIN

-- retorna todos os registros da tabela pls_pp_prest_evento_valor para inserir o estorno, neste o valor

-- sempre sera o contrario do ja existente por isso o *-1. 

open c01(nr_seq_pp_prest_p);
loop
	fetch c01 bulk collect into	tb_nr_pr_ev_val_w, tb_nr_seq_prest_w, tb_nr_seq_evento_w,
					tb_vl_acao_negativo_w, tb_vl_glosa_w, tb_vl_item_w, 
					tb_vl_liquido_w, tb_vl_tributo_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_prest_w.count = 0;

	-- insere o estorno e retorna as sequencias dos inserts para fazer o vinculo do registro de estorno 

	-- na pls_pp_prestador em seguida

	forall i in tb_nr_seq_prest_w.first..tb_nr_seq_prest_w.last
		insert into pls_pp_prest_evento_valor(
			nr_sequencia, dt_atualizacao, dt_atualizacao_nrec,
			nm_usuario, nm_usuario_nrec, nr_seq_evento,
			nr_seq_lote, nr_seq_prestador, vl_acao_negativo,
			vl_glosa, vl_item, vl_liquido,
			vl_tributo, ie_cancelado
		) values (
			nextval('pls_pp_prest_evento_valor_seq'), clock_timestamp(), clock_timestamp(),
			nm_usuario_p, nm_usuario_p, tb_nr_seq_evento_w(i),
			nr_seq_lote_p, tb_nr_seq_prest_w(i), tb_vl_acao_negativo_w(i),
			tb_vl_glosa_w(i), tb_vl_item_w(i), tb_vl_liquido_w(i),
			tb_vl_tributo_w(i), 'S'
		) returning nr_sequencia bulk collect into tb_nr_pr_ev_val_est_w;
	commit;

	-- faz o vinculo dos registros da pls_pp_prest_evento_valor estorno com a pls_pp_prestador estorno

	forall i in tb_nr_pr_ev_val_est_w.first..tb_nr_pr_ev_val_est_w.last
		insert into pls_pp_prest_event_prest(
			nr_sequencia, nr_seq_pp_prest, nr_seq_pp_prest_even_val
		) values (
			nextval('pls_pp_prest_event_prest_seq'), nr_seq_pp_prest_estor_p, tb_nr_pr_ev_val_est_w(i)
		);
	commit;
end loop;
close c01;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_canc_pgto_prest_pck.estornar_prest_evento_valor ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nr_seq_pp_prest_p pls_pp_prestador.nr_sequencia%type, nr_seq_pp_prest_estor_p pls_pp_prestador.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
