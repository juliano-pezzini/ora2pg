-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pie_practioner_condition ( dt_condition_edit_p pie_pract_condition.dt_condition_edit%type, tp_condition_p pie_pract_condition.tp_condition%type, ds_condition_detail_p pie_pract_condition.ds_condition_detail%type, nr_seq_pie_pract_p pie_pract_condition.nr_seq_pie_pract%type) AS $body$
DECLARE

  nr_sequencia_w 	pie_pract_condition.nr_sequencia%type;

BEGIN

	if ((dt_condition_edit_p IS NOT NULL AND dt_condition_edit_p::text <> '')
	and (tp_condition_p IS NOT NULL AND tp_condition_p::text <> '')
	and (ds_condition_detail_p IS NOT NULL AND ds_condition_detail_p::text <> '')
	and (nr_seq_pie_pract_p IS NOT NULL AND nr_seq_pie_pract_p::text <> ''))    then

		select nextval('pie_pract_condition_seq')
		into STRICT   nr_sequencia_w
		;

		insert into pie_pract_condition(nr_sequencia,
		dt_condition_edit,
		tp_condition,
		ds_condition_detail,
		nr_seq_pie_pract)
		values ( nr_sequencia_w,
		dt_condition_edit_p,
		tp_condition_p,
		ds_condition_detail_p,
		nr_seq_pie_pract_p);
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1088701);
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pie_practioner_condition ( dt_condition_edit_p pie_pract_condition.dt_condition_edit%type, tp_condition_p pie_pract_condition.tp_condition%type, ds_condition_detail_p pie_pract_condition.ds_condition_detail%type, nr_seq_pie_pract_p pie_pract_condition.nr_seq_pie_pract%type) FROM PUBLIC;

