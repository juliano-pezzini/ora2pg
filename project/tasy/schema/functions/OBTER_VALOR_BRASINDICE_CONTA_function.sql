-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_brasindice_conta ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_material_p bigint, dt_vigencia_p timestamp, cd_laboratorio_p text, cd_apresentacao_p text, cd_medicamento_p text) RETURNS bigint AS $body$
DECLARE


vl_brasindice_w		double precision := 0;
vl_retorno_w		double precision := 0;
tx_brasindice_pmc_w	CONVENIO_BRASINDICE.TX_BRASINDICE_PMC%type := 0;--number(15,4) := 0;
tx_brasindice_pfb_w	CONVENIO_BRASINDICE.TX_PRECO_FABRICA%type := 0;--number(15,4) := 0;
tx_pmc_neg_w		CONVENIO_BRASINDICE.TX_PMC_NEG%type := 0;--number(15,4) := 0;
tx_pmc_pos_w		CONVENIO_BRASINDICE.TX_PMC_POS%type := 0;--number(15,4) := 0;
dt_ult_vigencia_w		timestamp;
cd_tiss_w			varchar(40);

tx_pfb_neg_w		CONVENIO_BRASINDICE.TX_PFB_NEG%type;--number(15,4);
tx_pfb_pos_w		CONVENIO_BRASINDICE.TX_PFB_POS%type;--number(15,4);
cd_grupo_material_w	smallint;
cd_estabelecimento_w	smallint;
cd_classe_material_w	integer;
cd_subgrupo_material_w	smallint;
ie_tipo_material_w	varchar(3);
vl_minimo_brasind_w			CONVENIO_BRASINDICE.VL_MINIMO%type;--number(15,2);
vl_maximo_brasind_w			CONVENIO_BRASINDICE.VL_MAXIMO%type;--number(15,2);
c01 CURSOR FOR
	SELECT	coalesce(tx_brasindice_pmc,0),
		coalesce(tx_preco_fabrica,0),
		coalesce(tx_pmc_neg,0),
		coalesce(tx_pmc_pos,0),
		tx_pfb_neg,
		tx_pfb_pos,
		vl_minimo,
		vl_maximo
	from	convenio_brasindice
	where	cd_convenio = cd_convenio_p
	and	((coalesce(cd_categoria::text, '') = '') or (cd_categoria = cd_categoria_p))
	and 	((coalesce(cd_grupo_material::text, '') = '') or (cd_grupo_material = cd_grupo_material_w))
	and 	((coalesce(cd_subgrupo_material::text, '') = '') or (cd_subgrupo_material = cd_subgrupo_material_w))
	and 	((coalesce(cd_classe_material::text, '') = '') or (cd_classe_material = cd_classe_material_w))
	and	((coalesce(nr_seq_estrutura::text, '') = '') or (consistir_se_mat_estrutura(nr_seq_estrutura,cd_material_p) = 'S'))
	and 	((coalesce(ie_tipo_material::text, '') = '') or (ie_tipo_material = ie_tipo_material_w))
	and	cd_estabelecimento = cd_estabelecimento_w
	and	dt_inicio_vigencia = (	SELECT	max(dt_inicio_vigencia)
					from	convenio_brasindice
					where	cd_convenio = cd_convenio_p
					and	((coalesce(cd_categoria::text, '') = '') or (cd_categoria = cd_categoria_p))
					and 	((coalesce(cd_grupo_material::text, '') = '') or (cd_grupo_material = cd_grupo_material_w))
					and 	((coalesce(cd_subgrupo_material::text, '') = '') or (cd_subgrupo_material = cd_subgrupo_material_w))
					and 	((coalesce(cd_classe_material::text, '') = '') or (cd_classe_material = cd_classe_material_w))
					and	((coalesce(nr_seq_estrutura::text, '') = '') or (consistir_se_mat_estrutura(nr_seq_estrutura,cd_material_p) = 'S'))
					and 	((coalesce(ie_tipo_material::text, '') = '') or (ie_tipo_material = ie_tipo_material_w))
					and	dt_inicio_vigencia <= clock_timestamp())
	order by	coalesce(cd_categoria,'0'),
		coalesce(nr_seq_estrutura,0),
		coalesce(cd_grupo_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_classe_material,0),
		coalesce(ie_tipo_material,'0');


BEGIN

select 	max(cd_grupo_material),
	max(cd_subgrupo_material),
	max(cd_classe_material),
	max(ie_tipo_material)
into STRICT	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w,
	ie_tipo_material_w
from 	estrutura_material_v
where 	cd_material = cd_material_p;

select	coalesce(cd_estabelecimento_p, wheb_usuario_pck.get_cd_estabelecimento)
into STRICT	cd_estabelecimento_w
;

open c01;
loop
fetch c01 into
	tx_brasindice_pmc_w,
	tx_brasindice_pfb_w,
	tx_pmc_neg_w,
	tx_pmc_pos_w,
	tx_pfb_neg_w,
	tx_pfb_pos_w,
	vl_minimo_brasind_w,
	vl_maximo_brasind_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	tx_brasindice_pmc_w	:= 	tx_brasindice_pmc_w;
	tx_brasindice_pfb_w	:=	tx_brasindice_pfb_w;
	tx_pmc_neg_w		:=	tx_pmc_neg_w;
	tx_pmc_pos_w		:=	tx_pmc_pos_w;
	tx_pfb_neg_w		:=	tx_pfb_neg_w;
	tx_pfb_pos_w		:=	tx_pfb_pos_w;
	vl_minimo_brasind_w :=  vl_minimo_brasind_w;
	vl_maximo_brasind_w :=  vl_maximo_brasind_w;
	end;
end loop;
close c01;

cd_estabelecimento_w := 1;
SELECT * FROM obter_brasindice_valor_conta(
			cd_estabelecimento_w, cd_convenio_p, cd_categoria_p, cd_material_p, dt_vigencia_p, tx_brasindice_pmc_w, tx_brasindice_pfb_w, tx_pfb_pos_w, tx_pfb_neg_w, tx_pmc_neg_w, tx_pmc_pos_w, cd_laboratorio_p, cd_apresentacao_p, cd_medicamento_p, vl_brasindice_w, dt_ult_vigencia_w, cd_tiss_w) INTO STRICT vl_brasindice_w, dt_ult_vigencia_w, cd_tiss_w;

if ((coalesce(vl_minimo_brasind_w, 0) > 0) or (coalesce(vl_maximo_brasind_w, 0) > 0)) then
	if ((vl_brasindice_w < coalesce(vl_minimo_brasind_w, vl_brasindice_w)) or (vl_brasindice_w > coalesce(vl_maximo_brasind_w, vl_brasindice_w))) then
		vl_brasindice_w := 0;
	end if;
end if;

vl_retorno_w		:= vl_brasindice_w;

return vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_brasindice_conta ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_material_p bigint, dt_vigencia_p timestamp, cd_laboratorio_p text, cd_apresentacao_p text, cd_medicamento_p text) FROM PUBLIC;
