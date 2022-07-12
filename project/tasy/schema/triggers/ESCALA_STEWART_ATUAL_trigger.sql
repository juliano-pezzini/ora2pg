-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_stewart_atual ON escala_stewart CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_stewart_atual() RETURNS trigger AS $BODY$
DECLARE
    qt_reg_w         smallint;
    sql_w            varchar(800);
    qt_pontuacao_w   bigint;
    ds_erro_w        varchar(4000);
    ds_parametros_w  varchar(4000);
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
    BEGIN
        sql_w := 'CALL CALCULA_STEWART_MD(:1, :2, :3, :4, :5, :6, :7, :8, :9) INTO :qt_pontuacao_w';
        EXECUTE sql_w
            USING IN NEW.ie_consciencia, IN NEW.ie_via_aerea, IN NEW.ie_movimento, IN NEW.ie_sao2, IN NEW.ie_normotermia, IN NEW.ie_dor_controlada,
            IN NEW.ie_ausencia_vomito, IN NEW.ie_ausencia_sangramento, IN NEW.ie_sinais_estaveis, OUT qt_pontuacao_w;

    EXCEPTION
        WHEN OTHERS THEN
      ds_erro_w := sqlerrm;
      ds_parametros_w := (':new.nr_atendimento: '||NEW.nr_atendimento||'-'||':new.cd_profissional: '||NEW.cd_profissional||'-'||':new.ie_situacao: '||NEW.ie_situacao||'-'||
                          ':new.ie_consciencia: '||NEW.ie_consciencia||'-'||':new.ie_via_aerea: '||NEW.ie_via_aerea||'-'||':new.ie_movimento: '||NEW.ie_movimento||'-'||
                          ':new.ie_sao2: '||NEW.ie_sao2||'-'||':new.ie_normotermia: '||NEW.ie_normotermia||'-'||':new.ie_dor_controlada: '||NEW.ie_dor_controlada||'-'||
                          ':new.ie_ausencia_vomito: '||NEW.ie_ausencia_vomito||'-'||':new.ie_ausencia_sangramento: '||NEW.ie_ausencia_sangramento||'-'||
                          ':new.ie_sinais_estaveis: '||NEW.ie_sinais_estaveis||'-'||'qt_pontuacao_w: '||qt_pontuacao_w);
      CALL gravar_log_medical_device('escala_stewart_atual','CALCULA_STEWART_MD'
                                 ,ds_parametros_w,substr(ds_erro_w, 4000),NEW.nm_usuario,'N');
        
            qt_pontuacao_w := NULL;
    END;

    NEW.qt_pontuacao := qt_pontuacao_w;
    << final >> qt_reg_w := 0;
  END;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_stewart_atual() FROM PUBLIC;

CREATE TRIGGER escala_stewart_atual
	BEFORE INSERT OR UPDATE ON escala_stewart FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_stewart_atual();
