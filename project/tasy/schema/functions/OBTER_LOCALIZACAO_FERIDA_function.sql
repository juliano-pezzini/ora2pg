-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_localizacao_ferida ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_localizacao_w	varchar(60);


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	select	ds_localizacao
	into STRICT	ds_localizacao_w
	from	localizacao_ferida
	where	nr_sequencia	= nr_sequencia_p;
end if;

return	ds_localizacao_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_localizacao_ferida ( nr_sequencia_p bigint) FROM PUBLIC;

