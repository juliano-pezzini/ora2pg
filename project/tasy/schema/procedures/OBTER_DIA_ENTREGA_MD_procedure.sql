-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dia_entrega_md ( qt_dia_entrega_p bigint, dt_entrada_p timestamp, cd_estabelecimento_p bigint, ie_tipo_feriado_p bigint, dt_coleta_p timestamp, ie_data_resultado_p text, ie_domingo_p text, ie_segunda_p text, ie_terca_p text, ie_quarta_p text, ie_quinta_p text, ie_sexta_p text, ie_sabado_p text, ie_feriado_p text, qt_dia_entrega_out_p INOUT bigint, qt_dia_entrega_entrada_p INOUT bigint, dt_entrega_calc_p INOUT timestamp, qt_dia_entrega_coleta_p INOUT bigint ) AS $body$
DECLARE

    dia_semana_w integer := 1;

BEGIN
    IF ( coalesce(qt_dia_entrega_p, 0) > 0 )
        AND (ie_domingo_p IS NOT NULL AND ie_domingo_p::text <> '')
    THEN
        qt_dia_entrega_out_p := coalesce(qt_dia_entrega_p, 0);
        qt_dia_entrega_entrada_p := coalesce(qt_dia_entrega_p, 0);
        dt_entrega_calc_p := dt_entrada_p;
        WHILE qt_dia_entrega_out_p > 0 LOOP
            dt_entrega_calc_p := dt_entrega_calc_p + 1;
            SELECT
                pkg_date_utils.get_weekday(dt_entrega_calc_p)
            INTO STRICT dia_semana_w
;

            IF ( dia_semana_w = 1  AND  ie_domingo_p = 'N' ) OR ( dia_semana_w = 2  AND  ie_segunda_p = 'N' ) OR ( dia_semana_w = 3  AND  ie_terca_p = 'N' ) OR ( dia_semana_w = 4  AND  ie_quarta_p = 'N' ) OR ( dia_semana_w = 5  AND  ie_quinta_p = 'N' ) OR ( dia_semana_w = 6  AND  ie_sexta_p = 'N' ) OR ( dia_semana_w = 7  AND  ie_sabado_p = 'N' ) OR (
                ( lab_obter_se_feriado(cd_estabelecimento_p, dt_entrega_calc_p, ie_tipo_feriado_p) > 0 )
                AND ( ie_feriado_p = 'N' )
            ) THEN
                qt_dia_entrega_entrada_p := coalesce(qt_dia_entrega_entrada_p, 0) + 1;
            ELSE
                qt_dia_entrega_out_p := coalesce(qt_dia_entrega_out_p, 0) - 1;
            END IF;

            IF ( qt_dia_entrega_out_p > 90 ) THEN
                EXIT;
            END IF;
        END LOOP;

        IF (dt_coleta_p IS NOT NULL AND dt_coleta_p::text <> '' AND ( ie_data_resultado_p = 'C' OR ie_data_resultado_p = 'N' )) THEN
            qt_dia_entrega_out_p := coalesce(qt_dia_entrega_p, 0);
            qt_dia_entrega_coleta_p := coalesce(qt_dia_entrega_p, 0);
            dt_entrega_calc_p := dt_coleta_p;
            WHILE qt_dia_entrega_out_p > 0 LOOP
                dt_entrega_calc_p := dt_entrega_calc_p + 1;
                SELECT
                    pkg_date_utils.get_weekday(dt_entrega_calc_p)
                INTO STRICT dia_semana_w
;

                IF ( dia_semana_w = 1  AND  ie_domingo_p = 'N' ) OR ( dia_semana_w = 2  AND  ie_segunda_p = 'N' ) OR ( dia_semana_w = 3  AND  ie_terca_p = 'N' ) OR ( dia_semana_w = 4  AND  ie_quarta_p = 'N' ) OR ( dia_semana_w = 5  AND  ie_quinta_p = 'N' ) OR ( dia_semana_w = 6  AND  ie_sexta_p = 'N' ) OR ( dia_semana_w = 7  AND  ie_sabado_p = 'N' ) OR (
                    ( lab_obter_se_feriado(cd_estabelecimento_p, dt_entrega_calc_p, ie_tipo_feriado_p) > 0 )
                    AND ( ie_feriado_p = 'N' )
                ) THEN
                    qt_dia_entrega_coleta_p := coalesce(qt_dia_entrega_coleta_p, 0) + 1;
                ELSE
                    qt_dia_entrega_out_p := coalesce(qt_dia_entrega_out_p, 0) - 1;
                END IF;

                IF ( qt_dia_entrega_out_p > 90 ) THEN
                    EXIT;
                END IF;
            END LOOP;

        END IF;

    END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dia_entrega_md ( qt_dia_entrega_p bigint, dt_entrada_p timestamp, cd_estabelecimento_p bigint, ie_tipo_feriado_p bigint, dt_coleta_p timestamp, ie_data_resultado_p text, ie_domingo_p text, ie_segunda_p text, ie_terca_p text, ie_quarta_p text, ie_quinta_p text, ie_sexta_p text, ie_sabado_p text, ie_feriado_p text, qt_dia_entrega_out_p INOUT bigint, qt_dia_entrega_entrada_p INOUT bigint, dt_entrega_calc_p INOUT timestamp, qt_dia_entrega_coleta_p INOUT bigint ) FROM PUBLIC;

