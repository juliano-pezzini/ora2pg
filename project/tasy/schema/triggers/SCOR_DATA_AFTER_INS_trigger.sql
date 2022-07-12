-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS scor_data_after_ins ON scoring_data CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_scor_data_after_ins() RETURNS trigger AS $BODY$
BEGIN

    IF (coalesce(wheb_usuario_pck.get_ie_executar_trigger, 'S') = 'S') THEN
        UPDATE PROCEDIMENTO_PACIENTE
        SET VL_PROCEDIMENTO = 0,
            VL_MEDICO = 0, 
            VL_ANESTESISTA = 0, 
            VL_MATERIAIS = 0, 
            VL_AUXILIARES = 0, 
            VL_CUSTO_OPERACIONAL = 0, 
            VL_ADIC_PLANT = 0, 
            VL_ORIGINAL_TABELA = 0, 
            VL_DESP_TISS = 0, 
            VL_REPASSE_CALC = 0, 
            VL_TX_DESCONTO = 0, 
            VL_TX_ADM = 0, 
            NM_USUARIO = WHEB_USUARIO_PCK.GET_NM_USUARIO,
            DT_ATUALIZACAO = LOCALTIMESTAMP
        WHERE NR_ATENDIMENTO = OBTER_ATENDIMENTO_EPISODIO(NEW.nr_case);
    END IF;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_scor_data_after_ins() FROM PUBLIC;

CREATE TRIGGER scor_data_after_ins
	AFTER INSERT ON scoring_data FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_scor_data_after_ins();

