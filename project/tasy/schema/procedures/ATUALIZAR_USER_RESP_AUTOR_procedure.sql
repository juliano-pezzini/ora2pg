-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_user_resp_autor ( nr_sequencia_p bigint, nm_usuario_p text, nm_usuario_resp_p text) AS $body$
BEGIN
update	autorizacao_convenio
set	nm_usuario_resp	= nm_usuario_resp_p,
	nm_usuario	= nm_usuario_p
where	nr_sequencia 	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_user_resp_autor ( nr_sequencia_p bigint, nm_usuario_p text, nm_usuario_resp_p text) FROM PUBLIC;
