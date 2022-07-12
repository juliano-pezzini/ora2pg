-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_estab_md ( ie_estab_p text, qt_estab_p bigint ) RETURNS bigint AS $body$
DECLARE

    qt_estab_w	double precision;

BEGIN
    if (ie_estab_p IS NOT NULL AND ie_estab_p::text <> '') then
        if (ie_estab_p = 'N') then
            qt_estab_w := qt_estab_p;
        elsif (ie_estab_p = 'I') then
            if (qt_estab_p IS NOT NULL AND qt_estab_p::text <> '') then
                qt_estab_w := qt_estab_p;
            else
                qt_estab_w := 0;
            end if;
        elsif (ie_estab_p = 'A') then
            qt_estab_w := qt_estab_p * (365 * 24);
        elsif (ie_estab_p = 'M') then
            qt_estab_w := qt_estab_p * (30 * 24);
        elsif (ie_estab_p = 'D') then
            qt_estab_w := qt_estab_p * 24;
        elsif (ie_estab_p = 'S')  then
            qt_estab_w := qt_estab_p * 7;
        elsif (ie_estab_p = 'H') then
            qt_estab_w := qt_estab_p;
        elsif (ie_estab_p = 'MI') then
            qt_estab_w := DIVIDIR_SEM_ROUND_MD(qt_estab_p, 60);
        end if;
    end if;
    return qt_estab_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_estab_md ( ie_estab_p text, qt_estab_p bigint ) FROM PUBLIC;
