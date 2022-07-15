-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_util_tabela ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, cd_tabela_utilizada_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_atualizacao_w			timestamp	:= clock_timestamp();


BEGIN

insert into tabela_utilizada(
	cd_estabelecimento,
	cd_tabela_custo,
	cd_tabela_utilizada,
	nm_usuario,
	dt_atualizacao)
values (cd_estabelecimento_p,
	cd_tabela_custo_p,
	cd_tabela_utilizada_p,
	nm_usuario_p,
	dt_atualizacao_w);
exception when others then
	dt_atualizacao_w := clock_timestamp();

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_util_tabela ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, cd_tabela_utilizada_p bigint, nm_usuario_p text) FROM PUBLIC;

