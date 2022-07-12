-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_pim3_atual ON escala_pim3 CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_pim3_atual() RETURNS trigger AS $BODY$
declare

	qt_reg_w smallint;
	sql_w    varchar(500);
	ds_erro_w   varchar(4000);
	ds_parametro_w  varchar(4000);
BEGIN
  BEGIN

BEGIN

	if (wheb_usuario_pck.get_ie_executar_trigger = 'N')  then
	  goto Final;
	end if;
	
	BEGIN
	  sql_w := 'begin calcular_escala_pim3_md(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15, :16, :17, :18, :19, :20, :21); end;';
	  EXECUTE sql_w using in NEW.ie_resposta_pupilas,  
									in NEW.ie_adm_eletiva,
									in NEW.ie_ventilacao_mecanica,  
									in NEW.qt_base_excess,  
									in NEW.qt_pa_sitolica,  
									in NEW.qt_rel_fio2,
									in NEW.qt_rel_pao2,  
									in NEW.ie_proc_recuperacao,
									in NEW.ie_cirurgia_cardiaca,  
									in NEW.ie_diag_altissimo_risco,
									in NEW.ie_diag_alto_risco,
									in NEW.ie_diag_baixo_risco,
									out NEW.qt_pto_resp_pupilas,
									out NEW.qt_pto_adm_eletiva,
									out NEW.qt_pto_vent_mec,
									out NEW.qt_pto_ph_sangue,
									out NEW.qt_pto_pa_sistolica,
									out NEW.qt_pto_pao2_fio2,
									out NEW.qt_pto_proc_recup,
									out NEW.qt_pto_diag_alto_risco,
									out NEW.qt_tx_mortalidade;
	exception
	when others then
	  NEW.qt_pto_resp_pupilas := null;
	  NEW.qt_pto_adm_eletiva := null;
	  NEW.qt_pto_vent_mec := null;
	  NEW.qt_pto_ph_sangue := null;
	  NEW.qt_pto_pa_sistolica := null;
	  NEW.qt_pto_pao2_fio2 := null;
	  NEW.qt_pto_proc_recup := null;
	  NEW.qt_pto_diag_alto_risco := null;
		NEW.qt_tx_mortalidade := 0;
		ds_erro_w := substr(sqlerrm, 1, 4000);
		ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
		|| ' - :new.ie_resposta_pupilas: ' || NEW.ie_resposta_pupilas || ' - :new.ie_adm_eletiva: ' || NEW.ie_adm_eletiva || ' - :new.ie_ventilacao_mecanica: ' || NEW.ie_ventilacao_mecanica
		|| ' - :new.qt_base_excess: ' || NEW.qt_base_excess || ' - :new.qt_pa_sitolica: ' || NEW.qt_pa_sitolica || ' - :new.qt_rel_fio2: ' || NEW.qt_rel_fio2 || ' - :new.qt_rel_pao2: ' || NEW.qt_rel_pao2
		|| ' - :new.ie_proc_recuperacao: ' || NEW.ie_proc_recuperacao || ' - :new.ie_cirurgia_cardiaca: ' || NEW.ie_cirurgia_cardiaca || ' - :new.ie_diag_altissimo_risco: ' || NEW.ie_diag_altissimo_risco || ' - :new.ie_diag_alto_risco: ' || NEW.ie_diag_alto_risco
		|| ' - :new.ie_diag_baixo_risco: ' || NEW.ie_diag_baixo_risco || ' - :new.qt_pto_resp_pupilas: ' || NEW.qt_pto_resp_pupilas || ' - :new.qt_pto_adm_eletiva: ' || NEW.qt_pto_adm_eletiva || ' - :new.qt_pto_vent_mec: ' || NEW.qt_pto_vent_mec
		|| ' - :new.qt_pto_ph_sangue: ' || NEW.qt_pto_ph_sangue || ' - :new.qt_pto_pa_sistolica: ' || NEW.qt_pto_pa_sistolica || ' - :new.qt_pto_pao2_fio2: ' || NEW.qt_pto_pao2_fio2 || ' - :new.qt_pto_proc_recup: ' || NEW.qt_pto_proc_recup
		|| ' - :new.qt_pto_diag_alto_risco: ' || NEW.qt_pto_diag_alto_risco || ' - :new.qt_tx_mortalidade: ' || NEW.qt_tx_mortalidade, 1, 4000);
		CALL gravar_log_medical_device('ESCALA_PIM3_ATUAL', 'CALCULAR_ESCALA_PIM3_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
	end;

	<<Final>>
	qt_reg_w := 0;

exception
	when others then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(206726);
end;

  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_pim3_atual() FROM PUBLIC;

CREATE TRIGGER escala_pim3_atual
	BEFORE INSERT OR UPDATE ON escala_pim3 FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_pim3_atual();
