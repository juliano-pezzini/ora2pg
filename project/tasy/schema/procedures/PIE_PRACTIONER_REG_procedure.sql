-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pie_practioner_reg ( nr_seq_pie_pract_p pie_practitioner.nr_sequencia%type, nr_record_p pie_pract_registration.nr_record%type, tp_division_p pie_pract_registration.tp_division%type, tp_registration_p pie_pract_registration.tp_registration%type, tp_registration_sub_p pie_pract_registration.tp_registration_sub%type, tp_regist_status_p pie_pract_registration.tp_regist_status%type, tp_regist_sub_status_p pie_pract_registration.tp_regist_sub_status%type, dt_regist_expiry_p pie_pract_registration.dt_regist_expiry%type, tp_specialty_p pie_pract_registration.tp_specialty%type, tp_specialty_field_p pie_pract_registration.tp_specialty_field%type, dt_initial_registration_p pie_pract_registration.dt_initial_registration%type, nr_seq_pie_pract_reg_p INOUT pie_pract_registration.nr_sequencia%type) AS $body$
DECLARE

  nr_sequencia_w	pie_pract_registration.nr_sequencia%type;

BEGIN


	if ((nr_record_p IS NOT NULL AND nr_record_p::text <> '')
	and (tp_registration_p IS NOT NULL AND tp_registration_p::text <> '')
	and (tp_regist_status_p IS NOT NULL AND tp_regist_status_p::text <> '')) then

		select nextval('pie_pract_registration_seq')
		into STRICT   nr_sequencia_w
		;

		insert into pie_pract_registration( nr_sequencia,
		   nr_record,
		   tp_division,
		   tp_registration,
		   tp_registration_sub,
		   tp_regist_status,
		   tp_regist_sub_status,
		   dt_regist_expiry,
		   tp_specialty,
		   tp_specialty_field,
		   dt_initial_registration,
		   nr_seq_pie_pract)
		values ( nr_sequencia_w,
		   nr_record_p,
		   tp_division_p,
		   tp_registration_p,
		   tp_registration_sub_p,
		   tp_regist_status_p,
		   tp_regist_sub_status_p,
		   dt_regist_expiry_p,
		   tp_specialty_p,
		   tp_specialty_field_p,
		   dt_initial_registration_p,
		   nr_seq_pie_pract_p );
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1088701);
	end if;
	nr_seq_pie_pract_reg_p:= nr_sequencia_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pie_practioner_reg ( nr_seq_pie_pract_p pie_practitioner.nr_sequencia%type, nr_record_p pie_pract_registration.nr_record%type, tp_division_p pie_pract_registration.tp_division%type, tp_registration_p pie_pract_registration.tp_registration%type, tp_registration_sub_p pie_pract_registration.tp_registration_sub%type, tp_regist_status_p pie_pract_registration.tp_regist_status%type, tp_regist_sub_status_p pie_pract_registration.tp_regist_sub_status%type, dt_regist_expiry_p pie_pract_registration.dt_regist_expiry%type, tp_specialty_p pie_pract_registration.tp_specialty%type, tp_specialty_field_p pie_pract_registration.tp_specialty_field%type, dt_initial_registration_p pie_pract_registration.dt_initial_registration%type, nr_seq_pie_pract_reg_p INOUT pie_pract_registration.nr_sequencia%type) FROM PUBLIC;
