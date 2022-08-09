-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE load_pbs_catalogue (nr_pbs_version_p bigint, nm_user_p text, nr_estab_p bigint) AS $body$
DECLARE


ds_error_w PBS_MASTER.DS_ADDITIONAL_INFO%type := null;
ds_query_w constant PBS_MASTER.DS_PRICING_MODEL%type := 'alter session set nls_numeric_characters = ''.,''';


BEGIN

	EXECUTE ds_query_w;

	CALL process_pbs_catalog(nr_pbs_version_p,nm_user_p,nr_estab_p);

	update	mbs_import_log a
	set  	a.dt_end = clock_timestamp()
	where   a.ie_status = 'IPBS'
	and     coalesce(a.dt_end::text, '') = '';

	commit;

	exception
	when too_many_rows then
		rollback;
		ds_error_w:=SUBSTR(SQLERRM, 1 , 2000);
		update	mbs_import_log
		set  	dt_end = clock_timestamp(),
				ds_error = ds_error_w
		where   ie_status = 'IPBS'
		and     coalesce(dt_end::text, '') = '';

		commit;
	when others then
		rollback;
		ds_error_w:=SUBSTR(SQLERRM, 1 , 2000);
		update	mbs_import_log
		set  	dt_end = clock_timestamp(),
				ds_error = ds_error_w
		where   ie_status = 'IPBS'
		and     coalesce(dt_end::text, '') = '';

		commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE load_pbs_catalogue (nr_pbs_version_p bigint, nm_user_p text, nr_estab_p bigint) FROM PUBLIC;
