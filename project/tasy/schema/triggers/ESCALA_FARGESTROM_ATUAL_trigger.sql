-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_fargestrom_atual ON escala_fargestrom CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_fargestrom_atual() RETURNS trigger AS $BODY$
DECLARE
  qt_reg_w	  smallint;
  sql_w       varchar(200);
  qt_pontos_w smallint;
BEGIN
  BEGIN
  if (NEW.nr_hora is null) or (NEW.DT_AVALIACAO <> OLD.DT_AVALIACAO) then
      NEW.nr_hora := (to_char(round(NEW.DT_AVALIACAO, 'hh24'), 'hh24'))::numeric;
  end if;

  if (wheb_usuario_pck.get_ie_executar_trigger	= 'N') then
    goto Final;
  end if;

  BEGIN
      sql_w := 'call OBTER_SCORE_ESCALA_FARG_MD(:1,:2,:3,:4,:5,:6) into :qt_pontos_w';

      EXECUTE sql_w using in NEW.ie_lugar_proibido,
                                    in NEW.ie_satisfacao,
                                    in NEW.qt_cigarro_dia,
                                    in NEW.ie_freq_manha,
                                    in NEW.ie_fuma_doente,
                                    in NEW.ie_apos_acordar,
                                    out qt_pontos_w;
  exception
    when others then
          qt_pontos_w := null;
  end;

  NEW.qt_pontos := qt_pontos_w;

  <<Final>>
  qt_reg_w := 0;
  END;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_fargestrom_atual() FROM PUBLIC;

CREATE TRIGGER escala_fargestrom_atual
	BEFORE INSERT OR UPDATE ON escala_fargestrom FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_fargestrom_atual();

