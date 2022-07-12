-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_medico_delete ON agenda_medico CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_medico_delete() RETURNS trigger AS $BODY$
declare
qt_registros_w	bigint;
ds_erro_w		varchar(255);
BEGIN
  BEGIN

select	count(*)
into STRICT	qt_registros_w
from	AGEINT_TURNO_MEDICO
where	cd_pessoa_fisica  	= OLD.cd_medico
and		((cd_agenda			= OLD.cd_agenda) or (cd_agenda is null));

if (qt_registros_w > 0) then
	BEGIN

	delete	FROM AGEINT_TURNO_MEDICO
	where	cd_pessoa_fisica  				= OLD.cd_medico
	and		coalesce(cd_agenda, OLD.cd_agenda)	= OLD.cd_agenda;
	exception
	when others then
		ds_erro_w := substr(sqlerrm,1,255);
	end;

end if;

  END;
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_medico_delete() FROM PUBLIC;

CREATE TRIGGER agenda_medico_delete
	BEFORE DELETE ON agenda_medico FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_medico_delete();

