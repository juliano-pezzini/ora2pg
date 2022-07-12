-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE sncm_controle_mat_pck.gerar_job ( command_p text, nm_procedure_p text, minutes_p bigint, job_p INOUT bigint) AS $body$
DECLARE


	minutes_w	bigint;
	next_date_w	timestamp;
	time_w		bigint;
	
	
BEGIN
	
	--find if exists the job
	begin
	select	job
	into STRICT	job_p
	from	job_v
	where	upper(comando) like upper('%'||nm_procedure_p||'%');
	exception
	when others then
		job_p := null;
	end;

	minutes_w := minutes_p;

	--calc the time
	if (coalesce(minutes_p::text, '') = '' or minutes_p = 0) then
		minutes_w := 0.2;
	end if;

	time_w := (1/24/60 * minutes_w);
	next_date_w := clock_timestamp() + time_w;

	--if don't exist, create the job
	if (coalesce(job_p::text, '') = '') then
		dbms_job.submit(	job => job_p,
					what => command_p,
					next_date => next_date_w);
	else
		dbms_job.change(	job => job_p,
					what => command_p,
					next_date => next_date_w,
					interval => null);
	end if;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sncm_controle_mat_pck.gerar_job ( command_p text, nm_procedure_p text, minutes_p bigint, job_p INOUT bigint) FROM PUBLIC;