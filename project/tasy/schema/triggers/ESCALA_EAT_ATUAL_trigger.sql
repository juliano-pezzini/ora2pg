-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_eat_atual ON escala_eat CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_eat_atual() RETURNS trigger AS $BODY$
declare

  qt_reg_w	      bigint;
  sql_w           varchar(200);
  qt_pontuacao_w  smallint;
  ds_erro_w      varchar(4000);
  ds_parametro_w varchar(4000);
BEGIN
  BEGIN

  if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
    goto Final;
  end if;

  /** Medical Device **/


  BEGIN
    sql_w := 'call OBTER_SCORE_ESCALA_EAT_MD(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10) into :qt_pontuacao_w';
    EXECUTE sql_w using  in NEW.ie_engolir_perda_peso,
                                   in NEW.ie_engolir_fora_casa,
                                   in NEW.ie_forca_beber_liq,
                                   in NEW.ie_forca_comer,
                                   in NEW.ie_forca_remedio,
                                   in NEW.ie_dor_engolir,
                                   in NEW.ie_prazer_comer,
                                   in NEW.ie_comida_presa,
                                   in NEW.ie_tusso,
                                   in NEW.ie_estressado,			
                                  out qt_pontuacao_w;
  exception
    when others then
	  qt_pontuacao_w := null;
    ds_erro_w := sqlerrm;
    ds_parametro_w := ':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional;
    ds_parametro_w := ds_parametro_w || ' - :new.ie_engolir_perda_peso: ' || NEW.ie_engolir_perda_peso || ' - :new.ie_engolir_fora_casa: ' || NEW.ie_engolir_fora_casa || ' - :new.ie_forca_beber_liq: ' || NEW.ie_forca_beber_liq;
    ds_parametro_w := ds_parametro_w || ' - :new.ie_forca_comer: ' || NEW.ie_forca_comer || ' - :new.ie_forca_remedio: ' || NEW.ie_forca_remedio || ' - :new.ie_dor_engolir: ' || NEW.ie_dor_engolir || ' - :new.ie_prazer_comer: ' || NEW.ie_prazer_comer;
    ds_parametro_w := ds_parametro_w || ' - :new.ie_comida_presa: ' || NEW.ie_comida_presa || ' - :new.ie_tusso: ' || NEW.ie_tusso || ' - :new.ie_estressado: ' || NEW.ie_estressado || ' - qt_pontuacao_w: ' || qt_pontuacao_w;
    CALL gravar_log_medical_device('ESCALA_EAT_ATUAL', 'OBTER_SCORE_ESCALA_EAT_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
  end;

  NEW.qt_pontuacao := qt_pontuacao_w;

  <<Final>>
  qt_reg_w := 0;

  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_eat_atual() FROM PUBLIC;

CREATE TRIGGER escala_eat_atual
	BEFORE INSERT OR UPDATE ON escala_eat FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_eat_atual();
