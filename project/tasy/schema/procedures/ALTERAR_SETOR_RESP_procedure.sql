-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_setor_resp ( nr_sequencia_p bigint, cd_setor_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_sequencia_p > 0) and (cd_setor_p > 0) then
	begin
	update	convenio_retorno_glosa
	set	cd_setor_responsavel	= cd_setor_p,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= nr_sequencia_p;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_setor_resp ( nr_sequencia_p bigint, cd_setor_p bigint, nm_usuario_p text) FROM PUBLIC;

