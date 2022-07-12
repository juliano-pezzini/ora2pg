-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_aprov_cotacao ( nr_cot_compra_p bigint) RETURNS varchar AS $body$
DECLARE


ie_status_w		varchar(15);
dt_aprovacao_w		timestamp;
qt_registros_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_registros_w
from	cot_compra_item
where	nr_cot_compra = nr_cot_compra_p
and	(dt_reprovacao IS NOT NULL AND dt_reprovacao::text <> '');

if (qt_registros_w > 0) then
	ie_status_w := 'RE';
else
	select	dt_aprovacao
	into STRICT	dt_aprovacao_w
	from	cot_compra
	where	nr_cot_compra = nr_cot_compra_p;

	if (coalesce(dt_aprovacao_w::text, '') = '') then
		ie_status_w := 'NA';
	else
		ie_status_w := 'AP';
	end if;
end if;

return	ie_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_aprov_cotacao ( nr_cot_compra_p bigint) FROM PUBLIC;
