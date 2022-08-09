-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (vl_medicamento double precision);


CREATE OR REPLACE PROCEDURE obter_brasindice_valor_conta ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_material_p bigint, dt_vigencia_p timestamp, tx_brasindice_pmc_p bigint, tx_brasindice_pfb_p bigint, tx_pfb_pos_p bigint, tx_pfb_neg_p bigint, tx_pmc_neg_p bigint, tx_pmc_pos_p bigint, cd_laboratorio_p text, cd_apresentacao_p text, cd_medicamento_p text, vl_medicamento_p INOUT bigint, dt_ult_vigencia_p INOUT timestamp, cd_tiss_p INOUT text) AS $body$
DECLARE

type vetor is table of campos index by integer;

cd_laboratorio_w		varchar(6);
cd_medicamento_w		varchar(6);
cd_apresentacao_w	varchar(6);
vl_medicamento_w		double precision	:= 0;
ie_tipo_preco_w		varchar(3);
tx_preco_fabrica_w		CONVENIO_BRASINDICE.TX_PRECO_FABRICA%type := 1;--number(15,4)	:= 1;
qt_conversao_w		double precision	:= 1;
dt_ult_vigencia_w		timestamp		:= clock_timestamp();
dt_vigencia_bras_w		timestamp		:= clock_timestamp();
ie_relacionado_bras_w	varchar(1)	:= 'S';
tx_brasindice_pmc_w	CONVENIO_BRASINDICE.TX_BRASINDICE_PMC%type:= 1;--number(15,4)	:= 1;
tx_pmc_neg_w		CONVENIO_BRASINDICE.TX_PMC_NEG%type;--number(15,4);
tx_pmc_pos_w		CONVENIO_BRASINDICE.TX_PMC_POS%type;--number(15,4);
ie_brasindice_w		varchar(1)	:= 'N';
ie_preco_port_w		varchar(1)	:= '';
pr_ipi_w			real;
ie_exige_lib_w		varchar(01);
ie_pis_cofins_w		varchar(1);

tx_pfb_neg_w		CONVENIO_BRASINDICE.TX_PFB_NEG%type;--number(15,4);
tx_pfb_pos_w		CONVENIO_BRASINDICE.TX_PFB_POS%type;--number(15,4);
ie_dividir_indice_pmc_w	varchar(1);
ie_dividir_indice_pfb_w	varchar(1);
cd_grupo_material_w	 smallint;
ie_tipo_convenio_w		smallint;
ie_valor_brasindice_w	varchar(1);
i			bigint := 1;
qt_reg_w			bigint := 0;
vl_bras_w		double precision := 0;
ie_preco_medio_bras_w	varchar(1) := 'N';
vetor_valor_w		vetor;

ie_tipo_preco_regra_w	varchar(3);
cd_subgrupo_material_w	smallint;
cd_classe_material_w	integer;
ie_tipo_material_w	varchar(3);

ie_div_indice_pmc_conv_w	varchar(1);
ie_div_indice_pfb_conv_w	varchar(1);
ie_div_indice_pmc_regra_w	varchar(1);
ie_div_indice_pfb_regra_w	varchar(1);
vl_minimo_brasind_w			CONVENIO_BRASINDICE.VL_MINIMO%type;--number(15,2);
vl_maximo_brasind_w			CONVENIO_BRASINDICE.VL_MAXIMO%type;--number(15,2);
c01 CURSOR FOR
	SELECT	cd_laboratorio,
		cd_medicamento,
		cd_apresentacao,
		qt_conversao
	from	material_brasindice
	where	cd_material = cd_material_p
	and	coalesce(ie_situacao, 'A') = 'A'
	and	coalesce(dt_vigencia,dt_vigencia_bras_w) <= dt_vigencia_bras_w
	and	coalesce(cd_convenio,cd_convenio_p) = cd_convenio_p
	and	coalesce(ie_tipo_convenio,ie_tipo_convenio_w) = ie_tipo_convenio_w
	and	coalesce(cd_medicamento, coalesce(cd_medicamento_p, '0')) = coalesce(cd_medicamento_p, '0')
	and	coalesce(cd_laboratorio, coalesce(cd_laboratorio_p, '0')) = coalesce(cd_laboratorio_p, '0')
	and	coalesce(cd_apresentacao, coalesce(cd_apresentacao_p, '0')) = coalesce(cd_apresentacao_p, '0')
	and	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p,0))	= coalesce(cd_estabelecimento_p,0)
	order by coalesce(dt_vigencia,clock_timestamp() - interval '10000 days'),
		coalesce(cd_convenio,0),
		coalesce(ie_tipo_convenio,0);

c02 CURSOR FOR
	SELECT  'S',
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
	and	cd_estabelecimento	= cd_estabelecimento_p
	and	coalesce(ie_situacao,'A')	= 'A'
	order by coalesce(cd_categoria,'0'),
		coalesce(nr_seq_estrutura,0),
		coalesce(cd_grupo_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_classe_material,0),
		coalesce(ie_tipo_material,'0');


c03 CURSOR FOR
	SELECT	cd_laboratorio,
		cd_medicamento,
		cd_apresentacao,
		qt_conversao
	from	material_brasindice
	where	cd_material = cd_material_p
	and	coalesce(ie_situacao, 'A')	= 'A'
	and	coalesce(dt_vigencia,dt_vigencia_bras_w) <= dt_vigencia_bras_w
	and	coalesce(cd_convenio,cd_convenio_p) = cd_convenio_p
	and	coalesce(ie_tipo_convenio,ie_tipo_convenio_w) = ie_tipo_convenio_w
	and	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)
	and	coalesce(cd_medicamento, coalesce(cd_medicamento_p, '0')) = coalesce(cd_medicamento_p, '0')
	and	coalesce(cd_laboratorio, coalesce(cd_laboratorio_p, '0')) = coalesce(cd_laboratorio_p, '0')
	and	coalesce(cd_apresentacao, coalesce(cd_apresentacao_p, '0')) = coalesce(cd_apresentacao_p, '0')
	order by coalesce(dt_vigencia,clock_timestamp() - interval '10000 days'),
		coalesce(cd_convenio,0),
		coalesce(ie_tipo_convenio,0),
		coalesce(obter_valor_medic_brasindice(	cd_estabelecimento_p,
							cd_medicamento,
							cd_apresentacao,
							cd_laboratorio,
							qt_conversao,
							dt_vigencia_bras_w,
							tx_brasindice_pfb_p,
							tx_brasindice_pmc_p,
							tx_pmc_neg_p,
							tx_pmc_pos_p,
							tx_pfb_pos_p,
							tx_pfb_neg_p,
							cd_convenio_p,
							cd_categoria_p,
							cd_material_p,
							null,
							ie_tipo_preco_regra_w),0);

c04 CURSOR FOR
		SELECT	coalesce(obter_valor_medic_brasindice(	cd_estabelecimento_p,
							cd_medicamento,
							cd_apresentacao,
							cd_laboratorio,
							qt_conversao,
							dt_vigencia_bras_w,
							tx_brasindice_pfb_p,
							tx_brasindice_pmc_p,
							tx_pmc_neg_p,
							tx_pmc_pos_p,
							tx_pfb_pos_p,
							tx_pfb_neg_p,
							cd_convenio_p,
							cd_categoria_p,
							cd_material_p,
							null,
							ie_tipo_preco_regra_w),0)
		from	material_brasindice
		where	cd_material						= cd_material_p
		and	coalesce(ie_situacao, 'A')					= 'A'
		and	coalesce(dt_vigencia,dt_vigencia_bras_w)			<= dt_vigencia_bras_w
		and	coalesce(cd_convenio,cd_convenio_p)				= cd_convenio_p
		and	coalesce(ie_tipo_convenio,ie_tipo_convenio_w)		= ie_tipo_convenio_w
		and	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p,0))	= coalesce(cd_estabelecimento_p,0)
		order by coalesce(obter_valor_medic_brasindice(	cd_estabelecimento_p,
							cd_medicamento,
							cd_apresentacao,
							cd_laboratorio,
							qt_conversao,
							dt_vigencia_bras_w,
							tx_brasindice_pfb_p,
							tx_brasindice_pmc_p,
							tx_pmc_neg_p,
							tx_pmc_pos_p,
							tx_pfb_pos_p,
							tx_pfb_neg_p,
							cd_convenio_p,
							cd_categoria_p,
							cd_material_p,
							null,
							ie_tipo_preco_regra_w),0) asc;

C05 CURSOR FOR
	SELECT	coalesce(max(ie_dividir_indice_pmc),'N')
	from 	convenio_brasindice
	where	cd_convenio = cd_convenio_p
	and	((coalesce(cd_categoria::text, '') = '') or (cd_categoria = cd_categoria_p))
	and 	((coalesce(cd_grupo_material::text, '') = '') or (cd_grupo_material = cd_grupo_material_w))
	and 	((coalesce(cd_subgrupo_material::text, '') = '') or (cd_subgrupo_material = cd_subgrupo_material_w))
	and 	((coalesce(cd_classe_material::text, '') = '') or (cd_classe_material = cd_classe_material_w))
	and	((coalesce(nr_seq_estrutura::text, '') = '') or (consistir_se_mat_estrutura(nr_seq_estrutura,cd_material_p) = 'S'))
	and 	((coalesce(ie_tipo_material::text, '') = '') or (ie_tipo_material = ie_tipo_material_w))
	and	cd_estabelecimento	= cd_estabelecimento_p
	and	coalesce(ie_situacao,'A')	= 'A'
	order by coalesce(cd_categoria,'0'),
		coalesce(nr_seq_estrutura,0),
		coalesce(cd_grupo_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_classe_material,0),
		coalesce(ie_tipo_material,'0');

C06 CURSOR FOR
	SELECT	coalesce(max(ie_dividir_indice_pfb),'N')
	from 	convenio_brasindice
	where	cd_convenio = cd_convenio_p
	and	((coalesce(cd_categoria::text, '') = '') or (cd_categoria = cd_categoria_p))
	and 	((coalesce(cd_grupo_material::text, '') = '') or (cd_grupo_material = cd_grupo_material_w))
	and 	((coalesce(cd_subgrupo_material::text, '') = '') or (cd_subgrupo_material = cd_subgrupo_material_w))
	and 	((coalesce(cd_classe_material::text, '') = '') or (cd_classe_material = cd_classe_material_w))
	and	((coalesce(nr_seq_estrutura::text, '') = '') or (consistir_se_mat_estrutura(nr_seq_estrutura,cd_material_p) = 'S'))
	and 	((coalesce(ie_tipo_material::text, '') = '') or (ie_tipo_material = ie_tipo_material_w))
	and	cd_estabelecimento	= cd_estabelecimento_p
	and	coalesce(ie_situacao,'A')	= 'A'
	order by coalesce(cd_categoria,'0'),
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

/* Obter regra do Brasíndice para cargas com dois tipos de preços (PFB e PMC)  */

select	substr(Obter_Regra_Brasindice_Preco(cd_convenio_p,
					cd_categoria_p,
					cd_grupo_material_w,
					cd_subgrupo_material_w,
					cd_classe_material_w,
					cd_material_p,
					dt_vigencia_p,
					cd_estabelecimento_p, null),1,3)
into STRICT	ie_tipo_preco_regra_w
;

tx_preco_fabrica_w	:= tx_brasindice_pfb_p;
tx_pfb_neg_w		:= coalesce(tx_pfb_neg_p, tx_brasindice_pfb_p);
tx_pfb_pos_w		:= coalesce(tx_pfb_pos_p, tx_brasindice_pfb_p);

tx_brasindice_pmc_w	:= tx_brasindice_pmc_p;
tx_pmc_neg_w		:= coalesce(tx_pmc_neg_p, tx_brasindice_pmc_p);
tx_pmc_pos_w		:= coalesce(tx_pmc_pos_p, tx_brasindice_pmc_p);

select	coalesce(max(ie_exige_lib_bras),'N'),
	coalesce(max(ie_dividir_indice_pmc),'N'),
	coalesce(max(ie_dividir_indice_pfb),'N'),
	coalesce(max(ie_valor_brasindice),'N')
into STRICT	ie_exige_lib_w,
	ie_dividir_indice_pmc_w,
	ie_dividir_indice_pfb_w,
	ie_valor_brasindice_w
from	parametro_faturamento
where	cd_estabelecimento	= cd_estabelecimento_p;

dt_vigencia_bras_w 	:= coalesce(dt_vigencia_p,clock_timestamp());
ie_tipo_convenio_w	:= coalesce(obter_tipo_convenio(cd_convenio_p),0);

if (ie_valor_brasindice_w	= 'N') then
	open c01;
	loop
	fetch c01 into
		cd_laboratorio_w,
		cd_medicamento_w,
		cd_apresentacao_w,
		qt_conversao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	end loop;
	close c01;
elsif (ie_valor_brasindice_w	= 'S') then
	open c03;
	loop
	fetch c03 into
		cd_laboratorio_w,
		cd_medicamento_w,
		cd_apresentacao_w,
		qt_conversao_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
	end loop;
	close c03;
end if;

select 	max(ie_preco_medio_bras)
into STRICT	ie_preco_medio_bras_w
from 	convenio_estabelecimento
where	cd_convenio = cd_convenio_p
and	cd_estabelecimento = cd_estabelecimento_p;

/* obter preço do medicamento */

if (ie_exige_lib_w	= 'S') then
	begin
	select coalesce(vl_preco_final, vl_preco_medicamento),
		ie_tipo_preco,
		dt_inicio_vigencia,
		coalesce(ie_preco_port,'T'),
		coalesce(pr_ipi,0),
		coalesce(ie_pis_cofins,'T')
	into STRICT	vl_medicamento_w,
		ie_tipo_preco_w,
		dt_ult_vigencia_w,
		ie_preco_port_w,
		pr_ipi_w,
		ie_pis_cofins_w
	from	brasindice_preco
	where	cd_laboratorio		= cd_laboratorio_w
	and	cd_medicamento		= cd_medicamento_w
	and	cd_apresentacao		= cd_apresentacao_w
	--and	ie_tipo_preco	      = nvl(ie_tipo_preco_regra_w,ie_tipo_preco)
	and	dt_inicio_vigencia	=
		(SELECT max(a.dt_inicio_vigencia)
		from	brasindice_preco a
		where	a.cd_laboratorio      = cd_laboratorio_w
		and	a.cd_medicamento      = cd_medicamento_w
		and	a.cd_apresentacao     = cd_apresentacao_w
		--and	a.ie_tipo_preco	      = nvl(ie_tipo_preco_regra_w,a.ie_tipo_preco)
		and	a.dt_inicio_vigencia <= dt_vigencia_bras_w
		and 	((ie_exige_lib_w	= 'N') or (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')));
	exception
		when others then
		begin
		select coalesce(vl_preco_final, vl_preco_medicamento),
			ie_tipo_preco,
			dt_inicio_vigencia,
			coalesce(ie_preco_port,'T'),
			coalesce(pr_ipi,0),
			coalesce(ie_pis_cofins,'T')
		into STRICT	vl_medicamento_w,
			ie_tipo_preco_w,
			dt_ult_vigencia_w,
			ie_preco_port_w,
			pr_ipi_w,
			ie_pis_cofins_w
		from	brasindice_preco
		where	cd_laboratorio		= cd_laboratorio_w
		and	cd_medicamento		= cd_medicamento_w
		and	cd_apresentacao		= cd_apresentacao_w
		and	ie_tipo_preco	      = coalesce(ie_tipo_preco_regra_w,ie_tipo_preco)
		and	dt_inicio_vigencia	=
			(SELECT max(a.dt_inicio_vigencia)
			from	brasindice_preco a
			where	a.cd_laboratorio      = cd_laboratorio_w
			and	a.cd_medicamento      = cd_medicamento_w
			and	a.cd_apresentacao     = cd_apresentacao_w
			and	a.ie_tipo_preco	      = coalesce(ie_tipo_preco_regra_w,a.ie_tipo_preco)
			and	a.dt_inicio_vigencia <= dt_vigencia_bras_w
			and 	((ie_exige_lib_w	= 'N') or (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')));
		exception
			when others then
				ie_tipo_preco_w	:= '';
		end;
	end;
else
	begin
	select coalesce(vl_preco_final, vl_preco_medicamento),
		ie_tipo_preco,
		dt_inicio_vigencia,
		coalesce(ie_preco_port,'T'),
		coalesce(pr_ipi,0),
		coalesce(ie_pis_cofins,'T')
	into STRICT	vl_medicamento_w,
		ie_tipo_preco_w,
		dt_ult_vigencia_w,
		ie_preco_port_w,
		pr_ipi_w,
		ie_pis_cofins_w
	from	brasindice_preco
	where	cd_laboratorio		= cd_laboratorio_w
	and	cd_medicamento		= cd_medicamento_w
	and	cd_apresentacao		= cd_apresentacao_w
	--and	ie_tipo_preco	      = nvl(ie_tipo_preco_regra_w,ie_tipo_preco)
	and	dt_inicio_vigencia	=
		(SELECT /*+ index (a braprec_i3) */			max(a.dt_inicio_vigencia)
		from	brasindice_preco a
		where	a.cd_laboratorio      = cd_laboratorio_w
		and	a.cd_medicamento      = cd_medicamento_w
		and	a.cd_apresentacao     = cd_apresentacao_w
		--and	a.ie_tipo_preco	      = nvl(ie_tipo_preco_regra_w,a.ie_tipo_preco)
		and	a.dt_inicio_vigencia <= dt_vigencia_bras_w
		and 	((ie_exige_lib_w	= 'N') or (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')));
	exception
		when others then
		begin
		select coalesce(vl_preco_final, vl_preco_medicamento),
			ie_tipo_preco,
			dt_inicio_vigencia,
			coalesce(ie_preco_port,'T'),
			coalesce(pr_ipi,0),
			coalesce(ie_pis_cofins,'T')
		into STRICT	vl_medicamento_w,
			ie_tipo_preco_w,
			dt_ult_vigencia_w,
			ie_preco_port_w,
			pr_ipi_w,
			ie_pis_cofins_w
		from	brasindice_preco
		where	cd_laboratorio		= cd_laboratorio_w
		and	cd_medicamento		= cd_medicamento_w
		and	cd_apresentacao		= cd_apresentacao_w
		and	ie_tipo_preco	      = coalesce(ie_tipo_preco_regra_w,ie_tipo_preco)
		and	dt_inicio_vigencia	=
			(SELECT /*+ index (a braprec_i3) */				max(a.dt_inicio_vigencia)
			from	brasindice_preco a
			where	a.cd_laboratorio      = cd_laboratorio_w
			and	a.cd_medicamento      = cd_medicamento_w
			and	a.cd_apresentacao     = cd_apresentacao_w
			and	a.ie_tipo_preco	      = coalesce(ie_tipo_preco_regra_w,a.ie_tipo_preco)
			and	a.dt_inicio_vigencia <= dt_vigencia_bras_w
			and 	((ie_exige_lib_w	= 'N') or (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')));
		exception
			when others then
			ie_tipo_preco_w	:= '';
		end;
	end;
end if;

if (ie_dividir_indice_pfb_w = 'N') then

	if (tx_preco_fabrica_w IS NOT NULL AND tx_preco_fabrica_w::text <> '') and (ie_tipo_preco_w = 'PFB') then
		if (ie_pis_cofins_w = 'S') then
			vl_medicamento_w	:= (vl_medicamento_w * tx_pfb_pos_w);
		elsif (ie_pis_cofins_w = 'N') then
			vl_medicamento_w	:= (vl_medicamento_w * tx_pfb_neg_w);
		else
			vl_medicamento_w	:= (vl_medicamento_w * tx_preco_fabrica_w);
		end if;
	end if;

elsif (ie_dividir_indice_pfb_w = 'S') then

	if (tx_preco_fabrica_w IS NOT NULL AND tx_preco_fabrica_w::text <> '') and (ie_tipo_preco_w = 'PFB') then
		if (ie_pis_cofins_w = 'S') then
			vl_medicamento_w	:= dividir(vl_medicamento_w , tx_pfb_pos_w);
		elsif (ie_pis_cofins_w = 'N') then
			vl_medicamento_w	:= dividir(vl_medicamento_w , tx_pfb_neg_w);
		else
			vl_medicamento_w	:= dividir(vl_medicamento_w , tx_preco_fabrica_w);
		end if;
	end if;

elsif (ie_dividir_indice_pfb_w = 'R') then

	select	coalesce(max(ie_dividir_indice_pfb),'N')
	into STRICT	ie_div_indice_pfb_conv_w
	from 	convenio_estabelecimento
	where	cd_convenio		= cd_convenio_p
	and	cd_estabelecimento	= cd_estabelecimento_p;

	if (ie_div_indice_pfb_conv_w = 'S') then

		if (tx_preco_fabrica_w IS NOT NULL AND tx_preco_fabrica_w::text <> '') and (ie_tipo_preco_w = 'PFB') then
			if (ie_pis_cofins_w = 'S') then
				vl_medicamento_w	:= dividir(vl_medicamento_w , tx_pfb_pos_w);
			elsif (ie_pis_cofins_w = 'N') then
				vl_medicamento_w	:= dividir(vl_medicamento_w , tx_pfb_neg_w);
			else
				vl_medicamento_w	:= dividir(vl_medicamento_w , tx_preco_fabrica_w);
			end if;
		end if;

	elsif (ie_div_indice_pfb_conv_w = 'N') then

		if (tx_preco_fabrica_w IS NOT NULL AND tx_preco_fabrica_w::text <> '') and (ie_tipo_preco_w = 'PFB') then
			if (ie_pis_cofins_w = 'S') then
				vl_medicamento_w	:= (vl_medicamento_w * tx_pfb_pos_w);
			elsif (ie_pis_cofins_w = 'N') then
				vl_medicamento_w	:= (vl_medicamento_w * tx_pfb_neg_w);
			else
				vl_medicamento_w	:= (vl_medicamento_w * tx_preco_fabrica_w);
			end if;
		end if;

	elsif (ie_div_indice_pfb_conv_w = 'R') then

		open C06;
		loop
		fetch C06 into
			ie_div_indice_pfb_regra_w;
		EXIT WHEN NOT FOUND; /* apply on C06 */
			begin
			ie_div_indice_pfb_regra_w	:= ie_div_indice_pfb_regra_w;
			end;
		end loop;
		close C06;

		if (ie_div_indice_pfb_regra_w = 'S') then

			if (tx_preco_fabrica_w IS NOT NULL AND tx_preco_fabrica_w::text <> '') and (ie_tipo_preco_w = 'PFB') then
				if (ie_pis_cofins_w = 'S') then
					vl_medicamento_w	:= dividir(vl_medicamento_w , tx_pfb_pos_w);
				elsif (ie_pis_cofins_w = 'N') then
					vl_medicamento_w	:= dividir(vl_medicamento_w , tx_pfb_neg_w);
				else
					vl_medicamento_w	:= dividir(vl_medicamento_w , tx_preco_fabrica_w);
				end if;
			end if;

		elsif (ie_div_indice_pfb_regra_w = 'N') then

			if (tx_preco_fabrica_w IS NOT NULL AND tx_preco_fabrica_w::text <> '') and (ie_tipo_preco_w = 'PFB') then
				if (ie_pis_cofins_w = 'S') then
					vl_medicamento_w	:= (vl_medicamento_w * tx_pfb_pos_w);
				elsif (ie_pis_cofins_w = 'N') then
					vl_medicamento_w	:= (vl_medicamento_w * tx_pfb_neg_w);
				else
					vl_medicamento_w	:= (vl_medicamento_w * tx_preco_fabrica_w);
				end if;
			end if;
		end if;

	end if;

end if;

/* conforme resolução cmed nº 2, de 10 de março de 2006

art. 4º o preço máximo ao consumidor - pmc será obtido por meio da divisão do preço
fabricante - pf pelos fatores constantes da tabela abaixo, observadas as cargas tributárias do
icms praticadas nos estados de destino e a incidência da contribuição para o pis/pasep e
cofins, conforme o disposto na lei nº 10.147, de 21 de dezembro de 2001.

 icms            lista positiva               lista negativa                     lista neutra
19%   	0,7234   		0,7523    		0,7071
18%               0,7234     		0,7519      		0,7073
17%   	0,7234   		0,7515    		0,7075
12%   	0,7234   		0,7499    		0,7084
0%   	0,7234   		0,7465     		0,7103  */
if (ie_dividir_indice_pmc_w = 'N') then

	if (tx_brasindice_pmc_w IS NOT NULL AND tx_brasindice_pmc_w::text <> '') and (ie_tipo_preco_w = 'PMC') then
		if (ie_pis_cofins_w = 'S') then
			vl_medicamento_w	:= (vl_medicamento_w * tx_pmc_pos_w);
		elsif (ie_pis_cofins_w = 'N') then
			vl_medicamento_w	:= (vl_medicamento_w * tx_pmc_neg_w);
		else
			vl_medicamento_w	:= (vl_medicamento_w * tx_brasindice_pmc_w);
		end if;
	end if;

elsif (ie_dividir_indice_pmc_w = 'S') then

	if (tx_brasindice_pmc_w IS NOT NULL AND tx_brasindice_pmc_w::text <> '') and (ie_tipo_preco_w = 'PMC') then
		if (ie_pis_cofins_w = 'S') then
			vl_medicamento_w	:= dividir(vl_medicamento_w , tx_pmc_pos_w);
		elsif (ie_pis_cofins_w = 'N') then
			vl_medicamento_w	:= dividir(vl_medicamento_w , tx_pmc_neg_w);
		else
			vl_medicamento_w	:= dividir(vl_medicamento_w , tx_brasindice_pmc_w);
		end if;
	end if;

elsif (ie_dividir_indice_pmc_w = 'R') then

	select	coalesce(max(ie_dividir_indice_pmc),'N')
	into STRICT	ie_div_indice_pmc_conv_w
	from 	convenio_estabelecimento
	where	cd_convenio		= cd_convenio_p
	and	cd_estabelecimento	= cd_estabelecimento_p;

	if (ie_div_indice_pmc_conv_w = 'S') then

		if (tx_brasindice_pmc_w IS NOT NULL AND tx_brasindice_pmc_w::text <> '') and (ie_tipo_preco_w = 'PMC') then
			if (ie_pis_cofins_w = 'S') then
				vl_medicamento_w	:= dividir(vl_medicamento_w , tx_pmc_pos_w);
			elsif (ie_pis_cofins_w = 'N') then
				vl_medicamento_w	:= dividir(vl_medicamento_w , tx_pmc_neg_w);
			else
				vl_medicamento_w	:= dividir(vl_medicamento_w , tx_brasindice_pmc_w);
			end if;
		end if;

	elsif (ie_div_indice_pmc_conv_w = 'N') then

		if (tx_brasindice_pmc_w IS NOT NULL AND tx_brasindice_pmc_w::text <> '') and (ie_tipo_preco_w = 'PMC') then
			if (ie_pis_cofins_w = 'S') then
				vl_medicamento_w	:= (vl_medicamento_w * tx_pmc_pos_w);
			elsif (ie_pis_cofins_w = 'N') then
				vl_medicamento_w	:= (vl_medicamento_w * tx_pmc_neg_w);
			else
				vl_medicamento_w	:= (vl_medicamento_w * tx_brasindice_pmc_w);
			end if;
		end if;

	elsif (ie_div_indice_pmc_conv_w = 'R') then

		open C05;
		loop
		fetch C05 into
			ie_div_indice_pmc_regra_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin
			ie_div_indice_pmc_regra_w	:= ie_div_indice_pmc_regra_w;
			end;
		end loop;
		close C05;

		if (ie_div_indice_pmc_regra_w = 'S') then

			if (tx_brasindice_pmc_w IS NOT NULL AND tx_brasindice_pmc_w::text <> '') and (ie_tipo_preco_w = 'PMC') then
				if (ie_pis_cofins_w = 'S') then
					vl_medicamento_w	:= dividir(vl_medicamento_w , tx_pmc_pos_w);
				elsif (ie_pis_cofins_w = 'N') then
					vl_medicamento_w	:= dividir(vl_medicamento_w , tx_pmc_neg_w);
				else
					vl_medicamento_w	:= dividir(vl_medicamento_w , tx_brasindice_pmc_w);
				end if;
			end if;

		elsif (ie_div_indice_pmc_regra_w = 'N') then

			if (tx_brasindice_pmc_w IS NOT NULL AND tx_brasindice_pmc_w::text <> '') and (ie_tipo_preco_w = 'PMC') then
				if (ie_pis_cofins_w = 'S') then
					vl_medicamento_w	:= (vl_medicamento_w * tx_pmc_pos_w);
				elsif (ie_pis_cofins_w = 'N') then
					vl_medicamento_w	:= (vl_medicamento_w * tx_pmc_neg_w);
				else
					vl_medicamento_w	:= (vl_medicamento_w * tx_brasindice_pmc_w);
				end if;
			end if;
		end if;
	end if;

end if;

/*      converte o preco para consumo material */

if (qt_conversao_w = 0) then
	qt_conversao_w := 1;
end if;

if (vl_medicamento_w > 0) then
	vl_medicamento_w := vl_medicamento_w + (vl_medicamento_w * pr_ipi_w / 100);
	vl_medicamento_w := (vl_medicamento_w / qt_conversao_w);
end if;

if (ie_relacionado_bras_w = 'N') then
	vl_medicamento_w := 0;
end if;

ie_brasindice_w		:= 'N';

/* Passei para o início da function - Heckmann 19/05/2010 - OS 214864
select 	max(cd_grupo_material)
into	cd_grupo_material_w
from 	estrutura_material_v
where 	cd_material = cd_material_p;
*/
if (cd_categoria_p IS NOT NULL AND cd_categoria_p::text <> '') and (coalesce(cd_categoria_p,'0') <> '0') then
	begin

	open c02;
	loop
	fetch c02 into
		ie_brasindice_w,
		vl_minimo_brasind_w,
		vl_maximo_brasind_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		ie_brasindice_w:= ie_brasindice_w;
		vl_minimo_brasind_w := vl_minimo_brasind_w;
		vl_maximo_brasind_w := vl_maximo_brasind_w;
		end;
	end loop;
	close c02;

	end;
end if;

if (ie_preco_medio_bras_w = 'S') then
	open c04;
	loop
	fetch c04 into
		vl_bras_w;
	EXIT WHEN NOT FOUND; /* apply on c04 */
		begin
		vetor_valor_w[i].vl_medicamento := vl_bras_w;
		i := i + 1;
		end;
	end loop;
	close c04;

	select	round(dividir(i,2))
	into STRICT	qt_reg_w
	;

	if (i >= 3) then
		vl_medicamento_w := vetor_valor_w[qt_reg_w].vl_medicamento;
	end if;
end if;

if (ie_brasindice_w = 'N') then
	begin
	vl_medicamento_w	:= 0;
	dt_ult_vigencia_w	:= clock_timestamp();
	end;
end if;

if ((coalesce(vl_minimo_brasind_w, 0) > 0) or (coalesce(vl_maximo_brasind_w, 0) > 0)) then
	if ((vl_medicamento_w < coalesce(vl_minimo_brasind_w, vl_medicamento_w)) or (vl_medicamento_w > coalesce(vl_maximo_brasind_w, vl_medicamento_w))) then
		vl_medicamento_w := 0;
		dt_ult_vigencia_w	:= clock_timestamp();
	end if;
end if;

vl_medicamento_p	:= vl_medicamento_w;
dt_ult_vigencia_p	:= dt_ult_vigencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_brasindice_valor_conta ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_material_p bigint, dt_vigencia_p timestamp, tx_brasindice_pmc_p bigint, tx_brasindice_pfb_p bigint, tx_pfb_pos_p bigint, tx_pfb_neg_p bigint, tx_pmc_neg_p bigint, tx_pmc_pos_p bigint, cd_laboratorio_p text, cd_apresentacao_p text, cd_medicamento_p text, vl_medicamento_p INOUT bigint, dt_ult_vigencia_p INOUT timestamp, cd_tiss_p INOUT text) FROM PUBLIC;
