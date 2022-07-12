-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION converte_estab_hor ( ie_estab_p text, qt_estab_p bigint ) RETURNS bigint AS $body$
DECLARE


    qt_estab_w	double precision;
    sql_w varchar(250);

BEGIN
    begin
        sql_w := 'CALL OBTER_QT_ESTAB_MD(:1, :2) INTO :qt_estab_w';
        EXECUTE sql_w USING IN ie_estab_p, IN qt_estab_p, OUT qt_estab_w;
    exception
        when others then
            qt_estab_w := null;
    end;
    return qt_estab_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION converte_estab_hor ( ie_estab_p text, qt_estab_p bigint ) FROM PUBLIC;
