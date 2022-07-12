-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_rev_geneva_atual ON escala_rev_geneva CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_rev_geneva_atual() RETURNS trigger AS $BODY$
DECLARE
    qt_score_w       smallint := 0;
    sql_w            varchar(400);
    ds_erro_w        varchar(4000);
    ds_parametros_w  varchar(4000);
BEGIN
  BEGIN
    IF ( wheb_usuario_pck.get_ie_executar_trigger = 'S' ) THEN
        BEGIN
            sql_w := 'call calcular_score_rev_geneva_md(:1, :2, :3, :4, :5, :6, :7, :8, :9) into :qt_score_w';
            EXECUTE sql_w
                USING IN NEW.ie_idade_maior65, IN NEW.ie_tvp_tep_previo, IN NEW.ie_cirurgia_ult_mes, IN NEW.ie_neoplasia_maligna,
                IN NEW.ie_dor_unilateral, IN NEW.ie_hemoptise, IN NEW.ie_fc_7594_bpm, IN NEW.ie_fc_maior94_bpm, IN NEW.ie_edema_unilateral,
                OUT qt_score_w;

        EXCEPTION
            WHEN OTHERS THEN
      ds_erro_w := sqlerrm;
      ds_parametros_w := (':new.nr_atendimento: '||NEW.nr_atendimento||'-'||':new.cd_profissional: '||NEW.cd_profissional||'-'||':new.ie_situacao: '||NEW.ie_situacao||'-'||
                          ':new.ie_idade_maior65: '||NEW.ie_idade_maior65||'-'||':new.ie_tvp_tep_previo: '||NEW.ie_tvp_tep_previo||'-'||':new.ie_cirurgia_ult_mes: '||NEW.ie_cirurgia_ult_mes||'-'||
                          ':new.ie_neoplasia_maligna: '||NEW.ie_neoplasia_maligna||'-'||':new.ie_dor_unilateral: '||NEW.ie_dor_unilateral||'-'||':new.ie_hemoptise: '||NEW.ie_hemoptise||'-'||
                          ':new.ie_fc_7594_bpm: '||NEW.ie_fc_7594_bpm||'-'||':new.ie_fc_maior94_bpm: '||NEW.ie_fc_maior94_bpm||'-'||':new.ie_edema_unilateral: '||NEW.ie_edema_unilateral||'-'||
                          'qt_score_w: '||qt_score_w);

      CALL gravar_log_medical_device('escala_rev_geneva_atual','calcular_score_rev_geneva_md'
                                 ,ds_parametros_w,substr(ds_erro_w, 4000),NEW.nm_usuario,'N');
            
                qt_score_w := NULL;
        END;

        NEW.qt_score := qt_score_w;
    END IF;
  END;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_rev_geneva_atual() FROM PUBLIC;

CREATE TRIGGER escala_rev_geneva_atual
	BEFORE INSERT OR UPDATE ON escala_rev_geneva FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_rev_geneva_atual();
