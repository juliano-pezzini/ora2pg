-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_paciente_notification ON agenda_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_paciente_notification() RETURNS trigger AS $BODY$
DECLARE ie_status_w varchar(1) := 'Y';

BEGIN

IF (NEW.IE_STATUS_AGENDA = 'N' ) THEN

  BEGIN

       select CASE WHEN count(*)=0 THEN  'N'  ELSE 'Y' END  into STRICT  ie_status_w from wsuite_notification WHERE nr_primary_key  = NEW.Nr_Sequencia AND ie_notification_type ='AP';

  If (ie_status_w = 'N') then

       CALL wsuite_add_notification('AP',NEW.nr_sequencia, NULL, NEW.nm_usuario, NEW.cd_pessoa_fisica,NEW.nr_sequencia);

  end if;

  end;

elsif (NEW.IE_STATUS_AGENDA  = 'C') THEN

  BEGIN

        CALL wsuite_remove_notification('AP',NEW.nr_sequencia);

        CALL wsuite_add_notification('AP',NEW.nr_sequencia, NULL, NEW.nm_usuario, NEW.cd_pessoa_fisica,NEW.nr_sequencia);
  end;


END IF;



RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_paciente_notification() FROM PUBLIC;

CREATE TRIGGER agenda_paciente_notification
	AFTER INSERT OR UPDATE ON agenda_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_paciente_notification();
