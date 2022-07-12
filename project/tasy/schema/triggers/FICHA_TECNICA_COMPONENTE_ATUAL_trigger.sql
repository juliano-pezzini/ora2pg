-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ficha_tecnica_componente_atual ON ficha_tecnica_componente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ficha_tecnica_componente_atual() RETURNS trigger AS $BODY$
declare

BEGIN

if (NEW.cd_procedimento is not null) and (NEW.ie_origem_proced is null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(266640);
	/*O Procedimento deve ser localizado para que traga a origem do mesmo');*/

end if;
update	ficha_tecnica
set	dt_alteracao	= LOCALTIMESTAMP
where	nr_ficha_tecnica	= NEW.nr_ficha_tecnica;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ficha_tecnica_componente_atual() FROM PUBLIC;

CREATE TRIGGER ficha_tecnica_componente_atual
	BEFORE INSERT OR UPDATE ON ficha_tecnica_componente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ficha_tecnica_componente_atual();

