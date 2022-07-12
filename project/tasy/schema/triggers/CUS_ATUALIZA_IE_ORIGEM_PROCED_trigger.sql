-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cus_atualiza_ie_origem_proced ON custo_procedimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cus_atualiza_ie_origem_proced() RETURNS trigger AS $BODY$
declare
qt_registro_w		bigint;
BEGIN
  BEGIN

if (NEW.cd_procedimento is not null) 	then
	select 	count(*)
	into STRICT 	qt_registro_w
	from 	procedimento
	where 	cd_procedimento = NEW.cd_procedimento;

	if (qt_registro_w = 1) and (NEW.ie_origem_proced is null) then
		BEGIN
		select	ie_origem_proced
		into STRICT	NEW.ie_origem_proced
		from	procedimento
		where	cd_procedimento = NEW.cd_procedimento;
		exception when others then
			NEW.ie_origem_proced	:= null;
		end;
	end if;

end if;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cus_atualiza_ie_origem_proced() FROM PUBLIC;

CREATE TRIGGER cus_atualiza_ie_origem_proced
	BEFORE INSERT OR UPDATE ON custo_procedimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cus_atualiza_ie_origem_proced();
