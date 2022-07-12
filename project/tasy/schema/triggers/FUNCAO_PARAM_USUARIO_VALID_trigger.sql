-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS funcao_param_usuario_valid ON funcao_param_usuario CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_funcao_param_usuario_valid() RETURNS trigger AS $BODY$
BEGIN
  IF (wheb_usuario_pck.get_ie_executar_trigger = 'S') and (NEW.cd_funcao = 0) AND (NEW.nr_sequencia = 84) THEN
    IF ((NEW.vl_parametro IS NULL) OR NOT((trim(both NEW.vl_parametro))::numeric  BETWEEN 1 AND 10)) THEN
        CALL Wheb_mensagem_pck.exibir_mensagem_abort(1191978);
    END IF;
  END IF;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_funcao_param_usuario_valid() FROM PUBLIC;

CREATE TRIGGER funcao_param_usuario_valid
	AFTER INSERT OR UPDATE ON funcao_param_usuario FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_funcao_param_usuario_valid();
