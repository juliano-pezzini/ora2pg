-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_paciente_before_update ON agenda_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_paciente_before_update() RETURNS trigger AS $BODY$
declare

  ds_given_name_w           person_name.ds_given_name%type;
  ds_component_name_1_w     person_name.ds_component_name_1%type;
  ds_family_name_w          person_name.ds_family_name%type;
  nm_pessoa_montar_w        agenda_paciente.nm_paciente%type;

BEGIN

if (NEW.nr_seq_person_name is not null) then
  BEGIN
    select 	max(ds_given_name),
			max(ds_component_name_1),
			max(ds_family_name)
    into STRICT	ds_given_name_w,
			ds_component_name_1_w,
			ds_family_name_w
    from	person_name
    where	nr_sequencia = NEW.nr_seq_person_name
    and		ds_type	= 'main';
  end;
    nm_pessoa_montar_w := substr(montar_nm_pessoa_fisica(null, ds_given_name_w, ds_family_name_w, ds_component_name_1_w, NEW.nm_usuario, NEW.nr_seq_person_name),1,60);
  if (trim(both nm_pessoa_montar_w) is  not null) then
    NEW.nm_paciente	:= nm_pessoa_montar_w;
  end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_paciente_before_update() FROM PUBLIC;

CREATE TRIGGER agenda_paciente_before_update
	BEFORE UPDATE ON agenda_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_paciente_before_update();

