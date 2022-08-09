-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_historico_requisicao ( nr_requisicao_p bigint, ds_titulo_p text, ds_historico_p text, cd_evento_p text, nm_usuario_p text) AS $body$
BEGIN

insert into requisicao_mat_historico(
	nr_sequencia,
	nr_requisicao,
	dt_atualizacao,
	nm_usuario,
	dt_historico,
	ds_titulo,
	ds_historico,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ie_tipo,
	cd_evento,
	dt_liberacao,
	nm_usuario_lib)
values (nextval('requisicao_mat_historico_seq'),
	nr_requisicao_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	ds_titulo_p,
	ds_historico_p,
	clock_timestamp(),
	nm_usuario_p,
	'S',
	cd_evento_p,
	clock_timestamp(),
	nm_usuario_p);

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_historico_requisicao ( nr_requisicao_p bigint, ds_titulo_p text, ds_historico_p text, cd_evento_p text, nm_usuario_p text) FROM PUBLIC;
