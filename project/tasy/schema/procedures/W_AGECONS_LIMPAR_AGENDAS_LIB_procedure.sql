-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE w_agecons_limpar_agendas_lib (nm_usuario_p text, cd_tipo_agenda_p bigint default null) AS $body$
BEGIN

if coalesce(cd_tipo_agenda_p::text, '') = '' then

	delete	FROM W_AGENDAS_LIBERADAS
	where	nm_usuario = nm_usuario_p;

elsif cd_tipo_agenda_p = 3 then

	delete	FROM W_AGENDAS_LIBERADAS
	where	nm_usuario = nm_usuario_p
	and cd_tipo_agenda in (cd_tipo_agenda_p, 4);
	
else

	delete	FROM W_AGENDAS_LIBERADAS
	where	nm_usuario = nm_usuario_p
	and cd_tipo_agenda = cd_tipo_agenda_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE w_agecons_limpar_agendas_lib (nm_usuario_p text, cd_tipo_agenda_p bigint default null) FROM PUBLIC;

