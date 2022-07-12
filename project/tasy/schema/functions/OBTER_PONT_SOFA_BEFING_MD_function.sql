-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pont_sofa_befing_md ( qt_rel_pao2_fio2_p bigint ) RETURNS bigint AS $body$
DECLARE

    qt_pto_resp_w smallint := 0;

BEGIN
    IF ( coalesce(qt_rel_pao2_fio2_p::text, '') = '' ) THEN
        qt_pto_resp_w := 0;
    ELSIF ( qt_rel_pao2_fio2_p >= 400 ) THEN
        qt_pto_resp_w := 0;
    ELSIF ( qt_rel_pao2_fio2_p >= 300 )
        AND ( qt_rel_pao2_fio2_p < 400 )
    THEN
        qt_pto_resp_w := 1;
    ELSIF ( qt_rel_pao2_fio2_p >= 200 )
        AND ( qt_rel_pao2_fio2_p < 300 )
    THEN
        qt_pto_resp_w := 2;
    ELSIF ( qt_rel_pao2_fio2_p >= 100 )
        AND ( qt_rel_pao2_fio2_p < 200 )
    THEN
        qt_pto_resp_w := 3;
    ELSIF ( qt_rel_pao2_fio2_p < 100 ) THEN
        qt_pto_resp_w := 4;
    END IF;

    RETURN qt_pto_resp_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pont_sofa_befing_md ( qt_rel_pao2_fio2_p bigint ) FROM PUBLIC;

