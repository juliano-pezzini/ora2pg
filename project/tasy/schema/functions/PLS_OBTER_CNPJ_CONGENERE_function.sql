-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_cnpj_congenere ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


cd_cgc_w			varchar(14);


BEGIN

if (coalesce(nr_sequencia_p,0) <> 0) then

	select	cd_cgc
	into STRICT	cd_cgc_w
	from	pls_congenere
	where	nr_sequencia	= nr_sequencia_p;

end if;

return	cd_cgc_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_cnpj_congenere ( nr_sequencia_p bigint) FROM PUBLIC;

