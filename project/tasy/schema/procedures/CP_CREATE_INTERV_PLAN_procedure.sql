-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cp_create_interv_plan ( nr_seq_possible_prob_p cp_interv_plan.nr_seq_possible_prob%type, ds_unique_value_p cp_interv_plan.ds_unique_value%type, ds_display_name_p cp_interv_plan.ds_display_name%type, nr_seq_order_p cp_interv_plan.nr_seq_order%type, nm_usuario_p cp_interv_plan.nm_usuario%type, nr_sequencia_p INOUT cp_interv_plan.nr_sequencia%type ) AS $body$
DECLARE


si_record_changed_w			cp_interv_plan.si_record_changed%type;
nr_seq_old_care_plan_w		care_plan.nr_sequencia%type;
ds_display_name_w			cp_interv_plan.ds_display_name%type;


BEGIN

select	max(get_old_care_plan(nr_seq_care_plan))
into STRICT	nr_seq_old_care_plan_w
from	cp_possible_prob
where	nr_sequencia = nr_seq_possible_prob_p;

if (nr_seq_old_care_plan_w IS NOT NULL AND nr_seq_old_care_plan_w::text <> '') then

	select	CASE WHEN count(1)=0 THEN  'Y'  ELSE 'N' END ,
			max(ds_display_name)
	into STRICT	si_record_changed_w,
			ds_display_name_w
	from	cp_interv_plan a,
			cp_possible_prob b
	where	a.nr_seq_possible_prob = b.nr_sequencia
	and		a.ds_unique_value = ds_unique_value_p
	and		b.nr_seq_care_plan = nr_seq_old_care_plan_w;
	
	if (si_record_changed_w = 'N') then
		select	CASE WHEN ds_display_name_p=coalesce(ds_display_name_w, ds_display_name_p) THEN  'N'  ELSE 'Y' END
		into STRICT	si_record_changed_w
		;
	end if;
	
end if;

select	nextval('cp_interv_plan_seq')
into STRICT	nr_sequencia_p
;

insert into cp_interv_plan(
	nr_sequencia,
	nr_seq_possible_prob,
	ds_unique_value,
	ds_display_name,
	ie_origin,
	nr_seq_order,
	si_import_status,
	ie_situacao,
	nm_usuario,
	dt_atualizacao,
	nm_usuario_nrec,
	dt_atualizacao_nrec,
	si_record_changed
) values (
	nr_sequencia_p,
	nr_seq_possible_prob_p,
	ds_unique_value_p,
	ds_display_name_p,
	'E', -- From Elsevier
	nr_seq_order_p,
	'SP',
	'I',
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	coalesce(si_record_changed_w, 'N')
);

update	cp_interv_plan
set		si_record_changed = 'N'
where 	ds_unique_value = ds_unique_value_p
and		nr_sequencia <> nr_sequencia_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cp_create_interv_plan ( nr_seq_possible_prob_p cp_interv_plan.nr_seq_possible_prob%type, ds_unique_value_p cp_interv_plan.ds_unique_value%type, ds_display_name_p cp_interv_plan.ds_display_name%type, nr_seq_order_p cp_interv_plan.nr_seq_order%type, nm_usuario_p cp_interv_plan.nm_usuario%type, nr_sequencia_p INOUT cp_interv_plan.nr_sequencia%type ) FROM PUBLIC;

