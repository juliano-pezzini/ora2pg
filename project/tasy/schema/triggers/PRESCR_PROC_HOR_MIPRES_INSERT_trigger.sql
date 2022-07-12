-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS prescr_proc_hor_mipres_insert ON prescr_proc_hor CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_prescr_proc_hor_mipres_insert() RETURNS trigger AS $BODY$
DECLARE

nr_atendimento_w	bigint;

pragma autonomous_transaction;
BEGIN
  BEGIN
IF (wheb_usuario_pck.get_ie_executar_trigger	= 'S') THEN
  IF (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'es_CO' AND NEW.dt_lib_horario IS NOT NULL ) THEN
      BEGIN
          SELECT MAX(a.nr_atendimento)
          INTO STRICT nr_atendimento_w
          FROM prescr_medica a
          WHERE a.nr_prescricao = NEW.nr_prescricao;
      EXCEPTION
          WHEN no_data_found then
              nr_atendimento_w := null;
      END;

    
  END IF;
END IF;

  END;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_prescr_proc_hor_mipres_insert() FROM PUBLIC;

CREATE TRIGGER prescr_proc_hor_mipres_insert
	AFTER INSERT OR UPDATE ON prescr_proc_hor FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_prescr_proc_hor_mipres_insert();

