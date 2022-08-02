-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_update_cid_doenca ( nm_usuario_p text) AS $body$
BEGIN

update	cid_doenca
set	ie_situacao =  'I',
	nm_usuario  =  'Tasy',
	dt_atualizacao = clock_timestamp()
where	ie_situacao =  'A';

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_update_cid_doenca ( nm_usuario_p text) FROM PUBLIC;

