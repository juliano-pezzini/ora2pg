-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_result_acef ( qt_pontuacao_p bigint ) RETURNS bigint AS $body$
DECLARE


    qt_retorno_w    double precision;
    qt_pontuacao_w  double precision;
    sql_w           varchar(200);

BEGIN


    BEGIN
        sql_w := 'CALL Obter_qt_ret_Result_acef_md(:1) INTO :qt_retorno_w';
        EXECUTE sql_w
            USING IN qt_pontuacao_p, OUT qt_retorno_w;
    EXCEPTION
        WHEN OTHERS THEN
            qt_retorno_w := NULL;
    END;


    RETURN qt_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_result_acef ( qt_pontuacao_p bigint ) FROM PUBLIC;
