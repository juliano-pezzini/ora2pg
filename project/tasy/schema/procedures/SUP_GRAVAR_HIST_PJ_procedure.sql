-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_gravar_hist_pj ( cd_estab_p text, cd_cnpj_p text, ds_titulo_p text, ds_historico_p text, ie_tipo_p text, nm_usuario_p text) AS $body$
DECLARE


ds_historico_w				varchar(4000);


BEGIN

ds_historico_w	:= substr(ds_historico_p,1,4000);

insert into pessoa_juridica_historico(
	nr_sequencia,
	cd_cgc,
	dt_historico,
	ds_historico,
	dt_atualizacao,
	nm_usuario,
	ds_titulo,
	dt_liberacao,
	nm_usuario_lib,
	ie_tipo,
	cd_estabelecimento)
values (	nextval('pessoa_juridica_historico_seq'),
	cd_cnpj_p,
	clock_timestamp(),
	ds_historico_w,
	clock_timestamp(),
	nm_usuario_p,
	substr(ds_titulo_p,1,255),
	clock_timestamp(),
	nm_usuario_p,
	'S',
	cd_estab_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_gravar_hist_pj ( cd_estab_p text, cd_cnpj_p text, ds_titulo_p text, ds_historico_p text, ie_tipo_p text, nm_usuario_p text) FROM PUBLIC;

