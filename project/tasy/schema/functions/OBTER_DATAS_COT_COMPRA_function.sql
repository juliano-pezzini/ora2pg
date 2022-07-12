-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_datas_cot_compra ( nr_cot_compra_p bigint, ie_data_p text) RETURNS timestamp AS $body$
DECLARE


dt_cot_compra_w		timestamp;
dt_retorno_w		timestamp;


BEGIN

select	dt_cot_compra
into STRICT	dt_cot_compra_w
from	cot_compra
where	nr_cot_compra = nr_cot_compra_p;

if (ie_data_p = 'D') then
	dt_retorno_w := dt_cot_compra_w;
end if;


return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_datas_cot_compra ( nr_cot_compra_p bigint, ie_data_p text) FROM PUBLIC;

