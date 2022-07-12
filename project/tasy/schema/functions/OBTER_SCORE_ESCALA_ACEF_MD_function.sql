-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_escala_acef_md ( qt_idade_p bigint, qt_fracao_ejecao_p bigint, qt_creatinina_serica_p bigint ) RETURNS bigint AS $body$
DECLARE

    qt_score_w real := 0;

BEGIN
    qt_score_w := dividir_md(qt_idade_p, qt_fracao_ejecao_p);
    IF ( qt_creatinina_serica_p >= 2 ) THEN
        qt_score_w := qt_score_w + 1;
    END IF;
    RETURN qt_score_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_escala_acef_md ( qt_idade_p bigint, qt_fracao_ejecao_p bigint, qt_creatinina_serica_p bigint ) FROM PUBLIC;

