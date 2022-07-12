-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_dini_atual ON escala_dini CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_dini_atual() RETURNS trigger AS $BODY$
declare
  qt_reg_w       smallint;
  qt_pontuacao_w smallint;
  sql_w          varchar(200);
  ds_erro_w      varchar(4000);
  ds_parametro_w varchar(4000);
BEGIN
  BEGIN
 
  if (NEW.nr_hora is null) or (NEW.DT_AVALIACAO <> OLD.DT_AVALIACAO) then
    BEGIN  
	  NEW.nr_hora := (to_char(round(NEW.DT_AVALIACAO, 'hh24'), 'hh24'))::numeric;
    end;
  end if;

  if (wheb_usuario_pck.get_ie_executar_trigger	= 'N') then 
    goto Final;
  end if;
  /** Medical Device **/

  BEGIN
    sql_w := 'call obter_score_escala_dini_md(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11) into :qt_pontuacao_w';

    EXECUTE sql_w using  in NEW.ie_atividade,
                                   in NEW.ie_interv_controles,
                                   in NEW.ie_oxigenacao,
                                   in NEW.ie_terapeutica_medic,
                                   in NEW.ie_integridade_mucosa,
                                   in NEW.ie_alimentacao_hidrat,
                                   in NEW.ie_eliminacoes,
                                   in NEW.ie_higiene_corporal,
                                   in NEW.ie_mobilidade,
                                   in NEW.ie_part_acompanhante,
                                   in NEW.ie_rede_apoio_suporte,			
                                  out qt_pontuacao_w;
  exception
    when others then
	  qt_pontuacao_w := 0;
    ds_erro_w := sqlerrm;
    ds_parametro_w := ':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional;
    ds_parametro_w := ds_parametro_w || ' - :new.ie_atividade: ' || NEW.ie_atividade || ' - :new.ie_interv_controles: ' || NEW.ie_interv_controles || ' - :new.ie_oxigenacao: ' || NEW.ie_oxigenacao;
    ds_parametro_w := ds_parametro_w || ' - :new.ie_terapeutica_medic: ' || NEW.ie_terapeutica_medic || ' - :new.ie_integridade_mucosa: ' || NEW.ie_integridade_mucosa || ' - :new.ie_alimentacao_hidrat: ' || NEW.ie_alimentacao_hidrat || ' - :new.ie_eliminacoes: ' || NEW.ie_eliminacoes;
    ds_parametro_w := ds_parametro_w || ' - :new.ie_higiene_corporal: ' || NEW.ie_higiene_corporal || ' - :new.ie_mobilidade: ' || NEW.ie_mobilidade || ' - :new.ie_part_acompanhante: ' || NEW.ie_part_acompanhante || ' - :new.ie_rede_apoio_suporte: ' || NEW.ie_rede_apoio_suporte || ' - qt_pontuacao_w: ' || qt_pontuacao_w;
    CALL gravar_log_medical_device('ESCALA_DINI_ATUAL', 'OBTER_SCORE_ESCALA_DINI_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
  end;

  NEW.qt_pontuacao := qt_pontuacao_w;

  <<Final>>
  qt_reg_w := 0;
 
 
  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_dini_atual() FROM PUBLIC;

CREATE TRIGGER escala_dini_atual
	BEFORE INSERT OR UPDATE ON escala_dini FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_dini_atual();
