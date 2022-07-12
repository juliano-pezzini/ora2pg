-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_pend_oc_direta ( cd_conta_contabil_p text, cd_estabelecimento_p bigint, nr_seq_tipo_compra_p bigint, nr_seq_mod_compra_p bigint) RETURNS bigint AS $body$
DECLARE

 
vl_unitario_material_w		double precision;
vl_acumulado_w			double precision := 0;
vl_total_w			double precision := 0;
qt_prevista_entrega_w		double precision;
nr_ordem_compra_w		bigint;
nr_item_oci_w			integer;
			
c01 CURSOR FOR 
SELECT	distinct 
	a.nr_ordem_compra, 
	b.nr_item_oci 
from	ordem_compra a, 
	ordem_compra_item b 
where	a.nr_ordem_compra = b.nr_ordem_compra 
and	a.cd_estabelecimento = cd_estabelecimento_p 
and	trunc(a.dt_ordem_compra,'yyyy') = trunc(clock_timestamp(),'yyyy') 
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
and	coalesce(a.dt_aprovacao::text, '') = '' 
and	coalesce(a.nr_seq_motivo_cancel::text, '') = '' 
and	coalesce(a.nr_seq_licitacao::text, '') = '' 
and	coalesce(b.dt_reprovacao::text, '') = '' 
and	coalesce(b.dt_aprovacao::text, '') = '' 
and	((coalesce(cd_conta_contabil_p::text, '') = '') or (b.cd_conta_contabil		= cd_conta_contabil_p)) 
and	((coalesce(nr_seq_tipo_compra_p::text, '') = '') or (a.nr_seq_tipo_compra		= nr_seq_tipo_compra_p)) 
and	((coalesce(nr_seq_mod_compra_p::text, '') = '') or (a.nr_seq_mod_compra		= nr_seq_mod_compra_p));
		

BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_ordem_compra_w, 
	nr_item_oci_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	select	coalesce(vl_unitario_material,0) 
	into STRICT	vl_unitario_material_w 
	from	ordem_compra_item 
	where	nr_ordem_compra = nr_ordem_compra_w 
	and	nr_item_oci = nr_item_oci_w;
	 
	select	coalesce(sum(qt_prevista_entrega),0) 
	into STRICT	qt_prevista_entrega_w 
	from	ordem_compra_item_entrega 
	where	nr_ordem_compra = nr_ordem_compra_w 
	and	nr_item_oci = nr_item_oci_w 
	and	coalesce(dt_cancelamento::text, '') = '';
	 
	vl_total_w	:= (vl_unitario_material_w * qt_prevista_entrega_w);
	vl_acumulado_w	:= (vl_acumulado_w + vl_total_w);
	 
	end;
end loop;
close C01;
 
return	vl_acumulado_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_pend_oc_direta ( cd_conta_contabil_p text, cd_estabelecimento_p bigint, nr_seq_tipo_compra_p bigint, nr_seq_mod_compra_p bigint) FROM PUBLIC;
