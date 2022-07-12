-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_somente_letra_espaco ( ds_campo_p text) RETURNS varchar AS $body$
DECLARE


ds_campo_w    	varchar(255);
i     		integer;
k		integer;
ds_letra_w	varchar(27);


BEGIN
ds_letra_w		:= 'abcdefghijklmnopqrstuvxwyz ';
ds_campo_w		:= '';
if (coalesce(ds_campo_p::text, '') = '') or (ds_campo_p = '') then
	ds_campo_w	:= '';
else
	begin
	for i in 1..length(ds_campo_p) loop
 		begin
		k	:= instr(ds_letra_w, lower(substr(ds_campo_p, i, 1)) , -1);
	 	if (k <> 0)  then
  			ds_campo_w := ds_campo_w || substr(ds_campo_p, i, 1);
		end if;
		end;
	end loop;
	end;
end if;

return ds_campo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_somente_letra_espaco ( ds_campo_p text) FROM PUBLIC;
