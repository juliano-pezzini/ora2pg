-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION check_customer_environment () RETURNS varchar AS $body$
DECLARE

qtd_record_w		integer;														
result_w			varchar(1);
nm_database_w		varchar(255);
ds_server_host_w	varchar(255);


BEGIN
	
	select	sys_context('USERENV', 'DB_NAME'),
			sys_context('USERENV', 'SERVER_HOST')
	into STRICT	nm_database_w,
			ds_server_host_w
	;

	result_w := 'N';
	select	count(*)
	into STRICT 	qtd_record_w
	from	tasy_customer_environment
	where	nm_database = nm_database_w
	and		ds_server_host = ds_server_host_w;
	
	if (qtd_record_w >= 5) then

		select	count(d.ie_production)
		into STRICT	qtd_record_w
		from (SELECT	distinct c.ie_production		
				 from (select	a.nm_database,
								a.ds_server_host,
								a.ie_production,
								a.dt_atualizacao
						 from (select	b.nm_database,
										b.ds_server_host,
										b.ie_production,
										b.dt_atualizacao
								 from 	tasy_customer_environment b
								 where	b.nm_database = nm_database_w
								 and	b.ds_server_host = ds_server_host_w
								 order by b.dt_atualizacao desc) a LIMIT 5) c) d;
		
		if (qtd_record_w <> 1) then
			result_w := 'S';
		end if;
		
	else
		result_w := 'S';
	end if;
	
	return result_w;	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION check_customer_environment () FROM PUBLIC;
