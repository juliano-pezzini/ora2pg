-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_superf_corp_red_ped_md ( qt_idade_paciente_p bigint, qt_idade_calc_p bigint, qt_peso_p bigint, qt_altura_p bigint, ie_formula_sup_corporea_p text, qt_porcent_reducao_p bigint, qt_max_result_p bigint, nr_dec_sc_p bigint ) RETURNS bigint AS $body$
DECLARE

    qt_resultado_w double precision;

BEGIN
    IF ( qt_idade_paciente_p <= somente_numero_real(qt_idade_calc_p) ) THEN
        qt_resultado_w := dividir_md(((qt_peso_p * 4) + 7), qt_peso_p + 90);
    ELSE
        SELECT
            obter_superficie_corporea_md(qt_altura_p, qt_peso_p, ie_formula_sup_corporea_p, nr_dec_sc_p)
        INTO STRICT qt_resultado_w
;

        IF ( coalesce(qt_porcent_reducao_p, 0) > 0 ) THEN
            qt_resultado_w := qt_resultado_w - dividir_md((qt_resultado_w * qt_porcent_reducao_p), 100);
            qt_resultado_w := trunc(qt_resultado_w,nr_dec_sc_p);
        END IF;

    END IF;
    IF ( qt_max_result_p > 0 ) AND ( qt_resultado_w > qt_max_result_p ) THEN
        qt_resultado_w := qt_max_result_p;
    END IF;

    RETURN qt_resultado_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_superf_corp_red_ped_md ( qt_idade_paciente_p bigint, qt_idade_calc_p bigint, qt_peso_p bigint, qt_altura_p bigint, ie_formula_sup_corporea_p text, qt_porcent_reducao_p bigint, qt_max_result_p bigint, nr_dec_sc_p bigint ) FROM PUBLIC;

