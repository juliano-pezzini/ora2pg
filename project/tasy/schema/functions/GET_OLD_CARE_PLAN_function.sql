-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_old_care_plan (nr_seq_care_plan_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_care_plan_w	care_plan.nr_sequencia%type;
ds_unique_value_w	care_plan.ds_unique_value%type;


BEGIN

if (nr_seq_care_plan_p IS NOT NULL AND nr_seq_care_plan_p::text <> '') then

	select	max(ds_unique_value)
	into STRICT	ds_unique_value_w
	from	care_plan
	where	nr_sequencia = nr_seq_care_plan_p;
	
	if (ds_unique_value_w IS NOT NULL AND ds_unique_value_w::text <> '') then
	
		select 	max(nr_sequencia)
		into STRICT	nr_seq_care_plan_w
		from	care_plan
		where	ds_unique_value = ds_unique_value_w
		and		nr_sequencia <> nr_seq_care_plan_p;
		
	end if;
end if;

return nr_seq_care_plan_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_old_care_plan (nr_seq_care_plan_p bigint) FROM PUBLIC;
