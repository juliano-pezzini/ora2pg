-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alt_tipo_acomod_desej_aut_conv ( nr_sequencia_p bigint, cd_tipo_acomod_desej_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (coalesce(cd_tipo_acomod_desej_p,0) <> 0) then
	update 	autorizacao_convenio set
		cd_tipo_acomod_desej = cd_tipo_acomod_desej_p,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where 	nr_sequencia = nr_sequencia_p
	and 	cd_estabelecimento = cd_estabelecimento_p;

	commit;
end if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alt_tipo_acomod_desej_aut_conv ( nr_sequencia_p bigint, cd_tipo_acomod_desej_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

