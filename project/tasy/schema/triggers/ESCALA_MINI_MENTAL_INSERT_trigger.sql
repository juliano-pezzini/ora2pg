-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_mini_mental_insert ON escala_mini_mental CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_mini_mental_insert() RETURNS trigger AS $BODY$
DECLARE
    qt_pontuacao_total_w  bigint;
    qt_reg_w              smallint;
    sql_w                 varchar(300);
    ds_erro_w             varchar(4000);
    ds_parametros_w       varchar(4000);
BEGIN
  BEGIN
    CALL consiste_liberacao_escala(101);
    IF ( wheb_usuario_pck.get_ie_executar_trigger = 'N' ) THEN
        GOTO final;
    END IF;
    BEGIN
        sql_w := 'call OBTER_SCOR_ESC_MIN_MENTAL_MD(:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,:14,:15,:16,:17,:18,:19,:20,:21) into :qt_pontuacao_total_w';
        EXECUTE sql_w
            USING IN NEW.ie_dia_semana, IN NEW.ie_dia_mes, IN NEW.ie_mes, IN NEW.ie_ano, IN NEW.ie_hora_aproximada, IN NEW.ie_local_espec,
            IN NEW.ie_instituicao, IN NEW.ie_bairro, IN NEW.ie_cidade, IN NEW.ie_estado, IN NEW.qt_palavra, IN NEW.qt_calculo, 
            IN NEW.qt_evocacao, IN NEW.ie_nomear, IN NEW.ie_repetir, IN NEW.ie_comando, IN NEW.ie_comando_dobre,
            IN NEW.ie_comando_coloque, IN NEW.ie_ler_obedecer, IN NEW.ie_copiar_desenho, IN NEW.ie_escrever, OUT qt_pontuacao_total_w;

    EXCEPTION
        WHEN OTHERS THEN
      ds_erro_w := sqlerrm;
      ds_parametros_w := (':new.nr_atendimento: '||NEW.nr_atendimento||'-'||':new.cd_profissional: '||NEW.cd_profissional||'-'||':new.ie_situacao: '||NEW.ie_situacao||'-'||
                          ':new.ie_dia_semana: '||NEW.ie_dia_semana||'-'||':new.ie_dia_mes: '||NEW.ie_dia_mes||'-'||':new.ie_mes: '||NEW.ie_mes||'-'||
                          ':new.ie_ano: '||NEW.ie_ano||'-'||':new.ie_hora_aproximada: '||NEW.ie_hora_aproximada||'-'||':new.ie_local_espec: '||NEW.ie_local_espec||'-'||
                          ':new.ie_instituicao: '||NEW.ie_instituicao||'-'||':new.ie_bairro: '||NEW.ie_bairro||'-'||':new.ie_cidade: '||NEW.ie_cidade||'-'||
                          ':new.ie_estado: '||NEW.ie_estado||'-'||':new.qt_palavra: '||NEW.qt_palavra||'-'||':new.qt_calculo: '||NEW.qt_calculo||'-'||
                          ':new.qt_evocacao: '||NEW.qt_evocacao||'-'||':new.ie_nomear: '||NEW.ie_nomear||'-'||':new.ie_repetir: '||NEW.ie_repetir||'-'||
                          ':new.ie_comando: '||NEW.ie_comando||'-'||':new.ie_comando_dobre: '||NEW.ie_comando_dobre||'-'||':new.ie_comando_coloque: '||NEW.ie_comando_coloque||'-'||
                          ':new.ie_ler_obedecer: '||NEW.ie_ler_obedecer||'-'||':new.ie_copiar_desenho: '||NEW.ie_copiar_desenho||'-'||':new.ie_escrever: '||NEW.ie_escrever||'-'||
                          'qt_pontuacao_total_w: '||qt_pontuacao_total_w);

      CALL gravar_log_medical_device('escala_mini_mental_insert','OBTER_SCOR_ESC_MIN_MENTAL_MD'
                                 ,ds_parametros_w,substr(ds_erro_w, 4000),NEW.nm_usuario,'N');
        
            qt_pontuacao_total_w := NULL;
    END;

    NEW.qt_score := coalesce(qt_pontuacao_total_w, 0);
    << final >> qt_reg_w := 0;
  END;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_mini_mental_insert() FROM PUBLIC;

CREATE TRIGGER escala_mini_mental_insert
	BEFORE INSERT OR UPDATE ON escala_mini_mental FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_mini_mental_insert();
