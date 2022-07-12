-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_barthel_mod_atual ON escala_barthel_modificada CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_barthel_mod_atual() RETURNS trigger AS $BODY$
declare

BEGIN
NEW.QT_PONTUACAO	:=	coalesce(NEW.IE_COTIDIANO, 0)		+
						coalesce(NEW.IE_ENTENDER, 0)		+
						coalesce(NEW.IE_FAZER_ENTENDER, 0)	+
						coalesce(NEW.IE_ORIENTACAO, 0)		+
						coalesce(NEW.IE_SOCIAL, 0)			+
						coalesce(NEW.IE_VER, 0);
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_barthel_mod_atual() FROM PUBLIC;

CREATE TRIGGER escala_barthel_mod_atual
	BEFORE INSERT ON escala_barthel_modificada FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_barthel_mod_atual();
