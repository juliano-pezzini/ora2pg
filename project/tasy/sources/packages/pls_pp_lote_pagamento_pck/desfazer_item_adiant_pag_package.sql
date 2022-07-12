-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- exclui todos os eventos de adiantamento pago do lote



CREATE OR REPLACE PROCEDURE pls_pp_lote_pagamento_pck.desfazer_item_adiant_pag ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_sequencia_w		pls_util_cta_pck.t_number_table;
tb_nr_adiantamento_w	pls_util_cta_pck.t_number_table;
tb_vl_liquido_w		pls_util_cta_pck.t_number_table;
cd_moeda_w		adiantamento_pago.cd_moeda%type;
nr_seq_adiant_dev_w	adiant_pago_dev.nr_sequencia%type;

c01 CURSOR(	nr_seq_lote_pc	pls_pp_lote.nr_sequencia%type) FOR
	SELECT 	nr_sequencia,
		nr_adiantamento,
		vl_liquido
	from	pls_pp_item_lote
	where	nr_seq_lote = nr_seq_lote_pc
	and	ie_tipo_item = '3';
	
BEGIN
-- percorre o cursor e volta ao valor original de saldo do adiantamento pago e limpa a data de baixa

open c01( nr_seq_lote_p );
loop
	fetch c01 bulk collect into tb_sequencia_w, tb_nr_adiantamento_w, tb_vl_liquido_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_sequencia_w.count = 0;

	-- no item do lote como e desconto fica sempre negativo e no adiantamento deve sempre ser positivo

	forall i in tb_nr_adiantamento_w.first..tb_nr_adiantamento_w.last
		update	adiantamento_pago
		set	vl_saldo = abs(tb_vl_liquido_w(i)),
			dt_baixa  = NULL
		where	nr_adiantamento = tb_nr_adiantamento_w(i);
	commit;

	-- percorre todos os adiantamentos e insere o registro de 'devolucao' pois ja sera cobrado no pagamento

	for i in tb_nr_adiantamento_w.first..tb_nr_adiantamento_w.last loop

		select	max(cd_moeda)
		into STRICT	cd_moeda_w
		from	adiantamento_pago
		where	nr_adiantamento = tb_nr_adiantamento_w(i);

		select	coalesce(max(nr_sequencia), 0) + 1
		into STRICT	nr_seq_adiant_dev_w
		from	adiant_pago_dev;
		
		insert into adiant_pago_dev(
			nr_adiantamento, nr_sequencia, dt_devolucao,
			vl_devolucao, cd_moeda, dt_atualizacao,
			nm_usuario, ds_motivo_dev
		) values (
			tb_nr_adiantamento_w(i), nr_seq_adiant_dev_w, clock_timestamp(),
			pls_util_pck.obter_valor_negativo(tb_vl_liquido_w(i)), cd_moeda_w, clock_timestamp(),
			nm_usuario_p, wheb_mensagem_pck.get_texto(1107362, 'NR_SEQ_LOTE=' || nr_seq_lote_p)
		);

		-- atualiza o saldo e coloca a data da baixa no adiantamento

		CALL atualizar_saldo_adiant_pago(tb_nr_adiantamento_w(i), nm_usuario_p);

		commit;
	end loop;
	
	forall i in tb_sequencia_w.first..tb_sequencia_w.last
		delete 	from pls_pp_item_lote
		where	nr_sequencia = tb_sequencia_w(i);
	commit;
end loop;
close c01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_lote_pagamento_pck.desfazer_item_adiant_pag ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
