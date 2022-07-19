-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_leitura_cartao ( cd_usuario_plano_p text, nr_seq_segurado_p text, ie_tipo_leitura_p text, ds_tarja_magnetica_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into pls_carteira_leitura(nr_sequencia,cd_usuario_plano,cd_estabelecimento,
	dt_leitura,nm_usuario_leitura,dt_atualizacao,
	nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
	nr_seq_segurado, ie_tipo_leitura, ds_tarja_magnetica)
values (nextval('pls_carteira_leitura_seq'),cd_usuario_plano_p,cd_estabelecimento_p,
	clock_timestamp(),nm_usuario_p,clock_timestamp(),
	nm_usuario_p,clock_timestamp(),nm_usuario_p,
	nr_seq_segurado_p, ie_tipo_leitura_p, ds_tarja_magnetica_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_leitura_cartao ( cd_usuario_plano_p text, nr_seq_segurado_p text, ie_tipo_leitura_p text, ds_tarja_magnetica_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

