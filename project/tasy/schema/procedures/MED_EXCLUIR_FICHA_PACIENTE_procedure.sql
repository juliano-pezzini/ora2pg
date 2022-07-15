-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_excluir_ficha_paciente ( cd_pessoa_fisica_p text, cd_medico_p text) AS $body$
BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') then

	update	med_cliente
	set	cd_pessoa_sist_orig	 = NULL
        	where	cd_pessoa_fisica		= cd_pessoa_fisica_p
	and	cd_medico		= cd_medico_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_excluir_ficha_paciente ( cd_pessoa_fisica_p text, cd_medico_p text) FROM PUBLIC;

