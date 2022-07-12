-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS update_prescr_medica ON prescr_medica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_update_prescr_medica() RETURNS trigger AS $BODY$
DECLARE
    JSON_PRESC_W PHILIPS_JSON := PHILIPS_JSON();
    JSON_DATA_W text;
    DS_PARAM_INTEG_RES_W text;

BEGIN

	if (wheb_usuario_pck.get_ie_executar_trigger <> 'N') then
		if (wheb_usuario_pck.is_evento_ativo(990) = 'S') then

		   JSON_PRESC_W.PUT('numeroPrescricao', NEW.nr_prescricao);

		   if (wheb_usuario_pck.is_evento_ativo(8) = 'S') then
			  JSON_PRESC_W.PUT('codigoEstabelecimento', NEW.cd_estabelecimento);
		   else
			  JSON_PRESC_W.PUT('codigoEstabelecimento', 0);
		   end if;

		   dbms_lob.createtemporary(lob_loc => JSON_DATA_W, cache => true, dur => dbms_lob.call);
		   JSON_PRESC_W.(JSON_DATA_W);
		   DS_PARAM_INTEG_RES_W := BIFROST.SEND_INTEGRATION_CONTENT('standardLabIntegrationSendExamsEvent', JSON_DATA_W, wheb_usuario_pck.get_nm_usuario);

		end if;
	end if;
	
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_update_prescr_medica() FROM PUBLIC;

CREATE TRIGGER update_prescr_medica
 AFTER UPDATE OF DT_LIBERACAO ON prescr_medica FOR EACH ROW
       
	WHEN (new.dt_liberacao is not null)
	EXECUTE PROCEDURE trigger_fct_update_prescr_medica();

