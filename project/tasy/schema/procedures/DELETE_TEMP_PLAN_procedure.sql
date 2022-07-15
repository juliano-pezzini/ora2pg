-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE delete_temp_plan ( nr_sequencia_p bigint default 0, ie_todos_p text default 'N') AS $body$
BEGIN

if (ie_todos_p = 'S')then
	delete 	from w_medic_plano_imp
	where	nm_usuario = wheb_usuario_pck.get_nm_usuario;
else
	delete 	from w_medic_plano_imp
	where	nr_sequencia = nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE delete_temp_plan ( nr_sequencia_p bigint default 0, ie_todos_p text default 'N') FROM PUBLIC;

