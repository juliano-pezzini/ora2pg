-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_obter_regra_rateio_sh (CD_ESTABELECIMENTO_P bigint, CD_MATERIAL_P bigint, CD_PROCEDIMENTO_P bigint, IE_ORIGEM_PROCED_P bigint, CD_SETOR_ATENDIMENTO_P bigint, CD_CONVENIO_P INOUT bigint, CD_CATEGORIA_P INOUT bigint, VL_FIXO_P INOUT bigint) AS $body$
DECLARE


cd_grupo_proc_w			bigint		:= 0;
cd_especial_proc_w		bigint		:= 0;
cd_area_proc_w			bigint		:= 0;
cd_procedimento_w		bigint		:= 0;
cd_grupo_mat_w			smallint		:= 0;
cd_subgrupo_mat_w		smallint		:= 0;
cd_classe_mat_w			integer		:= 0;
cd_material_w			bigint		:= 0;
vl_fixo_w			double precision		:= 0;
cd_convenio_w			integer		:= 0;
cd_categoria_w			integer		:= 0;
cd_setor_atendimento_w		integer		:= 0;


/* Leitura do cadastro da regra de SH de procedimentos*/

C02 CURSOR FOR
	SELECT	vl_fixo,
		cd_convenio,
		cd_categoria
	from	sus_regra_rateio_sh
	where	cd_estabelecimento			= cd_estabelecimento_p
	and	coalesce(cd_procedimento,cd_procedimento_w)	= cd_procedimento_w 	or coalesce(cd_procedimento_w::text, '') = ''
	and	coalesce(cd_area_procedimento,cd_area_proc_w)= cd_area_proc_w 	or coalesce(cd_area_proc_w::text, '') = ''
	and	coalesce(cd_especialidade,cd_especial_proc_w) = cd_especial_proc_w 	or coalesce(cd_especial_proc_w::text, '') = ''
	and	coalesce(cd_grupo_proc,cd_grupo_proc_w)	= cd_grupo_proc_w 	or coalesce(cd_grupo_proc_w::text, '') = ''
	and	coalesce(cd_setor_atendimento,cd_setor_atendimento_w) = cd_setor_atendimento_w or coalesce(cd_setor_atendimento_w::text, '') = ''
	order by	coalesce(cd_procedimento,0),
			coalesce(cd_grupo_proc,0),
			coalesce(cd_especialidade,0),
			coalesce(cd_area_procedimento,0);

/* Leitura do cadastro da regra de SH de materiais*/

C03 CURSOR FOR
	SELECT	vl_fixo,
		cd_convenio,
		cd_categoria
	from	sus_regra_rateio_sh
	where	cd_estabelecimento			= cd_estabelecimento_p
	and	coalesce(cd_material,cd_material_w)		= cd_material_w		or coalesce(cd_material_w::text, '') = ''
	and	coalesce(cd_grupo_material,cd_grupo_mat_w)	= cd_grupo_mat_w 	or coalesce(cd_grupo_mat_w::text, '') = ''
	and	coalesce(cd_subgrupo_material,cd_subgrupo_mat_w) = cd_subgrupo_mat_w or coalesce(cd_subgrupo_mat_w::text, '') = ''
	and	coalesce(cd_classe_material,cd_classe_mat_w)	= cd_classe_mat_w 	or coalesce(cd_classe_mat_w::text, '') = ''
	and	coalesce(cd_setor_atendimento,cd_setor_atendimento_w) = cd_setor_atendimento_w or coalesce(cd_setor_atendimento_w::text, '') = ''
	order by	coalesce(cd_material,0),
			coalesce(cd_classe_material,0),
			coalesce(cd_subgrupo_material,0),
			coalesce(cd_grupo_material,0);





BEGIN
cd_procedimento_w	:= cd_procedimento_p;
cd_material_w		:= cd_material_p;
cd_setor_atendimento_w	:= cd_setor_atendimento_p;

/* Obter Estrutura do procedimento */

if (cd_procedimento_w > 0) then
	BEGIN
	select 	cd_grupo_proc,
		cd_especialidade,
		cd_area_procedimento
	into STRICT	cd_grupo_proc_w,
		cd_especial_proc_w,
		cd_area_proc_w
	from	Estrutura_Procedimento_V
	where	cd_procedimento 	= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p;

	OPEN C02;
	LOOP
	FETCH C02 INTO
		vl_fixo_w,
		cd_convenio_w,
		cd_categoria_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
		BEGIN
		vl_fixo_p	:= vl_fixo_w;
		cd_convenio_p	:= cd_convenio_w;
		cd_categoria_p	:= cd_categoria_w;
		END;
	END LOOP;
	CLOSE C02;
	END;
end if;

/* Obter Estrutura do material */

if (cd_material_w > 0) then
	BEGIN
	select 	cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material
	into STRICT	cd_grupo_mat_w,
		cd_subgrupo_mat_w,
		cd_classe_mat_w
	from 	estrutura_material_v
	where 	cd_material		= cd_material_p;

	OPEN C03;
	LOOP
	FETCH C03 INTO
		vl_fixo_w,
		cd_convenio_w,
		cd_categoria_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
		BEGIN
		vl_fixo_p	:= vl_fixo_w;
		cd_convenio_p	:= cd_convenio_w;
		cd_categoria_p	:= cd_categoria_w;
		END;
	END LOOP;
	CLOSE C03;
	END;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_obter_regra_rateio_sh (CD_ESTABELECIMENTO_P bigint, CD_MATERIAL_P bigint, CD_PROCEDIMENTO_P bigint, IE_ORIGEM_PROCED_P bigint, CD_SETOR_ATENDIMENTO_P bigint, CD_CONVENIO_P INOUT bigint, CD_CATEGORIA_P INOUT bigint, VL_FIXO_P INOUT bigint) FROM PUBLIC;

