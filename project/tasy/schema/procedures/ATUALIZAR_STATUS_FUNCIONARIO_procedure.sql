-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_status_funcionario ( cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
BEGIN
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	update	pessoa_fisica
	set	ie_funcionario = CASE WHEN coalesce(ie_funcionario,'N')='N' THEN 'S'  ELSE 'N' END ,
		nm_usuario = nm_usuario_p
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_status_funcionario ( cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;

