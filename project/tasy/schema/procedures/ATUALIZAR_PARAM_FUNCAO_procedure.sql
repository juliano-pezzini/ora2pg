-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_param_funcao ( nr_sequencia_p bigint, cd_funcao_p bigint, vl_parametro_p text, nm_usuario_p text) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (cd_funcao_p IS NOT NULL AND cd_funcao_p::text <> '') then
	update 	funcao_parametro
	set	dt_atualizacao 	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		vl_parametro 	= vl_parametro_p
	where 	nr_sequencia 	= nr_sequencia_p
	and	cd_funcao  	= cd_funcao_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_param_funcao ( nr_sequencia_p bigint, cd_funcao_p bigint, vl_parametro_p text, nm_usuario_p text) FROM PUBLIC;

