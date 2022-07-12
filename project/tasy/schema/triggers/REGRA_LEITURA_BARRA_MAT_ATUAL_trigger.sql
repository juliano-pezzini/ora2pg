-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS regra_leitura_barra_mat_atual ON regra_leitura_barra_mat CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_regra_leitura_barra_mat_atual() RETURNS trigger AS $BODY$
declare

BEGIN

if (NEW.ie_tipo_requisicao is not null) then
	BEGIN

	if (coalesce(NEW.cd_funcao,0) <> 109) then
		BEGIN
		NEW.ie_tipo_requisicao := null;
		end;
	end if;

	end;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_regra_leitura_barra_mat_atual() FROM PUBLIC;

CREATE TRIGGER regra_leitura_barra_mat_atual
	BEFORE INSERT OR UPDATE ON regra_leitura_barra_mat FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_regra_leitura_barra_mat_atual();
