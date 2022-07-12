-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_iss_item ( cd_convenio_p bigint, vl_item_p bigint) RETURNS bigint AS $body$
DECLARE


vl_iss_w		double precision	:= 0;
pr_imposto_w		double precision	:= 0;
cd_tributo_w		smallint;


BEGIN
select	coalesce(max(cd_tributo),0)
into STRICT	cd_tributo_w
from	tributo
where	ie_tipo_tributo	= 'ISS';

if (cd_tributo_w <> 0) then
	select	coalesce(max(pr_imposto),0)
	into STRICT	pr_imposto_w
	from	regra_calculo_imposto
	where	coalesce(cd_convenio, cd_convenio_p)	= cd_convenio_p
	and	cd_tributo			= cd_tributo_w;

	if (pr_imposto_w > 0) then
		vl_iss_w	:= dividir(pr_imposto_w, 100) * vl_item_p;
	end if;
end if;

return	vl_iss_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_iss_item ( cd_convenio_p bigint, vl_item_p bigint) FROM PUBLIC;

