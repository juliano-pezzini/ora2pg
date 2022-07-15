-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_indicator_time_unit ( nr_seq_indicator_p bigint, cd_establishment_p bigint, cd_department_p text, ds_first_time_p INOUT text, ds_second_time_p INOUT text, ds_first_unit_p INOUT text, ds_second_unit_p INOUT text, ds_color_p INOUT text) AS $body$
DECLARE


	qt_indicator_time_w				bigint := 0;

BEGIN
	if (nr_seq_indicator_p = 41) then
		qt_indicator_time_w := pfcs_telemetry_config_pck.get_average_waiting_time(cd_establishment_p, cd_department_p);
        ds_color_p := Pfcs_get_indicator_rule(nr_seq_indicator_p, qt_indicator_time_w, cd_establishment_p, 'COLOR');
	end if;

	SELECT * FROM get_time_units(	qt_indicator_time_w, ds_first_time_p, ds_second_time_p, ds_first_unit_p, ds_second_unit_p) INTO STRICT ds_first_time_p, ds_second_time_p, ds_first_unit_p, ds_second_unit_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_indicator_time_unit ( nr_seq_indicator_p bigint, cd_establishment_p bigint, cd_department_p text, ds_first_time_p INOUT text, ds_second_time_p INOUT text, ds_first_unit_p INOUT text, ds_second_unit_p INOUT text, ds_color_p INOUT text) FROM PUBLIC;

