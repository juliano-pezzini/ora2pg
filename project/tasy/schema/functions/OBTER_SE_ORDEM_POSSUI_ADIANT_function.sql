-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_ordem_possui_adiant (nr_ordem_compra_p bigint) RETURNS varchar AS $body$
DECLARE


qt_existe_w			bigint;
ie_retorno_w			varchar(1) := 'N';


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	ordem_compra_adiant_pago a
where	a.nr_ordem_compra = nr_ordem_compra_p;

if (qt_existe_w > 0) then
	ie_retorno_w := 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_ordem_possui_adiant (nr_ordem_compra_p bigint) FROM PUBLIC;
