-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_idv_atual ON escala_idv CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_idv_atual() RETURNS trigger AS $BODY$
declare
  qt_pontuacao_w bigint := 0;
  qt_reg_w       smallint;
  ds_erro_w      varchar(4000);
  ds_parametro_w varchar(4000);
  sql_w          varchar(4000);
BEGIN
  BEGIN
  if (NEW.nr_hora is null) or (NEW.dt_avaliacao <> OLD.dt_avaliacao) then
    NEW.nr_hora	:= (to_char(round(NEW.dt_avaliacao,'hh24'),'hh24'))::numeric;
  end if; 	

  if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
      goto Final;
  end if;

  BEGIN
      sql_w := 'call obter_score_escala_idv_md(:1,:2,:3,:4,:5,:6,:7,:8,:9,:10) into :qt_pontuacao_w';

      EXECUTE sql_w using in NEW.qt_glasgow, 
                                    in NEW.qt_fio2, 
                                    in NEW.qt_pao2, 
                                    in NEW.qt_paco2, 
                                    in NEW.pr_saturacao, 
                                    in NEW.qt_volume_corrente, 
                                    in NEW.qt_freq_respiratoria, 
                                    in NEW.qt_pressao_insp,
                                    in NEW.qt_pressao_sup, 
                                    in NEW.qt_ano,
                                    out qt_pontuacao_w;
  exception
      when others then
        ds_erro_w := substr(sqlerrm, 1, 4000);
        ds_parametro_w := substr(':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional ||
								 ' - :new.qt_glasgow: ' || NEW.qt_glasgow || ' - :new.qt_fio2: ' || NEW.qt_fio2 || ' - :new.qt_pao2: ' || NEW.qt_pao2 || ' - :new.qt_paco2: ' || NEW.qt_paco2 || 
								 ' - :new.pr_saturacao: ' || NEW.pr_saturacao || ' - :new.qt_volume_corrente: ' || NEW.qt_volume_corrente || ' - :new.qt_freq_respiratoria: ' || NEW.qt_freq_respiratoria || 
								 ' - :new.qt_pressao_insp: ' || NEW.QT_PRESSAO_INSP || ' - :new.QT_PRESSAO_SUP: ' || NEW.QT_PRESSAO_SUP || ' - :new.qt_ano: ' || NEW.qt_ano || ' - qt_pontuacao_w: ' || qt_pontuacao_w, 1, 4000);
        CALL gravar_log_medical_device('ESCALA_IDV_ATUAL', 'OBTER_SCORE_ESCALA_IDV_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
        qt_pontuacao_w := null;
  end;

  NEW.qt_pontuacao	:= qt_pontuacao_w;

  <<Final>>
  qt_reg_w	:= 0;
  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_idv_atual() FROM PUBLIC;

CREATE TRIGGER escala_idv_atual
	BEFORE INSERT OR UPDATE ON escala_idv FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_idv_atual();
