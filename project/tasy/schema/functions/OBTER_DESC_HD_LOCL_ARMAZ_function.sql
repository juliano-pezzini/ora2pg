-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_hd_locl_armaz ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(255);

BEGIN
ds_retorno_w := '';
if (coalesce(nr_sequencia_p,0) > 0) then

	select	 coalesce(max(ds_local),'')
	into STRICT	 ds_retorno_w
	from  	 hd_local_armazenamento
	where	 nr_sequencia = nr_sequencia_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_hd_locl_armaz ( nr_sequencia_p bigint) FROM PUBLIC;

