-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS update_dt_evt_prescr_medica ON prescr_medica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_update_dt_evt_prescr_medica() RETURNS trigger AS $BODY$
declare

BEGIN
if	wheb_usuario_pck.get_ie_executar_trigger = 'S' then

  if (OLD.nr_seq_pend_pac_acao is null and NEW.nr_seq_pend_pac_acao is not null) then

    if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then
      CALL update_dt_exec_prt_int_pac_evt(NEW.nr_seq_pend_pac_acao, NEW.dt_atualizacao);
    end if;

  end if;

end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_update_dt_evt_prescr_medica() FROM PUBLIC;

CREATE TRIGGER update_dt_evt_prescr_medica
	AFTER INSERT OR UPDATE ON prescr_medica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_update_dt_evt_prescr_medica();

