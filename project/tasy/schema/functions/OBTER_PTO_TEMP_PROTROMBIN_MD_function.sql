-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pto_temp_protrombin_md ( qt_tap_inr_p bigint ) RETURNS bigint AS $body$
DECLARE

    qt_pto_tap_inr_w smallint;

BEGIN
    IF ( coalesce(qt_tap_inr_p::text, '') = '' ) THEN
        qt_pto_tap_inr_w := 0;
    ELSIF ( qt_tap_inr_p < 1.4 ) THEN
        qt_pto_tap_inr_w := 0;
    ELSIF ( qt_tap_inr_p >= 1.4 ) THEN
        qt_pto_tap_inr_w := 1;
    END IF;

    RETURN qt_pto_tap_inr_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pto_temp_protrombin_md ( qt_tap_inr_p bigint ) FROM PUBLIC;

