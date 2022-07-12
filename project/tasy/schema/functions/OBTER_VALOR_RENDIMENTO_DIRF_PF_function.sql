-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_rendimento_dirf_pf (nr_titulo_p text, ie_soma_inss_p text default 'S', ie_primeiro_titulo_p text default 'S') RETURNS bigint AS $body$
DECLARE

			 
vl_rendimento_w	double precision;			
qt_registro_w	bigint;
vl_base_ir_w	double precision;
vl_base_inss_w	double precision;
vl_imposto_ir_w	double precision;
vl_imposto_inss_w	double precision;


BEGIN 
 
--verifica se existe impostos para o titulo 
select 	count(*) 
into STRICT	qt_registro_w 
from	titulo_pagar_imposto i, 
	tributo t 
where	i.cd_tributo = t.cd_tributo 
and	nr_titulo = nr_titulo_p 
and	t.ie_tipo_tributo in ('IR','INSS');
 
if qt_registro_w > 0 then 
	--verifica se existe IRRF e INSS 
	select sum(coalesce(i.vl_base_calculo,0)) vl_base_ir, 
		sum(coalesce(i.vl_imposto,0)) vl_imposto_ir 
	into STRICT	vl_base_ir_w, 
		vl_imposto_ir_w 
	from	titulo_pagar_imposto i, 
		tributo t 
	where	i.cd_tributo = t.cd_tributo 
	and	t.ie_tipo_tributo = 'IR' 
	and	nr_titulo = nr_titulo_p;
	 
	select 	sum(coalesce(vl_base_calculo,0)) vl_base_inss, 
		sum(coalesce(i.vl_imposto,0)) vl_imposto_inss 
	into STRICT	vl_base_inss_w, 
		vl_imposto_inss_w 
	from	titulo_pagar_imposto i, 
		tributo t 
	where	i.cd_tributo = t.cd_tributo 
	and	t.ie_tipo_tributo = 'INSS' 
	and	nr_titulo = nr_titulo_p;
	 
	if (vl_base_ir_w > 0) and (ie_primeiro_titulo_p = 'S') then 
		if (ie_soma_inss_p = 'S') then 
			vl_rendimento_w := coalesce(vl_base_ir_w,0) + coalesce(vl_imposto_inss_w,0);
		else 
			vl_rendimento_w := coalesce(vl_base_ir_w,0);
		end if;
	else 
		vl_rendimento_w := coalesce(vl_base_inss_w,0);
	end if;
	 
else 
	vl_rendimento_w := (obter_dados_tit_pagar(nr_titulo_p,'V'))::numeric;
end if;
 
 
 
return	vl_rendimento_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_rendimento_dirf_pf (nr_titulo_p text, ie_soma_inss_p text default 'S', ie_primeiro_titulo_p text default 'S') FROM PUBLIC;
