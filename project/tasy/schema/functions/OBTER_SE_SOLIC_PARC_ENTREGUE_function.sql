-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_solic_parc_entregue (nr_solic_compra_p bigint) RETURNS varchar AS $body$
DECLARE

				
/*OS229595 - Nao leva em consideracao a data de baixa da solicitacao - baixa parcial */
				

ie_pendente_w 				varchar(1);
nr_item_solic_compra_w		solic_compra_item.nr_item_solic_compra%type;
qt_entrega_solicitada_w		solic_compra_item_entrega.qt_entrega_solicitada%type;
qt_real_entrega_w		    ordem_compra_item_entrega.qt_real_entrega%type;

C01 CURSOR FOR
	SELECT 	b.nr_item_solic_compra,
		coalesce(sum(c.qt_entrega_solicitada),0)
	from 	solic_compra a,
		solic_compra_item b,
		SOLIC_COMPRA_ITEM_ENTREGA c
	where 	a.nr_solic_compra = b.nr_solic_compra
	and	a.nr_solic_compra = c.nr_solic_compra
	and	b.nr_item_solic_compra = c.nr_item_solic_compra
	and	a.nr_solic_compra = nr_solic_compra_p
	and	exists (	SELECT 	1
				from 	ordem_compra_item d 
				where 	d.nr_solic_compra = b.nr_solic_compra 
				and 	d.nr_item_solic_compra = b.nr_item_solic_compra)
	group by b.nr_item_solic_compra;


BEGIN
ie_pendente_w := 'N';
open C01;
loop
fetch C01 into	
	nr_item_solic_compra_w,
	qt_entrega_solicitada_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select 	coalesce(sum(b.qt_real_entrega),0)
	into STRICT	qt_real_entrega_w
	from	ordem_compra_item_entrega b,
		ordem_compra_item a
	where	b.nr_ordem_compra = a.nr_ordem_compra
	and	b.nr_item_oci = a.nr_item_oci
	and	a.nr_solic_compra = nr_solic_compra_p
	and	a.nr_item_solic_compra = nr_item_solic_compra_w;
	
	if (qt_real_entrega_w < qt_entrega_solicitada_w) then
		ie_pendente_w := 'S';
	end if;	
	end;
end loop;
close C01;

return	ie_pendente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_solic_parc_entregue (nr_solic_compra_p bigint) FROM PUBLIC;
