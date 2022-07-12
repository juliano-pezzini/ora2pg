-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dose_unitaria_md ( qt_dose_p bigint, unid_medida_p bigint ) RETURNS bigint AS $body$
BEGIN
    return dividir_md(coalesce(qt_dose_p, 0), unid_medida_p);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dose_unitaria_md ( qt_dose_p bigint, unid_medida_p bigint ) FROM PUBLIC;
