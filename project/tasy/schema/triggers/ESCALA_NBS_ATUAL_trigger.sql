-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_nbs_atual ON escala_nbs CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_nbs_atual() RETURNS trigger AS $BODY$
declare
  qt_ponto_w bigint := 0;
  qt_reg_w   smallint;
  sql_w      varchar(200);
  ds_erro_w   varchar(4000);
  ds_parametro_w  varchar(4000);
BEGIN
  BEGIN
  if (NEW.nr_hora is null) or (NEW.DT_AVALIACAO <> OLD.DT_AVALIACAO) then 
	NEW.nr_hora := (to_char(round(NEW.DT_AVALIACAO,'hh24'), 'hh24'))::numeric;
  end if;

  if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	  goto Final;
  end if;

  if (NEW.QT_GENITAL_MASCULINO	is not null) and (NEW.QT_GENITAL_FEMININO 	is not null) then
	  CALL Wheb_mensagem_pck.exibir_mensagem_abort(261614);
  end if;

  BEGIN
	  sql_w := 'call OBTER_SCORE_ESCALA_NBS_MD(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13) into :qt_ponto_w';

	  EXECUTE sql_w using in NEW.qt_postura, in NEW.qt_angulo_punho, in NEW.qt_retracao_braco, in NEW.qt_popliteo,
									in NEW.qt_sinal_xale, in NEW.qt_calcanhar_orelha, in NEW.qt_olhos_orelhas,
									in NEW.qt_pele, in NEW.qt_lanugo, in NEW.qt_superficie_planar,
									in NEW.qt_glandula_mamaria, in NEW.qt_genital_masculino,
									in NEW.qt_genital_feminino, out qt_ponto_w;
  exception
	when others then
	  qt_ponto_w := null;
      ds_erro_w := sqlerrm;
      ds_parametro_w := ':new.qt_postura: ' || NEW.qt_postura || ' - :new.qt_angulo_punho: ' || NEW.qt_angulo_punho
      || ' - :new.qt_retracao_braco: ' || NEW.qt_retracao_braco || ' - :new.qt_popliteo: ' || NEW.qt_popliteo
      || ' - :new.qt_sinal_xale: ' || NEW.qt_sinal_xale || ' - :new.qt_calcanhar_orelha: ' || NEW.qt_calcanhar_orelha
      || ' - :new.qt_olhos_orelhas: ' || NEW.qt_olhos_orelhas || ' - :new.qt_pele: ' || NEW.qt_pele
      || ' - :new.qt_lanugo: ' || NEW.qt_lanugo || ' - :new.qt_superficie_planar: ' || NEW.qt_superficie_planar
      || ' - :new.qt_glandula_mamaria: ' || NEW.qt_glandula_mamaria || ' - :new.qt_genital_masculino: ' || NEW.qt_genital_masculino
      || ' - :new.qt_genital_feminino: ' || NEW.qt_genital_feminino || ' - qt_ponto_w: ' || qt_ponto_w;
      CALL gravar_log_medical_device('ESCALA_NBS_ATUAL', 'OBTER_SCORE_ESCALA_NBS_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
  end;

  NEW.qt_pontuacao := qt_ponto_w;

  BEGIN
	  sql_w := 'begin PRD_OBTER_SCORE_ESCALA_NBS_MD(:1, :2, :3); end;';

	  EXECUTE sql_w using in NEW.qt_pontuacao,
									out NEW.qt_semanas, 
									out NEW.qt_dias;
  exception
	when others then
	  NEW.qt_semanas := null;
	  NEW.qt_dias    := null;
      ds_erro_w := sqlerrm;
      ds_parametro_w := ':new.qt_pontuacao: ' || NEW.qt_pontuacao || ' - :new.qt_semanas: ' || NEW.qt_semanas
      || ' - :new.qt_dias: ' || NEW.qt_dias;
      CALL gravar_log_medical_device('ESCALA_NBS_ATUAL', 'PRD_OBTER_SCORE_ESCALA_NBS_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
  end;

  if (NEW.dt_liberacao is not null) and (OLD.dt_liberacao is null) then
	  CALL Gerar_IGC_RN(NEW.nr_atendimento,NEW.nm_usuario);
  end if;

  <<Final>>
  qt_reg_w := 0;
  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_nbs_atual() FROM PUBLIC;

CREATE TRIGGER escala_nbs_atual
	BEFORE INSERT OR UPDATE ON escala_nbs FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_nbs_atual();
