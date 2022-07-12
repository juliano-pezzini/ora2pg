-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tempo_procedimento_update ON tempo_procedimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tempo_procedimento_update() RETURNS trigger AS $BODY$
DECLARE
qt_reg_w	smallint;
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;
if (NEW.cd_procedimento is null) and (NEW.ie_origem_proced is not null) then
	NEW.ie_origem_proced := null;
end if;
<<Final>>
qt_reg_w	:= 0;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tempo_procedimento_update() FROM PUBLIC;

CREATE TRIGGER tempo_procedimento_update
	BEFORE UPDATE ON tempo_procedimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tempo_procedimento_update();

