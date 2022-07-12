-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION com_obter_ambiente ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(50);
ie_migracao_w	varchar(5);


BEGIN
select	coalesce(max(a.ie_migracao),'D')
into STRICT	ie_migracao_w
from	com_cliente a
where	a.nr_sequencia = nr_sequencia_p;
if (coalesce(ie_migracao_w,'D') = 'M') then
	ds_retorno_w := 'Java';
else	ds_retorno_w := 'Delphi';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION com_obter_ambiente ( nr_sequencia_p bigint) FROM PUBLIC;

