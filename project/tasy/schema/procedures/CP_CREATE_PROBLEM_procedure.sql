-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cp_create_problem ( nr_seq_care_plan_p cp_possible_prob.nr_seq_care_plan%type, ds_unique_value_p cp_problem.ds_unique_value%type, ds_version_p cp_problem.ds_version%type, ds_display_name_p cp_problem.ds_display_name%type, ds_evidence_url_p cp_problem.ds_evidence_url%type, ie_evidence_url_type_p cp_problem.ie_evidence_url_type%type, nr_seq_order_p cp_problem.nr_seq_order%type, nm_usuario_p cp_problem.nm_usuario%type, nr_sequencia_p INOUT cp_problem.nr_sequencia%type, nr_seq_possible_prob_p INOUT cp_possible_prob.nr_sequencia%type ) AS $body$
DECLARE


ds_version_w			cp_problem.ds_version%type;
si_record_changed_w		cp_problem.si_record_changed%type;
ds_display_name_w		cp_problem.ds_display_name%type;


BEGIN

begin
	select	nr_sequencia,
			ds_version,
			ds_display_name
	into STRICT	nr_sequencia_p,
			ds_version_w,
			ds_display_name_w
	from	cp_problem
	where	nr_sequencia = (
		SELECT	max(nr_sequencia)
		from	cp_problem
		where	ds_unique_value = ds_unique_value_p
	);
exception
	when no_data_found then
	begin
		nr_sequencia_p		:= null;
		ds_version_w		:= null;
	end;
end;

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	update	cp_possible_prob
	set		si_record_changed = 'N'
	where	nr_seq_problem = nr_sequencia_p;
end if;

select	CASE WHEN count(1)=0 THEN  'N'  ELSE 'Y' END
into STRICT	si_record_changed_w
from	cp_problem
where	(ds_version IS NOT NULL AND ds_version::text <> '')
and		ds_version <> ds_version_p;

if (ds_version_w IS NOT NULL AND ds_version_w::text <> '') and (si_record_changed_w = 'Y') then

	select	CASE WHEN count(1)=0 THEN  'Y'  ELSE 'N' END
	into STRICT	si_record_changed_w
	from	cp_problem
	where	ds_unique_value = ds_unique_value_p;
	
	if (si_record_changed_w = 'N') then
		select	CASE WHEN ds_display_name_p=coalesce(ds_display_name_w, ds_display_name_p) THEN  'N'  ELSE 'Y' END
		into STRICT	si_record_changed_w
		;
	end if;

end if;

if (coalesce(nr_sequencia_p::text, '') = '' or ds_version_w <> ds_version_p) then
	select	nextval('cp_problem_seq')
	into STRICT	nr_sequencia_p
	;

	insert into cp_problem(
		nr_sequencia,
		ds_unique_value,
		ds_version,
		ds_display_name,
		ds_evidence_url,
		ie_evidence_url_type,
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
		ds_unique_value_p,
		ds_version_p,
		ds_display_name_p,
		ds_evidence_url_p,
		ie_evidence_url_type_p,
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
	
	update	cp_problem
	set		si_record_changed = 'N'
	where 	ds_version = ds_version_w;
end if;

if (nr_seq_care_plan_p IS NOT NULL AND nr_seq_care_plan_p::text <> '') then
	begin
		select	nr_sequencia
		into STRICT	nr_seq_possible_prob_p
		from	cp_possible_prob
		where	nr_seq_care_plan = nr_seq_care_plan_p
		and 	nr_seq_problem = nr_sequencia_p;
	exception
		when no_data_found then
			nr_seq_possible_prob_p	:= null;
	end;
	
	if (coalesce(nr_seq_possible_prob_p::text, '') = '') then
	
		if (si_record_changed_w = 'N') then
			select	CASE WHEN count(1)=0 THEN  'Y'  ELSE 'N' END
			into STRICT	si_record_changed_w
			from	cp_problem a,
					cp_possible_prob b
			where	a.nr_sequencia = b.nr_seq_problem
			and		b.nr_seq_care_plan = get_old_care_plan(nr_seq_care_plan_p) 
			and		a.ds_unique_value = ds_unique_value_p;
		end if;
		
		select	nextval('cp_possible_prob_seq')
		into STRICT	nr_seq_possible_prob_p
		;
		
		insert into cp_possible_prob(
			nr_sequencia,
			nr_seq_care_plan,
			nr_seq_problem,
			ie_origin,
			si_import_status,
			ie_situacao,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			si_record_changed
		) values (
			nr_seq_possible_prob_p,
			nr_seq_care_plan_p,
			nr_sequencia_p,
			'E', -- From Elsevier
			'SP',
			'I',
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			coalesce(si_record_changed_w, 'N')
		);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cp_create_problem ( nr_seq_care_plan_p cp_possible_prob.nr_seq_care_plan%type, ds_unique_value_p cp_problem.ds_unique_value%type, ds_version_p cp_problem.ds_version%type, ds_display_name_p cp_problem.ds_display_name%type, ds_evidence_url_p cp_problem.ds_evidence_url%type, ie_evidence_url_type_p cp_problem.ie_evidence_url_type%type, nr_seq_order_p cp_problem.nr_seq_order%type, nm_usuario_p cp_problem.nm_usuario%type, nr_sequencia_p INOUT cp_problem.nr_sequencia%type, nr_seq_possible_prob_p INOUT cp_possible_prob.nr_sequencia%type ) FROM PUBLIC;
