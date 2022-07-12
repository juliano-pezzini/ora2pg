-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_exportar_hl7_long_pck.append_separator (ie_first_append_p INOUT boolean, nr_count_p INOUT bigint, ds_valor_p INOUT text) AS $body$
DECLARE

	t_nr_count_w integer;
	
BEGIN
		t_nr_count_w := nr_count_p;
		if (ie_first_append_p) then
			t_nr_count_w := t_nr_count_w - 1;
			ie_first_append_p := false;
		end if;
		for i in 1..t_nr_count_w loop
			ds_valor_p := ds_valor_p || current_setting('wheb_exportar_hl7_long_pck.ds_separador_attr_w')::varchar(1);
		end loop;
		nr_count_p := 0;
	end;


$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_exportar_hl7_long_pck.append_separator (ie_first_append_p INOUT boolean, nr_count_p INOUT bigint, ds_valor_p INOUT text) FROM PUBLIC;
