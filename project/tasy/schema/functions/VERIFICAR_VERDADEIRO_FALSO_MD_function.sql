-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verificar_verdadeiro_falso_md ( dt_entrega_p timestamp, dt_entrada_p timestamp, qt_dia_entrega_entrada_p bigint, qt_min_entrega_p bigint, ds_hora_fixa_p text, ie_data_resultado_p text, ie_atualizar_dt_prescr_p text, dt_coleta_p timestamp, qt_dia_entrega_coleta_p bigint, ie_retorno_p bigint ) RETURNS varchar AS $body$
BEGIN
IF ( ie_retorno_p = 1 ) THEN
IF
( dt_entrega_p < ( dt_entrada_p + coalesce(qt_dia_entrega_entrada_p, 0) + ( dividir_sem_round_md(qt_min_entrega_p , 1440) ) + ( dividir_sem_round_md(coalesce(ds_hora_fixa_p,0) , 24) ) ) )
AND ( ie_data_resultado_p = 'P' )
AND ( coalesce(ie_atualizar_dt_prescr_p, 'S') = 'S' )
THEN
RETURN 'S';
ELSE
RETURN 'N';
END IF;
END IF;



IF ( ie_retorno_p = 2 ) THEN
IF
( dt_entrega_p < ( dt_coleta_p + coalesce(qt_dia_entrega_coleta_p, 0) + ( dividir_sem_round_md(qt_min_entrega_p , 1440) ) + ( dividir_sem_round_md(coalesce(ds_hora_fixa_p,0) , 24) ) ) )
AND ( ie_data_resultado_p = 'C' )
AND (dt_coleta_p IS NOT NULL AND dt_coleta_p::text <> '')
THEN
RETURN 'S';
ELSE
RETURN 'N';
END IF;



END IF;



IF ( ie_retorno_p = 3 ) THEN
IF (
( dt_entrega_p < ( dt_entrada_p + coalesce(qt_dia_entrega_entrada_p, 0) + ( dividir_sem_round_md(qt_min_entrega_p , 1440) ) + ( dividir_sem_round_md(coalesce(ds_hora_fixa_p,0) , 24) ) ) )
AND ( ie_data_resultado_p = 'N' )
AND ( coalesce(ie_atualizar_dt_prescr_p, 'S') = 'S' )
) OR (
( dt_entrega_p < ( dt_coleta_p + coalesce(qt_dia_entrega_coleta_p, 0) + ( dividir_sem_round_md(qt_min_entrega_p ,1440) ) + ( dividir_sem_round_md(coalesce(ds_hora_fixa_p,0) , 24) ) ) )
AND ( ie_data_resultado_p = 'N' )
AND (dt_coleta_p IS NOT NULL AND dt_coleta_p::text <> '')
) THEN
RETURN 'S';
ELSE
RETURN 'N';
END IF;
END IF;



END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verificar_verdadeiro_falso_md ( dt_entrega_p timestamp, dt_entrada_p timestamp, qt_dia_entrega_entrada_p bigint, qt_min_entrega_p bigint, ds_hora_fixa_p text, ie_data_resultado_p text, ie_atualizar_dt_prescr_p text, dt_coleta_p timestamp, qt_dia_entrega_coleta_p bigint, ie_retorno_p bigint ) FROM PUBLIC;
