-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS funcao_param_perfil_subject ON funcao_param_perfil CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_funcao_param_perfil_subject() RETURNS trigger AS $BODY$
COMPOUND TRIGGER
  apply_sync   boolean := false;
  AFTER EACH ROW IS BEGIN
    apply_sync := psa_is_auth_parameter(
      NEW.cd_funcao,
      NEW.nr_sequencia
    ) = 'TRUE' OR apply_sync;
  END AFTER EACH ROW;
  AFTER STATEMENT IS BEGIN
    IF
      apply_sync
    THEN
      psa_synchronize_subject;
    END IF;
  END AFTER STATEMENT;
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_funcao_param_perfil_subject() FROM PUBLIC;

CREATE TRIGGER funcao_param_perfil_subject
	COMPOUND INSERT OR UPDATE OR DELETE ON funcao_param_perfil FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_funcao_param_perfil_subject();
