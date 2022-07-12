-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION bifrost_log.getlogmessage ( nm_event_p text, ds_filter_p text, ds_path_filter_p text default null) RETURNS SETOF T_BIFROST_LAYER_LOG AS $body$
DECLARE

		
/*
=================================================================
ds_filter_p: 
	- defines the filters to be applied in the where clause;
	- simple filter: patientid=1015763231;
	- multiple value allowed: nrsequence=152556;patientid=26262;

ds_path_filter_p:
	- optional;
	- defines the path to be used to get the value to be used on the filter:
	- eg.: 	* json = {"patientidentification":{"patientid":"1015763231","sexid":"m"}} 
		* ds_filter_p = patientid=1015763231
		* ds_path_filter_p = patientidentification
		
		* json = {"patient_id" : "1018952367" , "encounter_id" : 3400010}
		* ds_filter_p = patient_id=1018952367
		* ds_path_filter_p = null
=================================================================
*/
bifrost_layer_log_w	bifrost_layer_log%rowtype;

c01				integer;
resultado				integer;

ds_select_w			varchar(4000);
ds_restricao_w			varchar(4000);
ds_where_w			varchar(4000);
ds_atributo_w			varchar(4000);
ds_valor_w			varchar(4000);

ds_filtros_w			dbms_sql.varchar2_table;
i				integer;
		

BEGIN
ds_select_w	:=	' select nr_sequence from bifrost_layer_log a where a.nm_event like ' || chr(39) || nm_event_p || chr(39) || ' ';
ds_filtros_w	:=	obter_lista_string(ds_filter_p, ';');

for i in 1..ds_filtros_w.count loop
	begin
	ds_atributo_w	:=	obter_valor_campo_separador(ds_filtros_w(i), 1, '=');
	ds_valor_w	:=	obter_valor_campo_separador(ds_filtros_w(i), 2, '=');
	
	if (coalesce(ds_path_filter_p,'NULL') <> 'NULL') then
		ds_atributo_w	:=	ds_path_filter_p || '.' || ds_atributo_w;
	end if;
		
	if (ds_atributo_w not like '$.%') then
		ds_atributo_w	:=	chr(39) || '$.' || ds_atributo_w || chr(39);
	else
		ds_atributo_w	:=	chr(39) || ds_atributo_w || chr(39) || ' ';
	end if;
	
	ds_valor_w	:=	chr(39) || ds_valor_w || chr(39);
	
	ds_restricao_w	:=	' and json_value(json_query(a.ds_content, ' ||
					ds_atributo_w  || ' WITH WRAPPER),'|| chr(39) || '$[0]' || chr(39) || ') = ' || ds_valor_w;
					
	ds_where_w	:=	ds_where_w || ds_restricao_w;
	end;
end loop;

c01 := dbms_sql.open_cursor;
dbms_sql.parse(c01, ds_select_w || ds_where_w, dbms_sql.native);
dbms_sql.define_column(c01, 1, bifrost_layer_log_w.nr_sequence);
resultado := dbms_sql.execute(c01);

while(dbms_sql.fetch_rows(c01) > 0) loop
	begin
	
	dbms_sql.column_value(c01, 1, bifrost_layer_log_w.nr_sequence);
	
	begin
	select	*
	into STRICT	bifrost_layer_log_w
	from	bifrost_layer_log
	where	nr_sequence = bifrost_layer_log_w.nr_sequence;
	
	RETURN NEXT bifrost_layer_log_w;
	exception
	when others then
		bifrost_layer_log_w	:=	null;
	end;
	end;
end loop;

dbms_sql.close_cursor(c01);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION bifrost_log.getlogmessage ( nm_event_p text, ds_filter_p text, ds_path_filter_p text default null) FROM PUBLIC;