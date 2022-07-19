-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_espec_prest_pf ( cd_pessoa_fisica_p text, cd_especialidade_p bigint) AS $body$
BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (cd_especialidade_p IS NOT NULL AND cd_especialidade_p::text <> '') then
	delete from pls_prestador_med_espec
	where	cd_especialidade = cd_especialidade_p
	and	cd_pessoa_fisica = cd_pessoa_fisica_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_espec_prest_pf ( cd_pessoa_fisica_p text, cd_especialidade_p bigint) FROM PUBLIC;

