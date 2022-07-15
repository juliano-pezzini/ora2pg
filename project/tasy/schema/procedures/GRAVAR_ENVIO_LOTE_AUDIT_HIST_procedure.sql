-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_envio_lote_audit_hist (nr_seq_lote_hist_p bigint, nm_usuario_p text, ds_destino_p text, ds_observacao_p text) AS $body$
BEGIN

insert into lote_audit_hist_envio(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_lote_hist,
	ds_destino,
	ds_observacao)
values (nextval('lote_audit_hist_envio_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_lote_hist_p,
	ds_destino_p,
	ds_observacao_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_envio_lote_audit_hist (nr_seq_lote_hist_p bigint, nm_usuario_p text, ds_destino_p text, ds_observacao_p text) FROM PUBLIC;

