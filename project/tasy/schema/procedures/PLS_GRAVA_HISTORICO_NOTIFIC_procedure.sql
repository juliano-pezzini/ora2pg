-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_grava_historico_notific ( nr_seq_notificacao_p bigint, ds_historico_p text, ds_parametro_1_p text, ds_parametro_2_p text, nm_usuario_p text) AS $body$
BEGIN

insert into pls_notificacao_hist_atend(nr_sequencia, nr_seq_notificacao, dt_historico,
	dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
	nm_usuario_nrec, ds_historico)
values (nextval('pls_notificacao_hist_atend_seq'), nr_seq_notificacao_p, clock_timestamp(),
	clock_timestamp(), nm_usuario_p, clock_timestamp(),
	nm_usuario_p,substr(ds_historico_p,1,4000));

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_grava_historico_notific ( nr_seq_notificacao_p bigint, ds_historico_p text, ds_parametro_1_p text, ds_parametro_2_p text, nm_usuario_p text) FROM PUBLIC;
