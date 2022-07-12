-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS sac_grau_satisf_delete ON sac_grau_satisfacao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_sac_grau_satisf_delete() RETURNS trigger AS $BODY$
DECLARE
qt_registro_w		bigint;

BEGIN

select	count(*)
into STRICT	qt_registro_w
from	sac_boletim_ocorrencia
where	ie_grau_satisfacao = OLD.ie_grau_satisfacao;

if (qt_registro_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(311660);
end if;

RETURN OLD;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_sac_grau_satisf_delete() FROM PUBLIC;

CREATE TRIGGER sac_grau_satisf_delete
	BEFORE DELETE ON sac_grau_satisfacao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_sac_grau_satisf_delete();

