-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_sofa_befins ON escala_sofa CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_sofa_befins() RETURNS trigger AS $BODY$
DECLARE
    qt_reg_w              smallint;
    sql_w                 varchar(4000);
    qt_pontuacao_w        bigint;
    qt_pontuacao_total_w  smallint;
    ds_erro_w             varchar(4000);
    ds_parametros_w       varchar(4000);
BEGIN
  BEGIN
    IF ( NEW.nr_hora IS NULL ) OR ( NEW.dt_avaliacao <> OLD.dt_avaliacao ) THEN
        BEGIN
            NEW.nr_hora := (to_char(round(NEW.dt_avaliacao, 'hh24'), 'hh24'))::numeric;

        END;
    END IF;

    IF ( wheb_usuario_pck.get_ie_executar_trigger = 'N' ) THEN
        GOTO final;
    END IF;

/* Pontuacao relacao Pa02/FiO2 */

    BEGIN
        sql_w := 'call obter_pont_sofa_befing_md(:1) into :qt_pontuacao_w';
        EXECUTE sql_w
            USING IN NEW.qt_rel_pao2_fio2, OUT qt_pontuacao_w;
    EXCEPTION
        WHEN OTHERS THEN
      ds_erro_w := sqlerrm;
      ds_parametros_w := (':new.nr_atendimento: '||NEW.nr_atendimento||'-'||':new.cd_profissional: '||NEW.cd_profissional||'-'||':new.ie_situacao: '||NEW.ie_situacao||'-'||
                          ':new.qt_rel_pao2_fio2: '||NEW.qt_rel_pao2_fio2||'-'||'qt_pontuacao_w: '||qt_pontuacao_w);
      CALL gravar_log_medical_device('escala_sofa_befins','obter_pont_sofa_befing_md'
                                 ,ds_parametros_w,substr(ds_erro_w, 4000),NEW.nm_usuario,'N');
        
            qt_pontuacao_w := 0;
    END;

    NEW.qt_pto_resp := qt_pontuacao_w;

/* Pontuacao Contagem de plaquetas */

    BEGIN
        sql_w := 'call obter_pon_plaq_sofa_befing_md(:1) into :qt_pontuacao_w';
        EXECUTE sql_w
            USING IN NEW.qt_plaquetas, OUT qt_pontuacao_w;
    EXCEPTION
        WHEN OTHERS THEN
      ds_erro_w := sqlerrm;
      ds_parametros_w := (':new.nr_atendimento: '||NEW.nr_atendimento||'-'||':new.cd_profissional: '||NEW.cd_profissional||'-'||':new.ie_situacao: '||NEW.ie_situacao||'-'||
                          ':new.qt_plaquetas: '||NEW.qt_plaquetas||'-'||'qt_pontuacao_w: '||qt_pontuacao_w);
      CALL gravar_log_medical_device('escala_sofa_befins','obter_pon_plaq_sofa_befing_md'
                                 ,ds_parametros_w,substr(ds_erro_w, 4000),NEW.nm_usuario,'N');

            qt_pontuacao_w := 0;
    END;

    NEW.qt_pto_coag := qt_pontuacao_w;

/* Pontuacao Bilirrubina serica */

    BEGIN
        sql_w := 'call obter_pont_bil_sofa_befing_md(:1) into :qt_pontuacao_w';
        EXECUTE sql_w
            USING IN NEW.qt_bilirrubina_serica, OUT qt_pontuacao_w;
    EXCEPTION
        WHEN OTHERS THEN
      ds_erro_w := sqlerrm;
      ds_parametros_w := (':new.nr_atendimento: '||NEW.nr_atendimento||'-'||':new.cd_profissional: '||NEW.cd_profissional||'-'||':new.ie_situacao: '||NEW.ie_situacao||'-'||
                          ':new.qt_bilirrubina_serica: '||NEW.qt_bilirrubina_serica||'-'||'qt_pontuacao_w: '||qt_pontuacao_w);
      CALL gravar_log_medical_device('escala_sofa_befins','obter_pont_bil_sofa_befing_md'
                                 ,ds_parametros_w,substr(ds_erro_w, 4000),NEW.nm_usuario,'N');

            qt_pontuacao_w := 0;
    END;

    NEW.qt_pto_figado := qt_pontuacao_w;

/* Pontuacao para Hipotensao */

    BEGIN
        sql_w := 'call obter_pont_hip_sofa_befing_md(:1, :2) into :qt_pontuacao_w';
        EXECUTE sql_w
            USING IN NEW.qt_pa_diastolica, IN NEW.qt_pa_sistolica, OUT qt_pontuacao_w;

    EXCEPTION
        WHEN OTHERS THEN
      ds_erro_w := sqlerrm;
      ds_parametros_w := (':new.nr_atendimento: '||NEW.nr_atendimento||'-'||':new.cd_profissional: '||NEW.cd_profissional||'-'||':new.ie_situacao: '||NEW.ie_situacao||'-'||
                          ':new.qt_pa_diastolica: '||NEW.qt_pa_diastolica||'-'||':new.qt_pa_sistolica: '||NEW.qt_pa_sistolica||'-'||'qt_pontuacao_w: '||qt_pontuacao_w);
      CALL gravar_log_medical_device('escala_sofa_befins','obter_pont_hip_sofa_befing_md'
                                 ,ds_parametros_w,substr(ds_erro_w, 4000),NEW.nm_usuario,'N');

            qt_pontuacao_w := 0;
    END;

    NEW.qt_pam := qt_pontuacao_w;
    BEGIN
        sql_w := 'call obter_pont_car_sofa_befing_md(:1, :2, :3, :4, :5) into :qt_pontuacao_w';
        EXECUTE sql_w
            USING IN NEW.ie_dobutamina, IN NEW.qt_pam, IN NEW.ie_noradrenalina, IN NEW.ie_adrenalina, IN NEW.ie_dopamina, OUT qt_pontuacao_w;

    EXCEPTION
        WHEN OTHERS THEN
      ds_erro_w := sqlerrm;
      ds_parametros_w := (':new.nr_atendimento: '||NEW.nr_atendimento||'-'||':new.cd_profissional: '||NEW.cd_profissional||'-'||':new.ie_situacao: '||NEW.ie_situacao||'-'||
                          ':new.ie_dobutamina: '||NEW.ie_dobutamina||'-'||':new.qt_pam: '||NEW.qt_pam||'-'||':new.ie_noradrenalina: '||NEW.ie_noradrenalina||'-'||
                          ':new.ie_adrenalina: '||NEW.ie_adrenalina||'-'||':new.ie_dopamina: '||NEW.ie_dopamina||'-'||'qt_pontuacao_w: '||qt_pontuacao_w);
      CALL gravar_log_medical_device('escala_sofa_befins','obter_pont_car_sofa_befing_md'
                                 ,ds_parametros_w,substr(ds_erro_w, 4000),NEW.nm_usuario,'N');

            qt_pontuacao_w := 0;
    END;

    NEW.qt_pto_cardio := qt_pontuacao_w;

/* Pontuacao Glasgow */

    BEGIN
        sql_w := 'call obter_pont_gla_sofa_befing_md(:1) into :qt_pontuacao_w';
        EXECUTE sql_w
            USING IN NEW.qt_glasgow, OUT qt_pontuacao_w;
    EXCEPTION
        WHEN OTHERS THEN
      ds_erro_w := sqlerrm;
      ds_parametros_w := (':new.nr_atendimento: '||NEW.nr_atendimento||'-'||':new.cd_profissional: '||NEW.cd_profissional||'-'||':new.ie_situacao: '||NEW.ie_situacao||'-'||
                          ':new.qt_glasgow: '||NEW.qt_glasgow||'-'||'qt_pontuacao_w: '||qt_pontuacao_w);
      CALL gravar_log_medical_device('escala_sofa_befins','obter_pont_gla_sofa_befing_md'
                                 ,ds_parametros_w,substr(ds_erro_w, 4000),NEW.nm_usuario,'N');

            qt_pontuacao_w := 0;
    END;

    NEW.qt_pto_snc := qt_pontuacao_w;

/* Pontuacao Creatinina Serica ou Diurese */

    BEGIN
        sql_w := 'call obter_pont_cre_sofa_befing_md(:1, :2) into :qt_pontuacao_w';
        EXECUTE sql_w
            USING IN NEW.qt_creatinina_serica, IN NEW.qt_diurese, OUT qt_pontuacao_w;

    EXCEPTION
        WHEN OTHERS THEN
      ds_erro_w := sqlerrm;
      ds_parametros_w := (':new.nr_atendimento: '||NEW.nr_atendimento||'-'||':new.cd_profissional: '||NEW.cd_profissional||'-'||':new.ie_situacao: '||NEW.ie_situacao||'-'||
                          ':new.qt_creatinina_serica: '||NEW.qt_creatinina_serica||'-'||':new.qt_diurese: '||NEW.qt_diurese||'-'||'qt_pontuacao_w: '||qt_pontuacao_w);
      CALL gravar_log_medical_device('escala_sofa_befins','obter_pont_cre_sofa_befing_md'
                                 ,ds_parametros_w,substr(ds_erro_w, 4000),NEW.nm_usuario,'N');

            qt_pontuacao_w := 0;
    END;

    NEW.qt_pto_renal := qt_pontuacao_w;

/* Obter a pontuacao total */

    BEGIN
        sql_w := 'call obter_total_sofa_befing_md(:1, :2, :3, :4, :5, :6) into :qt_pontuacao_total_w';
        EXECUTE sql_w
            USING IN NEW.qt_pto_resp, IN NEW.qt_pto_coag, IN NEW.qt_pto_figado, IN NEW.qt_pto_cardio, IN NEW.qt_pto_snc, IN NEW.qt_pto_renal,
            OUT qt_pontuacao_total_w;

    EXCEPTION
        WHEN OTHERS THEN
      ds_erro_w := sqlerrm;
      ds_parametros_w := (':new.nr_atendimento: '||NEW.nr_atendimento||'-'||':new.cd_profissional: '||NEW.cd_profissional||'-'||':new.ie_situacao: '||NEW.ie_situacao||'-'||
                          ':new.qt_pto_resp: '||NEW.qt_pto_resp||'-'||':new.qt_pto_coag: '||NEW.qt_pto_coag||'-'||':new.qt_pto_figado: '||NEW.qt_pto_figado||'-'||
                          ':new.qt_pto_cardio: '||NEW.qt_pto_cardio||'-'||':new.qt_pto_snc: '||NEW.qt_pto_snc||'-'||':new.qt_pto_renal: '||NEW.qt_pto_renal||'-'||
                          'qt_pontuacao_w: '||qt_pontuacao_w);
      CALL gravar_log_medical_device('escala_sofa_befins','obter_total_sofa_befing_md'
                                 ,ds_parametros_w,substr(ds_erro_w, 4000),NEW.nm_usuario,'N');

            qt_pontuacao_total_w := 0;
    END;

    NEW.qt_pontuacao := qt_pontuacao_total_w;
    IF ( OLD.dt_liberacao IS NULL )
        AND ( NEW.dt_liberacao IS NOT NULL )
    THEN
        CALL send_sofa_integration(NEW.nr_atendimento, NEW.nr_sequencia, NEW.dt_liberacao, NEW.dt_avaliacao, NEW.qt_rel_pao2_fio2,
                             NEW.ie_dopamina,
                             NEW.qt_pam,
                             NEW.ie_dobutamina,
                             NEW.ie_noradrenalina,
                             NEW.qt_plaquetas,
                             NEW.qt_creatinina_serica,
                             NEW.qt_bilirrubina_serica,
                             NEW.qt_glasgow,
                             NEW.qt_pa_sistolica);
    END IF;

    << final >> qt_reg_w := 0;
  END;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_sofa_befins() FROM PUBLIC;

CREATE TRIGGER escala_sofa_befins
	BEFORE INSERT OR UPDATE ON escala_sofa FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_sofa_befins();

