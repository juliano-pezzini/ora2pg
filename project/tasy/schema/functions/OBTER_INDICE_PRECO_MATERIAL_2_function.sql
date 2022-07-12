-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_indice_preco_material_2 (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


tx_indice_w		        double precision;--number(15,4);
cd_estabelecimento_w	        smallint;
ie_origem_preco_w		integer;
cd_material_w		        integer;
cd_brasindice_w		        varchar(80);
cd_laboratorio_w		varchar(06);
cd_medicamento_w		varchar(06);
cd_apresentacao_w	        varchar(06);
ie_pis_cofins_w		        varchar(1);
ie_tipo_preco_w		        varchar(3);
nr_seq_regra_ajuste_w	        bigint;
ie_origem_preco_regra_w	        integer;

tx_ajuste_tabela_w		double precision;
tx_brasindice_pfb_w	        REGRA_AJUSTE_MATERIAL.TX_BRASINDICE_PFB%TYPE;--number(15,4);
tx_brasindice_pmc_neutra_w 	CONVENIO_BRASINDICE.TX_BRASINDICE_PMC%TYPE;--number(15,4);
tx_brasindice_pmc_pos_w	        CONVENIO_BRASINDICE.TX_PMC_POS%TYPE;--number(15,4);
tx_brasindice_pmc_neg_w	        CONVENIO_BRASINDICE.TX_PMC_NEG%TYPE;--number(15,4);
tx_simpro_pfb_w		        double precision;
tx_simpro_pmc_w		        double precision;

cd_simpro_w		        bigint;
cd_convenio_w		        integer;
cd_categoria_w		        varchar(10);

tx_brasindice_pfb_pos_w	        CONVENIO_BRASINDICE.TX_PFB_POS%TYPE;--number(15,4);
tx_brasindice_pfb_neg_w	        CONVENIO_BRASINDICE.TX_PFB_NEG%TYPE;--number(15,4);
ie_tipo_material_w	        varchar(3);
qt_regra_w		        bigint;
ie_tipo_atendimento_w	        smallint;
ie_tipo_preco_regra_w	        varchar(3);
cd_grupo_material_w	        smallint;
cd_subgrupo_material_w	        smallint;
cd_classe_material_w	        integer;
ie_prioridade_brasindice_w	varchar(1);
nr_seq_conv_bras_w		bigint;
nr_seq_lote_fornec_w		material_lote_fornec.nr_sequencia%TYPE;
nr_seq_marca_w 			material_lote_fornec.nr_seq_marca%TYPE;

nr_seq_conv_simp_w		material_atend_paciente.nr_seq_conv_simp%type;
nr_seq_simp_preco_w		material_atend_paciente.nr_seq_simp_preco%type;

/*
ie_origem_preco da MATERIAL_ATEND_PACIENTE:
 1  (Brasindice)
 2  (Tabela de Material)
 4  (Simpro)
 */
C01 CURSOR FOR
	SELECT 	ie_pis_cofins,
		ie_tipo_preco
	FROM 	brasindice_preco
	WHERE 	cd_laboratorio = cd_laboratorio_w
	AND 	cd_medicamento = cd_medicamento_w
	AND 	cd_apresentacao = cd_apresentacao_w
	ORDER BY  dt_inicio_vigencia;

C02 CURSOR FOR
	SELECT  tx_ajuste_tabela_mat
	FROM    material_atend_paciente a,
		convenio_preco_mat b
	WHERE   a.nr_sequencia 		= nr_sequencia_p
	AND     a.cd_convenio 		= b.cd_convenio
	AND     a.cd_categoria 		= b.cd_categoria
	AND		((coalesce(b.cd_grupo_material::text, '') = '') OR (obter_estrutura_material(a.cd_material, 'G') = b.cd_grupo_material))  -- HSJ 2018 -- ADICIONADO RESTRIÇÃO
	AND 	((coalesce(b.cd_subgrupo_material::text, '') = '') OR (obter_estrutura_material(a.cd_material, 'S') = b.cd_subgrupo_material)) -- HSJ 2018 -- ADICIONADO RESTRIÇÃO
	AND		((coalesce(b.cd_classe_material::text, '') = '') OR (obter_estrutura_material(a.cd_material, 'C') = b.cd_classe_material)) -- HSJ 2018 -- ADICIONADO RESTRIÇÃO
	AND     a.ie_origem_preco 	= 2
	AND 	b.ie_situacao		= 'A'
	AND 	b.cd_estabelecimento 	= cd_estabelecimento_w
	AND 	coalesce(a.dt_vigencia_tabela,clock_timestamp()) BETWEEN coalesce(b.dt_inicio_vigencia, coalesce(a.dt_vigencia_tabela,clock_timestamp())) AND
							coalesce(dt_final_vigencia, coalesce(a.dt_vigencia_tabela,clock_timestamp()))
	ORDER BY b.nr_prioridade DESC;

C03 CURSOR FOR
	SELECT  CASE WHEN ie_tipo_preco_w='PMC' THEN  CASE WHEN ie_pis_cofins_w='N' THEN  coalesce(tx_brasindice_pmc_neg_w, tx_pmc_neg) WHEN ie_pis_cofins_w='S' THEN  coalesce(tx_brasindice_pmc_neutra_w, tx_pmc_pos)  ELSE coalesce(tx_brasindice_pmc_neutra_w, tx_brasindice_pmc) END  WHEN ie_tipo_preco_w='PFB' THEN  CASE WHEN ie_pis_cofins_w='N' THEN  coalesce(tx_brasindice_pfb_neg_w, tx_pfb_neg) WHEN ie_pis_cofins_w='S' THEN  coalesce(tx_brasindice_pfb_pos_w, tx_pfb_pos)  ELSE coalesce(tx_brasindice_pfb_w, tx_preco_fabrica) END   ELSE tx_preco_fabrica END
	FROM    material_atend_paciente a,
		convenio_brasindice b
	WHERE   a.nr_sequencia = nr_sequencia_p
	AND     a.cd_convenio = b.cd_convenio
	AND 	b.ie_situacao		= 'A'
	AND     a.cd_categoria = coalesce(b.cd_categoria, a.cd_categoria)
	AND     ie_origem_preco = 1
	AND	((coalesce(b.cd_grupo_material::text, '') = '') OR (obter_estrutura_material(a.cd_material, 'G') = b.cd_grupo_material))
	AND 	((coalesce(b.cd_subgrupo_material::text, '') = '') OR (obter_estrutura_material(a.cd_material, 'S') = b.cd_subgrupo_material))
	AND 	((coalesce(b.cd_classe_material::text, '') = '') OR (obter_estrutura_material(a.cd_material, 'C') = b.cd_classe_material))
	AND	((coalesce(b.nr_seq_estrutura::text, '') = '') OR (consistir_se_mat_estrutura(b.nr_seq_estrutura,a.cd_material) = 'S'))
	AND 	((coalesce(b.ie_tipo_material::text, '') = '') OR (b.ie_tipo_material = ie_tipo_material_w))
	AND	((coalesce(b.ie_tipo_atendimento::text, '') = '') OR (b.ie_tipo_atendimento = coalesce(ie_tipo_atendimento_w,0)))
	AND     b.cd_estabelecimento = cd_estabelecimento_w
	ORDER BY  b.dt_inicio_vigencia,
		coalesce(b.nr_seq_estrutura,0),
		coalesce(b.cd_classe_material,0),
		coalesce(b.cd_subgrupo_material,0),
		coalesce(b.cd_grupo_material,0),
		coalesce(b.ie_tipo_material,'0'),
		coalesce(b.ie_tipo_atendimento,0);

C04 CURSOR FOR
	SELECT 	ie_tipo_preco
	FROM 	simpro_preco
	WHERE 	cd_simpro = cd_simpro_w
	ORDER BY dt_vigencia;

C05 CURSOR FOR
	SELECT  CASE WHEN b.ie_tipo_preco='F' THEN  coalesce(tx_simpro_pfb_w, tx_preco_fabrica) WHEN b.ie_tipo_preco='V' THEN  coalesce(tx_simpro_pmc_w, tx_pmc)  ELSE coalesce(tx_simpro_pfb_w, tx_preco_fabrica) END
	FROM    material_atend_paciente a,
		convenio_simpro b
	WHERE   a.nr_sequencia = nr_sequencia_p
	AND     a.cd_convenio  = b.cd_convenio
	AND     a.cd_categoria = b.cd_categoria
	AND 	b.ie_situacao	= 'A'
	AND     ie_origem_preco = 4
	AND	((coalesce(b.cd_grupo_material::text, '') = '') OR (obter_estrutura_material(a.cd_material, 'G') = b.cd_grupo_material))
	AND 	((coalesce(b.cd_subgrupo_material::text, '') = '') OR (obter_estrutura_material(a.cd_material, 'S') = b.cd_subgrupo_material))
	AND 	((coalesce(b.cd_classe_material::text, '') = '') OR (obter_estrutura_material(a.cd_material, 'C') = b.cd_classe_material))
	ORDER BY b.dt_inicio_vigencia,
		coalesce(b.cd_classe_material,0),
		coalesce(b.cd_subgrupo_material,0),
		coalesce(b.cd_grupo_material,0);

C06 CURSOR FOR
	SELECT  CASE WHEN ie_tipo_preco_w='PMC' THEN  CASE WHEN ie_pis_cofins_w='N' THEN  coalesce(tx_brasindice_pmc_neg_w, tx_pmc_neg) WHEN ie_pis_cofins_w='S' THEN  coalesce(tx_brasindice_pmc_neutra_w, tx_pmc_pos)  ELSE coalesce(tx_brasindice_pmc_neutra_w, tx_brasindice_pmc) END  WHEN ie_tipo_preco_w='PFB' THEN  CASE WHEN ie_pis_cofins_w='N' THEN  coalesce(tx_brasindice_pfb_neg_w, tx_pfb_neg) WHEN ie_pis_cofins_w='S' THEN  coalesce(tx_brasindice_pfb_pos_w, tx_pfb_pos)  ELSE coalesce(tx_brasindice_pfb_w, tx_preco_fabrica) END   ELSE tx_preco_fabrica END
	FROM    convenio_brasindice b
	WHERE   b.nr_sequencia = nr_seq_conv_bras_w
	AND 	b.cd_convenio = cd_convenio_w
	AND 	b.ie_situacao		= 'A';


BEGIN

SELECT	MAX(cd_estabelecimento),
	MAX(b.ie_origem_preco),
	MAX(b.cd_material),
	MAX(b.nr_seq_regra_ajuste_mat),
	MAX(a.cd_convenio_parametro),
	MAX(a.cd_categoria_parametro),
	MAX(obter_tipo_atendimento(b.nr_atendimento)),
	coalesce(MAX(nr_seq_conv_bras),0),
	MAX(b.nr_seq_lote_fornec),
	max(b.nr_seq_conv_simp),
	max(b.nr_seq_simp_preco)
INTO STRICT	cd_estabelecimento_w,
	ie_origem_preco_w,
	cd_material_w,
	nr_seq_regra_ajuste_w,
	cd_convenio_w,
	cd_categoria_w,
	ie_tipo_atendimento_w,
	nr_seq_conv_bras_w,
	nr_seq_lote_fornec_w,
	nr_seq_conv_simp_w,
	nr_seq_simp_preco_w
FROM 	material_atend_paciente b,
	conta_paciente a
WHERE 	a.nr_interno_conta = b.nr_interno_conta
AND 	b.nr_sequencia = nr_sequencia_p;

SELECT 	coalesce(MAX(ie_prioridade_brasindice),'N')
INTO STRICT	ie_prioridade_brasindice_w
FROM	parametro_faturamento
WHERE	cd_estabelecimento	= cd_estabelecimento_w;

tx_brasindice_pfb_w		:= NULL;
tx_brasindice_pmc_neutra_w	:= NULL;
tx_brasindice_pmc_neg_w		:= NULL;
tx_brasindice_pmc_pos_w		:= NULL;
tx_simpro_pfb_w			:= NULL;
tx_simpro_pmc_w			:= NULL;
tx_ajuste_tabela_w		:= NULL;
tx_brasindice_pfb_neg_w		:= NULL;
tx_brasindice_pfb_pos_w		:= NULL;

IF (coalesce(nr_seq_regra_ajuste_w,0) > 0) THEN

	SELECT 	COUNT(*)
	INTO STRICT	qt_regra_w
	FROM 	regra_ajuste_material
	WHERE 	nr_sequencia = nr_seq_regra_ajuste_w
	AND	ie_situacao = 'A';

	IF (qt_regra_w > 0) THEN

		SELECT 	tx_brasindice_pfb,
			tx_brasindice_pmc,
			tx_pmc_neg,
			tx_pmc_pos,
			tx_simpro_pfb,
			tx_simpro_pmc,
			coalesce(tx_afaturar, tx_ajuste),
			tx_pfb_neg,
			tx_pfb_pos
		INTO STRICT	tx_brasindice_pfb_w,
			tx_brasindice_pmc_neutra_w,
			tx_brasindice_pmc_neg_w,
			tx_brasindice_pmc_pos_w,
			tx_simpro_pfb_w,
			tx_simpro_pmc_w,
			tx_ajuste_tabela_w,
			tx_brasindice_pfb_neg_w,
			tx_brasindice_pfb_pos_w
		FROM 	regra_ajuste_material
		WHERE 	nr_sequencia = nr_seq_regra_ajuste_w;
	END IF;

END IF;

IF (ie_origem_preco_w = 1) THEN -- Brasindice
	nr_seq_marca_w := 0;
	IF (coalesce(nr_seq_lote_fornec_w,0) > 0) THEN
		SELECT	MAX(coalesce(nr_seq_marca,0))
		INTO STRICT	nr_seq_marca_w
		FROM	material_lote_fornec
		WHERE	nr_sequencia = nr_seq_lote_fornec_w;
	END IF;

	SELECT 	obter_codigo_brasindice(cd_estabelecimento_w, cd_material_w ,clock_timestamp(), cd_convenio_w, nr_seq_marca_w)
	INTO STRICT	cd_brasindice_w
	;

	cd_laboratorio_w		:= SUBSTR(cd_brasindice_w,1,3);
	cd_medicamento_w		:= SUBSTR(cd_brasindice_w,5,5);
	cd_apresentacao_w		:= SUBSTR(cd_brasindice_w,11,4);

	SELECT	MAX(ie_tipo_material),
		MAX(cd_grupo_material),
		MAX(cd_subgrupo_material),
		MAX(cd_classe_material)
	INTO STRICT	ie_tipo_material_w,
		cd_grupo_material_w,
		cd_subgrupo_material_w,
		cd_classe_material_w
	FROM	estrutura_material_v
	WHERE	cd_material = cd_material_w;

	OPEN C01;
	LOOP
	FETCH C01 INTO
		ie_pis_cofins_w,
		ie_tipo_preco_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		BEGIN
		ie_pis_cofins_w  := ie_pis_cofins_w;
		ie_tipo_preco_w	 := ie_tipo_preco_w;
		END;
	END LOOP;
	CLOSE C01;

	SELECT	SUBSTR(Obter_Regra_Brasindice_Preco(cd_convenio_w, cd_categoria_w, cd_grupo_material_w, cd_subgrupo_material_w,	cd_classe_material_w, cd_material_w, clock_timestamp(),
				cd_estabelecimento_w, ie_tipo_atendimento_w),1,3)
	INTO STRICT	ie_tipo_preco_regra_w
	;

	IF (coalesce(ie_tipo_preco_regra_w,'REG') <> 'REG') THEN
		ie_tipo_preco_w	:= ie_tipo_preco_regra_w;
	END IF;

	IF (ie_prioridade_brasindice_w = 'N') THEN
		OPEN C03;
		LOOP
		FETCH C03 INTO
			tx_indice_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			BEGIN
			tx_indice_w:= tx_indice_w;
			END;
		END LOOP;
		CLOSE C03;
	ELSE
		OPEN C06;
		LOOP
		FETCH C06 INTO
			tx_indice_w;
		EXIT WHEN NOT FOUND; /* apply on C06 */
			BEGIN
			tx_indice_w:= tx_indice_w;
			END;
		END LOOP;
		CLOSE C06;
	END IF;

ELSIF (ie_origem_preco_w = 2) THEN -- Tabela Material
	OPEN C02;
	LOOP
	FETCH C02 INTO
		tx_indice_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		BEGIN
		tx_indice_w:= tx_indice_w;
		END;
	END LOOP;
	CLOSE C02;

	tx_indice_w:= coalesce(tx_ajuste_tabela_w, tx_indice_w);

ELSIF (ie_origem_preco_w = 4) THEN -- Simpro
	SELECT 	MAX(cd_simpro)
	INTO STRICT	cd_simpro_w
	FROM 	material_simpro
	WHERE 	cd_material = cd_material_w
	AND	coalesce(cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w;

	if (coalesce(nr_seq_simp_preco_w,0) > 0) then
		select	max(ie_tipo_preco)
		into STRICT	ie_tipo_preco_w
		from	simpro_preco
		where	nr_sequencia = nr_seq_simp_preco_w;
	else
		OPEN C04;
		LOOP
		FETCH C04 INTO
			ie_tipo_preco_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			BEGIN
			ie_tipo_preco_w:= ie_tipo_preco_w;
			END;
		END LOOP;
		CLOSE C04;
	end if;

	if (coalesce(nr_seq_conv_simp_w,0) > 0) then
		select  max(CASE WHEN ie_tipo_preco='F' THEN  coalesce(tx_simpro_pfb_w, tx_preco_fabrica) WHEN ie_tipo_preco='V' THEN  coalesce(tx_simpro_pmc_w, tx_pmc)  ELSE coalesce(tx_simpro_pfb_w, tx_preco_fabrica) END )
		into STRICT	tx_indice_w
		from	convenio_simpro
		where	nr_sequencia = nr_seq_conv_simp_w;
	else
		OPEN C05;
		LOOP
		FETCH C05 INTO
			tx_indice_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			BEGIN
			tx_indice_w:= tx_indice_w;
			END;
		END LOOP;
		CLOSE C05;
	end if;
	tx_ajuste_tabela_w := tx_indice_w;
END IF;

RETURN	coalesce(tx_ajuste_tabela_w, tx_indice_w);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_indice_preco_material_2 (nr_sequencia_p bigint) FROM PUBLIC;

