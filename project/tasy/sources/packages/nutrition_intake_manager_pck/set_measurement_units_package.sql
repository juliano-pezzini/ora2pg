-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nutrition_intake_manager_pck.set_measurement_units () AS $body$
BEGIN

		CALL nutrition_intake_manager_pck.init_record();

		r_basic_nutrition_item_w.nr_ordem		    := 1;
		r_basic_nutrition_item_w.cd_unid_med_cal	:= cd_unid_med_cal_w;
		r_basic_nutrition_item_w.cd_unid_med_carb	:= cd_unid_med_carb_w;
		r_basic_nutrition_item_w.cd_unid_med_prot	:= cd_unid_med_prot_w;
		r_basic_nutrition_item_w.cd_unid_med_gord	:= cd_unid_med_gord_w;
		r_basic_nutrition_item_w.cd_unid_med_fos	:= cd_unid_med_fos_w;
		r_basic_nutrition_item_w.cd_unid_med_ca		:= cd_unid_med_ca_w;
		r_basic_nutrition_item_w.cd_unid_med_mag 	:= cd_unid_med_mag_w;
		r_basic_nutrition_item_w.cd_unid_med_sod	:= cd_unid_med_sod_w;
		r_basic_nutrition_item_w.cd_unid_med_pot	:= cd_unid_med_pot_w;
		r_basic_nutrition_item_w.cd_unid_med_cl		:= cd_unid_med_cl_w;


	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nutrition_intake_manager_pck.set_measurement_units () FROM PUBLIC;
