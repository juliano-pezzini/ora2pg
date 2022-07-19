-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_wsuite_pessoa_fisica ( ds_login_p wsuite_usuario.ds_login%type, cd_pessoa_fisica_p wsuite_usuario.cd_pessoa_fisica%type) AS $body$
BEGIN

update	wsuite_usuario
set	cd_pessoa_fisica = cd_pessoa_fisica_p
where	ds_login = ds_login_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_wsuite_pessoa_fisica ( ds_login_p wsuite_usuario.ds_login%type, cd_pessoa_fisica_p wsuite_usuario.cd_pessoa_fisica%type) FROM PUBLIC;

