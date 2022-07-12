-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS prescr_dieta_insert ON prescr_dieta CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_prescr_dieta_insert() RETURNS trigger AS $BODY$
declare

dt_rep_pt_w		timestamp;
dt_rep_pt2_w		timestamp;

BEGIN

if (NEW.nr_seq_interno is null) then
	select nextval('prescr_dieta_seq')
	into STRICT	NEW.nr_seq_interno
	;
end if;

if (NEW.dt_rep_pt is null) and (NEW.dt_rep_pt2 is null) then

	select	max(dt_rep_pt),
		max(dt_rep_pt2)
	into STRICT	dt_rep_pt_w,
		dt_rep_pt2_w
	from	prescr_medica
	where	nr_prescricao = NEW.nr_prescricao;

	NEW.dt_rep_pt	:= dt_rep_pt_w;
	NEW.dt_rep_pt2	:= dt_rep_pt2_w;

end if;

NEW.ds_stack	:= substr(dbms_utility.format_call_stack,1,2000);

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_prescr_dieta_insert() FROM PUBLIC;

CREATE TRIGGER prescr_dieta_insert
	BEFORE INSERT ON prescr_dieta FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_prescr_dieta_insert();

