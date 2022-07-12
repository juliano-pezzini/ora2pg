-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hem_obter_cod_font ( nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


cd_fonte_w	hem_fonte_direcao.cd_fonte%type;

BEGIN
if (coalesce(nr_sequencia_p,0) > 0) then

	select	max(cd_fonte)
	into STRICT	cd_fonte_w
	from	hem_fonte_direcao
	where	nr_sequencia = nr_sequencia_p;

end if;
return	cd_fonte_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hem_obter_cod_font ( nr_sequencia_p bigint) FROM PUBLIC;
