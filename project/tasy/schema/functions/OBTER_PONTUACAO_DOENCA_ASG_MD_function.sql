-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pontuacao_doenca_asg_md ( ie_cancer_p text, ie_aids_p text, ie_caqueixa_p text, ie_ulcera_p text, ie_idade_65_p text, ie_insuf_renal_cronica_p text, ie_trauma_p text ) RETURNS bigint AS $body$
DECLARE

    qt_pontuacao_doenca_w   smallint := 0;

BEGIN
    IF ( ie_cancer_p = 'S' ) THEN
        qt_pontuacao_doenca_w := qt_pontuacao_doenca_w + 1;
    END IF;

    IF ( ie_aids_p = 'S' ) THEN
        qt_pontuacao_doenca_w := qt_pontuacao_doenca_w + 1;
    END IF;

    IF ( ie_caqueixa_p = 'S' ) THEN
        qt_pontuacao_doenca_w := qt_pontuacao_doenca_w + 1;
    END IF;

    IF ( ie_ulcera_p = 'S' ) THEN
        qt_pontuacao_doenca_w := qt_pontuacao_doenca_w + 1;
    END IF;

    IF ( ie_idade_65_p = 'S' ) THEN
        qt_pontuacao_doenca_w := qt_pontuacao_doenca_w + 1;
    END IF;

    IF ( ie_insuf_renal_cronica_p = 'S' ) THEN
        qt_pontuacao_doenca_w := qt_pontuacao_doenca_w + 1;
    END IF;

    IF ( ie_trauma_p = 'S' ) THEN
        qt_pontuacao_doenca_w := qt_pontuacao_doenca_w + 1;
    END IF;

    RETURN qt_pontuacao_doenca_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pontuacao_doenca_asg_md ( ie_cancer_p text, ie_aids_p text, ie_caqueixa_p text, ie_ulcera_p text, ie_idade_65_p text, ie_insuf_renal_cronica_p text, ie_trauma_p text ) FROM PUBLIC;
