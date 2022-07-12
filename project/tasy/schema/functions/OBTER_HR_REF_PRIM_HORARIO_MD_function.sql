-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_hr_ref_prim_horario_md ( hr_inicial_p text, dt_prescricao_p timestamp ) RETURNS timestamp AS $body$
DECLARE

    hr_ref_w timestamp;

BEGIN
    BEGIN
        IF ( substr(hr_inicial_p, 1, 2) = '24' ) THEN
            hr_ref_w := establishment_timezone_utils.startofday(dt_prescricao_p) + 1;
        ELSE
            hr_ref_w := pkg_date_utils.get_time(dt_prescricao_p, hr_inicial_p);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            hr_ref_w := NULL;
    END;

    RETURN hr_ref_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_hr_ref_prim_horario_md ( hr_inicial_p text, dt_prescricao_p timestamp ) FROM PUBLIC;

