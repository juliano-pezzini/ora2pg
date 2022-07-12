-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW conta_contabil_v (cd_conta_contabil, ds_conta_contabil, ie_situacao, dt_atualizacao, nm_usuario, ie_centro_custo, ie_tipo, cd_grupo, cd_classificacao, cd_empresa, cd_centro_custo, cd_sistema_contabil, nr_seq_crit_rateio, cd_plano_ans, ds_orientacao, ie_compensacao, ie_versao_ans, dt_inicio_vigencia, dt_fim_vigencia, cd_classif_superior, dt_atualizacao_nrec, nm_usuario_nrec, cd_classif_ecd, ie_ecd_reg_dre, ie_ecd_reg_bp, ie_diops, cd_classificacao_atual, cd_classif_superior_atual, ie_natureza_sped, ie_deducao_acomp_orc, ie_intercompany, ie_eliminacao_lancto, dt_eliminacao_lancto, cd_conta_referencia, ds_grupo, ds_conta_apres, ie_nivel, ie_classif_superior, cd_classificacao_sup, cd_conta_numerico, ds_centro_custo, ds_natureza_sped) AS select	a.CD_CONTA_CONTABIL,a.DS_CONTA_CONTABIL,a.IE_SITUACAO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.IE_CENTRO_CUSTO,a.IE_TIPO,a.CD_GRUPO,a.CD_CLASSIFICACAO,a.CD_EMPRESA,a.CD_CENTRO_CUSTO,a.CD_SISTEMA_CONTABIL,a.NR_SEQ_CRIT_RATEIO,a.CD_PLANO_ANS,a.DS_ORIENTACAO,a.IE_COMPENSACAO,a.IE_VERSAO_ANS,a.DT_INICIO_VIGENCIA,a.DT_FIM_VIGENCIA,a.CD_CLASSIF_SUPERIOR,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.CD_CLASSIF_ECD,a.IE_ECD_REG_DRE,a.IE_ECD_REG_BP,a.IE_DIOPS,a.CD_CLASSIFICACAO_ATUAL,a.CD_CLASSIF_SUPERIOR_ATUAL,a.IE_NATUREZA_SPED,a.IE_DEDUCAO_ACOMP_ORC,a.IE_INTERCOMPANY,a.IE_ELIMINACAO_LANCTO,a.DT_ELIMINACAO_LANCTO,a.CD_CONTA_REFERENCIA,
	b.ds_grupo,
	substr(lpad(' ', 2 *(substr(obter_classif_ctb(ctb_obter_classif_conta(a.cd_conta_contabil, a.cd_classificacao, null),'NIVEL'),1,3) -1))||ds_conta_contabil,1,254) ds_conta_apres,
	substr(obter_classif_ctb(a.cd_classificacao,'NIVEL'),1,3) ie_nivel,
	substr(obter_classif_ctb(a.cd_classificacao,'SUPERIOR'),1,20) ie_classif_superior,
	substr(coalesce(a.cd_classif_superior, ctb_obter_classif_conta_sup(a.cd_classificacao,null,a.cd_empresa)),1,40) cd_classificacao_sup,
	campo_numerico(cd_conta_contabil) cd_conta_numerico,
	substr(obter_desc_centro_custo(cd_centro_custo),1,255) ds_centro_custo,
	substr(obter_valor_dominio(4696,a.ie_natureza_sped),1,255) ds_natureza_sped
FROM	ctb_grupo_conta b,
	conta_contabil a
where	a.cd_grupo	= b.cd_grupo;

