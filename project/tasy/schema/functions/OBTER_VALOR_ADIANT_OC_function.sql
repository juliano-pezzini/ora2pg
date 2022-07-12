-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_adiant_oc ( nr_ordem_compra_p bigint) RETURNS bigint AS $body$
DECLARE


vl_vinculado_w			double precision;


BEGIN

select	coalesce(sum(vl_vinculado),0)
into STRICT	vl_vinculado_w
from	ordem_compra_adiant_pago
where	nr_ordem_compra = nr_ordem_compra_p;

return	vl_vinculado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_adiant_oc ( nr_ordem_compra_p bigint) FROM PUBLIC;

