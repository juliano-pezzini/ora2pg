-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS w_agenda_proc_adic_atual ON w_agenda_proc_adic CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_w_agenda_proc_adic_atual() RETURNS trigger AS $BODY$
declare

ie_origem_proced_w		bigint;
qt_reg_w	smallint;

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

select	coalesce(min(ie_origem_proced),0)
into STRICT	ie_origem_proced_w
from	procedimento
where	cd_procedimento		= NEW.cd_procedimento
and	ie_origem_proced	= NEW.ie_origem_proced;

if (ie_origem_proced_w	= 0) then
	select	coalesce(min(ie_origem_proced),0)
	into STRICT	ie_origem_proced_w
	from	procedimento
	where	cd_procedimento		= NEW.cd_procedimento;
end if;

if (ie_origem_proced_w <> NEW.ie_origem_proced) then
	NEW.ie_origem_proced	:= ie_origem_proced_w;
end if;
<<Final>>
qt_reg_w	:= 0;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_w_agenda_proc_adic_atual() FROM PUBLIC;

CREATE TRIGGER w_agenda_proc_adic_atual
	BEFORE INSERT OR UPDATE ON w_agenda_proc_adic FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_w_agenda_proc_adic_atual();
