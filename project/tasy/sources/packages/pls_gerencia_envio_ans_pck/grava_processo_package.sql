-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- gravao de log de processos efetuados no lote



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.grava_processo ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, ie_tipo_processo_p pls_monitor_tiss_processo.ie_tipo_processo%type, nm_usuario_p usuario.nm_usuario%type, ds_erro_p pls_monitor_tiss_processo.ds_erro%type, nr_seq_processo_p INOUT pls_monitor_tiss_processo.nr_sequencia%type) AS $body$
BEGIN
-- se no tiver erro s insere

if (coalesce(nr_seq_processo_p::text, '') = '') then

	insert 	into pls_monitor_tiss_processo(
		nr_sequencia, dt_atualizacao_nrec,
		nm_usuario_nrec, ie_tipo_processo,
		dt_processo, nr_seq_lote_monitor,
		nm_usuario, dt_atualizacao, ds_erro
	) values (
		nextval('pls_monitor_tiss_processo_seq'), clock_timestamp(),
		nm_usuario_p, ie_tipo_processo_p,
		clock_timestamp(), nr_seq_lote_p,
		nm_usuario_p, clock_timestamp(), ds_erro_p
	) returning nr_sequencia into nr_seq_processo_p;

-- se tiver erro grava o erro na tabela

elsif (nr_seq_processo_p IS NOT NULL AND nr_seq_processo_p::text <> '') then

	update 	pls_monitor_tiss_processo set
		ds_erro = ds_erro_p,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_seq_processo_p;
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.grava_processo ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, ie_tipo_processo_p pls_monitor_tiss_processo.ie_tipo_processo%type, nm_usuario_p usuario.nm_usuario%type, ds_erro_p pls_monitor_tiss_processo.ds_erro%type, nr_seq_processo_p INOUT pls_monitor_tiss_processo.nr_sequencia%type) FROM PUBLIC;
