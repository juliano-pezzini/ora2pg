-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atendimento_sinal_vital_bb ON atendimento_sinal_vital CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atendimento_sinal_vital_bb() RETURNS trigger AS $BODY$
BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
  if (OBTER_SE_INTEGRACAO_ATIVA(960, 245) = 'S') then
    IF (OLD.dt_liberacao is null AND NEW.dt_liberacao is not null AND coalesce(NEW.ie_integracao, 'N') <> 'S') THEN
      CALL integrar_sinais_vitais_bb(
          nr_sequencia_p => NEW.nr_sequencia,
          nr_atendimento_p => NEW.nr_atendimento,
          dt_sinal_vital_p => NEW.dt_sinal_vital,
          qt_freq_cardiaca_p => NEW.qt_freq_cardiaca,
          qt_freq_resp_p => NEW.qt_freq_resp,
          qt_saturacao_o2_p => NEW.qt_saturacao_o2,
          qt_temp_p => NEW.qt_temp,
          qt_pam_p => NEW.qt_pam,
          qt_pa_sistolica_p => NEW.qt_pa_sistolica,
          qt_pa_diastolica_p => NEW.qt_pa_diastolica,
          ie_aparelho_pa_p => NEW.ie_aparelho_pa);
    END IF;

    IF (OLD.dt_inativacao is null AND NEW.dt_inativacao is not null AND (NEW.qt_freq_cardiaca is not null OR
        NEW.qt_freq_resp is not null OR 
        NEW.qt_saturacao_o2 is not null OR 
        NEW.qt_temp is not null OR 
        NEW.qt_pam is not null OR 
        NEW.qt_pa_sistolica is not null OR 
        NEW.qt_pa_diastolica is not null)) THEN
      CALL p_cancelar_flowsheet(NEW.nr_sequencia, NEW.nr_atendimento, 'A');
    END IF;
  end if;
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atendimento_sinal_vital_bb() FROM PUBLIC;

CREATE TRIGGER atendimento_sinal_vital_bb
	AFTER INSERT OR UPDATE ON atendimento_sinal_vital FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atendimento_sinal_vital_bb();
