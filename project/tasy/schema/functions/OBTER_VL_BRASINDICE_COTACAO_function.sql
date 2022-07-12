-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vl_brasindice_cotacao ( cd_estabelecimento_p bigint, cd_material_p bigint, dt_vigencia_p timestamp, cd_unidade_medida_param_p text, ie_tipo_preco_p text, ie_opcao_preco_p text) RETURNS bigint AS $body$
DECLARE



vl_brasindice_w			brasindice_preco.vl_preco_medicamento%type	:= 0;
vl_bras_convertido_w		brasindice_preco.vl_preco_medicamento%type	:= 0;
vl_retorno_w			brasindice_preco.vl_preco_medicamento%type	:= 0;
qt_existe_w			bigint;

/*
ie_opcao_preco_p
B - Valor do brasindice
C - Valor convertido do brasindice
M - Maior valor brasindice
*/
c01 CURSOR FOR
SELECT	b.vl_preco_medicamento,
	coalesce(dividir(b.vl_preco_medicamento, coalesce(a.qt_conversao,1)),0)
from	material_brasindice a,
	brasindice_preco b
where	a.cd_material			= cd_material_p
and	a.cd_laboratorio		= b.cd_laboratorio
and	a.cd_medicamento		= b.cd_medicamento
and	a.cd_apresentacao		= b.cd_apresentacao
and	coalesce(a.ie_situacao, 'A')	= 'A'
and	coalesce(a.cd_estabelecimento, coalesce(cd_estabelecimento_p, 0))	= coalesce(cd_estabelecimento_p, 0)
and	b.ie_tipo_preco			= ie_tipo_preco_p
and	coalesce(b.dt_inicio_vigencia,dt_vigencia_p) <= dt_vigencia_p
order by b.dt_inicio_vigencia desc;


BEGIN


if (ie_opcao_preco_p in ('B','C')) then
	begin
	/* Adicionei este count pois em alguns clientes, se o material não existe na tabela
	a consulta demorava mais de 4 minutos */
	select	count(*)
	into STRICT	qt_existe_w
	from	material_brasindice a,
		brasindice_preco b
	where	a.cd_material		= cd_material_p
	and	a.cd_laboratorio		= b.cd_laboratorio
	and	a.cd_medicamento		= b.cd_medicamento
	and	a.cd_apresentacao		= b.cd_apresentacao
	and	coalesce(a.ie_situacao, 'A')	= 'A'
	and	coalesce(a.cd_estabelecimento, coalesce(cd_estabelecimento_p, 0))	= coalesce(cd_estabelecimento_p, 0)
	and	b.ie_tipo_preco			= ie_tipo_preco_p;

	if (qt_existe_w > 0) then
		begin

		open C01;
		loop
		fetch C01 into
			vl_brasindice_w,
			vl_bras_convertido_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			if (vl_brasindice_w > 0) then
				vl_brasindice_w 	:= vl_brasindice_w;
				vl_bras_convertido_w	:= vl_bras_convertido_w;
				exit;
			end if;

			end;
		end loop;
		close C01;

		end;
	end if;
	end;
end if;

if (ie_opcao_preco_p = 'B') then
	vl_retorno_w := vl_brasindice_w;
elsif (ie_opcao_preco_p = 'C') then
	vl_retorno_w := vl_bras_convertido_w;
elsif (ie_opcao_preco_p = 'M') then
	select	obter_maior_preco_brasindice(cd_estabelecimento_p, cd_material_p, dt_vigencia_p, cd_unidade_medida_param_p, ie_tipo_preco_p)
	into STRICT	vl_retorno_w
	;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vl_brasindice_cotacao ( cd_estabelecimento_p bigint, cd_material_p bigint, dt_vigencia_p timestamp, cd_unidade_medida_param_p text, ie_tipo_preco_p text, ie_opcao_preco_p text) FROM PUBLIC;
