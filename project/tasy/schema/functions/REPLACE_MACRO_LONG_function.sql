-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION replace_macro_long ( ds_text_p text, ds_macro_p text, ds_value_p text) RETURNS text AS $body$
DECLARE


ie_macro_feature_enabled	varchar(1) := 'S';
ds_text_w text;
macro_row_w search_macros_row := search_macros_row(null,null,null,null,null);

cursor_macros CURSOR FOR
SELECT 	*
from	table(search_macros(null, ds_macro_p, null, 'R'));


BEGIN
/*
	Ao alterar esta function favor verificar também as functions replace_macro e replace_macro_clob
*/
ds_text_w := ds_text_p;

if (ie_macro_feature_enabled = 'S') then
	begin
	open cursor_macros;
		loop
		fetch cursor_macros into
			macro_row_w.ds_macro_philips,
			macro_row_w.nr_seq_macro_philips,
			macro_row_w.ds_macro_client,
			macro_row_w.nr_seq_macro_client,
			macro_row_w.ds_locale;
		EXIT WHEN NOT FOUND; /* apply on cursor_macros */
			begin
			ds_text_w := replace(ds_text_w, macro_row_w.ds_macro_client, ds_value_p);
			end;
		end loop;
	close cursor_macros;
	end;
else
	begin
	ds_text_w := replace(ds_text_w, ds_macro_p, ds_value_p);
	end;
end if;

return	ds_text_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION replace_macro_long ( ds_text_p text, ds_macro_p text, ds_value_p text) FROM PUBLIC;

