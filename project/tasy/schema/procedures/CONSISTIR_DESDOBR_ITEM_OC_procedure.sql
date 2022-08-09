-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_desdobr_item_oc ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, qt_total_entrega_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE



qt_material_w				double precision;
qt_real_entrega_w				double precision;
ds_erro_w				varchar(255) := '';


BEGIN

select	coalesce(sum(qt_material),0)
into STRICT	qt_material_w
from	ordem_compra_item
where	nr_ordem_compra = nr_ordem_compra_p
and	nr_item_oci = nr_item_oci_p;

if (qt_material_w < qt_total_entrega_p) then
	ds_erro_w := substr(WHEB_MENSAGEM_PCK.get_texto(277385),1,255);
end if;

select	coalesce(sum(qt_real_entrega),0)
into STRICT	qt_real_entrega_w
from	ordem_compra_item_entrega
where	nr_ordem_compra = nr_ordem_compra_p
and	nr_item_oci = nr_item_oci_p;

if (qt_real_entrega_w > 0) then
	ds_erro_w := substr(WHEB_MENSAGEM_PCK.get_texto(277386),1,255);
end if;


ds_erro_p := ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_desdobr_item_oc ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, qt_total_entrega_p bigint, ds_erro_p INOUT text) FROM PUBLIC;
