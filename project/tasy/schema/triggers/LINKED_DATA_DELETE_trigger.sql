-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS linked_data_delete ON linked_data CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_linked_data_delete() RETURNS trigger AS $BODY$
DECLARE
  qt_reg_w smallint;
BEGIN
  IF (wheb_usuario_pck.get_ie_executar_trigger = 'N') THEN
    GOTO FINAL;
  END IF;

  IF OLD.ie_template = 'S' THEN
    CALL wheb_mensagem_pck.exibir_mensagem_abort(449833);
  END IF;

  <<final>>
  qt_reg_w := 0;
RETURN OLD;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_linked_data_delete() FROM PUBLIC;

CREATE TRIGGER linked_data_delete
	BEFORE DELETE ON linked_data FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_linked_data_delete();
