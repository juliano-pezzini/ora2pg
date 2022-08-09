-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_tx_reducao_acresc_conv ( cd_convenio_p bigint, cd_estabelecimento_p bigint, dt_referencia_p timestamp, cd_material_p bigint, cd_categoria_p text default null, cd_plano_p text default null, vl_referencia_p bigint default null, pr_adicional_p INOUT bigint DEFAULT NULL, ie_reducao_acrescimo_p INOUT text DEFAULT NULL) AS $body$
DECLARE


tx_acrescimo_w		double precision;
cd_grupo_material_w	bigint;
cd_subgrupo_material_w	bigint;
cd_classe_material_w	bigint;
nr_seq_familia_w	bigint;
ie_reducao_acrescimo_w	varchar(1);

c01 CURSOR FOR
SELECT	tx_acrescimo,
	coalesce(ie_reducao_acrescimo,'A')
from	regra_acrescimo_mat_esp
where	cd_convenio				= cd_convenio_p
and	cd_estabelecimento				= cd_estabelecimento_p
and	coalesce(cd_categoria, coalesce(cd_categoria_p, 'X'))	= coalesce(cd_categoria_p, 'X')
and	coalesce(vl_referencia_p,0) between coalesce(vl_minimo,0) and coalesce(vl_maximo,9999999999)
and	coalesce(cd_grupo_material,coalesce(cd_grupo_material_w,0))	= coalesce(cd_grupo_material_w,0)
and	coalesce(cd_subgrupo_material,coalesce(cd_subgrupo_material_w,0))	= coalesce(cd_subgrupo_material_w,0)
and	coalesce(cd_classe_material,coalesce(cd_classe_material_w,0))	= coalesce(cd_classe_material_w,0)
and	coalesce(cd_material,coalesce(cd_material_p,0))			= coalesce(cd_material_p,0)
and	dt_referencia_p between ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_inicio_vigencia)  and 	
	 ESTABLISHMENT_TIMEZONE_UTILS.endOfDay(coalesce(dt_fim_vigencia,to_date('01/01/2099','dd/mm/yyyy')))
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
	tx_acrescimo_w,
	ie_reducao_acrescimo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	tx_acrescimo_w	:= tx_acrescimo_w;
	ie_reducao_acrescimo_w := ie_reducao_acrescimo_w;
end loop;
close c01;

pr_adicional_p 		:= tx_acrescimo_w;
ie_reducao_acrescimo_p	:= coalesce(ie_reducao_acrescimo_w,'A');

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_tx_reducao_acresc_conv ( cd_convenio_p bigint, cd_estabelecimento_p bigint, dt_referencia_p timestamp, cd_material_p bigint, cd_categoria_p text default null, cd_plano_p text default null, vl_referencia_p bigint default null, pr_adicional_p INOUT bigint DEFAULT NULL, ie_reducao_acrescimo_p INOUT text DEFAULT NULL) FROM PUBLIC;
