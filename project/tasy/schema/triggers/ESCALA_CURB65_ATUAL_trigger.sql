-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_curb65_atual ON escala_curb65 CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_curb65_atual() RETURNS trigger AS $BODY$
DECLARE
  sql_w           varchar(200);
  qt_pontuacao_w  smallint;
  qt_reg_w        smallint;
BEGIN
  BEGIN
  IF ( wheb_usuario_pck.get_ie_executar_trigger = 'N' ) THEN
      GOTO final;
  END IF;

  BEGIN
    sql_w := 'CALL OBTER_PONT_ESCALA_CURB_MD(:1, :2, :3, :4, :5) INTO :qt_pontuacao_w';
    EXECUTE sql_w
            USING IN NEW.ie_blood_pressure, IN NEW.ie_freq_resp, IN NEW.ie_alt_consciencia, IN NEW.ie_idade, IN NEW.ie_urea,
            OUT qt_pontuacao_w;

  EXCEPTION
    WHEN OTHERS THEN
      NEW.qt_pontuacao := NULL;
  END;

  NEW.qt_pontuacao := qt_pontuacao_w;
  << final >>
  qt_reg_w := 0;
  END;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_curb65_atual() FROM PUBLIC;

CREATE TRIGGER escala_curb65_atual
	BEFORE INSERT OR UPDATE ON escala_curb65 FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_curb65_atual();
