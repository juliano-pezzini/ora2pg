-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_gravar_log_reap (nr_seq_retorno_p bigint, nr_seq_lote_hist_p bigint, ds_log_p text, nm_usuario_p text) AS $body$
BEGIN

insert into tiss_log_reap(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	nr_seq_retorno,
	nr_seq_lote_hist,
	ds_log)
values (nextval('tiss_log_reap_seq'),
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_retorno_p,
	nr_seq_lote_hist_p,
	ds_log_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_gravar_log_reap (nr_seq_retorno_p bigint, nr_seq_lote_hist_p bigint, ds_log_p text, nm_usuario_p text) FROM PUBLIC;
