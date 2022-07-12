-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_mirels_atual ON escala_mirels CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_mirels_atual() RETURNS trigger AS $BODY$
DECLARE
    sql_w            varchar(200);
    qt_pontuacao_w   bigint;
    qt_reg_w         smallint;
    ds_erro_w        varchar(4000);
    ds_parametros_w  varchar(4000);
BEGIN
  BEGIN
    IF ( wheb_usuario_pck.get_ie_executar_trigger = 'N' ) THEN
        GOTO final;
    END IF;
    BEGIN
        sql_w := 'CALL OBTER_SCORE_ESCALA_MIRELS_MD(:1, :2, :3, :4) INTO :qt_pontuacao_w';
        EXECUTE sql_w
            USING IN NEW.ie_local, IN NEW.ie_dor, IN NEW.ie_lesao, IN NEW.ie_tamanho, OUT qt_pontuacao_w;

    EXCEPTION
        WHEN OTHERS THEN
      ds_erro_w := sqlerrm;
      ds_parametros_w := (':new.nr_atendimento: '||NEW.nr_atendimento||'-'||':new.cd_profissional: '||NEW.cd_profissional||'-'||':new.ie_situacao: '||NEW.ie_situacao||'-'||
                          ':new.ie_local: '||NEW.ie_local||'-'||':new.ie_dor: '||NEW.ie_dor||'-'||':new.ie_lesao: '||NEW.ie_lesao||'-'||
                          ':new.ie_tamanho: '||NEW.ie_tamanho||'-'||'qt_pontuacao_w: '||qt_pontuacao_w);

      CALL gravar_log_medical_device('escala_mirels_atual','OBTER_SCORE_ESCALA_MIRELS_MD'
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
-- REVOKE ALL ON FUNCTION trigger_fct_escala_mirels_atual() FROM PUBLIC;

CREATE TRIGGER escala_mirels_atual
	BEFORE INSERT OR UPDATE ON escala_mirels FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_mirels_atual();

