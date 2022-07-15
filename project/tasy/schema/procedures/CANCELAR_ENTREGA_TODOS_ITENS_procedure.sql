-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_entrega_todos_itens ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, ie_nova_solic_p text, ie_nova_cotacao_p text, ie_mantem_forn_cot_p text, nm_usuario_p text, ds_observacao_p text, nr_seq_motivo_cancel_p bigint, ie_cancela_ordem_p text, ie_cancela_processo_p text, cd_material_p integer, ie_cancela_item_solic_p text, nr_cot_compra_p INOUT text, nr_solic_compra_p INOUT text) AS $body$
DECLARE


		
--ORDEM_COMPRA_ITEM		
nr_seq_entrega_w	ordem_compra_item_entrega.nr_sequencia%type;

--COT_COMPRA
nr_cot_compra_w		cot_compra.nr_cot_compra%type;

--SOLIC_COMPRA
nr_solic_compra_w	solic_compra.nr_solic_compra%type;

--Variaveis de controle
qt_entrega_w		bigint;
ie_cancela_ordem_w	varchar(1) := 'N';
ie_cancela_item_solic_w	varchar(1) := 'N';
i			integer := 0;
				
c01 CURSOR FOR
	SELECT	b.nr_sequencia
	from	ordem_compra_item_entrega b,
		ordem_compra_item a
	where	a.nr_ordem_compra = nr_ordem_compra_p
	and	a.nr_ordem_compra = b.nr_ordem_compra
	and	a.nr_item_oci = b.nr_item_oci
	and	a.nr_item_oci = nr_item_oci_p
	and	coalesce(b.dt_cancelamento::text, '') = '';


BEGIN

select	count(*)
into STRICT	qt_entrega_w
from	ordem_compra_item_entrega b,
	ordem_compra_item a
where	a.nr_ordem_compra = nr_ordem_compra_p
and	a.nr_ordem_compra = b.nr_ordem_compra
and	a.nr_item_oci = b.nr_item_oci
and	coalesce(b.dt_cancelamento::text, '') = '';

open c01;
loop
fetch c01 into	
	nr_seq_entrega_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	i := i + 1;
	if (i = qt_entrega_w) then
		ie_cancela_ordem_w := ie_cancela_ordem_p;
		ie_cancela_item_solic_w := ie_cancela_item_solic_p;
	end if;
	
	SELECT * FROM cancelar_entrega_item(	nr_ordem_compra_p, nr_item_oci_p, nr_seq_entrega_w, ie_nova_solic_p, ie_nova_cotacao_p, ie_mantem_forn_cot_p, nm_usuario_p, ds_observacao_p, nr_seq_motivo_cancel_p, ie_cancela_ordem_w, ie_cancela_processo_p, cd_material_p, ie_cancela_item_solic_w, nr_cot_compra_w, nr_solic_compra_w) INTO STRICT nr_cot_compra_w, nr_solic_compra_w;
				
	if (position(nr_cot_compra_w in (coalesce(nr_cot_compra_p, '0'))::numeric ) = 0) then
		if (coalesce(nr_cot_compra_p::text, '') = '') then
			nr_cot_compra_p := substr(nr_cot_compra_p || nr_cot_compra_w,1,4000);
		else
			nr_cot_compra_p := substr(',' || nr_cot_compra_p || nr_cot_compra_w || ',',1,4000);
		end if;
	end if;
	
	if (position(nr_solic_compra_w in nr_solic_compra_p) = 0) then
		if (coalesce(nr_solic_compra_p::text, '') = '') then
			nr_solic_compra_p := substr(nr_solic_compra_p || nr_solic_compra_w,1,4000);
		else
			nr_solic_compra_p := substr(',' || nr_solic_compra_p || nr_solic_compra_w,1,4000);
		end if;
	end if;
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_entrega_todos_itens ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, ie_nova_solic_p text, ie_nova_cotacao_p text, ie_mantem_forn_cot_p text, nm_usuario_p text, ds_observacao_p text, nr_seq_motivo_cancel_p bigint, ie_cancela_ordem_p text, ie_cancela_processo_p text, cd_material_p integer, ie_cancela_item_solic_p text, nr_cot_compra_p INOUT text, nr_solic_compra_p INOUT text) FROM PUBLIC;

