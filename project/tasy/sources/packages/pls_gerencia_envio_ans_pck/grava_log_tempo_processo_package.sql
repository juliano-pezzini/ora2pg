-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- gravao de log para monitoramento de tempos do processo da funo



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.grava_log_tempo_processo ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, ds_processo_p pls_monitor_tempo_lote.ds_processo%type, ie_tipo_processo_p text, nm_usuario_p usuario.nm_usuario%type, nr_seq_processo_p INOUT pls_monitor_tempo_lote.nr_sequencia%type) AS $body$
BEGIN
-- grava o incio do processo

if (ie_tipo_processo_p = 'I') then

	insert 	into pls_monitor_tempo_lote(
		nr_sequencia, dt_atualizacao_nrec,
		nm_usuario_nrec, ds_processo,
		dt_inicio, nr_seq_lote_monitor
	) values (
		nextval('pls_monitor_tempo_lote_seq'), clock_timestamp(),
		nm_usuario_p, ds_processo_p,
		clock_timestamp(), nr_seq_lote_p
	) returning nr_sequencia into nr_seq_processo_p;

else
	-- grava a data de fim do processo

	update 	pls_monitor_tempo_lote set dt_fim = clock_timestamp()
	where	nr_sequencia = nr_seq_processo_p;
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.grava_log_tempo_processo ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, ds_processo_p pls_monitor_tempo_lote.ds_processo%type, ie_tipo_processo_p text, nm_usuario_p usuario.nm_usuario%type, nr_seq_processo_p INOUT pls_monitor_tempo_lote.nr_sequencia%type) FROM PUBLIC;