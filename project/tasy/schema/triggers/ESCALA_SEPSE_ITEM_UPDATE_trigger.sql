-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_sepse_item_update ON escala_sepse_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_sepse_item_update() RETURNS trigger AS $BODY$
DECLARE
    qt_reg_w         smallint;
    sql_w            varchar(200);
    qt_pontuacao_w   bigint;
    ds_erro_w        varchar(4000);
    ds_parametros_w  varchar(4000);
BEGIN
  BEGIN
    IF ( wheb_usuario_pck.get_ie_executar_trigger = 'N' ) THEN
        GOTO final;
    END IF;
    BEGIN
        sql_w := 'CALL OBTER_PONT_ESCALA_SEPSE_MD(:1) INTO :qt_pontuacao_w';
        EXECUTE sql_w
            USING IN NEW.ie_resultado, OUT qt_pontuacao_w;
    EXCEPTION
        WHEN OTHERS THEN
      ds_erro_w := sqlerrm;
      ds_parametros_w := (':new.ie_resultado: '||NEW.ie_resultado||'-'||'qt_pontuacao_w: '||qt_pontuacao_w);
      CALL gravar_log_medical_device('escala_sepse_item_update','OBTER_PONT_ESCALA_SEPSE_MD!'
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
-- REVOKE ALL ON FUNCTION trigger_fct_escala_sepse_item_update() FROM PUBLIC;

CREATE TRIGGER escala_sepse_item_update
	BEFORE UPDATE ON escala_sepse_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_sepse_item_update();
