-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pont_bili_prism_md ( qt_bilirrubina_total_p bigint ) RETURNS bigint AS $body$
DECLARE

    qt_pto_bilirrubina_w        smallint := 0;

BEGIN

if (coalesce(qt_bilirrubina_total_p::text, '') = '') then
	qt_pto_bilirrubina_w := 0;
elsif (qt_bilirrubina_total_p > 3.5) then
	qt_pto_bilirrubina_w := 6;
else
     qt_pto_bilirrubina_w := 0;
end if;

    RETURN qt_pto_bilirrubina_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pont_bili_prism_md ( qt_bilirrubina_total_p bigint ) FROM PUBLIC;
