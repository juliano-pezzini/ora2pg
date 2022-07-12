-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION quebra_linha_etiqueta ( ds_texto_p text, linha_p bigint, qt_caracter_linha_p bigint) RETURNS varchar AS $body$
DECLARE


ds_resultado_w  	varchar(4000);
ds_resultado_aux_w 	varchar(4000);
i   			bigint;
k   			bigint;
j   			bigint;
l   			bigint;
total_caracter_w 	numeric(20);
ds_texto_w  		varchar(4000) := ds_texto_p||' ';

BEGIN
if (ds_texto_p IS NOT NULL AND ds_texto_p::text <> '') then
l := 1;

for j in l..linha_p loop
	ds_resultado_w := '';
	k := (( (j-1) * qt_caracter_linha_p) /*+ 1*/) + (j-1);
	total_caracter_w := (((	(j-1) * qt_caracter_linha_p) +1) + qt_caracter_linha_p) + (j-1);

	for i in k..total_caracter_w loop
		begin
		ds_resultado_aux_w := ds_resultado_aux_w || substr(ds_texto_w, i,1);

		if (substr(ds_texto_w, i,1) = ' ') then
			ds_resultado_w		:= ds_resultado_w || ds_resultado_aux_w;
			ds_resultado_aux_w	:= '';

		end if;

		end;

	end loop;
end loop;

end if;

return ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION quebra_linha_etiqueta ( ds_texto_p text, linha_p bigint, qt_caracter_linha_p bigint) FROM PUBLIC;

