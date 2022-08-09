-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_senha_laudo_user ( nm_usuario_p text, ds_senha_laudo_p text, nm_usuario_atual_p text) AS $body$
BEGIN

update	usuario
set	ds_senha_laudo = ds_senha_laudo_p,
	dt_atualizacao = clock_timestamp(),
	nm_usuario_atual = nm_usuario_atual_p
where	nm_usuario = nm_usuario_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_senha_laudo_user ( nm_usuario_p text, ds_senha_laudo_p text, nm_usuario_atual_p text) FROM PUBLIC;
