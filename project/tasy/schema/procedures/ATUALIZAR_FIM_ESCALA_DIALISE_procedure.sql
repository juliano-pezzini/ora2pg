-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_fim_escala_dialise ( cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
BEGIN

update	hd_escala_dialise
set   	dt_fim  = clock_timestamp(),
	nm_usuario = nm_usuario_p
where  	coalesce(dt_fim::text, '') = ''
and    	cd_pessoa_fisica = cd_pessoa_fisica_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_fim_escala_dialise ( cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;
