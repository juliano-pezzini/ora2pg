-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estab_titulo (nr_interno_conta_p bigint, nr_seq_protocolo_p bigint) RETURNS bigint AS $body$
DECLARE


cd_estab_w	smallint;
nr_titulo_w	bigint;


BEGIN

cd_estab_w:= 0;

select 	coalesce(max(nr_titulo),0)
into STRICT	nr_titulo_w
from 	titulo_receber
where 	nr_interno_conta = nr_interno_conta_p;

if (coalesce(nr_titulo_w,0) = 0) then
	select 	coalesce(max(nr_titulo),0)
	into STRICT	nr_titulo_w
	from 	titulo_receber
	where 	nr_seq_protocolo = nr_seq_protocolo_p;
end if;

if (coalesce(nr_titulo_w,0) > 0) then
	select 	coalesce(max(cd_estabelecimento),0)
	into STRICT	cd_estab_w
	from 	titulo_receber
	where	nr_titulo = nr_titulo_w;
end if;

return	cd_estab_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estab_titulo (nr_interno_conta_p bigint, nr_seq_protocolo_p bigint) FROM PUBLIC;

