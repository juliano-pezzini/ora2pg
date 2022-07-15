-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adep_gravar_config_painel ( cd_funcao_p bigint, ds_cor_fonte_p text, ds_fonte_p text, ds_estilo_fonte_p text, qt_tamanho_fonte_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_erro_w	varchar(255);


BEGIN

begin
update 	adep_painel_fonte
set	ds_cor_fonte		= coalesce(ds_cor_fonte_p, 'clBlack'),
	ds_fonte		= ds_fonte_p,
	ds_estilo_fonte		= ds_estilo_fonte_p,
	qt_tamanho_fonte	= qt_tamanho_fonte_p,
	dt_atualizacao		= clock_timestamp()
where	nm_usuario		= nm_usuario_p
and	cd_funcao		= cd_funcao_p;

if (NOT FOUND) then
	insert into adep_painel_fonte(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_funcao,
		ds_cor_fonte,
		ds_fonte,
		ds_estilo_fonte,
		qt_tamanho_fonte)
	values (
		nextval('adep_painel_fonte_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_funcao_p,
		coalesce(ds_cor_fonte_p, 'clBlack'),
		ds_fonte_p,
		ds_estilo_fonte_p,
		qt_tamanho_fonte_p);
end if;
exception
when others then
	ds_erro_w		:= sqlerrm(SQLSTATE);
	--Ocorreu um erro na atualização. Erro: ' || ds_erro_w ||'#@#@');
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(261446, 'ERRO='|| ds_erro_w);
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_gravar_config_painel ( cd_funcao_p bigint, ds_cor_fonte_p text, ds_fonte_p text, ds_estilo_fonte_p text, qt_tamanho_fonte_p bigint, nm_usuario_p text) FROM PUBLIC;

