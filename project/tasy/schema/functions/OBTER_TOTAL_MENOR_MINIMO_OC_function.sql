-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_total_menor_minimo_oc (nr_ordem_p text, ie_consiste_vl_minimo_p text, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE

 
ie_tot_menor_minimo_w		varchar(01) := 'N';
qt_historico_w			smallint;
vl_minimo_nf_w			double precision;
vl_total_ordem_w		double precision;
ie_juros_negociado_oc_w		varchar(1);
pr_juros_negociado_w		double precision;
cd_estabelecimento_w		smallint;
			

BEGIN 
 
select	coalesce(sum(obter_valor_liquido_ordem(nr_ordem_compra)),0), 
	coalesce(max(pr_juros_negociado),0), 
	max(cd_estabelecimento) 
into STRICT	vl_total_ordem_w, 
	pr_juros_negociado_w, 
	cd_estabelecimento_w 
from	ordem_compra 
where	nr_ordem_compra = nr_ordem_p;
 
select	coalesce(ie_juros_negociado_oc,'N') 
into STRICT	ie_juros_negociado_oc_w 
from	parametro_compras 
where	cd_estabelecimento = cd_estabelecimento_w;
 
if (ie_juros_negociado_oc_w = 'S') and (pr_juros_negociado_w > 0) then 
	vl_total_ordem_w	:= 	vl_total_ordem_w + dividir((vl_total_ordem_w * pr_juros_negociado_w),100);
end if;	
 
select	count(*) 
into STRICT	qt_historico_w 
from 	ordem_compra_hist	 
where 	ds_titulo like '%' || WHEB_MENSAGEM_PCK.get_texto(305962) || '%' 
and	nr_ordem_compra = nr_ordem_p;
 
if (ie_consiste_vl_minimo_p = 'A') and (qt_historico_w = 0) then 
	begin 
	select	(substr(obter_dados_pf_pj_estab(cd_estabelecimento, null, cd_cgc_fornecedor, 'EVM'),1,20))::numeric  
	into STRICT	vl_minimo_nf_w 
	from	ordem_compra 
	where	nr_ordem_compra = nr_ordem_p;
 
	if (vl_total_ordem_w < vl_minimo_nf_w) then 
		ie_tot_menor_minimo_w := 'S';		
	end if;
	end;
end if;
 
return	ie_tot_menor_minimo_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_total_menor_minimo_oc (nr_ordem_p text, ie_consiste_vl_minimo_p text, nm_usuario_p text) FROM PUBLIC;

