-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_preco_venda ( cd_material_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


vl_resultado_w	double precision := 0;


BEGIN

select	obter_valor_brasindice(cd_material_p, ie_opcao_p)
into STRICT	vl_resultado_w
;

if (coalesce(vl_resultado_w::text, '') = '' or vl_resultado_w = 0) then
	begin
	select	max(coalesce(a.vl_preco_venda,0))
	into STRICT	vl_resultado_w
	from	preco_material a
	where	cd_material = cd_material_p
	and	a.dt_inicio_vigencia		=	(SELECT	max(x.dt_inicio_vigencia)
						from 	preco_material x
						where	x.cd_material	=	a.cd_material
						and	x.vl_preco_venda	> 0);
	end;
end if;

/*
if	(vl_resultado_w is null or vl_resultado_w = 0) then
	begin
	select	nvl(obter_preco_simpro(b.cd_simpro),0)
	into	vl_resultado_w
	from     	material a,
	         	simpro_cadastro c,
	         	material_simpro b
	where    	a.cd_material	= b.cd_material
	and	b.cd_simpro	= c.cd_simpro
	and      	a.cd_material	= cd_material_p;
	end;
end if;
*/
return	vl_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_preco_venda ( cd_material_p bigint, ie_opcao_p text) FROM PUBLIC;

