-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_filtro_regra_event_rgl_pck.atualiza_log_tempo ( nr_seq_analise_rec_p pls_analise_conta.nr_sequencia%type, nr_seq_prot_rec_p pls_rec_glosa_protocolo.nr_sequencia%type, nr_seq_cta_rec_p pls_rec_glosa_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, tb_dt_inicio_p INOUT pls_util_cta_pck.t_date_table, tb_dt_fim_p INOUT pls_util_cta_pck.t_date_table, tb_nr_seq_regra_p INOUT pls_util_cta_pck.t_number_table, tb_nr_id_trans_p INOUT pls_util_cta_pck.t_number_table) AS $body$
BEGIN

if (tb_nr_seq_regra_p.count > 0) then
	forall i in tb_nr_seq_regra_p.first..tb_nr_seq_regra_p.last
		insert into pls_pp_cta_log_tempo(
			nr_sequencia, nr_seq_protocolo_rec, nr_seq_conta_rec,
			nr_seq_regra, ds_tempo_execucao, dt_fim_processo, 
			dt_inicio_processo, nm_usuario, nr_id_transacao, 
			dt_atualizacao, nr_seq_analise_rec)
		values (	nextval('pls_pp_cta_log_tempo_seq'), nr_seq_prot_rec_p, nr_seq_cta_rec_p, 
			tb_nr_seq_regra_p(i), pls_manipulacao_datas_pck.obter_tempo_execucao_format(tb_dt_inicio_p(i), tb_dt_fim_p(i)), tb_dt_fim_p(i),
			tb_dt_inicio_p(i), nm_usuario_p, tb_nr_id_trans_p(i), 
			clock_timestamp(), nr_seq_analise_rec_p);
	commit;
end if;

tb_dt_inicio_p.delete;
tb_dt_fim_p.delete;
tb_nr_seq_regra_p.delete;
tb_nr_id_trans_p.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_filtro_regra_event_rgl_pck.atualiza_log_tempo ( nr_seq_analise_rec_p pls_analise_conta.nr_sequencia%type, nr_seq_prot_rec_p pls_rec_glosa_protocolo.nr_sequencia%type, nr_seq_cta_rec_p pls_rec_glosa_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, tb_dt_inicio_p INOUT pls_util_cta_pck.t_date_table, tb_dt_fim_p INOUT pls_util_cta_pck.t_date_table, tb_nr_seq_regra_p INOUT pls_util_cta_pck.t_number_table, tb_nr_id_trans_p INOUT pls_util_cta_pck.t_number_table) FROM PUBLIC;