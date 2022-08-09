-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pie_practitioner_prof (nr_seq_pie_message_p pie_message.nr_sequencia%type, dt_name_edit_p pie_practitioner.dt_name_edit%type, ds_name_title_p pie_practitioner.ds_name_title%type, ds_name_family_p pie_practitioner.ds_name_family%type, ds_name_given_p pie_practitioner.ds_name_given%type, ds_name_middle_p pie_practitioner.ds_name_middle%type, tp_gender_p pie_practitioner.tp_gender%type, nr_profession_p pie_practitioner.nr_profession%type, tp_profession_p pie_practitioner.tp_profession%type, dt_profession_start_p pie_practitioner.dt_profession_start%type, nr_seq_pie_pract_p INOUT pie_practitioner.nr_sequencia%type) AS $body$
DECLARE

  nr_sequencia_w	pie_practitioner.nr_sequencia%type;

BEGIN

	if((dt_name_edit_p IS NOT NULL AND dt_name_edit_p::text <> '')
	and (ds_name_family_p IS NOT NULL AND ds_name_family_p::text <> '')
	and (tp_gender_p IS NOT NULL AND tp_gender_p::text <> '')
	and (nr_profession_p IS NOT NULL AND nr_profession_p::text <> '')
	and (tp_profession_p IS NOT NULL AND tp_profession_p::text <> '')
	and (nr_seq_pie_message_p IS NOT NULL AND nr_seq_pie_message_p::text <> '')) then

		select nextval('pie_practitioner_seq')
		into STRICT   nr_sequencia_w
		;

		insert into pie_practitioner(nr_sequencia,
		dt_name_edit,
		ds_name_title,
		ds_name_family,
		ds_name_given,
		ds_name_middle,
		tp_gender,
		nr_profession,
		tp_profession,
		dt_profession_start,
		nr_seq_pie_message
		)
		values (
		 nr_sequencia_w,
		 dt_name_edit_p,
		 ds_name_title_p,
		 ds_name_family_p,
		 ds_name_given_p,
		 ds_name_middle_p,
		 tp_gender_p,
		 nr_profession_p,
		 tp_profession_p,
		 dt_profession_start_p,
		 nr_seq_pie_message_p
		);
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1088701);
	end if;
      nr_seq_pie_pract_p:= nr_sequencia_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pie_practitioner_prof (nr_seq_pie_message_p pie_message.nr_sequencia%type, dt_name_edit_p pie_practitioner.dt_name_edit%type, ds_name_title_p pie_practitioner.ds_name_title%type, ds_name_family_p pie_practitioner.ds_name_family%type, ds_name_given_p pie_practitioner.ds_name_given%type, ds_name_middle_p pie_practitioner.ds_name_middle%type, tp_gender_p pie_practitioner.tp_gender%type, nr_profession_p pie_practitioner.nr_profession%type, tp_profession_p pie_practitioner.tp_profession%type, dt_profession_start_p pie_practitioner.dt_profession_start%type, nr_seq_pie_pract_p INOUT pie_practitioner.nr_sequencia%type) FROM PUBLIC;
