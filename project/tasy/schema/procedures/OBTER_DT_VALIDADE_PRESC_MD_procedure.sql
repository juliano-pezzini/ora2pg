-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dt_validade_presc_md ( ie_mat_cpoe_p text, dt_inicio_medic_p timestamp, dt_validade_prescr_p INOUT timestamp, nr_hora_validade_p INOUT bigint ) AS $body$
BEGIN
	if (ie_mat_cpoe_p = 'S') and (dt_inicio_medic_p IS NOT NULL AND dt_inicio_medic_p::text <> '') then
		dt_validade_prescr_p	:= dt_inicio_medic_p +24/24;
		nr_hora_validade_p 		:= 24;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dt_validade_presc_md ( ie_mat_cpoe_p text, dt_inicio_medic_p timestamp, dt_validade_prescr_p INOUT timestamp, nr_hora_validade_p INOUT bigint ) FROM PUBLIC;

