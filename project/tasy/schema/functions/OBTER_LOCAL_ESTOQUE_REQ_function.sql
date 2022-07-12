-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_local_estoque_req (nr_requisicao_p bigint) RETURNS bigint AS $body$
DECLARE


cd_local_estoque_w		integer;


BEGIN

if (nr_requisicao_p IS NOT NULL AND nr_requisicao_p::text <> '') then
	select	cd_local_estoque
	into STRICT	cd_local_estoque_w
	from	requisicao_material
	where	nr_requisicao = nr_requisicao_p;
end if;

return cd_local_estoque_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_local_estoque_req (nr_requisicao_p bigint) FROM PUBLIC;
