-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE export_dpc_questionnaire_file (nr_atendimento_p bigint, nr_seq_patient_dpc_p bigint, cd_pessoa_fisica_p text, dt_start_p timestamp, dt_end_p timestamp, cd_department_p bigint, si_discharge_p text, si_questionnaire_status_p text, nm_usuario_p text, si_reacquisition_p text default 'N') AS $body$
BEGIN

    CALL dpc_pkg.export_dpc_questionnaire_file(nr_atendimento_p, nr_seq_patient_dpc_p, cd_pessoa_fisica_p, dt_start_p, dt_end_p, cd_department_p, si_discharge_p, si_questionnaire_status_p, nm_usuario_p, si_reacquisition_p);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE export_dpc_questionnaire_file (nr_atendimento_p bigint, nr_seq_patient_dpc_p bigint, cd_pessoa_fisica_p text, dt_start_p timestamp, dt_end_p timestamp, cd_department_p bigint, si_discharge_p text, si_questionnaire_status_p text, nm_usuario_p text, si_reacquisition_p text default 'N') FROM PUBLIC;
