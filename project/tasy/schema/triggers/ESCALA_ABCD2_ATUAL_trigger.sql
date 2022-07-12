-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_abcd2_atual ON escala_abcd2 CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_abcd2_atual() RETURNS trigger AS $BODY$
declare
    EXEC_w         varchar(200);
    qt_pontuacao_w bigint;
BEGIN
  BEGIN
    if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then
      --INCIO MD

      BEGIN
        EXEC_w := 'CALL CALCULA_ABCD2_MD(:1,:2,:3,:4,:5) INTO :result';

        EXECUTE EXEC_w USING IN NEW.ie_age,
                                       IN NEW.ie_blood_pressure, 
                                       IN NEW.ie_clinical_features, 
                                       IN NEW.ie_symptoms_duration, 
                                       IN NEW.ie_diabetes,
                                       OUT qt_pontuacao_w;
      exception
        when others then
            qt_pontuacao_w := null;
      end;

      NEW.qt_abcd2	:= qt_pontuacao_w;
      --FIM MD

    end if;
  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_abcd2_atual() FROM PUBLIC;

CREATE TRIGGER escala_abcd2_atual
	BEFORE INSERT OR UPDATE ON escala_abcd2 FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_abcd2_atual();

