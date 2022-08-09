-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_pontuacao_pa_prism_md ( qt_pa_sistolica_p bigint, ie_lactante_p text, qt_pa_diastolica_p bigint, qt_pto_pas_p INOUT bigint, qt_pto_pad_p INOUT bigint ) AS $body$
BEGIN
    --MD1
    IF ( coalesce(qt_pa_sistolica_p::text, '') = '' ) THEN
        qt_pto_pas_p := 0;
    ELSIF ( ie_lactante_p = 'S' )
        AND ( qt_pa_sistolica_p > 160 )
    THEN
        qt_pto_pas_p := 6;
    ELSIF ( ie_lactante_p = 'S' )
        AND ( qt_pa_sistolica_p >= 130  AND  qt_pa_sistolica_p <= 160 )
    THEN
        qt_pto_pas_p := 2;
    ELSIF ( ie_lactante_p = 'S' )
        AND ( qt_pa_sistolica_p >= 66  AND  qt_pa_sistolica_p <= 129 )
    THEN
        qt_pto_pas_p := 0;
    ELSIF ( ie_lactante_p = 'S' )
        AND ( qt_pa_sistolica_p >= 55  AND  qt_pa_sistolica_p <= 65 )
    THEN
        qt_pto_pas_p := 2;
    ELSIF ( ie_lactante_p = 'S' )
        AND ( qt_pa_sistolica_p >= 40  AND  qt_pa_sistolica_p <= 54 )
    THEN
        qt_pto_pas_p := 6;
    ELSIF ( ie_lactante_p = 'S' )
        AND ( qt_pa_sistolica_p < 40 )
    THEN
        qt_pto_pas_p := 7;
    ELSIF ( ie_lactante_p = 'N' )
        AND ( qt_pa_sistolica_p > 200 )
    THEN
        qt_pto_pas_p := 6;
    ELSIF ( ie_lactante_p = 'N' )
        AND ( qt_pa_sistolica_p >= 150  AND  qt_pa_sistolica_p <= 200 )
    THEN
        qt_pto_pas_p := 2;
    ELSIF ( ie_lactante_p = 'N' )
        AND ( qt_pa_sistolica_p >= 76  AND  qt_pa_sistolica_p <= 149 )
    THEN
        qt_pto_pas_p := 0;
    ELSIF ( ie_lactante_p = 'N' )
        AND ( qt_pa_sistolica_p >= 65  AND  qt_pa_sistolica_p <= 75 )
    THEN
        qt_pto_pas_p := 2;
    ELSIF ( ie_lactante_p = 'N' )
        AND ( qt_pa_sistolica_p >= 50  AND  qt_pa_sistolica_p <= 64 )
    THEN
        qt_pto_pas_p := 6;
    ELSIF ( ie_lactante_p = 'N' )
        AND ( qt_pa_sistolica_p < 50 )
    THEN
        qt_pto_pas_p := 7;
    END IF;
    --MD2
    IF ( coalesce(qt_pa_diastolica_p::text, '') = '' ) THEN
        qt_pto_pad_p := 0;
    ELSIF ( qt_pa_diastolica_p > 110 ) THEN
        qt_pto_pad_p := 6;
    ELSE
        qt_pto_pad_p := 0;
    END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_pontuacao_pa_prism_md ( qt_pa_sistolica_p bigint, ie_lactante_p text, qt_pa_diastolica_p bigint, qt_pto_pas_p INOUT bigint, qt_pto_pad_p INOUT bigint ) FROM PUBLIC;
