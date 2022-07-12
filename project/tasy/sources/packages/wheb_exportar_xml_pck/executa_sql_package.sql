-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--
-- dblink wrapper to call function wheb_exportar_xml_pck.executa_sql() as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE wheb_exportar_xml_pck.executa_sql (ar_xml_elemento_p xmlElemento,ar_result_query_sup_p myArray,ar_resultado_p INOUT myArray, cursor_p INOUT integer) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'SELECT * FROM wheb_exportar_xml_pck.executa_sql_atx ( ' || quote_nullable(ar_xml_elemento_p) || ',' || quote_nullable(ar_result_query_sup_p) || ',' || quote_nullable(ar_resultado_p) || ',' || quote_nullable(cursor_p) || ' )';
	SELECT * FROM dblink(v_conn_str, v_query) AS p (v_ret0 myArray, v_ret1 integer) INTO ar_resultado_p, cursor_p;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE wheb_exportar_xml_pck.executa_sql_atx (ar_xml_elemento_p xmlElemento,ar_result_query_sup_p myArray,ar_resultado_p INOUT myArray, cursor_p INOUT integer) AS $body$
DECLARE
ds_param_w			varchar(4000);
	qt_registro_w  		bigint;
	contador_w			bigint;
	ar_nm_param_sql_w	myArray;
	conta_w				bigint;
	ds_comando_p 		varchar(32000);
	ds_parametro_w		varchar(32000);
	
BEGIN
		begin
		ds_parametro_w := '';
		ds_comando_p := ar_xml_elemento_p[1].DS_SQL;
		cursor_p := DBMS_SQL.OPEN_CURSOR;
		DBMS_SQL.PARSE(cursor_p, ds_comando_p, dbms_sql.native);
		/*Verifica se possui algum parametro*/


		ar_nm_param_sql_w := wheb_exportar_xml_pck.armazena_parametros_sql(ds_comando_p, ar_nm_param_sql_w);
		/*Verifica valor correspondente ao parametro*/


		FOR contador_w IN 1..ar_nm_param_sql_w.count LOOP
			/*Verifica se existe valor para o parametro na Query Superior*/


			ds_param_w := wheb_exportar_xml_pck.obter_valor_parametro(ar_nm_param_sql_w[contador_w].nm,ar_result_query_sup_p);
			/*Verificar se deve gerar o HASH*/


			if ( ar_result_query_sup_p.count = 0 ) and ( ar_nm_param_sql_w[contador_w].nm = 'DS_XML_VALOR') then
				CALL wheb_exportar_xml_pck.gerar_hash();
				ds_param_w := current_setting('wheb_exportar_xml_pck.ds_hash_w')::varchar(32);
			/*Verificar se existe valor para o parametro nos parametros do projeto*/


			elsif ( coalesce(ds_param_w::text, '') = '' ) then
				ds_param_w := wheb_exportar_xml_pck.obter_valor_parametro(ar_nm_param_sql_w[contador_w].nm,current_setting('wheb_exportar_xml_pck.ar_parametros_w')::myArray);
			end if;
			if ( coalesce(ds_param_w::text, '') = '' ) then
				ds_param_w := wheb_exportar_xml_pck.obter_valor_parametro(ar_nm_param_sql_w[contador_w].nm,current_setting('wheb_exportar_xml_pck.ar_result_todos_sql_p')::myArray);
			end if;
			DBMS_SQL.BIND_VARIABLE(cursor_p,ar_nm_param_sql_w[contador_w].nm,ds_param_w,4000);
			ds_parametro_w := ds_parametro_w ||' '|| ar_nm_param_sql_w[contador_w].nm || '='||ds_param_w;
		END LOOP;
		/*Registra as colunas do SQL*/


		ar_resultado_p := wheb_exportar_xml_pck.armazena_colunas_sql(cursor_p, ar_resultado_p);
		/*Executa o SQL*/


		qt_registro_w := DBMS_SQL.EXECUTE(cursor_p);

		exception
		when others then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(174653,'NM_ELEMENTO='||ar_xml_elemento_p[1].NM_ELEMENTO||';NR_SEQUENCIA='||ar_xml_elemento_p[1].NR_SEQUENCIA||';DS_PARAMETROS='||ds_parametro_w||';DS_ERRO='||sqlerrm||';');
		end;
	END;
	/*Armazena os parametros do projeto passados inicialmente*/



$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_exportar_xml_pck.executa_sql (ar_xml_elemento_p xmlElemento,ar_result_query_sup_p myArray,ar_resultado_p INOUT myArray, cursor_p INOUT integer) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE wheb_exportar_xml_pck.executa_sql_atx (ar_xml_elemento_p xmlElemento,ar_result_query_sup_p myArray,ar_resultado_p INOUT myArray, cursor_p INOUT integer) FROM PUBLIC;
