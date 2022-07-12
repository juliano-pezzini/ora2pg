-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_estoque_nuvem ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_local_estoque_p bigint, dt_mesano_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE

 
ie_cons_req_etapa_ressup_w		parametro_compras.ie_cons_req_etapa_ressup%type;
qt_itens_nuvem_w			item_requisicao_material.qt_material_requisitada%type := 0;
qt_estoque_w			saldo_estoque.qt_estoque%type := 0;
			

BEGIN 
 
 
select	coalesce(max(ie_cons_req_etapa_ressup),'N') 
into STRICT	ie_cons_req_etapa_ressup_w 
from	parametro_compras 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
if (coalesce(ie_cons_req_etapa_ressup_w,'N') = 'S') then 
	 
	select 	coalesce(sum(i.qt_material_atendida),0) 
	into STRICT	qt_itens_nuvem_w 
	from	requisicao_material b, 
		operacao_estoque o, 
		item_requisicao_material i 
	where	b.cd_operacao_estoque = o.cd_operacao_estoque 
	and	i.nr_requisicao = b.nr_requisicao 
	and	i.cd_material = cd_material_p 
	and	o.ie_tipo_requisicao = 21 
	and	coalesce(i.dt_recebimento::text, '') = '' 
	and	exists (SELECT 	1 
			from 	sup_motivo_baixa_req e 
			where	i.cd_motivo_baixa	= e.nr_sequencia 
			and	e.cd_motivo_baixa	in (1,4));
		 
end if;
 
select	obter_saldo_disp_estoque(cd_estabelecimento_p, cd_material_p, cd_local_estoque_p, dt_mesano_referencia_p) 
into STRICT	qt_estoque_w
;
 
qt_estoque_w := qt_estoque_w + qt_itens_nuvem_w;
 
 
return	qt_estoque_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_estoque_nuvem ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_local_estoque_p bigint, dt_mesano_referencia_p timestamp) FROM PUBLIC;
