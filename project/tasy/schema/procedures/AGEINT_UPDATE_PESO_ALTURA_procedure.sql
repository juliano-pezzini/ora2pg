-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_update_peso_altura (nr_sequencia_p bigint, qt_peso_p bigint, qt_altura_cm_p bigint) AS $body$
BEGIN

if ((nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and
	(qt_peso_p IS NOT NULL AND qt_peso_p::text <> '') and
	(qt_altura_cm_p IS NOT NULL AND qt_altura_cm_p::text <> '')) then
	begin

	update	agenda_integrada
	set		qt_peso		= qt_peso_p,
			qt_altura_cm	= qt_altura_cm_p,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario		= coalesce(wheb_usuario_pck.get_nm_usuario, nm_usuario)
	where	nr_sequencia = nr_sequencia_p;
	
	end;
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_update_peso_altura (nr_sequencia_p bigint, qt_peso_p bigint, qt_altura_cm_p bigint) FROM PUBLIC;
