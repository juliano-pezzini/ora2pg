-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_pelod_atual ON escala_pelod CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_pelod_atual() RETURNS trigger AS $BODY$
declare
cd_pessoa_fisica_w	   varchar(10);
nr_idade_dias_w		     bigint;
nr_idade_meses_w	     bigint;
qt_reg_w	             smallint;
qt_pontuacao_total_w   smallint;
qt_pontuacao_w         smallint;
pr_mortalidade_W       double precision;
sql_w                  varchar(300);
ds_erro_w   varchar(4000);
ds_parametro_w  varchar(4000);
BEGIN
  BEGIN
    if (NEW.nr_hora is null) or (NEW.DT_AVALIACAO <> OLD.DT_AVALIACAO) then
      NEW.nr_hora	:= (to_char(round(NEW.DT_AVALIACAO,'hh24'),'hh24'))::numeric;
    end if;

    if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
      goto Final;
    end if;

    select	cd_pessoa_fisica
    into STRICT	cd_pessoa_fisica_w
    from	atendimento_paciente
    where	nr_atendimento = NEW.nr_atendimento;

    select	coalesce(obter_idade_pf(cd_pessoa_fisica_w, NEW.dt_avaliacao, 'M'),0)
    into STRICT	nr_idade_meses_w
;

    BEGIN
      sql_w := 'CALL OBTER_PTO_FREQ_CARDIACA_MD(:1, :2) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.qt_freq_cardiaca, IN nr_idade_meses_w, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.qt_freq_cardiaca: ' || NEW.qt_freq_cardiaca || ' - nr_idade_meses_w: ' || nr_idade_meses_w || '- qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PTO_FREQ_CARDIACA_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_freq_cardiaca	:= qt_pontuacao_w;

    BEGIN
      sql_w := 'CALL OBTER_PTO_PRESS_SISTOLICA_MD(:1, :2) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.qt_pa_sistolica, IN nr_idade_meses_w, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.qt_pa_sistolica: ' || NEW.qt_pa_sistolica || ' - nr_idade_meses_w: ' || nr_idade_meses_w || '- qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PTO_PRESS_SISTOLICA_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_pa_sistolica	:= qt_pontuacao_w;

    BEGIN
      sql_w := 'CALL OBTER_PONTUACAO_RELACAO_MD(:1) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.qt_rel_pao2_fio2, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.qt_rel_pao2_fio2: ' || NEW.qt_rel_pao2_fio2 || ' - qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PONTUACAO_RELACAO_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_rel_pao2_fio2	:= qt_pontuacao_w;

    BEGIN
      sql_w := 'CALL OBTER_PONTUACAO_PACO2_MD(:1) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.qt_paco2, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.qt_paco2: ' || NEW.qt_paco2 || '- qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PONTUACAO_PACO2_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_paco2	:= qt_pontuacao_w;

    BEGIN
      sql_w := 'CALL OBTER_PTO_VENTIL_MECANICA_MD(:1) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.ie_ventilacao_mecanica, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.ie_ventilacao_mecanica: ' || NEW.ie_ventilacao_mecanica || '- qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PTO_VENTIL_MECANICA_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_vent_mecanica	:= qt_pontuacao_w;

    select	obter_dias_entre_datas(to_date(obter_dados_pf(cd_pessoa_fisica_w, 'DN'),'dd/mm/yyyy'), NEW.dt_avaliacao)
    into STRICT	nr_idade_dias_w
;

    BEGIN
      sql_w := 'CALL OBTER_PTO_CREATINA_SERICA_MD(:1, :2, :3, :4) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.qt_creatinina_serica, IN nr_idade_meses_w, IN NEW.dt_avaliacao, IN nr_idade_dias_w, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.qt_creatinina_serica: ' || NEW.qt_creatinina_serica || '- nr_idade_meses_w: ' || nr_idade_meses_w || ' - :new.dt_avaliacao: ' || NEW.dt_avaliacao
            || ' - nr_idade_dias_w: ' || nr_idade_dias_w || ' - qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PTO_CREATINA_SERICA_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_creatinina_serica	:= qt_pontuacao_w;

    BEGIN
      sql_w := 'CALL OBTER_PTO_ESCALA_GLASGOW_MD(:1) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.qt_glasgow, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.qt_glasgow: ' || NEW.qt_glasgow || '- qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PTO_ESCALA_GLASGOW_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_glasgow	:= qt_pontuacao_w;

    BEGIN
      sql_w := 'CALL OBTER_PTO_REACOES_PUPILAR_MD(:1) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.ie_pupila_fixa, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.ie_pupila_fixa: ' || NEW.ie_pupila_fixa || '- qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PTO_REACOES_PUPILAR_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_pupila_fixa	:= qt_pontuacao_w;

    BEGIN
      sql_w := 'CALL OBTER_PTO_GLOBULO_BRANCOS_MD(:1) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.qt_globulos_brancos, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.qt_globulos_brancos: ' || NEW.qt_globulos_brancos || '- qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PTO_GLOBULO_BRANCOS_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_glob_branco	:= qt_pontuacao_w;

    BEGIN
      sql_w := 'CALL OBTER_PONTUACAO_PLAQUETAS_MD(:1) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.qt_plaquetas, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.qt_plaquetas: ' || NEW.qt_plaquetas || '- qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PONTUACAO_PLAQUETAS_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_plaquetas	:= qt_pontuacao_w;

    BEGIN
      sql_w := 'CALL OBTER_PONTUACAO_TGO_MD(:1) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.qt_tgo, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.qt_tgo: ' || NEW.qt_tgo || '- qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PONTUACAO_TGO_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_tgo	:= qt_pontuacao_w;

    BEGIN
      sql_w := 'CALL OBTER_PTO_TEMP_PROTROMBIN_MD(:1) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.qt_tap_inr, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.qt_tap_inr: ' || NEW.qt_tap_inr || '- qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PTO_TEMP_PROTROMBIN_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_tap_inr	:= qt_pontuacao_w;

    BEGIN
      sql_w := 'CALL OBTER_PTO_CARDIOVASCULAR_MD(:1, :2) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.qt_pto_freq_cardiaca, IN NEW.qt_pto_pa_sistolica, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.qt_pto_freq_cardiaca: ' || NEW.qt_pto_freq_cardiaca || '- :new.qt_pto_pa_sistolica: ' || NEW.qt_pto_pa_sistolica || ' - qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PTO_CARDIOVASCULAR_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_cardio := qt_pontuacao_w;

    BEGIN
      sql_w := 'CALL OBTER_PONTUACAO_PULMONAR_MD(:1, :2, :3) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.qt_pto_rel_pao2_fio2, IN NEW.qt_pto_paco2, IN NEW.qt_pto_vent_mecanica, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.qt_pto_rel_pao2_fio2: ' || NEW.qt_pto_rel_pao2_fio2 || '- :new.qt_pto_paco2: ' || NEW.qt_pto_paco2
            || ' - :new.qt_pto_vent_mecanica: ' || NEW.qt_pto_vent_mecanica || ' - qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PONTUACAO_PULMONAR_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_pulmonar := qt_pontuacao_w;

    BEGIN
      sql_w := 'CALL OBTER_PONTUACAO_HEPATICA_MD(:1, :2) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.qt_pto_tgo, IN NEW.qt_pto_tap_inr, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.qt_pto_tgo: ' || NEW.qt_pto_tgo || '- :new.qt_pto_tap_inr: ' || NEW.qt_pto_tap_inr || ' - qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PONTUACAO_HEPATICA_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_hepatica := qt_pontuacao_w;

    BEGIN
      sql_w := 'CALL OBTER_PTO_SI_NERV_CENTRAL_MD(:1, :2) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.qt_pto_glasgow, IN NEW.qt_pto_pupila_fixa, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.qt_pto_glasgow: ' || NEW.qt_pto_glasgow || '- :new.qt_pto_pupila_fixa: ' || NEW.qt_pto_pupila_fixa || ' - qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PTO_SI_NERV_CENTRAL_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_snc := qt_pontuacao_w;

    NEW.qt_pto_renal := NEW.qt_pto_creatinina_serica;

    BEGIN
      sql_w := 'CALL OBTER_PTO_HEMATOLOGICAL_MD(:1, :2) INTO :qt_pontuacao_w';

      EXECUTE sql_w USING IN NEW.qt_pto_glob_branco, IN NEW.qt_pto_plaquetas, OUT qt_pontuacao_w;
    exception
        when others then
            qt_pontuacao_w := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.qt_pto_glob_branco: ' || NEW.qt_pto_glob_branco || '- :new.qt_pto_plaquetas: ' || NEW.qt_pto_plaquetas || ' - qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PTO_HEMATOLOGICAL_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pto_hematologica := qt_pontuacao_w;

    BEGIN
      sql_w := 'BEGIN OBTER_PONTUACAO_TOTAL_MD(:1, :2, :3, :4, :5, :6, :7, :8); END;';

      EXECUTE sql_w USING IN NEW.qt_pto_cardio, 
                                    IN NEW.qt_pto_pulmonar, 
                                    IN NEW.qt_pto_hepatica, 
                                    IN NEW.qt_pto_snc,
                                    IN NEW.qt_pto_renal, 
                                    IN NEW.qt_pto_hematologica,
                                    OUT qt_pontuacao_total_w, 
                                    OUT pr_mortalidade_w;
    exception
        when others then
            qt_pontuacao_total_w := 0;
            pr_mortalidade_w     := 0;
            ds_erro_w := substr(sqlerrm, 1, 4000);
            ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional
            || ' - :new.qt_pto_cardio: ' || NEW.qt_pto_cardio || '- :new.qt_pto_pulmonar: ' || NEW.qt_pto_pulmonar || ' - :new.qt_pto_hepatica: ' || NEW.qt_pto_hepatica
            || ' - :new.qt_pto_snc: ' || NEW.qt_pto_snc || '- :new.qt_pto_renal: ' || NEW.qt_pto_renal || ' - :new.qt_pto_hematologica: ' || NEW.qt_pto_hematologica
            || ' - qt_pontuacao_total_w: ' || qt_pontuacao_total_w || '- pr_mortalidade_w: ' || pr_mortalidade_w, 1, 4000);
            CALL gravar_log_medical_device('ESCALA_PELOD_ATUAL', 'OBTER_PONTUACAO_TOTAL_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pontuacao   := qt_pontuacao_total_w;
    NEW.pr_mortalidade := pr_mortalidade_W;

    <<Final>>
    qt_reg_w	:= 0;
  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_pelod_atual() FROM PUBLIC;

CREATE TRIGGER escala_pelod_atual
	BEFORE INSERT OR UPDATE ON escala_pelod FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_pelod_atual();
