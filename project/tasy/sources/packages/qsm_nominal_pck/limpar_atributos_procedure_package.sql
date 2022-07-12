-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE qsm_nominal_pck.limpar_atributos_procedure (r_update_nominal_procedure_p INOUT r_update_nominal_procedure) AS $body$
BEGIN
	r_update_nominal_procedure_p.ds_code			:= null;
	r_update_nominal_procedure_p.dt_date			:= null;
	r_update_nominal_procedure_p.ds_department		:= null;
	r_update_nominal_procedure_p.ds_department_type		:= null;
	r_update_nominal_procedure_p.ds_key			:= null;
	r_update_nominal_procedure_p.ds_localization		:= null;
	r_update_nominal_procedure_p.ds_visit			:= null;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qsm_nominal_pck.limpar_atributos_procedure (r_update_nominal_procedure_p INOUT r_update_nominal_procedure) FROM PUBLIC;