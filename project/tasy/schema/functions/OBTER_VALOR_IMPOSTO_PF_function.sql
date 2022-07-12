-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_imposto_pf (nr_titulo_p bigint, ie_tipo_imposto_p text) RETURNS bigint AS $body$
DECLARE


vl_imposto_w	double precision;			


BEGIN

if (ie_tipo_imposto_p = 'IR') then
	select	coalesce(sum(i.vl_imposto),0)
	into STRICT	vl_imposto_w
	from	titulo_pagar_imposto i,
		tributo t
	where	i.cd_tributo = t.cd_tributo
	and	i.nr_titulo = nr_titulo_p
	and	t.ie_tipo_tributo = 'IR';
elsif (ie_tipo_imposto_p = 'ISRDOM') then
	select	coalesce(sum(i.vl_imposto),0)
	into STRICT	vl_imposto_w
	from	titulo_pagar_imposto i,
		tributo t
	where	i.cd_tributo = t.cd_tributo
	and	i.nr_titulo = nr_titulo_p
	and	t.ie_tipo_tributo = 'ISRDOM';
end if;

return	vl_imposto_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_imposto_pf (nr_titulo_p bigint, ie_tipo_imposto_p text) FROM PUBLIC;
