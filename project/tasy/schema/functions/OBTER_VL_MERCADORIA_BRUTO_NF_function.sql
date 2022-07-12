-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vl_mercadoria_bruto_nf ( nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


vl_mercadoria_bruto_w	double precision;


BEGIN

--select	nvl(sum(qt_item_nf* vl_unitario_item_nf),0)  alterado na OS 731184
select	coalesce(sum(vl_total_item_nf),0)
into STRICT	vl_mercadoria_bruto_w
from 	nota_fiscal_item a
where	a.nr_sequencia = nr_sequencia_p;

return vl_mercadoria_bruto_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vl_mercadoria_bruto_nf ( nr_sequencia_p bigint) FROM PUBLIC;
