-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS regra_retorno_update ON regra_retorno CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_regra_retorno_update() RETURNS trigger AS $BODY$
DECLARE

Contador_w	smallint := 0;

BEGIN

if (NEW.CD_AREA_PROCEDIMENTO is not null) then
	Contador_w := 1;
end if;

if (NEW.CD_ESPECIALIDADE is not null) then
	Contador_w := Contador_w + 1;
end if;

if (NEW.CD_GRUPO_PROC is not null) then
	Contador_w := Contador_w + 1;
end if;

if (NEW.CD_PROCEDIMENTO is not null) then
	Contador_w := Contador_w + 1;
end if;

if (Contador_w > 1) then
	--r.aise_application_error(-20011,'Deve ser informado somente o procedimento ou grupo ou área ou especialidade!');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263430);
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_regra_retorno_update() FROM PUBLIC;

CREATE TRIGGER regra_retorno_update
	BEFORE UPDATE ON regra_retorno FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_regra_retorno_update();

