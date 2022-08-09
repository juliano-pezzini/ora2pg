-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_acomp_analitico ( cd_empresa_p bigint, cd_estab_p bigint, cd_centro_custo_p bigint, ie_tipo_visual_p bigint, ie_tipo_valor_p bigint, nr_seq_mes_inicial_p bigint, nr_seq_mes_final_p bigint, nm_usuario_p text, cd_conta_contabil_p text, nr_seq_grupo_centro_p bigint, ie_consolida_holding_p text default 'N') AS $body$
DECLARE


vl_variacao_01_w			double precision;
vl_variacao_02_w			double precision;
vl_variacao_03_w			double precision;
vl_variacao_04_w			double precision;
vl_variacao_05_w			double precision;
vl_variacao_06_w			double precision;
vl_variacao_07_w			double precision;
vl_variacao_08_w			double precision;
vl_variacao_09_w			double precision;
vl_variacao_10_w			double precision;
vl_variacao_11_w			double precision;
vl_variacao_12_w			double precision;
pr_var_01_w				double precision;
pr_var_02_w				double precision;
pr_var_03_w				double precision;
pr_var_04_w				double precision;
pr_var_05_w				double precision;
pr_var_06_w				double precision;
pr_var_07_w				double precision;
pr_var_08_w				double precision;
pr_var_09_w				double precision;
pr_var_10_w				double precision;
pr_var_11_w				double precision;
pr_var_12_w				double precision;
vl_total_real_w				double precision;
vl_media_w				double precision;
vl_total_w				double precision;
vl_variacao_w				double precision;
pr_variacao_w				double precision;
vl_media_real_w				double precision;
nr_nivel_atual_w			bigint;
qt_meses_w				bigint;
nr_nivel_conta_w 			bigint;
nr_nivel_centro_w 			bigint;
ds_justificativa_w              	varchar(2000);
ds_gerencial_w				varchar(255);
ds_cor_fonte_w				varchar(255);
ds_cor_fundo_w				varchar(255);
cd_classif_conta_w			varchar(40);
cd_classificacao_w			varchar(80);
cd_classif_sup_w			varchar(80);
ie_regra_lib_conta_w			varchar(1);
ie_justificativa_w			varchar(1);
dt_inicial_w				timestamp;
dt_final_w				timestamp;
ie_separador_conta_w			empresa.ie_sep_classif_conta_ctb%type;
w_ctb_orcamento_vis_w			w_ctb_orcamento_vis%rowtype;

c01 CURSOR FOR
	SELECT	y.cd_conta_contabil,
		y.ds_conta_contabil,
		y.cd_centro_custo,
		y.cd_classificacao,
		y.cd_estabelecimento,
		y.cd_empresa,
		coalesce(sum(y.vl_orc_01),0) vl_orc_01,
		coalesce(sum(y.vl_orc_02),0) vl_orc_02,
		coalesce(sum(y.vl_orc_03),0) vl_orc_03,
		coalesce(sum(y.vl_orc_04),0) vl_orc_04,
		coalesce(sum(y.vl_orc_05),0) vl_orc_05,
		coalesce(sum(y.vl_orc_06),0) vl_orc_06,
		coalesce(sum(y.vl_orc_07),0) vl_orc_07,
		coalesce(sum(y.vl_orc_08),0) vl_orc_08,
		coalesce(sum(y.vl_orc_09),0) vl_orc_09,
		coalesce(sum(y.vl_orc_10),0) vl_orc_10,
		coalesce(sum(y.vl_orc_11),0) vl_orc_11,
		coalesce(sum(y.vl_orc_12),0) vl_orc_12,
		coalesce(sum(y.vl_real_01),0) vl_real_01,
		coalesce(sum(y.vl_real_02),0) vl_real_02,
		coalesce(sum(y.vl_real_03),0) vl_real_03,
		coalesce(sum(y.vl_real_04),0) vl_real_04,
		coalesce(sum(y.vl_real_05),0) vl_real_05,
		coalesce(sum(y.vl_real_06),0) vl_real_06,
		coalesce(sum(y.vl_real_07),0) vl_real_07,
		coalesce(sum(y.vl_real_08),0) vl_real_08,
		coalesce(sum(y.vl_real_09),0) vl_real_09,
		coalesce(sum(y.vl_real_10),0) vl_real_10,
		coalesce(sum(y.vl_real_11),0) vl_real_11,
		coalesce(sum(y.vl_real_12),0) vl_real_12,
		coalesce(sum(y.vl_orcado),0) vl_orcado,
		coalesce(sum(y.vl_realizado),0) vl_realizado
	from(
	SELECT	c.cd_conta_contabil,
		c.ds_conta_contabil,
		e.cd_estabelecimento,
		e.cd_empresa,
		CASE WHEN coalesce(nr_seq_grupo_centro_p,0)=0 THEN d.cd_centro_custo  ELSE null END  cd_centro_custo,
		CASE WHEN coalesce(nr_seq_grupo_centro_p,0)=0 THEN d.cd_classificacao  ELSE null END  cd_classificacao,
		CASE WHEN b.dt_referencia=dt_inicial_w THEN  vl_orcado  ELSE 0 END  vl_orc_01,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,01,0) THEN  vl_orcado  ELSE 0 END  vl_orc_02,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,02,0) THEN  vl_orcado  ELSE 0 END  vl_orc_03,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,03,0) THEN  vl_orcado  ELSE 0 END  vl_orc_04,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,04,0) THEN  vl_orcado  ELSE 0 END  vl_orc_05,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,05,0) THEN  vl_orcado  ELSE 0 END  vl_orc_06,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,06,0) THEN  vl_orcado  ELSE 0 END  vl_orc_07,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,07,0) THEN  vl_orcado  ELSE 0 END  vl_orc_08,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,08,0) THEN  vl_orcado  ELSE 0 END  vl_orc_09,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,09,0) THEN  vl_orcado  ELSE 0 END  vl_orc_10,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,10,0) THEN  vl_orcado  ELSE 0 END  vl_orc_11,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,11,0) THEN  vl_orcado  ELSE 0 END  vl_orc_12,
		CASE WHEN b.dt_referencia=dt_inicial_w THEN  vl_realizado  ELSE 0 END  vl_real_01,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,01,0) THEN  vl_realizado  ELSE 0 END  vl_real_02,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,02,0) THEN  vl_realizado  ELSE 0 END  vl_real_03,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,03,0) THEN  vl_realizado  ELSE 0 END  vl_real_04,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,04,0) THEN  vl_realizado  ELSE 0 END  vl_real_05,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,05,0) THEN  vl_realizado  ELSE 0 END  vl_real_06,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,06,0) THEN  vl_realizado  ELSE 0 END  vl_real_07,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,07,0) THEN  vl_realizado  ELSE 0 END  vl_real_08,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,08,0) THEN  vl_realizado  ELSE 0 END  vl_real_09,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,09,0) THEN  vl_realizado  ELSE 0 END  vl_real_10,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,10,0) THEN  vl_realizado  ELSE 0 END  vl_real_11,
		CASE WHEN b.dt_referencia=pkg_date_utils.add_month(dt_inicial_w,11,0) THEN  vl_realizado  ELSE 0 END  vl_real_12,
		a.vl_orcado,
		a.vl_realizado
	from	conta_contabil c,
		ctb_mes_ref b,
		ctb_orcamento a,
		centro_custo d,
		estabelecimento e
	where	a.nr_seq_mes_ref	= b.nr_sequencia
	and	a.cd_conta_contabil	= c.cd_conta_contabil
	and	a.cd_estabelecimento	= e.cd_estabelecimento
	and	a.cd_estabelecimento	= coalesce(cd_estab_p, a.cd_estabelecimento)   /* Deveria filtrar somente pelos estabelecimentos holding */
	and 	d.cd_centro_custo 	= coalesce(cd_centro_custo_p, d.cd_centro_custo)
	and	a.cd_centro_custo	= d.cd_centro_custo
	and 	((coalesce(nr_seq_grupo_centro_p,0) = 0) or exists (select	1
			from	ctb_cen_centro_grupo x
			where	d.cd_centro_custo = x.cd_centro_custo
			and 	x.nr_seq_grupo    = nr_seq_grupo_centro_p))
	and	((coalesce(cd_conta_contabil_p, '0') = '0') or (substr(ctb_obter_se_conta_filtro(c.cd_conta_contabil,cd_conta_contabil_p,ctb_obter_classif_conta(c.cd_conta_contabil, c.cd_classificacao, dt_inicial_w)),1,2) = 'S'))
	and	b.cd_empresa		= CASE WHEN ie_consolida_holding_p='S' THEN e.cd_empresa  ELSE cd_empresa_p END
	and	b.dt_referencia between dt_inicial_w and dt_final_w
	and	(((ie_regra_lib_conta_w = 'S') and substr(ctb_obter_se_conta_ce_usuario(e.cd_empresa, a.cd_centro_custo, a.cd_conta_contabil, nm_usuario_p),1,1) in ('S','V')) or
		 ((ie_regra_lib_conta_w = 'N') and substr(ctb_obter_se_centro_usuario(a.cd_centro_custo, e.cd_empresa, nm_usuario_p),1,1) in ('S','V')))
	and	((ie_consolida_holding_p = 'N') or exists (	select	1
								from	grupo_empresa g,
									grupo_emp_estrutura x
								where	g.nr_sequencia	= x.nr_seq_grupo
								and	x.cd_empresa	= e.cd_empresa
								and	g.nr_sequencia	= HOLDING_PCK.GET_GRUPO_EMP_USUARIO(cd_empresa_p)))
	order by b.dt_referencia) y
	where	1 = 1
	group by y.cd_conta_contabil,
		 y.ds_conta_contabil,
		 y.cd_centro_custo,
		 y.cd_classificacao,
		 y.cd_estabelecimento,
		y.cd_empresa;

c01_w 	c01%rowtype;


BEGIN

/* Separador de nível de conta */

ie_separador_conta_w		:= philips_contabil_pck.get_separador_conta;

/* Data inicial e final utilizados no select */

dt_inicial_w	:= ctb_obter_mes_ref(nr_seq_mes_inicial_p);
dt_final_w	:= ctb_obter_mes_ref(nr_seq_mes_final_p);

begin
/* Aplicar regra de liberação de contas contábeis no Acompanhamento do Orçamento */

ie_regra_lib_conta_w := substr(coalesce(obter_valor_param_usuario(925,69,obter_perfil_ativo,nm_usuario_p, cd_estab_p),'S'),1,1);
exception when others then
	ie_regra_lib_conta_w := 'S';
end;

open c01;
loop
fetch c01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	/* Limpar variáveis */

	vl_total_w			:= 0;
	vl_media_w			:= 0;
	vl_media_real_w			:= 0;
	vl_total_real_w 		:= 0;
	vl_variacao_w			:= 0;
	pr_variacao_w			:= 0;

	/* Obter classificação e classificação superior da conta */

	cd_classif_conta_w		:= substr(ctb_obter_classif_conta(c01_w.cd_conta_contabil, null, dt_inicial_w),1,40);
	cd_classif_sup_w		:= substr(ctb_obter_classif_conta_sup(cd_classif_conta_w, dt_inicial_w, c01_w.cd_empresa),1,40); /* empresa_p*/


	/*
	Tipo visual:
	0 = Orçamento
	1 = Acompanhamento
	2 = DRE
	*/
	ds_gerencial_w		:= c01_w.ds_conta_contabil;
	if (ie_tipo_visual_p = 1) then /* Se estiver sendo chamada dentro da CTB_GERAR_ACOMP_PADRAO */
		begin
		cd_classificacao_w	:= c01_w.cd_classificacao || ie_separador_conta_w || cd_classif_conta_w;
		nr_nivel_atual_w	:= ctb_obter_nivel_classif_conta(cd_classificacao_w);
		ds_gerencial_w		:= substr(lpad(' ', nr_nivel_atual_w * 3) || ds_gerencial_w,1,255);
		/* Nível de centro e de conta utilizado somente para a opção Acompanhamento, procedure CTB_GERAR_ACOMP_PADRAO */

		end;
	else /* Se estiver sendo chamada direto pela CTB_GERAR_ORCAMENTO_VIS */
		begin
		cd_classificacao_w	:= cd_classif_conta_w;
		end;
	end if;
	nr_nivel_conta_w := ctb_obter_nivel_classif_conta(cd_classif_conta_w);
	nr_nivel_centro_w := ctb_obter_nivel_classif_conta(c01_w.cd_classificacao);

	/*
	Cálculo de percentual de variação
	Se ORÇADO igual 0, E valor REAL = 0, então % = 0, se real maior que 0 então % = 100
	Se ORÇADO maior que 0,  calcula variação normal
	*/
	select	CASE WHEN c01_w.vl_orc_01=0 THEN CASE WHEN c01_w.vl_real_01=0 THEN 0  ELSE 100 END    ELSE ((c01_w.vl_real_01 - c01_w.vl_orc_01) * 100) / c01_w.vl_orc_01 END ,
		CASE WHEN c01_w.vl_orc_02=0 THEN CASE WHEN c01_w.vl_real_02=0 THEN 0  ELSE 100 END    ELSE ((c01_w.vl_real_02 - c01_w.vl_orc_02) * 100) / c01_w.vl_orc_02 END ,
		CASE WHEN c01_w.vl_orc_03=0 THEN CASE WHEN c01_w.vl_real_03=0 THEN 0  ELSE 100 END    ELSE ((c01_w.vl_real_03 - c01_w.vl_orc_03) * 100) / c01_w.vl_orc_03 END ,
		CASE WHEN c01_w.vl_orc_04=0 THEN CASE WHEN c01_w.vl_real_04=0 THEN 0  ELSE 100 END    ELSE ((c01_w.vl_real_04 - c01_w.vl_orc_04) * 100) / c01_w.vl_orc_04 END ,
		CASE WHEN c01_w.vl_orc_05=0 THEN CASE WHEN c01_w.vl_real_05=0 THEN 0  ELSE 100 END    ELSE ((c01_w.vl_real_05 - c01_w.vl_orc_05) * 100) / c01_w.vl_orc_05 END ,
		CASE WHEN c01_w.vl_orc_06=0 THEN CASE WHEN c01_w.vl_real_06=0 THEN 0  ELSE 100 END    ELSE ((c01_w.vl_real_06 - c01_w.vl_orc_06) * 100) / c01_w.vl_orc_06 END ,
		CASE WHEN c01_w.vl_orc_07=0 THEN CASE WHEN c01_w.vl_real_07=0 THEN 0  ELSE 100 END    ELSE ((c01_w.vl_real_07 - c01_w.vl_orc_07) * 100) / c01_w.vl_orc_07 END ,
		CASE WHEN c01_w.vl_orc_08=0 THEN CASE WHEN c01_w.vl_real_08=0 THEN 0  ELSE 100 END    ELSE ((c01_w.vl_real_08 - c01_w.vl_orc_08) * 100) / c01_w.vl_orc_08 END ,
		CASE WHEN c01_w.vl_orc_09=0 THEN CASE WHEN c01_w.vl_real_09=0 THEN 0  ELSE 100 END    ELSE ((c01_w.vl_real_09 - c01_w.vl_orc_09) * 100) / c01_w.vl_orc_09 END ,
		CASE WHEN c01_w.vl_orc_10=0 THEN CASE WHEN c01_w.vl_real_10=0 THEN 0  ELSE 100 END    ELSE ((c01_w.vl_real_10 - c01_w.vl_orc_10) * 100) / c01_w.vl_orc_10 END ,
		CASE WHEN c01_w.vl_orc_11=0 THEN CASE WHEN c01_w.vl_real_11=0 THEN 0  ELSE 100 END    ELSE ((c01_w.vl_real_11 - c01_w.vl_orc_11) * 100) / c01_w.vl_orc_11 END ,
		CASE WHEN c01_w.vl_orc_12=0 THEN CASE WHEN c01_w.vl_real_12=0 THEN 0  ELSE 100 END    ELSE ((c01_w.vl_real_12 - c01_w.vl_orc_12) * 100) / c01_w.vl_orc_12 END
	into STRICT	pr_var_01_w,
		pr_var_02_w,
		pr_var_03_w,
		pr_var_04_w,
		pr_var_05_w,
		pr_var_06_w,
		pr_var_07_w,
		pr_var_08_w,
		pr_var_09_w,
		pr_var_10_w,
		pr_var_11_w,
		pr_var_12_w
	;

	/* Calcular variação REAL x ORÇADO */

	vl_variacao_01_w := (c01_w.vl_real_01 - c01_w.vl_orc_01);
	vl_variacao_02_w := (c01_w.vl_real_02 - c01_w.vl_orc_02);
	vl_variacao_03_w := (c01_w.vl_real_03 - c01_w.vl_orc_03);
	vl_variacao_04_w := (c01_w.vl_real_04 - c01_w.vl_orc_04);
	vl_variacao_05_w := (c01_w.vl_real_05 - c01_w.vl_orc_05);
	vl_variacao_06_w := (c01_w.vl_real_06 - c01_w.vl_orc_06);
	vl_variacao_07_w := (c01_w.vl_real_07 - c01_w.vl_orc_07);
	vl_variacao_08_w := (c01_w.vl_real_08 - c01_w.vl_orc_08);
	vl_variacao_09_w := (c01_w.vl_real_09 - c01_w.vl_orc_09);
	vl_variacao_10_w := (c01_w.vl_real_10 - c01_w.vl_orc_10);
	vl_variacao_11_w := (c01_w.vl_real_11 - c01_w.vl_orc_11);
	vl_variacao_12_w := (c01_w.vl_real_12 - c01_w.vl_orc_12);

	/* Realizado - Fonte */

	ds_cor_fonte_w := '';
	ds_cor_fonte_w := ds_cor_fonte_w|| 'PR_VAR_01='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_01_w, pr_var_01_w, cd_estab_p, 0),1,255);
	ds_cor_fonte_w := ds_cor_fonte_w|| 'PR_VAR_02='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_02_w, pr_var_02_w, cd_estab_p, 0),1,255);
	ds_cor_fonte_w := ds_cor_fonte_w|| 'PR_VAR_03='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_03_w, pr_var_03_w, cd_estab_p, 0),1,255);
	ds_cor_fonte_w := ds_cor_fonte_w|| 'PR_VAR_04='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_04_w, pr_var_04_w, cd_estab_p, 0),1,255);
	ds_cor_fonte_w := ds_cor_fonte_w|| 'PR_VAR_05='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_05_w, pr_var_05_w, cd_estab_p, 0),1,255);
	ds_cor_fonte_w := ds_cor_fonte_w|| 'PR_VAR_06='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_06_w, pr_var_06_w, cd_estab_p, 0),1,255);
	ds_cor_fonte_w := ds_cor_fonte_w|| 'PR_VAR_07='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_07_w, pr_var_07_w, cd_estab_p, 0),1,255);
	ds_cor_fonte_w := ds_cor_fonte_w|| 'PR_VAR_08='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_08_w, pr_var_08_w, cd_estab_p, 0),1,255);
	ds_cor_fonte_w := ds_cor_fonte_w|| 'PR_VAR_09='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_09_w, pr_var_09_w, cd_estab_p, 0),1,255);
	ds_cor_fonte_w := ds_cor_fonte_w|| 'PR_VAR_10='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_10_w, pr_var_10_w, cd_estab_p, 0),1,255);
	ds_cor_fonte_w := ds_cor_fonte_w|| 'PR_VAR_11='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_11_w, pr_var_11_w, cd_estab_p, 0),1,255);
	ds_cor_fonte_w := ds_cor_fonte_w|| 'PR_VAR_12='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_12_w, pr_var_12_w, cd_estab_p, 0),1,255);

	/* Realizado - Fundo */

	ds_cor_fundo_w := '';
	ds_cor_fundo_w := ds_cor_fundo_w|| 'PR_VAR_01='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_01_w, pr_var_01_w, cd_estab_p, 1),1,255);
	ds_cor_fundo_w := ds_cor_fundo_w|| 'PR_VAR_02='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_02_w, pr_var_02_w, cd_estab_p, 1),1,255);
	ds_cor_fundo_w := ds_cor_fundo_w|| 'PR_VAR_03='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_03_w, pr_var_03_w, cd_estab_p, 1),1,255);
	ds_cor_fundo_w := ds_cor_fundo_w|| 'PR_VAR_04='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_04_w, pr_var_04_w, cd_estab_p, 1),1,255);
	ds_cor_fundo_w := ds_cor_fundo_w|| 'PR_VAR_05='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_05_w, pr_var_05_w, cd_estab_p, 1),1,255);
	ds_cor_fundo_w := ds_cor_fundo_w|| 'PR_VAR_06='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_06_w, pr_var_06_w, cd_estab_p, 1),1,255);
	ds_cor_fundo_w := ds_cor_fundo_w|| 'PR_VAR_07='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_07_w, pr_var_07_w, cd_estab_p, 1),1,255);
	ds_cor_fundo_w := ds_cor_fundo_w|| 'PR_VAR_08='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_08_w, pr_var_08_w, cd_estab_p, 1),1,255);
	ds_cor_fundo_w := ds_cor_fundo_w|| 'PR_VAR_09='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_09_w, pr_var_09_w, cd_estab_p, 1),1,255);
	ds_cor_fundo_w := ds_cor_fundo_w|| 'PR_VAR_10='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_10_w, pr_var_10_w, cd_estab_p, 1),1,255);
	ds_cor_fundo_w := ds_cor_fundo_w|| 'PR_VAR_11='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_11_w, pr_var_11_w, cd_estab_p, 1),1,255);
	ds_cor_fundo_w := ds_cor_fundo_w|| 'PR_VAR_12='||substr(ctb_obter_regra_cor_orcamento(cd_classif_conta_w, c01_w.cd_conta_contabil, 'N', vl_variacao_12_w, pr_var_12_w, cd_estab_p, 1),1,255);

	/*
	Tipo valor:
	0 = Orçado 1 = Real
	2 = % Variação 3 = Completo
	4 = Orç/Real 5 = Compl s/  total
	6 = Variação(Var/Per)
	*/
	qt_meses_w := trunc(coalesce(months_between(dt_final_w, dt_inicial_w),1)) + 1;
	if (ie_tipo_valor_p = 0) then /* Orçado */
		vl_total_w	:= c01_w.vl_orcado;
		vl_media_w	:= dividir(c01_w.vl_orcado, qt_meses_w);
	elsif (ie_tipo_valor_p = 1) then /* Real */
		vl_total_w	:= c01_w.vl_realizado;
		vl_media_w	:= dividir(c01_w.vl_realizado, qt_meses_w);
	elsif (ie_tipo_valor_p in (3,4)) then /* Completo(3) - Orc/Real(4) */
		begin
		vl_total_w	:= c01_w.vl_orcado;
		vl_total_real_w	:= c01_w.vl_realizado;
		vl_media_w	:= dividir(c01_w.vl_orcado, qt_meses_w);
		vl_media_real_w	:= dividir(c01_w.vl_realizado, qt_meses_w);
		vl_variacao_w	:= vl_total_w - vl_total_real_w;
		pr_variacao_w	:= (dividir(vl_total_real_w - vl_total_w,vl_total_w)*100);
		end;
	end if;

	/* Obter justificativa somente se for por centro de custo */

	ds_justificativa_w := null;
	if (coalesce(nr_seq_grupo_centro_p,0) = 0) then
		begin
		select	coalesce(max('S'), 'N')
		into STRICT	ie_justificativa_w
		from	ctb_mes_ref b,
			ctb_orcamento a
		where	a.nr_seq_mes_ref	= b.nr_sequencia
		and	a.cd_centro_custo	= c01_w.cd_centro_custo
		and	a.cd_conta_contabil	= c01_w.cd_conta_contabil
		and	(a.ds_justificativa IS NOT NULL AND a.ds_justificativa::text <> '')
		and	b.dt_referencia	between dt_inicial_w and dt_final_w;

		if (ie_justificativa_w = 'S') then
			begin
			ds_justificativa_w := substr(ctb_obter_justi_orc_periodo(c01_w.cd_empresa, c01_w.cd_centro_custo, c01_w.cd_conta_contabil, dt_inicial_w, dt_final_w),1,255);
			end;
		end if;
		end;
	else
		begin
		ie_justificativa_w := 'N';
		end;
	end if;

	/* Limpar os valores da variável para garantir valores novos em todos os campos */

	w_ctb_orcamento_vis_w := null;

	/* Buscar próxima sequence e carregar valores */

	select	nextval('w_ctb_orcamento_vis_seq')
	into STRICT	w_ctb_orcamento_vis_w.nr_sequencia
	;

	w_ctb_orcamento_vis_w.dt_atualizacao		:= clock_timestamp();
	w_ctb_orcamento_vis_w.nm_usuario		:= nm_usuario_p;
	w_ctb_orcamento_vis_w.dt_atualizacao_nrec	:= clock_timestamp();
	w_ctb_orcamento_vis_w.nm_usuario_nrec		:= nm_usuario_p;
	w_ctb_orcamento_vis_w.cd_centro_custo		:= c01_w.cd_centro_custo;
	w_ctb_orcamento_vis_w.cd_conta_contabil		:= c01_w.cd_conta_contabil;
	w_ctb_orcamento_vis_w.cd_classif_conta		:= cd_classif_conta_w;
	w_ctb_orcamento_vis_w.cd_classificacao		:= cd_classificacao_w;
	w_ctb_orcamento_vis_w.cd_classif_sup		:= cd_classif_sup_w;
	w_ctb_orcamento_vis_w.ds_gerencial		:= ds_gerencial_w;
	w_ctb_orcamento_vis_w.vl_orc_01			:= c01_w.vl_orc_01;
	w_ctb_orcamento_vis_w.vl_orc_02			:= c01_w.vl_orc_02;
	w_ctb_orcamento_vis_w.vl_orc_03			:= c01_w.vl_orc_03;
	w_ctb_orcamento_vis_w.vl_orc_04			:= c01_w.vl_orc_04;
	w_ctb_orcamento_vis_w.vl_orc_05			:= c01_w.vl_orc_05;
	w_ctb_orcamento_vis_w.vl_orc_06			:= c01_w.vl_orc_06;
	w_ctb_orcamento_vis_w.vl_orc_07			:= c01_w.vl_orc_07;
	w_ctb_orcamento_vis_w.vl_orc_08			:= c01_w.vl_orc_08;
	w_ctb_orcamento_vis_w.vl_orc_09			:= c01_w.vl_orc_09;
	w_ctb_orcamento_vis_w.vl_orc_10			:= c01_w.vl_orc_10;
	w_ctb_orcamento_vis_w.vl_orc_11			:= c01_w.vl_orc_11;
	w_ctb_orcamento_vis_w.vl_orc_12			:= c01_w.vl_orc_12;
	w_ctb_orcamento_vis_w.vl_total			:= vl_total_w;
	w_ctb_orcamento_vis_w.vl_media			:= vl_media_w;
	w_ctb_orcamento_vis_w.vl_real_01		:= c01_w.vl_real_01;
	w_ctb_orcamento_vis_w.vl_real_02		:= c01_w.vl_real_02;
	w_ctb_orcamento_vis_w.vl_real_03		:= c01_w.vl_real_03;
	w_ctb_orcamento_vis_w.vl_real_04		:= c01_w.vl_real_04;
	w_ctb_orcamento_vis_w.vl_real_05		:= c01_w.vl_real_05;
	w_ctb_orcamento_vis_w.vl_real_06		:= c01_w.vl_real_06;
	w_ctb_orcamento_vis_w.vl_real_07		:= c01_w.vl_real_07;
	w_ctb_orcamento_vis_w.vl_real_08		:= c01_w.vl_real_08;
	w_ctb_orcamento_vis_w.vl_real_09		:= c01_w.vl_real_09;
	w_ctb_orcamento_vis_w.vl_real_10		:= c01_w.vl_real_10;
	w_ctb_orcamento_vis_w.vl_real_11		:= c01_w.vl_real_11;
	w_ctb_orcamento_vis_w.vl_real_12		:= c01_w.vl_real_12;
	w_ctb_orcamento_vis_w.pr_var_01			:= pr_var_01_w;
	w_ctb_orcamento_vis_w.pr_var_02			:= pr_var_02_w;
	w_ctb_orcamento_vis_w.pr_var_03			:= pr_var_03_w;
	w_ctb_orcamento_vis_w.pr_var_04			:= pr_var_04_w;
	w_ctb_orcamento_vis_w.pr_var_05			:= pr_var_05_w;
	w_ctb_orcamento_vis_w.pr_var_06			:= pr_var_06_w;
	w_ctb_orcamento_vis_w.pr_var_07			:= pr_var_07_w;
	w_ctb_orcamento_vis_w.pr_var_08			:= pr_var_08_w;
	w_ctb_orcamento_vis_w.pr_var_09			:= pr_var_09_w;
	w_ctb_orcamento_vis_w.pr_var_10			:= pr_var_10_w;
	w_ctb_orcamento_vis_w.pr_var_11			:= pr_var_11_w;
	w_ctb_orcamento_vis_w.pr_var_12			:= pr_var_12_w;
	w_ctb_orcamento_vis_w.cd_estabelecimento	:= c01_w.cd_estabelecimento;
	w_ctb_orcamento_vis_w.ds_cor_fonte		:= ds_cor_fonte_w;
	w_ctb_orcamento_vis_w.ds_cor_fundo		:= ds_cor_fundo_w;
	w_ctb_orcamento_vis_w.ie_justificativa		:= ie_justificativa_w;
	w_ctb_orcamento_vis_w.vl_total_real		:= vl_total_real_w;
	w_ctb_orcamento_vis_w.vl_variacao		:= vl_variacao_w;
	w_ctb_orcamento_vis_w.pr_variacao		:= pr_variacao_w;
	w_ctb_orcamento_vis_w.vl_media_real		:= vl_media_real_w;
	w_ctb_orcamento_vis_w.vl_var_01			:= vl_variacao_01_w;
	w_ctb_orcamento_vis_w.vl_var_02			:= vl_variacao_02_w;
	w_ctb_orcamento_vis_w.vl_var_03			:= vl_variacao_03_w;
	w_ctb_orcamento_vis_w.vl_var_04			:= vl_variacao_04_w;
	w_ctb_orcamento_vis_w.vl_var_05			:= vl_variacao_05_w;
	w_ctb_orcamento_vis_w.vl_var_06			:= vl_variacao_06_w;
	w_ctb_orcamento_vis_w.vl_var_07			:= vl_variacao_07_w;
	w_ctb_orcamento_vis_w.vl_var_08			:= vl_variacao_08_w;
	w_ctb_orcamento_vis_w.vl_var_09			:= vl_variacao_09_w;
	w_ctb_orcamento_vis_w.vl_var_10			:= vl_variacao_10_w;
	w_ctb_orcamento_vis_w.vl_var_11			:= vl_variacao_11_w;
	w_ctb_orcamento_vis_w.vl_var_12			:= vl_variacao_12_w;
	w_ctb_orcamento_vis_w.nr_nivel_conta		:= nr_nivel_conta_w;
	w_ctb_orcamento_vis_w.nr_nivel_centro		:= nr_nivel_centro_w;
	w_ctb_orcamento_vis_w.ds_justificativa		:= ds_justificativa_w;

	/* Inserir registro pronto na tabela e limpar variável */

	insert into w_ctb_orcamento_vis values (w_ctb_orcamento_vis_w.*);
	/* Limpar os valores da variável */

	w_ctb_orcamento_vis_w := null;
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_acomp_analitico ( cd_empresa_p bigint, cd_estab_p bigint, cd_centro_custo_p bigint, ie_tipo_visual_p bigint, ie_tipo_valor_p bigint, nr_seq_mes_inicial_p bigint, nr_seq_mes_final_p bigint, nm_usuario_p text, cd_conta_contabil_p text, nr_seq_grupo_centro_p bigint, ie_consolida_holding_p text default 'N') FROM PUBLIC;
