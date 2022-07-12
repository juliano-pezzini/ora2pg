-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	/* Generate all possible dimensions */




CREATE OR REPLACE PROCEDURE hdm_indic_pck.populate_dimensions () AS $body$
DECLARE

	si_exists_months_w	varchar(1);
	
BEGIN	
		select	CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
		into STRICT	si_exists_months_w
		from	hdm_indic_dm_month;
		
		if (si_exists_months_w = 'N') then
			CALL hdm_indic_pck.populate_dim_month();
			CALL hdm_indic_pck.populate_dim_day();
		end if;
		
		CALL hdm_indic_pck.populate_dim_disease_risk();
		CALL hdm_indic_pck.populate_dim_glyc_range();
		CALL hdm_indic_pck.populate_dim_bp_range();
		CALL hdm_indic_pck.populate_dim_bmi_range();
		CALL hdm_indic_pck.populate_dim_program();
		CALL hdm_indic_pck.populate_dim_campaign();
		CALL hdm_indic_pck.populate_dim_activ_group();
		CALL hdm_indic_pck.populate_dim_patient_group();
		CALL hdm_indic_pck.populate_dim_exams();
		CALL hdm_indic_pck.populate_dim_exams_ref();
		CALL hdm_indic_pck.populate_dim_habit();
		CALL hdm_indic_pck.populate_dim_clinic_ant();
		CALL hdm_indic_pck.populate_dim_medication();
		CALL hdm_indic_pck.populate_dim_bill_type();
		CALL hdm_indic_pck.populate_dim_bill_diag();
		CALL hdm_indic_pck.populate_dim_control_group();
		CALL hdm_indic_pck.populate_dim_vaccine();
		CALL hdm_indic_pck.populate_dim_procedure();
		CALL hdm_indic_pck.populate_dim_red_cost_range();
		CALL hdm_indic_pck.populate_dim_cost_type();
		CALL hdm_indic_pck.populate_dim_episode_data();
		CALL hdm_indic_pck.populate_dim_professional();
		CALL hdm_indic_pck.populate_dim_appointment_data();
		CALL hdm_indic_pck.populate_dim_partic_data();
		CALL hdm_indic_pck.populate_dim_care_plan_data();
		CALL hdm_indic_pck.populate_dim_cube_rule();
		CALL hdm_indic_pck.populate_dim_susp_details();
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.populate_dimensions () FROM PUBLIC;
