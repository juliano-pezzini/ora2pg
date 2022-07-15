-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_historico_repasse_pend (nm_usuario_p text, dt_historico_p timestamp, ds_historico_p text, nr_seq_proc_repasse_p bigint, nr_seq_mat_repasse_p bigint) AS $body$
BEGIN

insert into repasse_pendente_hist(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ds_historico,
	nr_seq_proc_repasse,
	nr_seq_mat_repasse,
	dt_historico)
values (nextval('repasse_pendente_hist_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	ds_historico_p,
	nr_seq_proc_repasse_p,
	nr_seq_mat_repasse_p,
	dt_historico_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_historico_repasse_pend (nm_usuario_p text, dt_historico_p timestamp, ds_historico_p text, nr_seq_proc_repasse_p bigint, nr_seq_mat_repasse_p bigint) FROM PUBLIC;

