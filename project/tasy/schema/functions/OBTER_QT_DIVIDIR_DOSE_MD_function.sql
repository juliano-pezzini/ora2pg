-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_dividir_dose_md ( qt_dose_p bigint, qt_conversao_ml_p bigint ) RETURNS bigint AS $body$
DECLARE

    qt_retorno_w double precision;

BEGIN
    if (qt_conversao_ml_p > 0) then
        qt_retorno_w	:= qt_dose_p / qt_conversao_ml_p;
    end if;
    return qt_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_dividir_dose_md ( qt_dose_p bigint, qt_conversao_ml_p bigint ) FROM PUBLIC;
