-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS up_ie_suspenso_prescr_proc ON prescr_procedimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_up_ie_suspenso_prescr_proc() RETURNS trigger AS $BODY$
DECLARE
    JSON_PRESC_W PHILIPS_JSON := PHILIPS_JSON();
    JSON_DATA_W text;
    DS_PARAM_INTEG_RES_W text;

BEGIN

	if (wheb_usuario_pck.get_ie_executar_trigger <> 'N') then
	  if (wheb_usuario_pck.is_evento_ativo(996) = 'S') then
		JSON_PRESC_W.PUT('numeroPrescricao', NEW.nr_prescricao);
		dbms_lob.createtemporary(lob_loc => JSON_DATA_W, cache => true, dur => dbms_lob.call);
		JSON_PRESC_W.(JSON_DATA_W);
		DS_PARAM_INTEG_RES_W := BIFROST.SEND_INTEGRATION_CONTENT('standardLabIntegrationSendSuspExamsEvent', JSON_DATA_W, wheb_usuario_pck.get_nm_usuario);
	  end if;
	end if;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_up_ie_suspenso_prescr_proc() FROM PUBLIC;

CREATE TRIGGER up_ie_suspenso_prescr_proc
AFTER UPDATE OF IE_SUSPENSO ON prescr_procedimento FOR EACH ROW
	WHEN (new.ie_suspenso = 'S')
	EXECUTE PROCEDURE trigger_fct_up_ie_suspenso_prescr_proc();
