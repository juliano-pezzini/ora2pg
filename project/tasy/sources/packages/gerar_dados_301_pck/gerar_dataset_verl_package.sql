-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE gerar_dados_301_pck.gerar_dataset_verl ( nr_seq_lote_p bigint, nr_seq_log_scheduler_p bigint, nr_seq_atend_prev_alta_p bigint, nm_usuario_p text, cd_convenio_p bigint) AS $body$
DECLARE


	nr_seq_dataset_w	d301_dataset_envio.nr_sequencia%type;
	nr_seq_arquivo_w	bigint;
	
BEGIN

		nr_seq_arquivo_w := gerar_dados_301_pck.obter_seq_arquivo(nr_seq_lote_p, nr_seq_log_scheduler_p, cd_convenio_p, nm_usuario_p, nr_seq_arquivo_w);

		if (current_setting('gerar_dados_301_pck.nr_seq_estrut_arq_w')::bigint = 1) then --GKV - Stand: 14
			nr_seq_dataset_w := gerar_dados_301_pck.inserir_dataset(nr_seq_lote_p, nr_seq_arquivo_w, nr_seq_log_scheduler_p, 'VERL', nm_usuario_p, nr_seq_atend_prev_alta_p, nr_seq_dataset_w);
			CALL gerar_dados_301_pck.gerar_segmentos_dataset('VERL',nr_seq_dataset_w,nm_usuario_p);
			CALL GERAR_D301_CONTEUDO_VERL(nr_seq_dataset_w,nm_usuario_p);

		elsif (current_setting('gerar_dados_301_pck.nr_seq_estrut_arq_w')::bigint = 2) then --PKV - Stand: Nov 2017
			nr_seq_dataset_w := gerar_dados_301_pck.inserir_dataset(nr_seq_lote_p, nr_seq_arquivo_w, nr_seq_log_scheduler_p, 'PVER', nm_usuario_p, nr_seq_atend_prev_alta_p, nr_seq_dataset_w);
			CALL gerar_dados_301_pck.gerar_segmentos_dataset('PVER',nr_seq_dataset_w,nm_usuario_p);
			CALL gerar_d301_conteudo_PVER(nr_seq_dataset_w,nm_usuario_p);
		end if;
		commit;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dados_301_pck.gerar_dataset_verl ( nr_seq_lote_p bigint, nr_seq_log_scheduler_p bigint, nr_seq_atend_prev_alta_p bigint, nm_usuario_p text, cd_convenio_p bigint) FROM PUBLIC;
