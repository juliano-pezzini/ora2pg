-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*----------------------------------------------------------------------------------------
'updateNominalData'
*/
CREATE OR REPLACE PROCEDURE qsm_nominal_pck.limpar_atributos_case_data (r_update_nominal_case_data_p INOUT r_update_nominal_case_data) AS $body$
BEGIN
	r_update_nominal_case_data_p.dt_admission_date		:= null;
	r_update_nominal_case_data_p.ds_admission_occasion	:= null;
	r_update_nominal_case_data_p.ds_admission_reason	:= null;
	r_update_nominal_case_data_p.nr_admission_weight	:= null;
	r_update_nominal_case_data_p.nr_age			:= null;
	r_update_nominal_case_data_p.nr_age_days		:= null;
	r_update_nominal_case_data_p.ds_local_case_id		:= null;
	r_update_nominal_case_data_p.dt_discharge		:= null;
	r_update_nominal_case_data_p.ds_discharge_reason	:= null;
	r_update_nominal_case_data_p.ds_ext_hospital_id		:= null;
	r_update_nominal_case_data_p.ds_return_nominal_data	:= null;
	r_update_nominal_case_data_p.ds_return_status		:= null;
	r_update_nominal_case_data_p.ds_return_trigger_info	:= null;
	r_update_nominal_case_data_p.nr_ventilation		:= null;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qsm_nominal_pck.limpar_atributos_case_data (r_update_nominal_case_data_p INOUT r_update_nominal_case_data) FROM PUBLIC;