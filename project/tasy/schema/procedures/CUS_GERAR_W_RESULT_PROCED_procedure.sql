-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cus_gerar_w_result_proced ( cd_estabelecimento_p bigint, cd_area_procedimento_p bigint, cd_grupo_proc_p bigint, cd_especialidade_p bigint, cd_convenio_p bigint, cd_setor_atendimento_p bigint, nr_seq_grupo_exame_p bigint, dt_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
/* procedure criada por matheus para o relatório wcus 6019*/
 
 
cd_procedimento_w				bigint;
cd_tabela_custo_proc_w			bigint;
dt_mes_referencia_w				timestamp;
ie_origem_proced_w				bigint;
nr_interno_conta_w				bigint;
pr_resultado_w				double precision;
qt_parametro_w				double precision;
qt_resumo_w					double precision;
vl_custo_w					double precision;
vl_custo_dir_apoio_w				double precision;
vl_custo_dir_fixo_w				double precision;
vl_custo_hm_w					double precision;
vl_custo_indireto_w				double precision;
vl_custo_mao_obra_w				double precision;
vl_custo_total_w				double precision;
vl_custo_var_w				double precision;
vl_despesa_w					double precision;
vl_preco_calculado_w				double precision;
vl_preco_tabela_w				double precision;
vl_procedimento_w				double precision;
vl_resultado_w				double precision;

/*Contas do Mês*/
 
c01 CURSOR FOR 
SELECT	distinct 
	a.nr_interno_conta 
from	conta_paciente_resumo_v3 a 
where	a.dt_referencia = dt_mes_referencia_w 
and	a.cd_convenio	= coalesce(cd_convenio_p, a.cd_convenio);

/* Procedimentos executados no mês */
 
c02 CURSOR FOR 
SELECT	c.cd_procedimento, 
	c.ie_origem_proced, 
	c.qt_resumo, 
	coalesce(c.vl_procedimento,0), 
	coalesce(c.vl_custo,0), 
	coalesce(c.vl_custo_variavel,0), 
	coalesce(c.vl_custo_dir_apoio,0), 
	coalesce(c.vl_custo_mao_obra,0), 
	coalesce(c.vl_custo_direto,0), 
	coalesce(c.vl_custo_indireto,0), 
	coalesce(c.vl_despesa,0), 
	coalesce(c.vl_custo_hm,0) 
from	conta_paciente_resumo_v3 c 
where	c.nr_interno_conta			= nr_interno_conta_w 
and	c.dt_referencia 			= dt_mes_referencia_w 
and	c.cd_area_procedimento			= coalesce(cd_area_procedimento_p, c.cd_area_procedimento) 
and	c.cd_grupo_proc				= coalesce(cd_grupo_proc_p, c.cd_grupo_proc) 
and	c.cd_especialidade			= coalesce(cd_especialidade_p, c.cd_especialidade) 
and	c.cd_setor_atendimento			= coalesce(cd_setor_atendimento_p, c.cd_setor_atendimento) 
and	c.nr_seq_grupo_exame			= coalesce(nr_seq_grupo_exame_p, c.nr_seq_grupo_exame) 
and	(c.cd_procedimento IS NOT NULL AND c.cd_procedimento::text <> '');


BEGIN 
 
delete	from w_cus_result_proced;
commit;
 
dt_mes_referencia_w	:= trunc(dt_referencia_p,'mm');
 
open c01;
loop 
fetch c01 into 
	nr_interno_conta_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
	open c02;
	loop 
	fetch c02 into 
		cd_procedimento_w, 
		ie_origem_proced_w, 
		qt_resumo_w, 
		vl_procedimento_w, 
		vl_custo_w, 
		vl_custo_var_w, 
		vl_custo_dir_apoio_w, 
		vl_custo_mao_obra_w, 
		vl_custo_dir_fixo_w, 
		vl_custo_indireto_w, 
		vl_despesa_w, 
		vl_custo_hm_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		 
		vl_resultado_w			:= vl_procedimento_w - vl_custo_w;
		pr_resultado_w			:= dividir(vl_resultado_w, vl_procedimento_w) *100;
 
		insert into w_cus_result_proced( 
			cd_procedimento, 
			ie_origem_proced, 
			qt_resumo, 
			vl_procedimento, 
			vl_preco_calculado, 
			vl_custo_variavel, 
			vl_custo_mao_obra, 
			vl_custo_direto_fixo, 
			vl_custo_direto_apoio, 
			vl_custo_indireto, 
			vl_despesa, 
			vl_custo_hm, 
			vl_resultado, 
			pr_resultado, 
			dt_atualizacao, 
			nm_usuario) 
		values (cd_procedimento_w, 
			ie_origem_proced_w, 
			qt_resumo_w, 
			vl_procedimento_w, 
			vl_custo_w, 
			vl_custo_var_w, 
			vl_custo_mao_obra_w, 
			vl_custo_dir_fixo_w, 
			vl_custo_dir_apoio_w, 
			vl_custo_indireto_w, 
			vl_despesa_w, 
			vl_custo_hm_w, 
			vl_resultado_w, 
			pr_resultado_w, 
			clock_timestamp(), 
			nm_usuario_p);
	end loop;
	close c02;
 
end loop;
close c01;
 
commit;	
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cus_gerar_w_result_proced ( cd_estabelecimento_p bigint, cd_area_procedimento_p bigint, cd_grupo_proc_p bigint, cd_especialidade_p bigint, cd_convenio_p bigint, cd_setor_atendimento_p bigint, nr_seq_grupo_exame_p bigint, dt_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;

