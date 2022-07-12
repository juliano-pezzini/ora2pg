-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_exportar_hl7_long_pck.armazena_result_todos_sql (nm_param_w text, vl_param_w text, vl_param_2_w DBMS_SQL.VARCHAR2A) AS $body$
DECLARE

	contador_w	bigint;
	achou_param_w	boolean;
	
BEGIN
--		if	( vl_param_w is not null ) then
			achou_param_w := false;
			for contador_w in 1..ar_result_todos_sql_p.count loop
				if ( current_setting('wheb_exportar_hl7_long_pck.ar_result_todos_sql_p')::myArray[contador_w].nm = nm_param_w ) then
						current_setting('wheb_exportar_hl7_long_pck.ar_result_todos_sql_p')::myArray[contador_w].vl := vl_param_w;
            current_setting('wheb_exportar_hl7_long_pck.ar_result_todos_sql_p')::myArray[contador_w].v2 := vl_param_2_w;
						achou_param_w := true;
						exit;
				end if;
			end loop;
			if ( not achou_param_w ) then
				current_setting('wheb_exportar_hl7_long_pck.ar_result_todos_sql_p')::myArray(current_setting('wheb_exportar_hl7_long_pck.ar_result_todos_sql_p')::myArray.count+1).nm := nm_param_w;
				current_setting('wheb_exportar_hl7_long_pck.ar_result_todos_sql_p')::myArray(current_setting('wheb_exportar_hl7_long_pck.ar_result_todos_sql_p')::myArray.count).vl := vl_param_w;
        current_setting('wheb_exportar_hl7_long_pck.ar_result_todos_sql_p')::myArray(current_setting('wheb_exportar_hl7_long_pck.ar_result_todos_sql_p')::myArray.count).v2 := vl_param_2_w;
			end if;
--		end if;
	end;

	/*Percorre a String do final para o começo eliminando os caracter que não estiver na lista de caracteres validos;
	  Quando encontrar um caracter valido comeca a concatenar os caracteres até encontrar novamente
	  um caracter não válido
	*/
$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_exportar_hl7_long_pck.armazena_result_todos_sql (nm_param_w text, vl_param_w text, vl_param_2_w DBMS_SQL.VARCHAR2A) FROM PUBLIC;
