-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_log_ap_lote_hist ( nr_seq_lote_p bigint, ds_evento_p text, ds_log_p text, nm_usuario_p text) AS $body$
BEGIN

insert into ap_lote_historico(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	nr_seq_lote,
	ds_evento,
	ds_log)
values (	nextval('ap_lote_historico_seq'),
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_lote_p,
	ds_evento_p,
	ds_log_p);

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_log_ap_lote_hist ( nr_seq_lote_p bigint, ds_evento_p text, ds_log_p text, nm_usuario_p text) FROM PUBLIC;

