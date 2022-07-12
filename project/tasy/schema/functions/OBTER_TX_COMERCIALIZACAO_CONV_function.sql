-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tx_comercializacao_conv ( cd_convenio_p bigint, cd_estabelecimento_p bigint, dt_referencia_p timestamp, cd_material_p bigint, cd_categoria_p text default null, cd_plano_p text default null, vl_referencia_p bigint default null) RETURNS bigint AS $body$
DECLARE


tx_acrescimo_w		double precision;
cd_grupo_material_w	bigint;
cd_subgrupo_material_w	bigint;
cd_classe_material_w	bigint;
nr_seq_familia_w	bigint;

c01 CURSOR FOR
SELECT	tx_acrescimo
from	regra_acrescimo_mat_esp
where	cd_convenio				= cd_convenio_p
and	cd_estabelecimento				= cd_estabelecimento_p
and	coalesce(cd_categoria, coalesce(cd_categoria_p, 'X'))	= coalesce(cd_categoria_p, 'X')
and	coalesce(vl_referencia_p,0) between coalesce(vl_minimo,0) and coalesce(vl_maximo,9999999999)
and	coalesce(cd_grupo_material,coalesce(cd_grupo_material_w,0))	= coalesce(cd_grupo_material_w,0)
and	coalesce(cd_subgrupo_material,coalesce(cd_subgrupo_material_w,0))	= coalesce(cd_subgrupo_material_w,0)
and	coalesce(cd_classe_material,coalesce(cd_classe_material_w,0))	= coalesce(cd_classe_material_w,0)
and	coalesce(cd_material,coalesce(cd_material_p,0))			= coalesce(cd_material_p,0)
and	dt_referencia_p between trunc(dt_inicio_vigencia,'dd') and
	 fim_dia(coalesce(dt_fim_vigencia,to_date('01/01/2099','dd/mm/yyyy')))
and	coalesce(nr_seq_familia,coalesce(nr_seq_familia_w,0))		= coalesce(nr_seq_familia_w,0)
and	((coalesce(nr_seq_mat_estrut::text, '') = '')	or (consistir_se_mat_estrutura(nr_seq_mat_estrut,cd_material_p)	= 'S'))
and (coalesce(cd_plano_convenio,coalesce(cd_plano_p,'0'))		= coalesce(cd_plano_p,'0'))
order by
	coalesce(cd_material,0),
	coalesce(nr_seq_familia,0),
	coalesce(cd_grupo_material,0),
	coalesce(cd_subgrupo_material,0),
	coalesce(cd_classe_material,0),
	coalesce(cd_categoria,'X'),
	coalesce(cd_plano_convenio,'0'),
	coalesce(nr_seq_mat_estrut,0);


BEGIN

select	max(cd_grupo_material),
	max(cd_subgrupo_material),
	max(cd_classe_material),
	max(nr_seq_familia)
into STRICT	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w,
	nr_seq_familia_w
from 	estrutura_material_v
where	cd_material	= cd_material_p;

open c01;
loop
fetch c01 into
	tx_acrescimo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	tx_acrescimo_w	:= tx_acrescimo_w;
end loop;
close c01;

return	tx_acrescimo_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tx_comercializacao_conv ( cd_convenio_p bigint, cd_estabelecimento_p bigint, dt_referencia_p timestamp, cd_material_p bigint, cd_categoria_p text default null, cd_plano_p text default null, vl_referencia_p bigint default null) FROM PUBLIC;
