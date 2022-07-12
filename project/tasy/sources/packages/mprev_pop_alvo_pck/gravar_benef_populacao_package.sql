-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>GRAVAR BENEFICIARIOS NA POPULACAO ALVO<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--



CREATE OR REPLACE PROCEDURE mprev_pop_alvo_pck.gravar_benef_populacao ( nr_seq_populacao_alvo_p bigint, nm_usuario_p text, ds_select_comp_p text) AS $body$
DECLARE


	cursor_w		sql_pck.t_cursor;
	tb_benef_pop_alvo_w	mprev_pop_alvo_pck.table_benef_pop_alvo;

	
BEGIN

	current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind := sql_pck.executa_sql_cursor(ds_select_comp_p, current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind);

	loop
		CALL CALL mprev_pop_alvo_pck.limpar_tipo_tabelas('tb_benef_pop_alvo_w');

		fetch	cursor_w bulk collect
		into	tb_benef_pop_alvo_w.nr_seq_segurado, tb_benef_pop_alvo_w.cd_usuario_plano, tb_benef_pop_alvo_w.ie_preco_plano,
		        tb_benef_pop_alvo_w.ds_preco_plano, tb_benef_pop_alvo_w.dt_inclusao_plano, tb_benef_pop_alvo_w.ie_situacao_contrato,
		        tb_benef_pop_alvo_w.ie_situacao_atend, tb_benef_pop_alvo_w.nr_seq_pessoa
		limit	current_setting('mprev_pop_alvo_pck.qt_reg_commit_w')::integer;

		exit when tb_benef_pop_alvo_w.nr_seq_segurado.count = 0;

		forall i in tb_benef_pop_alvo_w.nr_seq_segurado.first .. tb_benef_pop_alvo_w.nr_seq_segurado.last
			insert into mprev_pop_alvo_benef(nr_sequencia, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_pop_alvo_pessoa,
			nr_seq_segurado, cd_usuario_plano, ie_preco_plano,
			ds_preco_plano,	dt_inclusao_plano, ie_situacao_contrato,
			ie_situacao_atend, nr_seq_populacao_alvo)
		values (nextval('mprev_pop_alvo_benef_seq'), clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, tb_benef_pop_alvo_w.nr_seq_pessoa(i),
			tb_benef_pop_alvo_w.nr_seq_segurado(i), tb_benef_pop_alvo_w.cd_usuario_plano(i), tb_benef_pop_alvo_w.ie_preco_plano(i),
			tb_benef_pop_alvo_w.ds_preco_plano(i), tb_benef_pop_alvo_w.dt_inclusao_plano(i), tb_benef_pop_alvo_w.ie_situacao_contrato(i),
			tb_benef_pop_alvo_w.ie_situacao_atend(i),nr_seq_populacao_alvo_p);
		commit;
	end loop;
	close cursor_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_pop_alvo_pck.gravar_benef_populacao ( nr_seq_populacao_alvo_p bigint, nm_usuario_p text, ds_select_comp_p text) FROM PUBLIC;
