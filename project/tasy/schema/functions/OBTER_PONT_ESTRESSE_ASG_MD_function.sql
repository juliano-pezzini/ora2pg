-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pont_estresse_asg_md ( ie_febre_p bigint, ie_duracao_febre_p bigint, ie_corticosteroides_p bigint ) RETURNS bigint AS $body$
DECLARE

    qt_pontuacao_demanda_w integer := 0;

BEGIN
    IF ( ie_febre_p = 1 ) THEN
        qt_pontuacao_demanda_w := qt_pontuacao_demanda_w + 1;
    ELSIF ( ie_febre_p = 2 ) THEN
        qt_pontuacao_demanda_w := qt_pontuacao_demanda_w + 2;
    ELSIF ( ie_febre_p = 3 ) THEN
        qt_pontuacao_demanda_w := qt_pontuacao_demanda_w + 3;
    END IF;

    IF ( ie_duracao_febre_p = 1 ) THEN
        qt_pontuacao_demanda_w := qt_pontuacao_demanda_w + 1;
    ELSIF ( ie_duracao_febre_p = 2 ) THEN
        qt_pontuacao_demanda_w := qt_pontuacao_demanda_w + 2;
    ELSIF ( ie_duracao_febre_p = 3 ) THEN
        qt_pontuacao_demanda_w := qt_pontuacao_demanda_w + 3;
    END IF;

    IF ( ie_corticosteroides_p = 1 ) THEN
        qt_pontuacao_demanda_w := qt_pontuacao_demanda_w + 1;
    ELSIF ( ie_corticosteroides_p = 2 ) THEN
        qt_pontuacao_demanda_w := qt_pontuacao_demanda_w + 2;
    ELSIF ( ie_corticosteroides_p = 3 ) THEN
        qt_pontuacao_demanda_w := qt_pontuacao_demanda_w + 3;
    END IF;


    RETURN qt_pontuacao_demanda_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pont_estresse_asg_md ( ie_febre_p bigint, ie_duracao_febre_p bigint, ie_corticosteroides_p bigint ) FROM PUBLIC;
