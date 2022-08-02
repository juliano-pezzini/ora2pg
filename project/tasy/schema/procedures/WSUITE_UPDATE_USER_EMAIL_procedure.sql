-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE wsuite_update_user_email ( nm_usuario_p wsuite_usuario.nm_usuario%type, ds_email_p wsuite_usuario.ds_email%type, nr_sequencia_p wsuite_usuario.nr_sequencia%type) AS $body$
BEGIN

update	wsuite_usuario
set	dt_atualizacao 	= clock_timestamp(),
	nm_usuario 	= nm_usuario_p,
	ds_email 	= ds_email_p
where	nr_sequencia 	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wsuite_update_user_email ( nm_usuario_p wsuite_usuario.nm_usuario%type, ds_email_p wsuite_usuario.ds_email%type, nr_sequencia_p wsuite_usuario.nr_sequencia%type) FROM PUBLIC;

