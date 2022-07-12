-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_pat_local ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		pat_local.ds_local%type;


BEGIN
begin
	select	a.ds_local
	into STRICT	ds_retorno_w
	from	pat_local a
	where	a.nr_sequencia = nr_sequencia_p;
exception
when others then
	ds_retorno_w := '';
end;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_pat_local ( nr_sequencia_p bigint) FROM PUBLIC;

