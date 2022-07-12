-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS exame_lab_material_insert ON exame_lab_material CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_exame_lab_material_insert() RETURNS trigger AS $BODY$
declare

ie_existe_inativ_w        varchar(1);

BEGIN
ie_existe_inativ_w := 'N';

select   CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT     ie_existe_inativ_w
from     material_exame_lab
where    nr_sequencia   = NEW.nr_seq_material
and      ie_situacao   = 'I';

if (ie_existe_inativ_w = 'S') then
  /*este material está inativo. não pode ser incluído.*/

  CALL wheb_mensagem_pck.exibir_mensagem_abort(887397);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_exame_lab_material_insert() FROM PUBLIC;

CREATE TRIGGER exame_lab_material_insert
	BEFORE INSERT ON exame_lab_material FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_exame_lab_material_insert();
