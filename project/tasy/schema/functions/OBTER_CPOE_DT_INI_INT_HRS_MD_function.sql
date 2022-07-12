-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cpoe_dt_ini_int_hrs_md ( ie_interv_24_p text, dt_inicio_base_p timestamp, qt_horas_interv_p bigint, qt_operacao_p bigint, dt_inicio_prescr_p timestamp ) RETURNS timestamp AS $body$
DECLARE

    dt_inicio_w timestamp;

BEGIN
    dt_inicio_w := dt_inicio_base_p;

	IF ( ie_interv_24_p = 'S' ) THEN
        dt_inicio_w :=  dt_inicio_base_p + ( dividir_sem_round_md(coalesce(qt_horas_interv_p,0) , 24) );
    ELSIF ( qt_operacao_p < 24 ) THEN
        dt_inicio_w :=  dt_inicio_base_p + ( dividir_sem_round_md(( coalesce(qt_horas_interv_p,0) + coalesce(qt_horas_interv_p,0) ) , 24 ) );
    END IF;

    dt_inicio_w := to_date(to_char(dt_inicio_base_p, 'dd/mm/yyyy ')|| to_char(dt_inicio_w, 'hh24:mi'),'dd/mm/yyyy hh24:mi');

    IF ( dt_inicio_w < coalesce(dt_inicio_prescr_p, dt_inicio_base_p) ) THEN
        dt_inicio_w := dt_inicio_w + 1;
    END IF;

    RETURN dt_inicio_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cpoe_dt_ini_int_hrs_md ( ie_interv_24_p text, dt_inicio_base_p timestamp, qt_horas_interv_p bigint, qt_operacao_p bigint, dt_inicio_prescr_p timestamp ) FROM PUBLIC;

