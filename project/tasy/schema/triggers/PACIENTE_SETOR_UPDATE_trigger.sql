-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS paciente_setor_update ON paciente_setor CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_paciente_setor_update() RETURNS trigger AS $BODY$
declare

qt_reg_w	bigint;

pragma autonomous_transaction;

BEGIN

if (NEW.ie_status = 'I') and (OLD.ie_status = 'A') then
	
	select	count(*)
	into STRICT	qt_reg_w
	from	paciente_atendimento a
	where	dt_chegada is not null
	and		ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_chegada) = ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(LOCALTIMESTAMP)
	and		dt_fim_adm is null
	and		a.nr_seq_paciente = NEW.nr_seq_paciente;
	
	if (qt_reg_w	> 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1029223);
	end if;
	
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_paciente_setor_update() FROM PUBLIC;

CREATE TRIGGER paciente_setor_update
	BEFORE UPDATE ON paciente_setor FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_paciente_setor_update();
