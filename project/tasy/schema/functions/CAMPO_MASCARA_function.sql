-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION campo_mascara ( vl_campo_p bigint, qt_decimais_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(80) := '';
ds_mascara_w		varchar(100) := '';
vl_campo_w		varchar(100);
qt_campos_antes_virg_w	bigint := 0;
i			bigint := 0;


BEGIN

if (vl_campo_p IS NOT NULL AND vl_campo_p::text <> '') then
	begin
	vl_campo_w := to_char(vl_campo_p);

	vl_campo_w := replace(vl_campo_w, ',', '.');

	i := 0;

	for	i in 1..length(vl_campo_w) loop
		if (substr(vl_campo_w,i,1) <> '.') then
			qt_campos_antes_virg_w	:= qt_campos_antes_virg_w + 1;
		else
			begin
			if (qt_campos_antes_virg_w = 0) then
				qt_campos_antes_virg_w := 1;
			end if;
			exit;
			end;
		end if;
	end loop;

	i := 0;

	for	i in 1..qt_campos_antes_virg_w loop
		ds_mascara_w	:= ds_mascara_w || '0';
	end loop;

	if (qt_decimais_p IS NOT NULL AND qt_decimais_p::text <> '') and (qt_decimais_p > 0) then
		ds_mascara_w	:= ds_mascara_w || '.';
	end if;

	i := 0;

	for	i in 1..qt_decimais_p loop
		ds_mascara_w	:= ds_mascara_w || '9';
	end loop;

	if (vl_campo_p IS NOT NULL AND vl_campo_p::text <> '') then

		ds_retorno_w := to_char(vl_campo_p, ds_mascara_w);
	end if;
	end;
	end if;

ds_retorno_w := replace(ds_retorno_w, ' ', '');

return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION campo_mascara ( vl_campo_p bigint, qt_decimais_p bigint) FROM PUBLIC;
