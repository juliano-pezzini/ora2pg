-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hem_obter_cod_ventr ( nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


cd_ventriculo_w	hem_desc_ventriculografia.cd_ventriculo%type;

BEGIN
if (coalesce(nr_sequencia_p,0) > 0) then

	select	max(cd_ventriculo)
	into STRICT	cd_ventriculo_w
	from	hem_desc_ventriculografia
	where	nr_sequencia = nr_sequencia_p;

end if;
return	cd_ventriculo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hem_obter_cod_ventr ( nr_sequencia_p bigint) FROM PUBLIC;
