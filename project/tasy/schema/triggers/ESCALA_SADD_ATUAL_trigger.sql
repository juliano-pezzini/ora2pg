-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_sadd_atual ON escala_sadd CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_sadd_atual() RETURNS trigger AS $BODY$
declare

BEGIN

NEW.QT_PONTUACAO := 	NEW.QT_PENSAMENTO 	+
			NEW.QT_FOME		+
			NEW.QT_FUNCAO		+
			NEW.QT_HORARIO 	+
			NEW.QT_FAVORITA 	+
			NEW.QT_COMPROMISSO 	+
			NEW.QT_PREJUDICIAL 	+
			NEW.QT_CONTROLE 	+
			NEW.QT_PARAR_BEBER 	+
			NEW.QT_MELHORAR 	+
			NEW.QT_TREMOR 		+
			NEW.QT_VOMITO 		+
			NEW.QT_DIA_POSTERIOR 	+
			NEW.QT_IMAGINACAO 	+
			NEW.QT_ESQUECIDO;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_sadd_atual() FROM PUBLIC;

CREATE TRIGGER escala_sadd_atual
	BEFORE INSERT OR UPDATE ON escala_sadd FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_sadd_atual();

