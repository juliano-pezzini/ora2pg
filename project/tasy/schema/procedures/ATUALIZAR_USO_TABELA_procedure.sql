-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_uso_tabela ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, ie_inicio_fim_p text, nm_usuario_p text) AS $body$
DECLARE


dt_atualizacao_w			timestamp	:= clock_timestamp();


BEGIN

if (ie_inicio_fim_p = 'I') then
	update	tabela_custo
	set	dt_inicio_uso		= dt_atualizacao_w
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	cd_tabela_custo	= cd_tabela_custo_p;
else
	update	tabela_custo
	set	dt_final_uso		= dt_atualizacao_w
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	cd_tabela_custo	= cd_tabela_custo_p;
end if;
commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_uso_tabela ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, ie_inicio_fim_p text, nm_usuario_p text) FROM PUBLIC;
