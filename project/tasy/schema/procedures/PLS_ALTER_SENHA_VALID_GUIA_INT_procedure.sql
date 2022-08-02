-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alter_senha_valid_guia_int ( nr_seq_guia_p bigint, cd_senha_p text, dt_validade_senha_p timestamp, nm_usuario_p text) AS $body$
BEGIN

update	pls_guia_plano
set	cd_senha_externa	= cd_senha_p,
	dt_valid_senha_ext	= dt_validade_senha_p,
	dt_validade_senha	= dt_validade_senha_p,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_sequencia		= nr_seq_guia_p;

CALL pls_guia_gravar_historico(	nr_seq_guia_p, 2, substr('O usuário '||obter_nome_usuario(nm_usuario_p)||
				' alterou a senha externa e a data de validade em '||to_char(clock_timestamp(), 'dd/mm/yyyy hh24:mi:ss'),1,4000),
				'', nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alter_senha_valid_guia_int ( nr_seq_guia_p bigint, cd_senha_p text, dt_validade_senha_p timestamp, nm_usuario_p text) FROM PUBLIC;

