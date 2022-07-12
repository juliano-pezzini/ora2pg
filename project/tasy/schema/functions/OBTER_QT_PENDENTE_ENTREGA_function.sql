-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_pendente_entrega ( nr_solic_compra_p bigint, nr_item_solic_compra_p bigint) RETURNS bigint AS $body$
DECLARE


retorno		double precision := 0;


BEGIN

if (coalesce(nr_solic_compra_p,0) > 0) and (coalesce(nr_item_solic_compra_p,0) > 0) then
	select	coalesce(sum(a.qt_prevista_entrega),0) - coalesce(max(obter_qt_entregue_solic_nf(b.nr_solic_compra, b.nr_item_solic_compra)),0)
	into STRICT	retorno
	from	ordem_compra_item_entrega a,
			ordem_compra_item b
	where   a.nr_ordem_compra = b.nr_ordem_compra
	and		a.nr_item_oci = b.nr_item_oci
	and		b.nr_solic_compra = nr_solic_compra_p
	and		b.nr_item_solic_compra = nr_item_solic_compra_p
	and		coalesce(a.dt_cancelamento::text, '') = '';
end if;

return retorno;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_pendente_entrega ( nr_solic_compra_p bigint, nr_item_solic_compra_p bigint) FROM PUBLIC;

