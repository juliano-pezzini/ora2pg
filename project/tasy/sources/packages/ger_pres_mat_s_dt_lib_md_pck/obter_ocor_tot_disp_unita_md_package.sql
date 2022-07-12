-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ger_pres_mat_s_dt_lib_md_pck.obter_ocor_tot_disp_unita_md (qt_dose_especial_p bigint, ie_agrupador_dil_p bigint, nr_ocorrencia_dil_p INOUT bigint, qt_total_disp_dil_p INOUT bigint, qt_unitaria_dil_p INOUT bigint ) AS $body$
BEGIN
	if (coalesce(qt_dose_especial_p,0) > 0) and (ie_agrupador_dil_p = 3) then
	  nr_ocorrencia_dil_p	:= coalesce(nr_ocorrencia_dil_p,0) +1;
	end if;

	qt_unitaria_dil_p	:= dividir_md(qt_total_disp_dil_p,nr_ocorrencia_dil_p);

	if (coalesce(qt_dose_especial_p,0) > 0) then
		nr_ocorrencia_dil_p	:= coalesce(nr_ocorrencia_dil_p,0) - 1;
		if (ie_agrupador_dil_p = 9) then
			qt_total_disp_dil_p	:= coalesce(qt_total_disp_dil_p,0) - (coalesce(qt_unitaria_dil_p,0) * ceil(coalesce(qt_dose_especial_p,0)));
		else
			qt_total_disp_dil_p	:= coalesce(qt_total_disp_dil_p,0) - ceil(qt_unitaria_dil_p);
		end if;
	end if;
	end;



$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ger_pres_mat_s_dt_lib_md_pck.obter_ocor_tot_disp_unita_md (qt_dose_especial_p bigint, ie_agrupador_dil_p bigint, nr_ocorrencia_dil_p INOUT bigint, qt_total_disp_dil_p INOUT bigint, qt_unitaria_dil_p INOUT bigint ) FROM PUBLIC;