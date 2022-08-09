-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE define_sequencia_parametro ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_conta_p bigint, ie_clinica_p bigint, cd_setor_atendimento_p bigint, ie_classif_convenio_p text, ie_tipo_atendimento_p bigint, ie_tipo_convenio_p bigint, cd_convenio_p bigint, cd_categoria_convenio_p text, cd_local_estoque_p bigint, cd_operacao_estoque_p bigint, dt_vigencia_p timestamp, cd_conta_contabil_p INOUT text, cd_centro_custo_p INOUT bigint, cd_plano_p text, ie_regra_pacote_p text default null, ie_complexidade_sus_p text default null, ie_tipo_financ_sus_p text default null, nr_seq_motivo_solic_p bigint default null, cd_sequencia_parametro_p INOUT bigint DEFAULT NULL, vl_item_regra_p bigint default null) AS $body$
DECLARE


/* -------------- Tipo de Conta -------
	1 - Receita
	2 - Estoque
	3 - Passagem Direta
	4 - Desp pre-faturamento
	5 - Ajuste producao
	6 - Redutora Receita
	7 - Gratuidade
*/
cd_grupo_w                	bigint  := 0;
cd_especialidade_w        	bigint  := 0;
cd_area_w		bigint  := 0;
dt_vigencia_w		timestamp;
nr_seq_forma_org_w	bigint := 0;
nr_seq_grupo_w		bigint := 0;
nr_seq_subgrupo_w	bigint := 0;
nr_seq_familia_w	parametros_conta_contabil.nr_seq_familia%type;
cd_operacao_estoque_w	parametros_conta_contabil.cd_operacao_estoque%type;
cd_empresa_w		smallint;
cd_classe_material_w      	integer := 0;
cd_subgrupo_material_w    	smallint := 0;
cd_grupo_material_w       	smallint := 0;
cd_sequencia_parametro_w    bigint;
ie_tipo_centro_w		smallint;
ie_tipo_tributo_item_w	varchar(15);
cd_local_estoque_w	integer;
ie_regra_pacote_w		varchar(1);
ie_param19_w		varchar(1);
ie_considera_dt_vig_w		varchar(1);

c001 CURSOR FOR
SELECT	cd_sequencia_parametro
from 	parametros_conta_contabil
where	cd_empresa					= cd_empresa_w
and	coalesce(cd_estabelecimento, cd_estabelecimento_p)		= cd_estabelecimento_p
and	coalesce(cd_procedimento,cd_procedimento_p) 		= cd_procedimento_p
and	coalesce(CASE WHEN coalesce(cd_procedimento,0)=0 THEN null  ELSE ie_origem_proced END ,ie_origem_proced_p) = ie_origem_proced_p
and	coalesce(cd_area_proced,cd_area_w)			= cd_area_w
and	coalesce(cd_especial_proced,cd_especialidade_w)		= cd_especialidade_w
and	coalesce(cd_grupo_proced,cd_grupo_w)			= cd_grupo_w
and	coalesce(nr_seq_forma_org, nr_seq_forma_org_w)		= nr_seq_forma_org_w
and	coalesce(nr_seq_grupo, nr_seq_grupo_w)			= nr_seq_grupo_w
and	coalesce(nr_seq_subgrupo, nr_seq_subgrupo_w)		= nr_seq_subgrupo_w
and 	coalesce(ie_tipo_atendimento,coalesce(ie_tipo_atendimento_p,0)) 	= coalesce(ie_tipo_atendimento_p,0)
and	coalesce(cd_setor_atendimento,coalesce(cd_setor_atendimento_p,0))	= coalesce(cd_setor_atendimento_p,0)
and	coalesce(cd_centro_custo,coalesce(cd_centro_custo_p,0))		= coalesce(cd_centro_custo_p,0)
and	coalesce(ie_classif_convenio,coalesce(ie_classif_convenio_p,0))	= coalesce(ie_classif_convenio_p,0)
and	coalesce(ie_tipo_convenio,coalesce(ie_tipo_convenio_p,0))		= coalesce(ie_tipo_convenio_p,0)
and	coalesce(cd_plano,coalesce(cd_plano_p,0))			= coalesce(cd_plano_p,0)
and	coalesce(cd_categoria_convenio,coalesce(cd_categoria_convenio_p,'0')) = coalesce(cd_categoria_convenio_p,'0')
and	coalesce(cd_convenio,coalesce(cd_convenio_p,0))			= coalesce(cd_convenio_p,0)
and	coalesce(nr_seq_motivo_solic,coalesce(nr_seq_motivo_solic_p,0))	= coalesce(nr_seq_motivo_solic_p,0)
and	((IE_TIPO_CONTA_P = 1 AND cd_conta_receita IS NOT NULL AND cd_conta_receita::text <> '') or
	(IE_TIPO_CONTA_P = 2 AND cd_conta_estoque IS NOT NULL AND cd_conta_estoque::text <> '') or
	(IE_TIPO_CONTA_P = 3 AND cd_conta_passag_direta IS NOT NULL AND cd_conta_passag_direta::text <> '') or
	(IE_TIPO_CONTA_P = 4 AND cd_conta_desp_pre_fatur IS NOT NULL AND cd_conta_desp_pre_fatur::text <> '') or
	(IE_TIPO_CONTA_P = 6 AND CD_CONTA_REDUT_RECEITA IS NOT NULL AND CD_CONTA_REDUT_RECEITA::text <> '') or
	(IE_TIPO_CONTA_P = 7 AND cd_conta_gratuidade IS NOT NULL AND cd_conta_gratuidade::text <> ''))
and	coalesce(cd_material::text, '') = ''
and	coalesce(cd_classe_material::text, '') = ''
and	coalesce(cd_subgrupo_material::text, '') = ''
and	coalesce(cd_grupo_material::text, '') = ''
and coalesce(nr_seq_familia::text, '') = ''
and	coalesce(ie_clinica, coalesce(ie_clinica_p,0))			= coalesce(ie_clinica_p,0)
and	coalesce(ie_complexidade_sus,coalesce(ie_complexidade_sus_p,'0')) 	= coalesce(ie_complexidade_sus_p,'0')
and	coalesce(ie_tipo_financ_sus,coalesce(ie_tipo_financ_sus_p,'0'))	= coalesce(ie_tipo_financ_sus_p,'0')
and (coalesce(dt_inicio_vigencia, dt_vigencia_w) <= dt_vigencia_w and coalesce(dt_fim_vigencia, dt_vigencia_w) >= dt_vigencia_w)
order by	CASE WHEN ie_considera_dt_vig_w='S' THEN dt_inicio_vigencia  ELSE null END ,
	coalesce(cd_estabelecimento,0),
	coalesce(ie_tipo_financ_sus,0),
	coalesce(ie_complexidade_sus,0),
	coalesce(cd_categoria_convenio,'0'),
	coalesce(cd_plano,0),
	coalesce(cd_convenio,0),
	coalesce(ie_tipo_convenio,0),
	coalesce(ie_classif_convenio,0),
	coalesce(cd_setor_atendimento,0),
	coalesce(cd_centro_custo,0),
	coalesce(ie_tipo_atendimento,0),
	coalesce(ie_clinica,0),
	coalesce(cd_procedimento,0),
	coalesce(nr_seq_forma_org,0),
	coalesce(nr_seq_subgrupo,0),
	coalesce(nr_seq_grupo,0),
	coalesce(cd_grupo_proced,0),
	coalesce(cd_especial_proced,0),
	coalesce(cd_area_proced,0);

c002 CURSOR FOR
	/* Obter contas do material  */

	SELECT	cd_sequencia_parametro
	from 	parametros_conta_contabil
	where	cd_empresa						= cd_empresa_w
	and	coalesce(cd_estabelecimento, cd_estabelecimento_p)			= cd_estabelecimento_p
	and	coalesce(cd_material,cd_material_p) 				= cd_material_p
	and	coalesce(cd_grupo_material,cd_grupo_material_w)			= cd_grupo_material_w
	and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w)		= cd_subgrupo_material_w
	and	coalesce(cd_classe_material,cd_classe_material_w)			= cd_classe_material_w
	and coalesce(nr_seq_familia, coalesce(nr_seq_familia_w, 0)) 				= coalesce(nr_seq_familia_w, 0)
	and 	coalesce(ie_tipo_atendimento,coalesce(ie_tipo_atendimento_p,0)) 		= coalesce(ie_tipo_atendimento_p,0)
	and	coalesce(cd_setor_atendimento,coalesce(cd_setor_atendimento_p,0)) 		= coalesce(cd_setor_atendimento_p,0)
	and	coalesce(cd_centro_custo,coalesce(cd_centro_custo_p,0)) 			= coalesce(cd_centro_custo_p,0)
	and	coalesce(ie_classif_convenio,coalesce(ie_classif_convenio_p,0))		= coalesce(ie_classif_convenio_p,0)
	and	coalesce(ie_tipo_convenio,coalesce(ie_tipo_convenio_p,0))			= coalesce(ie_tipo_convenio_p,0)
	and	coalesce(cd_convenio,coalesce(cd_convenio_p,0))				= coalesce(cd_convenio_p,0)
	and	coalesce(cd_local_estoque,coalesce(cd_local_estoque_w,0))			= coalesce(cd_local_estoque_w,0)
	and	coalesce(ie_tipo_tributo_item,coalesce(ie_tipo_tributo_item_w,'N'))		= coalesce(ie_tipo_tributo_item_w,'N')
	and	coalesce(cd_plano,coalesce(cd_plano_p,0))				= coalesce(cd_plano_p,0)
	and	coalesce(cd_categoria_convenio,coalesce(cd_categoria_convenio_p,'0'))	= coalesce(cd_categoria_convenio_p,'0')
	and	coalesce(ie_tipo_centro,coalesce(ie_tipo_centro_w,0)) 			= coalesce(ie_tipo_centro_w,0)
	and	coalesce(ie_clinica, coalesce(ie_clinica_p,0))				= coalesce(ie_clinica_p,0)
	and	coalesce(nr_seq_motivo_solic, coalesce(nr_seq_motivo_solic_p,0))		= coalesce(nr_seq_motivo_solic_p,0)
	and  	((ie_param19_w = 'S' and ((coalesce(cd_operacao_estoque_w::text, '') = '') or (coalesce(cd_operacao_estoque::text, '') = '') or (cd_operacao_estoque_w = cd_operacao_estoque)))
		or ( ie_param19_w = 'N' and coalesce(cd_operacao_estoque,coalesce(cd_operacao_estoque_w,0)) 	= coalesce(cd_operacao_estoque_w,0)))
	and	((ie_tipo_conta_p = 1 AND cd_conta_receita IS NOT NULL AND cd_conta_receita::text <> '') or
		(ie_tipo_conta_p = 2 AND cd_conta_estoque IS NOT NULL AND cd_conta_estoque::text <> '') or
		(ie_tipo_conta_p = 5 AND cd_conta_ajuste_prod IS NOT NULL AND cd_conta_ajuste_prod::text <> '') or
		(ie_tipo_conta_p = 3 AND cd_conta_passag_direta IS NOT NULL AND cd_conta_passag_direta::text <> '') or
		(ie_tipo_conta_p = 4 AND cd_conta_desp_pre_fatur IS NOT NULL AND cd_conta_desp_pre_fatur::text <> '') or
		(ie_tipo_conta_p = 6 AND cd_conta_redut_receita IS NOT NULL AND cd_conta_redut_receita::text <> '')  or
		(ie_tipo_conta_p = 7 AND cd_conta_gratuidade IS NOT NULL AND cd_conta_gratuidade::text <> ''))
	and	coalesce(cd_procedimento::text, '') = ''
	and	coalesce(cd_grupo_proced::text, '') = ''
	and	coalesce(cd_especial_proced::text, '') = ''
	and	coalesce(cd_area_proced::text, '') = ''
	and	coalesce(nr_seq_forma_org::text, '') = ''
	and	coalesce(nr_seq_grupo::text, '') = ''
	and	coalesce(nr_seq_subgrupo::text, '') = ''
	and (coalesce(dt_inicio_vigencia, dt_vigencia_w) <= dt_vigencia_w and coalesce(dt_fim_vigencia, dt_vigencia_w) >= dt_vigencia_w)
	and (coalesce(nr_seq_regra_valor::text, '') = '' or pat_obter_se_regra_valor(nr_seq_regra_valor,vl_item_regra_p, dt_vigencia_p) = 'S')
	order by
		CASE WHEN ie_considera_dt_vig_w='S' THEN dt_inicio_vigencia  ELSE null END ,
		coalesce(cd_estabelecimento,0),
		coalesce(ie_tipo_tributo_item,'N'),
		coalesce(cd_categoria_convenio,'0'),
		coalesce(cd_plano,0),
		coalesce(cd_convenio,0),
		coalesce(ie_tipo_convenio,0),
		coalesce(ie_classif_convenio,0),
		coalesce(cd_setor_atendimento,0),
		coalesce(cd_centro_custo,0),
		coalesce(ie_tipo_centro,0),
		coalesce(cd_local_estoque,0),
		CASE WHEN ie_param19_w='S' THEN ((CASE WHEN (cd_operacao_estoque_w IS NOT NULL AND cd_operacao_estoque_w::text <> '') THEN 0 ELSE coalesce(cd_operacao_estoque,0) END))  ELSE (coalesce(cd_operacao_estoque,0)) END ,
		coalesce(ie_tipo_atendimento,0),
		coalesce(ie_clinica,0),
		coalesce(cd_material,0),
		coalesce(cd_classe_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_grupo_material,0),
		coalesce(nr_seq_familia,0),
		coalesce(nr_seq_regra_valor,0);


BEGIN

select	CASE WHEN cd_operacao_estoque_p=0 THEN  null  ELSE cd_operacao_estoque_p END
into STRICT	cd_operacao_estoque_w
;

ie_considera_dt_vig_w := coalesce(obter_valor_param_usuario(7050, 20, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo), 'S');
ie_param19_w          := coalesce(obter_valor_param_usuario(7050, 19, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo), 'S');

dt_vigencia_w		:= trunc(dt_vigencia_p,'dd');

select	max(cd_empresa)
into STRICT	cd_empresa_w
from	estabelecimento
where	cd_estabelecimento	= cd_estabelecimento_p;

if (cd_procedimento_p > 0) then
	begin
	select	cd_grupo_proc,
		cd_especialidade,
		cd_area_procedimento,
		coalesce(substr(sus_obter_seq_estrut_proc(sus_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_p, 'C', 'F'),'F'),1,10),0),
		coalesce(substr(sus_obter_seq_estrut_proc(sus_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_p, 'C', 'G'),'G'),1,10),0),
		coalesce(substr(sus_obter_seq_estrut_proc(sus_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_p, 'C', 'S'),'S'),1,10),0)
	into STRICT	cd_grupo_w,
		cd_especialidade_w,
		cd_area_w,
		nr_seq_forma_org_w,
		nr_seq_grupo_w,
		nr_seq_subgrupo_w
	from	estrutura_procedimento_v
	where	cd_procedimento 	= cd_procedimento_p
	and	ie_origem_proced 	= ie_origem_proced_p;
	exception when others then
		cd_grupo_w 		:= 0;
		cd_especialidade_w	:= 0;
		cd_area_w		:= 0;
	end;

	open c001;
	loop
	fetch c001 into
		cd_sequencia_parametro_w;
	EXIT WHEN NOT FOUND; /* apply on c001 */
		begin
			cd_sequencia_parametro_w := cd_sequencia_parametro_w;
		end;
	end loop;
	close c001;

elsif (cd_material_p > 0) then
	begin
	cd_conta_contabil_p	:= null;
	ie_tipo_centro_w	:= 0;

	ie_tipo_tributo_item_w	:= coalesce(obter_tipo_tributacao_item(cd_estabelecimento_p,cd_material_p),'N');

	select	cd_classe_material,
		cd_subgrupo_material,
		nr_seq_familia,
		cd_grupo_material
	into STRICT	cd_classe_material_w,
		cd_subgrupo_material_w,
		nr_seq_familia_w,
		cd_grupo_material_w
	from	estrutura_material_v
	where	cd_material	 = cd_material_p;
	exception when others then
		cd_classe_material_w 	:= 0;
		cd_subgrupo_material_w 	:= 0;
		cd_grupo_material_w 	:= 0;
		nr_seq_familia_w		:= 0;
	end;

	begin
	if (coalesce(cd_centro_custo_p,0) <> 0) then
		select	coalesce(max(ie_tipo_custo),0)
		into STRICT	ie_tipo_centro_w
		from	centro_custo
		where	cd_centro_custo	= cd_centro_custo_p;
	end if;
	exception
	when others then
		ie_tipo_centro_w	:= 0;
	end;

	cd_local_estoque_w	:= cd_local_estoque_p;
	ie_regra_pacote_w		:= coalesce(ie_regra_pacote_p,'N');

	open C002;
	loop
	fetch C002 into
		cd_sequencia_parametro_w;
	EXIT WHEN NOT FOUND; /* apply on C002 */
		begin
			cd_sequencia_parametro_w := cd_sequencia_parametro_w;
		end;
	end loop;
	close C002;
end if;

if (cd_sequencia_parametro_w IS NOT NULL AND cd_sequencia_parametro_w::text <> '') then
	cd_sequencia_parametro_p := cd_sequencia_parametro_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE define_sequencia_parametro ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_conta_p bigint, ie_clinica_p bigint, cd_setor_atendimento_p bigint, ie_classif_convenio_p text, ie_tipo_atendimento_p bigint, ie_tipo_convenio_p bigint, cd_convenio_p bigint, cd_categoria_convenio_p text, cd_local_estoque_p bigint, cd_operacao_estoque_p bigint, dt_vigencia_p timestamp, cd_conta_contabil_p INOUT text, cd_centro_custo_p INOUT bigint, cd_plano_p text, ie_regra_pacote_p text default null, ie_complexidade_sus_p text default null, ie_tipo_financ_sus_p text default null, nr_seq_motivo_solic_p bigint default null, cd_sequencia_parametro_p INOUT bigint DEFAULT NULL, vl_item_regra_p bigint default null) FROM PUBLIC;
