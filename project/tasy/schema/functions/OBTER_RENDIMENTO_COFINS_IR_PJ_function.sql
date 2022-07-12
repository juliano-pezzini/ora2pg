-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_rendimento_cofins_ir_pj (nr_titulo_p text, ie_tipo_p text, ie_imposto_p text) RETURNS bigint AS $body$
DECLARE

 
vl_rendimento_w	double precision;			
nr_registros_w	bigint;
nr_seq_nota_fiscal_w	bigint;


BEGIN 
 
select 	count(*) 
into STRICT	nr_registros_w 
from	titulo_pagar_imposto 
where	nr_titulo = nr_titulo_p;
 
select 	coalesce(nr_seq_nota_fiscal,0) 
into STRICT	nr_seq_nota_fiscal_w 
from 	titulo_pagar 
where	nr_titulo = nr_titulo_p;
 
if (ie_tipo_p = 'RET') then 
	if (nr_registros_w > 0) then 
		select	sum(CASE WHEN coalesce(vl_base_calculo::text, '') = '' THEN (obter_dados_tit_pagar(nr_titulo,'VN'))::numeric   ELSE vl_base_calculo END ) vl_rendimento 
		into STRICT	vl_rendimento_w 
		from (SELECT sum(coalesce(f.vl_total_item_nf,p.vl_titulo)) vl_base_calculo, 
				p.nr_titulo 
			FROM titulo_pagar p
LEFT OUTER JOIN nota_fiscal n ON (p.nr_Seq_nota_fiscal = n.nr_sequencia)
LEFT OUTER JOIN nota_fiscal_item f ON (n.nr_sequencia = f.nr_sequencia)
WHERE p.nr_titulo = nr_titulo_p group by p.nr_titulo) alias8 LIMIT 1;
	else 
		select 	count(*) 
		into STRICT	nr_registros_w 
		from	titulo_pagar 
		where	nr_seq_nota_fiscal = nr_seq_nota_fiscal_w;
		 
		if (nr_registros_w <= 1) then 
			select	sum((obter_dados_tit_pagar(p.nr_titulo,'VN'))::numeric ) vl_rendimento 
			into STRICT	vl_rendimento_w 
			from	titulo_pagar p 
			where	p.nr_titulo = nr_titulo_p  LIMIT 1;
		else 
			select 	count(*) 
			into STRICT	nr_registros_w 
			from	titulo_pagar p, 
				titulo_pagar_imposto i 
			where	p.nr_titulo = i.nr_titulo 
			and	p.nr_seq_nota_fiscal = nr_seq_nota_fiscal_w;
			 
			if (nr_registros_w > 0) then 
				vl_rendimento_w := 0;
			else 
				select	sum((obter_dados_tit_pagar(p.nr_titulo,'VN'))::numeric ) vl_rendimento 
				into STRICT	vl_rendimento_w 
				from	titulo_pagar p 
				where	p.nr_titulo = nr_titulo_p  LIMIT 1;
			end if;
				 
		end if;
			 
	end if;
else 
	select	sum(CASE WHEN t.ie_tipo_tributo=upper(ie_imposto_p) THEN coalesce(i.vl_imposto,0)  ELSE 0 END ) vl_imposto 
	into STRICT	vl_rendimento_w 
	from	titulo_pagar p, 
		titulo_pagar_imposto i, 
		tributo t 
	where	p.nr_titulo = i.nr_titulo 
	and	i.cd_tributo = t.cd_tributo 
	and	p.nr_titulo = nr_titulo_p;
end if;
	 
 
return	vl_rendimento_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_rendimento_cofins_ir_pj (nr_titulo_p text, ie_tipo_p text, ie_imposto_p text) FROM PUBLIC;

