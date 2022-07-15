-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cus_copiar_regra_aloc_setor ( cd_estabelecimento_p bigint, cd_setor_origem_p bigint, cd_setor_destino_p bigint, nr_seq_regra_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into regra_aloc_custo_setor(
	nr_sequencia,
	cd_setor_atendimento,
	cd_estabelecimento,
	dt_atualizacao,
	nm_usuario,
	ie_calculo_custo,
	pr_aplicar,
	vl_custo,
	cd_area_procedimento,
	cd_especialidade,
	cd_grupo_proc,
	cd_procedimento,
	ie_origem_proced,
	cd_convenio,
	cd_proc_custo,
	ie_origem_proc_custo,
	cd_grupo_material,
	cd_subgrupo_material,
	cd_classe_material,
	cd_material,
	pr_custo_oper,
	pr_medico,
	pr_material,
	ds_criterio_aloc_mat,
	ie_custo_hm,
	nr_seq_exame,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	pr_imposto,
	nr_seq_grupo,
	nr_seq_subgrupo,
	nr_seq_forma_org,
	cd_edicao_amb,
	ie_tipo_atendimento,
	nr_seq_proc_interno,
	cd_categoria_convenio,
	dt_inicio_vigencia,
	dt_fim_vigencia,
	ie_responsavel_credito,
	cd_material_custo)
SELECT	nextval('regra_aloc_custo_setor_seq'),
	cd_setor_destino_p,
	cd_estabelecimento,
	clock_timestamp(),
	nm_usuario_p,
	ie_calculo_custo,
	pr_aplicar,
	vl_custo,
	cd_area_procedimento,
	cd_especialidade,
	cd_grupo_proc,
	cd_procedimento,
	ie_origem_proced,
	cd_convenio,
	cd_proc_custo,
	ie_origem_proc_custo,
	cd_grupo_material,
	cd_subgrupo_material,
	cd_classe_material,
	cd_material,
	pr_custo_oper,
	pr_medico,
	pr_material,
	ds_criterio_aloc_mat,
	ie_custo_hm,
	nr_seq_exame,
	clock_timestamp(),
	nm_usuario_p,
	pr_imposto,
	nr_seq_grupo,
	nr_seq_subgrupo,
	nr_seq_forma_org,
	cd_edicao_amb,
	ie_tipo_atendimento,
	nr_seq_proc_interno,
	cd_categoria_convenio,
	dt_inicio_vigencia,
	dt_fim_vigencia,
	ie_responsavel_credito,
	cd_material_custo
from	regra_aloc_custo_setor
where	cd_setor_atendimento = cd_setor_origem_p
and	cd_estabelecimento = cd_estabelecimento_p
and	((nr_sequencia = coalesce(nr_seq_regra_p,0)) or (coalesce(nr_seq_regra_p,0) = 0));

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cus_copiar_regra_aloc_setor ( cd_estabelecimento_p bigint, cd_setor_origem_p bigint, cd_setor_destino_p bigint, nr_seq_regra_p bigint, nm_usuario_p text) FROM PUBLIC;

