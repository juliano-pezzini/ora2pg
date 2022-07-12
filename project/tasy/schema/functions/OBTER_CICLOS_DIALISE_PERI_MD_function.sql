-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ciclos_dialise_peri_md (qt_sum_volume_p bigint, qt_volume_ciclo_p bigint) RETURNS bigint AS $body$
DECLARE

 
nr_ciclos_w  bigint;

BEGIN
	nr_ciclos_w := 0;
    if (qt_volume_ciclo_p IS NOT NULL AND qt_volume_ciclo_p::text <> '') and qt_volume_ciclo_p > 0 then
        nr_ciclos_w:= ceil(coalesce(qt_sum_volume_p, 0) / coalesce(qt_volume_ciclo_p, 0));
    end if;
    return nr_ciclos_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ciclos_dialise_peri_md (qt_sum_volume_p bigint, qt_volume_ciclo_p bigint) FROM PUBLIC;

