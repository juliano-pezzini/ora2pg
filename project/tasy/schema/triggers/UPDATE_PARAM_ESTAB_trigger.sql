-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS update_param_estab ON funcao_param_estab CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_update_param_estab() RETURNS trigger AS $BODY$
declare


pragma autonomous_transaction;


BEGIN

IF position('#@' in NEW.VL_PARAMETRO) > 0 THEN
  CALL wheb_mensagem_pck.exibir_mensagem_abort(1040016);
END IF;

CALL atualizar_log_alt_parametros(
			NEW.nm_usuario,
			NEW.cd_estabelecimento,
			NEW.cd_estabelecimento,
			OLD.cd_estabelecimento,
			null,
			null,
			null,
			null,
			NEW.nr_seq_param,
			NEW.vl_parametro,
			OLD.vl_parametro,
			'E',
			NEW.cd_funcao);
commit;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_update_param_estab() FROM PUBLIC;

CREATE TRIGGER update_param_estab
	BEFORE INSERT OR UPDATE ON funcao_param_estab FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_update_param_estab();

