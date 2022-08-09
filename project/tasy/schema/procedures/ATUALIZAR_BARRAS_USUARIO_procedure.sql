-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_barras_usuario ( cd_funcionario_p text, cd_pessoa_fisica_p text) AS $body$
BEGIN

if (cd_funcionario_p IS NOT NULL AND cd_funcionario_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	begin
	update	usuario
	set	cd_barras = coalesce(cd_barras, cd_funcionario_p)
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	commit;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_barras_usuario ( cd_funcionario_p text, cd_pessoa_fisica_p text) FROM PUBLIC;
