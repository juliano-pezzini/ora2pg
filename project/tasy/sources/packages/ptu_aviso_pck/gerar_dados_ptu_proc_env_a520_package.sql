-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



-- Gerar dados PTU_AVISO_PROCEDIMENTO para envio



CREATE OR REPLACE PROCEDURE ptu_aviso_pck.gerar_dados_ptu_proc_env_a520 ( ds_sql_cursor_p text, nm_usuario_p usuario.nm_usuario%type, nr_seq_aviso_conta_p ptu_aviso_procedimento.nr_seq_aviso_conta%type, dados_bind_p sql_pck.t_dado_bind) AS $body$
DECLARE

						
_ora2pg_r RECORD;
-- SQL dinamico

valor_bind_proc_w		sql_pck.t_dado_bind;	-- Binds para o sql dinamico
cursor_sql_w			sql_pck.t_cursor;

-- Carregar dados

tb_nr_seq_conta_proc_w		pls_util_cta_pck.t_number_table;
tb_ie_origem_proced_w		pls_util_cta_pck.t_number_table;
tb_cd_procedimento_w		pls_util_cta_pck.t_number_table;
tb_cd_despesa_w			pls_util_cta_pck.t_varchar2_table_5;
tb_dt_execucao_w		pls_util_cta_pck.t_date_table;
tb_hr_inicial_w			pls_util_cta_pck.t_date_table;
tb_hr_final_w			pls_util_cta_pck.t_date_table;
tb_cd_tabela_w			pls_util_cta_pck.t_varchar2_table_5;
tb_cd_proc_envio_w		pls_util_cta_pck.t_varchar2_table_10;
tb_ds_procedimento_w		pls_util_cta_pck.t_varchar2_table_255;
tb_qt_executada_w		pls_util_cta_pck.t_number_table;
tb_ie_via_acesso_w		pls_util_cta_pck.t_varchar2_table_1;
tb_ie_tecnica_utilizada_w	pls_util_cta_pck.t_varchar2_table_1;
tb_tx_reducao_acrescimo_w	pls_util_cta_pck.t_number_table;
tb_vl_unitario_w		pls_util_cta_pck.t_number_table;
tb_vl_total_w			pls_util_cta_pck.t_number_table;
-- Seq novo

tb_nr_seq_aviso_procedimento_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_conta_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_conta_pos_estab_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_pos_proc_w		pls_util_cta_pck.t_number_table;
tb_ie_local_w			dbms_sql.varchar2_table;

nr_seq_item_tiss_w      ptu_aviso_procedimento.nr_seq_item_tiss%type;

BEGIN

-- Carrega o sql dinamico (por questoes de performance, ele e montado fora do loop da conta

valor_bind_proc_w := dados_bind_p;

valor_bind_proc_w := sql_pck.executa_sql_cursor(ds_sql_cursor_p, valor_bind_proc_w);

loop fetch cursor_sql_w bulk collect into 	tb_nr_seq_conta_proc_w,		tb_ie_origem_proced_w,		tb_cd_procedimento_w,
						tb_cd_despesa_w,		tb_dt_execucao_w,		tb_hr_inicial_w,
						tb_hr_final_w,			tb_cd_tabela_w,			tb_cd_proc_envio_w,
						tb_ds_procedimento_w,		tb_qt_executada_w,		tb_ie_via_acesso_w,
						tb_ie_tecnica_utilizada_w,	tb_tx_reducao_acrescimo_w,	tb_vl_unitario_w,
						tb_vl_total_w,			tb_nr_seq_conta_w,		tb_nr_seq_conta_pos_estab_w,
						tb_nr_seq_pos_proc_w,		tb_ie_local_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_conta_proc_w.count = 0;
	
	for i in tb_nr_seq_conta_proc_w.first..tb_nr_seq_conta_proc_w.last loop
		PERFORM set_config('ptu_aviso_pck.ie_qtd_proc_mat', 'S', false);
		nr_seq_item_tiss_w 	:= ptu_aviso_pck.gera_seq_tiss(nr_seq_aviso_conta_p);
		insert into ptu_aviso_procedimento(nr_sequencia,					dt_atualizacao,				nm_usuario,
			dt_atualizacao_nrec,				nm_usuario_nrec,			nr_seq_aviso_conta,
			nr_seq_conta_proc,				ie_origem_proced,			cd_procedimento,
			cd_despesa,					dt_execucao,				hr_inicial,
			hr_final,					cd_tabela,				cd_proc_envio,
			qt_executada,					ie_via_acesso,				ds_procedimento,
			ie_tecnica_utilizada,				tx_reducao_acrescimo,			vl_unitario,
			vl_total,					nr_seq_item_tiss)
		values (nextval('ptu_aviso_procedimento_seq'),		clock_timestamp(),				nm_usuario_p,
			clock_timestamp(),					nm_usuario_p,				nr_seq_aviso_conta_p,
			tb_nr_seq_conta_proc_w(i),			tb_ie_origem_proced_w(i),		tb_cd_procedimento_w(i),
			tb_cd_despesa_w(i),				tb_dt_execucao_w(i),			tb_hr_inicial_w(i),
			coalesce(tb_hr_final_w(i),tb_hr_inicial_w(i)),	tb_cd_tabela_w(i),			tb_cd_proc_envio_w(i),
			tb_qt_executada_w(i),				tb_ie_via_acesso_w(i),			ptu_somente_caracter_permitido(tb_ds_procedimento_w(i), 'ANS'),
			tb_ie_tecnica_utilizada_w(i),			tb_tx_reducao_acrescimo_w(i),		tb_vl_unitario_w(i),
			tb_vl_total_w(i),				nr_seq_item_tiss_w) returning nr_sequencia into tb_nr_seq_aviso_procedimento_w(i);
		
		-- Gerar dados PTU_AVISO_PARTICIPANTE para envio

		CALL ptu_aviso_pck.gerar_dados_ptu_part_env_a520( tb_nr_seq_aviso_procedimento_w(i), nm_usuario_p);
	end loop;
	
	-- gera a tabela de rastreabilidade (hoje nao tem nenhum agrupamento em cima dos itens, entao pode ser feito depois de sua insersao)

	SELECT * FROM ptu_aviso_pck.grava_aviso_proc_item(	nm_usuario_p, tb_nr_seq_aviso_procedimento_w, tb_nr_seq_conta_w, tb_nr_seq_conta_proc_w, tb_nr_seq_pos_proc_w, tb_nr_seq_conta_pos_estab_w, tb_qt_executada_w, tb_vl_unitario_w, tb_vl_total_w, tb_ie_local_w, 'N', 'S') INTO STRICT _ora2pg_r;
 tb_nr_seq_aviso_procedimento_w := _ora2pg_r.nr_seq_aviso_procedimento_p; tb_nr_seq_conta_w := _ora2pg_r.nr_seq_conta_p; tb_nr_seq_conta_proc_w := _ora2pg_r.nr_seq_conta_proc_p; tb_nr_seq_pos_proc_w := _ora2pg_r.nr_seq_pos_proc_p; tb_nr_seq_conta_pos_estab_w := _ora2pg_r.nr_seq_conta_pos_estab_p; tb_qt_executada_w := _ora2pg_r.qt_executada_p; tb_vl_unitario_w := _ora2pg_r.vl_unitario_p; tb_vl_total_w := _ora2pg_r.vl_total_p; tb_ie_local_w := _ora2pg_r.ie_local_p;

end loop;
close cursor_sql_w;

if (cursor_sql_w%isopen) then
	close cursor_sql_w;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_aviso_pck.gerar_dados_ptu_proc_env_a520 ( ds_sql_cursor_p text, nm_usuario_p usuario.nm_usuario%type, nr_seq_aviso_conta_p ptu_aviso_procedimento.nr_seq_aviso_conta%type, dados_bind_p sql_pck.t_dado_bind) FROM PUBLIC;
