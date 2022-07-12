-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_geriatrica_yesavage_tr ON escala_yesavage CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_geriatrica_yesavage_tr() RETURNS trigger AS $BODY$
declare

BEGIN


if (NEW.nr_hora is null) or (NEW.DT_AVALIACAO <> OLD.DT_AVALIACAO) then
	BEGIN
	NEW.nr_hora	:= (to_char(round(NEW.DT_AVALIACAO,'hh24'),'hh24'))::numeric;
	end;
end if;

NEW.qt_pontuacao := 	NEW.ie_satisfeito_vida +
			NEW.ie_interrompeu_atividades +
			NEW.ie_vida_vazia +
			NEW.ie_aborrece_freq +
			NEW.ie_bem_vida +
			NEW.ie_teme_algo_ruim +
			NEW.ie_alegre +
			NEW.ie_desamparado +
			NEW.ie_casa +
			NEW.ie_probl_memoria +
			NEW.ie_marav_vivo +
			NEW.ie_apena_viver +
			NEW.ie_energia +
			NEW.ie_solucao +
			NEW.ie_situacao_melhor;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_geriatrica_yesavage_tr() FROM PUBLIC;

CREATE TRIGGER escala_geriatrica_yesavage_tr
	BEFORE INSERT OR UPDATE ON escala_yesavage FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_geriatrica_yesavage_tr();

