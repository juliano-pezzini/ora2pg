-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_lib_titulo_pagar ( nr_titulo_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_observacao_titulo_w	titulo_pagar.ds_observacao_titulo%type;


BEGIN
if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	ds_observacao_titulo_w	:= wheb_mensagem_pck.get_texto(303197,'DATA=' || clock_timestamp() || ';NM_USUARIO=' || Upper(nm_usuario_p));

	update	titulo_pagar
	set	dt_liberacao    = NULL,
		nm_usuario     = nm_usuario_p,
		nm_usuario_lib  = NULL,
		ds_observacao_titulo = substr(substr(ds_observacao_titulo,1,3700) || ds_observacao_titulo_w,1,3998)
	where	nr_titulo      = nr_titulo_p;

	/*Desfazer a liberação do título que o usuário liberou*/

	update	conta_pagar_lib
	set	dt_liberacao	 = NULL,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_titulo	= nr_titulo_p
	and	nm_usuario_lib	= nm_usuario_p;

end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_lib_titulo_pagar ( nr_titulo_p bigint, nm_usuario_p text) FROM PUBLIC;

