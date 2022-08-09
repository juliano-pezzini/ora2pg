-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_finalizar_vig_preco_serv ( cd_tabela_servico_p preco_servico.cd_tabela_servico%type, dt_inicio_vigencia_p preco_servico.dt_inicio_vigencia%type, dt_vigencia_final_p preco_servico.dt_vigencia_final%type, cd_procedimento_p preco_servico.cd_procedimento%type, cd_estabelecimento_p preco_servico.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

	update	preco_servico
	set	dt_vigencia_final	= dt_vigencia_final_p,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_tabela_servico	= cd_tabela_servico_p
	and	dt_inicio_vigencia	= dt_inicio_vigencia_p
	and	cd_procedimento		= cd_procedimento_p
	and	cd_estabelecimento_p	= cd_estabelecimento_p
	and	coalesce(dt_vigencia_final::text, '') = '';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_finalizar_vig_preco_serv ( cd_tabela_servico_p preco_servico.cd_tabela_servico%type, dt_inicio_vigencia_p preco_servico.dt_inicio_vigencia%type, dt_vigencia_final_p preco_servico.dt_vigencia_final%type, cd_procedimento_p preco_servico.cd_procedimento%type, cd_estabelecimento_p preco_servico.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
