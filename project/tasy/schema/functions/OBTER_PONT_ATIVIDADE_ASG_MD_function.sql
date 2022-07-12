-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pont_atividade_asg_md ( ie_atividade_p text ) RETURNS bigint AS $body$
DECLARE

    qt_pontuacao_ativ_w   smallint := 0;

BEGIN
    IF ( ie_atividade_p = 'NT' ) THEN
        qt_pontuacao_ativ_w := 1;
    ELSIF ( ie_atividade_p = 'NS' ) THEN
        qt_pontuacao_ativ_w := 2;
    ELSIF ( ie_atividade_p = 'CF' ) THEN
        qt_pontuacao_ativ_w := 3;
    ELSIF ( ie_atividade_p = 'BT' ) THEN
        qt_pontuacao_ativ_w := 3;
    END IF;

    RETURN qt_pontuacao_ativ_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pont_atividade_asg_md ( ie_atividade_p text ) FROM PUBLIC;
