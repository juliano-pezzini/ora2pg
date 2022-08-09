-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_interv_dieta_prot ( nr_inicio_intervalo_p bigint DEFAULT NULL, nr_fim_intervalo_p bigint DEFAULT NULL, ie_duracao_p INOUT protocolo_medic_dieta.ie_duracao%TYPE DEFAULT NULL, dt_inicio_p INOUT cpoe_dieta.dt_inicio%TYPE DEFAULT NULL, dt_fim_p INOUT cpoe_dieta.dt_fim%TYPE DEFAULT NULL) AS $body$
DECLARE


ie_mantido_ate_2a_ordem_w   CONSTANT protocolo_medic_dieta.ie_duracao%TYPE := 'C';
ie_programado_w             CONSTANT protocolo_medic_dieta.ie_duracao%TYPE := 'P';
nr_5_minutos_w              CONSTANT bigint := 5/1440;


BEGIN
    if(( coalesce(nr_inicio_intervalo_p::text, '') = '' ) and ( coalesce(nr_fim_intervalo_p::text, '') = '' )) then 
        ie_duracao_p := ie_mantido_ate_2a_ordem_w;
        dt_inicio_p := clock_timestamp() + nr_5_minutos_w;
    else
        ie_duracao_p := ie_programado_w;
    end if;

    if ((nr_inicio_intervalo_p IS NOT NULL AND nr_inicio_intervalo_p::text <> '') and ( coalesce(nr_fim_intervalo_p::text, '') = '' )) then
        dt_inicio_p := clock_timestamp() + nr_inicio_intervalo_p + nr_5_minutos_w;
        dt_fim_p := establishment_timezone_utils.endOfDay(dt_inicio_p);
    elsif(nr_inicio_intervalo_p IS NOT NULL AND nr_inicio_intervalo_p::text <> '' AND nr_fim_intervalo_p IS NOT NULL AND nr_fim_intervalo_p::text <> '') then 
        dt_inicio_p := clock_timestamp() + nr_inicio_intervalo_p + nr_5_minutos_w;
        dt_fim_p := establishment_timezone_utils.endOfDay(clock_timestamp() + nr_fim_intervalo_p);
    end if;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_interv_dieta_prot ( nr_inicio_intervalo_p bigint DEFAULT NULL, nr_fim_intervalo_p bigint DEFAULT NULL, ie_duracao_p INOUT protocolo_medic_dieta.ie_duracao%TYPE DEFAULT NULL, dt_inicio_p INOUT cpoe_dieta.dt_inicio%TYPE DEFAULT NULL, dt_fim_p INOUT cpoe_dieta.dt_fim%TYPE DEFAULT NULL) FROM PUBLIC;
