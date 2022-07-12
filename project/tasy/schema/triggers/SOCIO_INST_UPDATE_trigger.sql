-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS socio_inst_update ON socio_inst CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_socio_inst_update() RETURNS trigger AS $BODY$
BEGIN

IF (wheb_usuario_pck.get_ie_executar_trigger = 'S') THEN
	IF (NEW.CD_PESSOA_FISICA IS NOT NULL AND NEW.CD_CGC IS NOT NULL) THEN
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1195491);
	END IF;
END IF;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_socio_inst_update() FROM PUBLIC;

CREATE TRIGGER socio_inst_update
	BEFORE INSERT OR UPDATE ON socio_inst FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_socio_inst_update();

