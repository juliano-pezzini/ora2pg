-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_qt_job_ativa ( ds_rotina_p text, qt_job_p INOUT bigint) AS $body$
DECLARE


qt_job_w	integer;

c01 CURSOR(	ds_rotina_pc	text) FOR
	SELECT	job
	from	all_jobs
	where	what like '%'||ds_rotina_pc||'%'
	and	broken = 'Y';

BEGIN

if (ds_rotina_p IS NOT NULL AND ds_rotina_p::text <> '') then

	-- limpamos todas que estiverem paradas
	for r_c01_w in c01(ds_rotina_p) loop
		if (r_c01_w.job IS NOT NULL AND r_c01_w.job::text <> '') then
			dbms_job.remove(r_c01_w.job);
		end if;
	end loop;

	-- depois verificamos se existe uma job ativa
	select	count(1)
	into STRICT	qt_job_w
	from	job_v
	where 	comando like '%' || ds_rotina_p || '%';
end if;

qt_job_p := qt_job_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_qt_job_ativa ( ds_rotina_p text, qt_job_p INOUT bigint) FROM PUBLIC;
