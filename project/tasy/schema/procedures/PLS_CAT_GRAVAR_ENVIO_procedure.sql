-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_cat_gravar_envio ( nr_seq_segurado_p bigint, ds_email_p text, ds_observacao_p text, nm_usuario_p text) AS $body$
BEGIN

insert into pls_cat_envio(nr_sequencia, nr_seq_segurado, dt_envio,
	ds_destino, dt_atualizacao, nm_usuario,
	dt_atualizacao_nrec, nm_usuario_nrec, ds_observacao)
values (	nextval('pls_cat_envio_seq'), nr_seq_segurado_p , clock_timestamp(),
	ds_email_p, clock_timestamp(), nm_usuario_p,
	clock_timestamp(), nm_usuario_p, ds_observacao_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cat_gravar_envio ( nr_seq_segurado_p bigint, ds_email_p text, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;
