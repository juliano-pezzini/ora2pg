-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_charlson_tr ON escala_charlson CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_charlson_tr() RETURNS trigger AS $BODY$
declare
qt_ponto_idade_w smallint := 0;
qt_ponto_w	     smallint := 0;
qt_reg_w	     smallint;
qt_idade_w	     bigint;
sql_w            varchar(600);
BEGIN
  BEGIN


if (NEW.nr_hora is null) or (NEW.DT_AVALIACAO <> OLD.DT_AVALIACAO) then
	BEGIN  
	NEW.nr_hora	:= (to_char(round(NEW.DT_AVALIACAO,'hh24'),'hh24'))::numeric;
	end;
end if;
if (wheb_usuario_pck.get_ie_executar_trigger = 'N')  then
	goto final;
end if;
qt_idade_w	:= obter_idade_pf(obter_pessoa_atendimento(NEW.nr_atendimento,'C'),LOCALTIMESTAMP,'A');

--- Inicio MD 1
--pontos = 1
   BEGIN
   sql_w := 'CALL OBTER_PONT_ESCALA_CHARLSON_MD(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15, :16, :17, :18, :19, :20, :21, :22, :23) INTO :qt_ponto_w';

        EXECUTE sql_w USING IN NEW.ie_insuf_cardiac_cong, IN NEW.ie_inf_miocardio, IN NEW.ie_doenca_vasc_per,
                                      IN NEW.ie_doenca_cereb_vasc, IN NEW.ie_demencia, IN NEW.ie_doenca_pulm_cronica,
                                      IN NEW.ie_doenca_tec_conjuntivo, IN NEW.ie_ulcera, IN NEW.ie_cirrose,
                                      IN NEW.ie_diabetes_sem_compl, IN NEW.ie_depressao, IN NEW.ie_varfarina,
                                      IN NEW.ie_hipertensao, IN NEW.ie_hemiplegia, IN NEW.ie_doenca_renal,
                                      IN NEW.ie_diabetes_com_compl, IN NEW.ie_tumor, IN NEW.ie_leucemia,
                                      IN NEW.ie_linfoma, IN NEW.ie_ulcera_celulite, IN NEW.ie_doenca_figado,
                                      IN NEW.ie_tumor_maligno, IN NEW.ie_aids, OUT qt_ponto_w;
    EXCEPTION
        WHEN OTHERS THEN
            qt_ponto_w := null;
    END;
    NEW.qt_pontuacao := qt_ponto_w;

--- Fim MD 1
--- Inicio MD 2
  BEGIN
   sql_w := 'CALL OBTER_PONT_IDADE_ESC_CHARL_MD(:1, :2) INTO :qt_ponto_idade_w';

        EXECUTE sql_w
            USING IN qt_ponto_w, IN qt_idade_w, OUT qt_ponto_idade_w;
    EXCEPTION
        WHEN OTHERS THEN
            qt_ponto_idade_w := NULL;
    END;
    NEW.QT_PONTUACAO_IDADE := qt_ponto_idade_w;
--- Fim MD 2
<<final>>
qt_reg_w := 0;
  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_charlson_tr() FROM PUBLIC;

CREATE TRIGGER escala_charlson_tr
	BEFORE INSERT OR UPDATE ON escala_charlson FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_charlson_tr();

