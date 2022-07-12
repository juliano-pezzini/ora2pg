-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION arredondar_valores_cig (qt_valor_p bigint) RETURNS bigint AS $body$
DECLARE


ds_valor_w	varchar(15);
qt_valor_w	double precision;
qt_decimal_w	smallint;
ie_pos_decimal_w	smallint;

vl_arredondado_w	double precision;


BEGIN
if (qt_valor_p IS NOT NULL AND qt_valor_p::text <> '') then
	ds_valor_w	:= to_char(qt_valor_p);
	ie_pos_decimal_w	:= position(',' in ds_valor_w);
	if (ie_pos_decimal_w = 1) then
		qt_valor_w	:= 0;
	else
		qt_valor_w	:= (substr(ds_valor_w, 1, ie_pos_decimal_w-1))::numeric;
	end if;
	qt_decimal_w		:= (substr(ds_valor_w, ie_pos_decimal_w+1, 1))::numeric;

	if (ie_pos_decimal_w > 0) then
		if (qt_decimal_w < 3) then
			ds_valor_w := qt_valor_w || ',0';
		elsif (qt_decimal_w < 8) then
			ds_valor_w := qt_valor_w || ',5';
		else
			qt_valor_w := qt_valor_w + 1;
			ds_valor_w := qt_valor_w || ',0';
		end if;
		vl_arredondado_w := (ds_valor_w)::numeric;
	else
		vl_arredondado_w := qt_valor_p;
	end if;
end if;

return vl_arredondado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION arredondar_valores_cig (qt_valor_p bigint) FROM PUBLIC;
