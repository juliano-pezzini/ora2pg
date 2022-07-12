-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_parcialidade_item_solic ( nr_solic_compra_p bigint, nr_item_solic_compra_p bigint) RETURNS varchar AS $body$
DECLARE


qt_solic_compra_w	double precision;
qt_real_entrega_w double precision;
ds_retorno_w	varchar(1);


BEGIN


select	coalesce(sum(b.qt_material),0)
into STRICT	qt_solic_compra_w
from	solic_compra a,
	solic_compra_item b
where	a.nr_solic_compra = b.nr_solic_compra
and (coalesce(b.nr_seq_motivo_cancel::text, '') = '')
and	a.nr_solic_compra = nr_solic_compra_p
and	b.nr_item_solic_compra = nr_item_solic_compra_p;


select	coalesce(obter_qt_entregue_solic_nf(nr_solic_compra_p, nr_item_solic_compra_p),0)
into STRICT	qt_real_entrega_w
;

if (qt_real_entrega_w >= qt_solic_compra_w) then
	ds_retorno_w := 'T';
elsif (qt_real_entrega_w = 0) then
	ds_retorno_w := 'S';
elsif (qt_real_entrega_w < qt_solic_compra_w) then
	ds_retorno_w := 'P';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_parcialidade_item_solic ( nr_solic_compra_p bigint, nr_item_solic_compra_p bigint) FROM PUBLIC;
