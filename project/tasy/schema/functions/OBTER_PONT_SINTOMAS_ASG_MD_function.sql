-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pont_sintomas_asg_md ( ie_sem_apetite_p text, ie_nausea_p text, ie_vomito_p text, ie_constipacao_p text, ie_diarreia_p text, ie_ferida_boca_p text, ie_boca_seca_p text, ie_alimento_sem_gosto_p text, ie_cheiro_enjoam_p text, ie_problema_engolir_p text, ie_rapidamente_sat_p text, ie_fadiga_p text, ie_dor_p text, ie_outros_p text ) RETURNS bigint AS $body$
DECLARE

    qt_pontuacao_sint_w           smallint := 0;

BEGIN
    IF ( ie_sem_apetite_p = 'S' ) THEN
        qt_pontuacao_sint_w := qt_pontuacao_sint_w + 3;
    END IF;

    IF ( ie_nausea_p = 'S' ) THEN
        qt_pontuacao_sint_w := qt_pontuacao_sint_w + 1;
    END IF;

    IF ( ie_vomito_p = 'S' ) THEN
        qt_pontuacao_sint_w := qt_pontuacao_sint_w + 3;
    END IF;

    IF ( ie_constipacao_p = 'S' ) THEN
        qt_pontuacao_sint_w := qt_pontuacao_sint_w + 1;
    END IF;

    IF ( ie_diarreia_p = 'S' ) THEN
        qt_pontuacao_sint_w := qt_pontuacao_sint_w + 3;
    END IF;

    IF ( ie_ferida_boca_p = 'S' ) THEN
        qt_pontuacao_sint_w := qt_pontuacao_sint_w + 2;
    END IF;

    IF ( ie_boca_seca_p = 'S' ) THEN
        qt_pontuacao_sint_w := qt_pontuacao_sint_w + 1;
    END IF;

    IF ( ie_alimento_sem_gosto_p = 'S' ) THEN
        qt_pontuacao_sint_w := qt_pontuacao_sint_w + 1;
    END IF;

    IF ( ie_cheiro_enjoam_p = 'S' ) THEN
        qt_pontuacao_sint_w := qt_pontuacao_sint_w + 1;
    END IF;

    IF ( ie_problema_engolir_p = 'S' ) THEN
        qt_pontuacao_sint_w := qt_pontuacao_sint_w + 2;
    END IF;

    IF ( ie_rapidamente_sat_p = 'S' ) THEN
        qt_pontuacao_sint_w := qt_pontuacao_sint_w + 1;
    END IF;

    IF ( ie_fadiga_p = 'S' ) THEN
        qt_pontuacao_sint_w := qt_pontuacao_sint_w + 1;
    END IF;

    IF ( ie_dor_p = 'S' ) THEN
        qt_pontuacao_sint_w := qt_pontuacao_sint_w + 3;
    END IF;

    IF ( ie_outros_p = 'S' ) THEN
        qt_pontuacao_sint_w := qt_pontuacao_sint_w + 1;
    END IF;

    RETURN qt_pontuacao_sint_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pont_sintomas_asg_md ( ie_sem_apetite_p text, ie_nausea_p text, ie_vomito_p text, ie_constipacao_p text, ie_diarreia_p text, ie_ferida_boca_p text, ie_boca_seca_p text, ie_alimento_sem_gosto_p text, ie_cheiro_enjoam_p text, ie_problema_engolir_p text, ie_rapidamente_sat_p text, ie_fadiga_p text, ie_dor_p text, ie_outros_p text ) FROM PUBLIC;

