-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fis_check_fiscal_xml ( nr_seq_project_p bigint ) RETURNS varchar AS $body$
DECLARE


record_amount_w	bigint := 0;
response_w		varchar(1) := 'N';


BEGIN
	
	select count(*)
	into STRICT record_amount_w
	from fis_projeto_xml
	where nr_seq_projeto = nr_seq_project_p;
	
	if (record_amount_w > 0) then
		response_w := 'S';
	end if;
	
	return response_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fis_check_fiscal_xml ( nr_seq_project_p bigint ) FROM PUBLIC;

