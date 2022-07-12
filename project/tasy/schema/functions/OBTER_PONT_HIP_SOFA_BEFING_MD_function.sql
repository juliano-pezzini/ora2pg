-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pont_hip_sofa_befing_md ( qt_pa_diastolica_p bigint, qt_pa_sistolica_p bigint ) RETURNS bigint AS $body$
DECLARE

	qt_pam_w smallint;

BEGIN
	if (qt_pa_diastolica_p IS NOT NULL AND qt_pa_diastolica_p::text <> '') and (qt_pa_sistolica_p IS NOT NULL AND qt_pa_sistolica_p::text <> '') then
		qt_pam_w:= dividir_sem_round_md((qt_pa_sistolica_p + qt_pa_diastolica_p * 2), 3);
	end if;

	return qt_pam_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pont_hip_sofa_befing_md ( qt_pa_diastolica_p bigint, qt_pa_sistolica_p bigint ) FROM PUBLIC;
