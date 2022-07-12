-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS projeto_recurso_atual ON projeto_recurso CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_projeto_recurso_atual() RETURNS trigger AS $BODY$
DECLARE

BEGIN

if (NEW.IE_TIPO_PROJETO = 'P') and (NEW.NR_SEQ_SUPERIOR is not null) then
	CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(249182);
end if;

if (NEW.IE_TIPO_PROJETO = 'S') and (NEW.NR_SEQ_SUPERIOR is null) then
	CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(249180);
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_projeto_recurso_atual() FROM PUBLIC;

CREATE TRIGGER projeto_recurso_atual
	AFTER INSERT OR UPDATE ON projeto_recurso FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_projeto_recurso_atual();
