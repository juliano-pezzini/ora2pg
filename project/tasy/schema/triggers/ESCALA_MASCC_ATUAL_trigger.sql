-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_mascc_atual ON escala_mascc CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_mascc_atual() RETURNS trigger AS $BODY$
declare
    EXEC_w        varchar(200);
    qt_reg_w      smallint;
    qt_pontos_w   bigint := 0;
    ds_erro_w      varchar(4000);
    ds_parametro_w varchar(4000);
BEGIN
  BEGIN
    if (NEW.nr_hora is null) or (NEW.DT_AVALIACAO <> OLD.DT_AVALIACAO) then
        NEW.nr_hora	:= (to_char(round(NEW.DT_AVALIACAO,'hh24'),'hh24'))::numeric;
    end if;

    if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
        goto Final;
    end if;

    BEGIN
        EXEC_w := 'CALL OBTER_SCORE_ESCALA_MASCC_MD(:1, :2, :3, :4, :5, :6, :7) INTO :qt_pontos_w';

        EXECUTE EXEC_w USING  IN NEW.ie_sintoma, 
                                        IN NEW.qt_pas, 
                                        IN NEW.ie_bronquite, 
                                        IN NEW.ie_onco_hematologica, 
                                        IN NEW.ie_hidratacao_endo, 
                                        IN NEW.ie_febre, 
                                        IN NEW.qt_idade, 
                                        OUT qt_pontos_w;
    exception
        when others then
            qt_pontos_w := null;
            ds_erro_w := sqlerrm;
            ds_parametro_w := ':new.nr_atendimento: ' || NEW.nr_atendimento || ' - :new.ie_situacao: ' || NEW.ie_situacao || ' - :new.cd_profissional: ' || NEW.cd_profissional;
            ds_parametro_w := ds_parametro_w || ' - :new.ie_sintoma: ' || NEW.ie_sintoma || ' - :new.qt_pas: ' || NEW.qt_pas || ' - :new.ie_bronquite: ' || NEW.ie_bronquite;
            ds_parametro_w := ds_parametro_w || ' - :new.ie_onco_hematologica: ' || NEW.ie_onco_hematologica || ' - :new.ie_hidratacao_endo: ' || NEW.ie_hidratacao_endo || ' - :new.ie_febre: ' || NEW.ie_febre || ' - :new.qt_idade: ' || NEW.qt_idade;
            ds_parametro_w := ds_parametro_w || ' - qt_pontos_w: ' || qt_pontos_w;
            CALL gravar_log_medical_device('ESCALA_MASCC_ATUAL', 'OBTER_SCORE_ESCALA_MASCC_MD', ds_parametro_w, ds_erro_w, wheb_usuario_pck.get_nm_usuario, 'N');
    end;

    NEW.qt_pontuacao	:= qt_pontos_w;

    <<Final>>
    qt_reg_w	:= 0;

  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_mascc_atual() FROM PUBLIC;

CREATE TRIGGER escala_mascc_atual
	BEFORE INSERT OR UPDATE ON escala_mascc FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_mascc_atual();

