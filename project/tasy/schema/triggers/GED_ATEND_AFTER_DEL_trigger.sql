-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ged_atend_after_del ON ged_atendimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ged_atend_after_del() RETURNS trigger AS $BODY$
declare
qt_anexo_agenda_w	 integer;

BEGIN

select	count(*)
into STRICT		qt_anexo_agenda_w
from	anexo_agenda
where	nr_seq_agenda = OLD.nr_seq_agenda
and		ds_arquivo	= OLD.ds_arquivo;

if (qt_anexo_agenda_w > 0) then
	delete from anexo_agenda
	where	nr_seq_agenda = OLD.nr_seq_agenda
	and		ds_arquivo	= OLD.ds_arquivo;
end if;

RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ged_atend_after_del() FROM PUBLIC;

CREATE TRIGGER ged_atend_after_del
	AFTER DELETE ON ged_atendimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ged_atend_after_del();
