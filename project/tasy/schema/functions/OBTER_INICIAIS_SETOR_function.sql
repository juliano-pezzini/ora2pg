-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_iniciais_setor ( ds_setor_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(20);
ds_setor_w	varchar(255);


BEGIN

ds_setor_w := ds_setor_p;
ds_retorno_w := substr(ds_setor_w,1,1);

while length(ds_setor_w) > 0 loop
	if (substr(ds_setor_w,1,1) = ' ') then
		ds_retorno_w := ds_retorno_w || substr(ds_setor_w,2,1);
	end if;
	ds_setor_w := substr(ds_setor_w,2,length(ds_setor_w));
end loop;

return upper(ds_retorno_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_iniciais_setor ( ds_setor_p text) FROM PUBLIC;
