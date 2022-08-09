-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE data_model_view_drop ( data_model_id_p data_model.nr_sequencia%type) AS $body$
DECLARE


ds_sql varchar(4000);
object_name_w data_model.object_name%type;


BEGIN
	begin
	select 	max(b.object_name)
	into STRICT 	object_name_w
	from 	data_model a,
		user_objects b
	where 	a.nr_sequencia = data_model_id_p
	and	upper(a.object_name) = upper(b.object_name)
	and	b.object_type 	= 'MATERIALIZED VIEW';
	exception
	when 	no_data_found then
		object_name_w := null;
	when 	others then
		object_name_w := null;
	end;	
	
	if (object_name_w IS NOT NULL AND object_name_w::text <> '') then	
		ds_sql := 'drop materialized view ' || object_name_w;
		
		$if dbms_db_version.version >= 11 $then
			EXECUTE ds_sql;
		$end
		
	end if;

exception when no_data_found then
	null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE data_model_view_drop ( data_model_id_p data_model.nr_sequencia%type) FROM PUBLIC;
