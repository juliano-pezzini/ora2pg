-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION formata_casas_decimais ( vl_campo_p bigint, qt_decimais_p bigint) RETURNS varchar AS $body$
DECLARE



ds_retorno_w		varchar(60) := '';
vl_campo_w		varchar(60);
vl_novo_campo_w		varchar(60);
i			bigint  := 0;
ie_decimais_w		varchar(100) := '';


BEGIN

--if	(qt_decimais_p = '0') then
--	ie_decimais_w	:= '';
--end if;
i := 0;
for	i in 1..qt_decimais_p loop
	ie_decimais_w	:= (ie_decimais_w || '9');
end loop;

if (ie_decimais_w IS NOT NULL AND ie_decimais_w::text <> '') then
	ie_decimais_w := '.' || ie_decimais_w;
end if;

if (vl_campo_p IS NOT NULL AND vl_campo_p::text <> '') then
	begin
	vl_campo_w	:= to_char(vl_campo_p);

	select	replace(replace(replace(replace(to_char(vl_campo_p, '999,999,999,990' || ie_decimais_w), ',', 'X'),'.', ','), 'X', '.'),' ','')
	into STRICT	vl_campo_w
	;

	i := 0;
	for	i in 1..length(vl_campo_w) loop
		if (substr(vl_campo_w,i,1) <> ' ') then
			vl_novo_campo_w	:= vl_novo_campo_w || substr(vl_campo_w,i,1);
		end if;
	end loop;
	end;
end if;

ds_retorno_w	:= vl_novo_campo_w;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION formata_casas_decimais ( vl_campo_p bigint, qt_decimais_p bigint) FROM PUBLIC;

