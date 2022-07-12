-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_rockall_atual ON escala_rockall CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_rockall_atual() RETURNS trigger AS $BODY$
declare
qt_reg_w	smallint;

BEGIN


if (NEW.nr_hora is null) or (NEW.DT_AVALIACAO <> OLD.DT_AVALIACAO) then
	BEGIN
	NEW.nr_hora	:= (to_char(round(NEW.DT_AVALIACAO,'hh24'),'hh24'))::numeric;
	end;
end if;
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;
if (NEW.qt_idade < 60) then
	NEW.qt_pontos_idade := 0;
elsif (NEW.qt_idade > 80) then
	NEW.qt_pontos_idade := 2;
else
	NEW.qt_pontos_idade := 1;
end if;

if (NEW.qt_pa_sistolica >= 100) and (NEW.qt_freq_cardiaca < 100) then
	NEW.qt_pontos_estado := 0;
elsif (NEW.qt_pa_sistolica >= 100) and (NEW.qt_freq_cardiaca >= 100) then
	NEW.qt_pontos_estado := 1;
else
	NEW.qt_pontos_estado := 2;
end if;

NEW.qt_pontos_doencas_assoc	:=	coalesce(NEW.ie_doencas_associadas,0);
NEW.qt_pontos_diagnostico		:=	coalesce(NEW.ie_diagnostico,0);
NEW.qt_pontos_sinais			:=	coalesce(NEW.ie_sinais_hemorragia,0);
NEW.qt_rockall					:=	NEW.qt_pontos_idade +
									NEW.qt_pontos_estado +
									NEW.qt_pontos_doencas_assoc +
									NEW.qt_pontos_diagnostico +
									NEW.qt_pontos_sinais;
<<Final>>
qt_reg_w	:= 0;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_rockall_atual() FROM PUBLIC;

CREATE TRIGGER escala_rockall_atual
	BEFORE INSERT OR UPDATE ON escala_rockall FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_rockall_atual();
