-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Gravar pessoas na tabela temporaria mprev_pessoa_cubo_ops_w<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--
CREATE OR REPLACE PROCEDURE mprev_pop_alvo_prest_pck.gravar_pessoas_cubo_ops_w (nr_seq_populacao_alvo_p bigint, nm_usuario_p text, nr_seq_controle_p bigint, ds_select_comp_p text) AS $body$
DECLARE


	cursor_w		sql_pck.t_cursor;
	tb_pessoas_cubo_ops_w	mprev_pop_alvo_prest_pck.table_pessoas_cubo_ops;

	
BEGIN
	
	current_setting('mprev_pop_alvo_prest_pck.bind_sql_w')::sql_pck.t_dado_bind := sql_pck.executa_sql_cursor(ds_select_comp_p, current_setting('mprev_pop_alvo_prest_pck.bind_sql_w')::sql_pck.t_dado_bind);
	
	loop
		CALL CALL mprev_pop_alvo_prest_pck.limpar_tipo_tabelas('tb_pessoas_cubo_ops_w');

		fetch	cursor_w bulk collect
		into	tb_pessoas_cubo_ops_w.cd_pessoa_fisica, tb_pessoas_cubo_ops_w.dt_nascimento,
			tb_pessoas_cubo_ops_w.nr_sequencia

		limit	current_setting('mprev_pop_alvo_prest_pck.qt_reg_commit_w')::integer;

		exit when tb_pessoas_cubo_ops_w.cd_pessoa_fisica.count = 0;

		forall i in tb_pessoas_cubo_ops_w.cd_pessoa_fisica.first .. tb_pessoas_cubo_ops_w.cd_pessoa_fisica.last
			
			insert into mprev_pessoa_cubo_ops_w(dt_atualizacao, nm_usuario, dt_nascimento,
				cd_pessoa_fisica, nr_seq_controle, nr_sequencia,
				nr_seq_pop_alvo)
			values (clock_timestamp(), nm_usuario_p, tb_pessoas_cubo_ops_w.dt_nascimento(i),
				tb_pessoas_cubo_ops_w.cd_pessoa_fisica(i), nr_seq_controle_p,
				tb_pessoas_cubo_ops_w.nr_sequencia(i), nr_seq_populacao_alvo_p);
		commit;
	end loop;
	close cursor_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_pop_alvo_prest_pck.gravar_pessoas_cubo_ops_w (nr_seq_populacao_alvo_p bigint, nm_usuario_p text, nr_seq_controle_p bigint, ds_select_comp_p text) FROM PUBLIC;
