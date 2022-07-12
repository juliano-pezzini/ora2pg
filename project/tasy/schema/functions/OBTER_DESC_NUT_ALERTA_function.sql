-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_nut_alerta (cd_pessoa_fisica_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);
nr_sequencia_w	integer;


BEGIN
ds_retorno_w := '';
if (cd_pessoa_fisica_p <> 0) then
	select  max(nr_sequencia),
		    max(substr(ds_alerta,1,255))
	into STRICT	nr_sequencia_w,
			ds_retorno_w
	from nut_alerta
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_nut_alerta (cd_pessoa_fisica_p bigint) FROM PUBLIC;
