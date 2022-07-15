-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_liberar_repasse_aprov ( nr_repasse_terceiro_p bigint, ie_estornar_aprovar_p text, nm_usuario_p text) AS $body$
DECLARE



/*
L - Liberar
E - Estornar liberação
*/
BEGIN

if (coalesce(ie_estornar_aprovar_p, 'L') = 'L') then
	begin

	update	repasse_terceiro
	set	dt_liberacao	= clock_timestamp(),
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_repasse_terceiro	= nr_repasse_terceiro_p;

	end;
elsif (ie_estornar_aprovar_p	= 'E') then
	begin

	update	repasse_terceiro
	set	dt_liberacao	 = NULL,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_repasse_terceiro	= nr_repasse_terceiro_p;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_liberar_repasse_aprov ( nr_repasse_terceiro_p bigint, ie_estornar_aprovar_p text, nm_usuario_p text) FROM PUBLIC;

