-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcula_timi_risk_md ( qt_ano_p bigint, ie_fator_risco_p text, ie_dac_p text, ie_aas_p text, ie_angina_24h_p text, ie_elev_enzima_p text, ie_desvio_st_p text, qt_escore_ano_p INOUT bigint, qt_escore_fat_risco_p INOUT bigint, qt_escore_dac_p INOUT bigint, qt_escore_aas_p INOUT bigint, qt_escore_angina_p INOUT bigint, qt_escore_elev_enzima_p INOUT bigint, qt_escore_desvio_p INOUT bigint, qt_escore_p INOUT bigint, pr_morte_infarto_p INOUT bigint, pr_morte_infarto_revasc_p INOUT bigint ) AS $body$
BEGIN
    qt_escore_ano_p := 0;
    qt_escore_fat_risco_p := 0;
    qt_escore_dac_p := 0;
    qt_escore_aas_p := 0;
    qt_escore_angina_p := 0;
    qt_escore_angina_p := 0;
    qt_escore_elev_enzima_p := 0;
    qt_escore_desvio_p := 0;
    qt_escore_p := 0;
    pr_morte_infarto_p := 0;
    pr_morte_infarto_revasc_p := 0;
    IF ( qt_ano_p > 64 ) THEN
        qt_escore_ano_p := 1;
    END IF;
    IF ( ie_fator_risco_p = 'S' ) THEN
        qt_escore_fat_risco_p := 1;
    END IF;
    IF ( ie_dac_p = 'S' ) THEN
        qt_escore_dac_p := 1;
    END IF;
    IF ( ie_aas_p = 'S' ) THEN
        qt_escore_aas_p := 1;
    END IF;
    IF ( ie_angina_24h_p = 'S' ) THEN
        qt_escore_angina_p := 1;
    END IF;
    IF ( ie_elev_enzima_p = 'S' ) THEN
        qt_escore_elev_enzima_p := 1;
    END IF;
    IF ( ie_desvio_st_p = 'S' ) THEN
        qt_escore_desvio_p := 1;
    END IF;
    qt_escore_p := ( coalesce(qt_escore_ano_p, 0) + coalesce(qt_escore_fat_risco_p, 0) + coalesce(qt_escore_dac_p, 0) + coalesce(qt_escore_aas_p, 0) +
    coalesce(qt_escore_angina_p, 0) + coalesce(qt_escore_elev_enzima_p, 0) + coalesce(qt_escore_desvio_p, 0) );

    IF ( qt_escore_p < 2 ) THEN
        pr_morte_infarto_p := 3;
        pr_morte_infarto_revasc_p := 5;
    ELSIF ( qt_escore_p = 2 ) THEN
        pr_morte_infarto_p := 3;
        pr_morte_infarto_revasc_p := 8;
    ELSIF ( qt_escore_p = 3 ) THEN
        pr_morte_infarto_p := 5;
        pr_morte_infarto_revasc_p := 13;
    ELSIF ( qt_escore_p = 4 ) THEN
        pr_morte_infarto_p := 7;
        pr_morte_infarto_revasc_p := 20;
    ELSIF ( qt_escore_p = 5 ) THEN
        pr_morte_infarto_p := 12;
        pr_morte_infarto_revasc_p := 26;
    ELSIF ( qt_escore_p > 5 ) THEN
        pr_morte_infarto_p := 19;
        pr_morte_infarto_revasc_p := 41;
    END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcula_timi_risk_md ( qt_ano_p bigint, ie_fator_risco_p text, ie_dac_p text, ie_aas_p text, ie_angina_24h_p text, ie_elev_enzima_p text, ie_desvio_st_p text, qt_escore_ano_p INOUT bigint, qt_escore_fat_risco_p INOUT bigint, qt_escore_dac_p INOUT bigint, qt_escore_aas_p INOUT bigint, qt_escore_angina_p INOUT bigint, qt_escore_elev_enzima_p INOUT bigint, qt_escore_desvio_p INOUT bigint, qt_escore_p INOUT bigint, pr_morte_infarto_p INOUT bigint, pr_morte_infarto_revasc_p INOUT bigint ) FROM PUBLIC;

