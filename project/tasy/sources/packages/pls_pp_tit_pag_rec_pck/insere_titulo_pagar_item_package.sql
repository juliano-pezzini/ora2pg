-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_tit_pag_rec_pck.insere_titulo_pagar_item ( nr_contador_p INOUT integer, tb_nr_titulo_pagar_p INOUT pls_util_cta_pck.t_number_table, tb_vl_saldo_titulo_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_evento_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_regra_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_prestador_p INOUT pls_util_cta_pck.t_number_table, tb_cd_centro_custo_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_lote_p INOUT pls_util_cta_pck.t_number_table, tb_nm_usuario_p INOUT pls_util_cta_pck.t_varchar2_table_15, tb_cd_estabelecimento_p INOUT pls_util_cta_pck.t_number_table) AS $body$
DECLARE


tb_nr_seq_baixa_w	pls_util_cta_pck.t_number_table;
BEGIN

if (tb_nr_titulo_pagar_p.count > 0) then
	-- insere os registros no pagamento de produção
	forall i in tb_nr_titulo_pagar_p.first..tb_nr_titulo_pagar_p.last
		insert into pls_pp_item_lote(	
			nr_sequencia, dt_atualizacao, dt_atualizacao_nrec, 
			ie_tipo_item, nm_usuario, nm_usuario_nrec, 
			nr_titulo_pagar, vl_item, vl_glosa, 
			vl_liquido, nr_seq_evento, nr_seq_regra_tit_pag, 
			nr_seq_prestador, cd_centro_custo, nr_seq_lote,
			ie_acao_negativo, vl_acao_negativo, vl_desconto_tributo,
			ie_cancelado, nr_seq_prestador_origem
		) values (
			nextval('pls_pp_item_lote_seq'), clock_timestamp(), clock_timestamp(),
			'5', tb_nm_usuario_p(i), tb_nm_usuario_p(i), 
			tb_nr_titulo_pagar_p(i), tb_vl_saldo_titulo_p(i), 0, 
			tb_vl_saldo_titulo_p(i), tb_nr_seq_evento_p(i), tb_nr_seq_regra_p(i), 
			tb_nr_seq_prestador_p(i), tb_cd_centro_custo_p(i), tb_nr_seq_lote_p(i),
			'N', 0, 0,
			'N', tb_nr_seq_prestador_p(i)
		);
	commit;

	-- faz a baixa dos títulos que entraram no pagamento e atualiza a observação
	for i in tb_nr_titulo_pagar_p.first..tb_nr_titulo_pagar_p.last loop

		CALL baixa_titulo_pagar(	tb_cd_estabelecimento_p(i), pls_pp_lote_pagamento_pck.cd_tipo_baixa_pgto_w,
					tb_nr_titulo_pagar_p(i), tb_vl_saldo_titulo_p(i), 
					tb_nm_usuario_p(i), pls_pp_lote_pagamento_pck.nr_seq_trans_fin_pag_pgto_w,
					null, null, 
					clock_timestamp(), null, 
					null);
		commit;

		-- busca a sequencia da baixa que foi inserida
		select	coalesce(max(nr_sequencia),0)
		into STRICT	tb_nr_seq_baixa_w(i)
		from	titulo_pagar_baixa
		where	nr_titulo = tb_nr_titulo_pagar_p(i);
	end loop;

	-- coloca uma observação no título para identificar o motivo do estorno da baixa
	forall i in tb_nr_titulo_pagar_p.first..tb_nr_titulo_pagar_p.last
		update	titulo_pagar_baixa
		set	ds_observacao = 'Baixa gerada através da regra (' || tb_nr_seq_regra_p(i) || ') de evento para títulos a pagar no lote ' || tb_nr_seq_lote_p(i) || '.' || pls_util_pck.enter_w ||
					' Função OPS - Pagamentos de Produção Médica (nova).'
		where	nr_sequencia = tb_nr_seq_baixa_w(i)
		and	nr_titulo = tb_nr_titulo_pagar_p(i);
	commit;

	-- por último atualiza a baixa do título (rotina padrão após realizar a baixa de um título)
	for i in tb_nr_titulo_pagar_p.first..tb_nr_titulo_pagar_p.last loop

		CALL atualizar_saldo_tit_pagar(tb_nr_titulo_pagar_p(i), tb_nm_usuario_p(i));
		
		commit;
	end loop;
end if;

nr_contador_p := 0;
tb_nr_titulo_pagar_p.delete;
tb_vl_saldo_titulo_p.delete;
tb_nr_seq_evento_p.delete;
tb_nr_seq_regra_p.delete;
tb_nr_seq_prestador_p.delete;
tb_cd_centro_custo_p.delete;
tb_nr_seq_lote_p.delete;
tb_nm_usuario_p.delete;
tb_cd_estabelecimento_p.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_tit_pag_rec_pck.insere_titulo_pagar_item ( nr_contador_p INOUT integer, tb_nr_titulo_pagar_p INOUT pls_util_cta_pck.t_number_table, tb_vl_saldo_titulo_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_evento_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_regra_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_prestador_p INOUT pls_util_cta_pck.t_number_table, tb_cd_centro_custo_p INOUT pls_util_cta_pck.t_number_table, tb_nr_seq_lote_p INOUT pls_util_cta_pck.t_number_table, tb_nm_usuario_p INOUT pls_util_cta_pck.t_varchar2_table_15, tb_cd_estabelecimento_p INOUT pls_util_cta_pck.t_number_table) FROM PUBLIC;
