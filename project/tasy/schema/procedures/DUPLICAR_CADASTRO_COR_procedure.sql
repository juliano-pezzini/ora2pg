-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_cadastro_cor ( nr_seq_cor_origem_p bigint, cd_estabelecimento_novo_p bigint, cd_perfil_novo_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_perfil_w		bigint;


BEGIN

if (cd_perfil_novo_p = 0) then
	cd_perfil_w	:= null;
else
	cd_perfil_w	:= cd_perfil_novo_p;
end if;

insert into tasy_padrao_cor_perfil(
	nr_sequencia,
	cd_estabelecimento,
	cd_perfil,
	nr_seq_padrao,
	dt_atualizacao,
	nm_usuario,
	ds_cor_fundo,
	ds_cor_fonte,
	ds_cor_selecao,
	dt_atualizacao_nrec,
	nm_usuario_nrec)
SELECT	nextval('tasy_padrao_cor_perfil_seq'),
	cd_estabelecimento_novo_p,
	cd_perfil_w,
	nr_seq_padrao,
	clock_timestamp(),
	nm_usuario_p,
	ds_cor_fundo,
	ds_cor_fonte,
	ds_cor_selecao,
	clock_timestamp(),
	nm_usuario_p
from	tasy_padrao_cor_perfil
where	nr_sequencia	= nr_seq_cor_origem_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_cadastro_cor ( nr_seq_cor_origem_p bigint, cd_estabelecimento_novo_p bigint, cd_perfil_novo_p bigint, nm_usuario_p text) FROM PUBLIC;

