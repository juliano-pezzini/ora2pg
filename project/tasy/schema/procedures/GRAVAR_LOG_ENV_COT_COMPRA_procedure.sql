-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_log_env_cot_compra ( nr_cot_compra_p bigint, ds_arquivo_p text, ds_conteudo_p text, ie_envio_retorno_p text, nm_usuario_p text) AS $body$
BEGIN

insert into cot_compra_arq(	nr_sequencia,
			nr_cot_compra,
			dt_atualizacao,
			nm_usuario,
			ds_arquivo,
			ds_conteudo,
			ie_envio_retorno,
			dt_atualizacao_nrec,
			nm_usuario_nrec)
values (	nextval('cot_compra_arq_seq'),
	nr_cot_compra_p,
	clock_timestamp(),
	nm_usuario_p,
	ds_arquivo_p,
	ds_conteudo_p,
	ie_envio_retorno_p,
	clock_timestamp(),
	nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_env_cot_compra ( nr_cot_compra_p bigint, ds_arquivo_p text, ds_conteudo_p text, ie_envio_retorno_p text, nm_usuario_p text) FROM PUBLIC;
