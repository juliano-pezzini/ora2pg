-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_laboratorio (cd_laboratorio_p bigint) RETURNS varchar AS $body$
DECLARE

ds_nome_laboratorio_w		varchar(100);


BEGIN

if (cd_laboratorio_p IS NOT NULL AND cd_laboratorio_p::text <> '') then
	select 	nm_laboratorio
	into STRICT	ds_nome_laboratorio_w
	from 	laboratorio
	where	nr_sequencia = cd_laboratorio_p;
end if;

return	ds_nome_laboratorio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_laboratorio (cd_laboratorio_p bigint) FROM PUBLIC;
