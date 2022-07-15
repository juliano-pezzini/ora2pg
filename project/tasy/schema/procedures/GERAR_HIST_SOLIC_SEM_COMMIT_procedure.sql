-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_hist_solic_sem_commit ( nr_solic_compra_p bigint, ds_titulo_p text, ds_historico_p text, cd_evento_p text, nm_usuario_p text) AS $body$
BEGIN

insert into solic_compra_hist(
	nr_sequencia,
	nr_solic_compra,
	dt_atualizacao,
	nm_usuario,
	dt_historico,
	ds_titulo,
	ds_historico,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ie_tipo,
	cd_evento,
	dt_liberacao)
values (nextval('solic_compra_hist_seq'),
	nr_solic_compra_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	ds_titulo_p,
	substr(ds_historico_p,1,4000),
	clock_timestamp(),
	nm_usuario_p,
	'S',
	cd_evento_p,
	clock_timestamp());

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_hist_solic_sem_commit ( nr_solic_compra_p bigint, ds_titulo_p text, ds_historico_p text, cd_evento_p text, nm_usuario_p text) FROM PUBLIC;

