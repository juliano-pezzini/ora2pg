-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_gerar_hist_conjunto ( ds_historico_p text, ie_alteracao_p text, nr_conjunto_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into conjunto_historico(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ds_historico,
	ie_alteracao,
	nr_conjunto)
values (	nextval('conjunto_historico_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	ds_historico_p,
	ie_alteracao_p,
	nr_conjunto_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_gerar_hist_conjunto ( ds_historico_p text, ie_alteracao_p text, nr_conjunto_p bigint, nm_usuario_p text) FROM PUBLIC;

