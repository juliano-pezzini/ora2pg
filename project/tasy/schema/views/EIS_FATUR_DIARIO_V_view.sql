-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_fatur_diario_v (dt_referencia, cd_estabelecimento, dt_atualizacao, nm_usuario, cd_convenio, cd_setor_atendimento, ie_tipo_atendimento, vl_prov_sem_alta, vl_prov_com_alta, vl_conta_def, vl_prot_prov, vl_prot_def, dt_atualizacao_nrec, nm_usuario_nrec, vl_total, dt_referencia_mensal, ds_convenio, ds_setor_atendimento, ds_tipo_atendimento) AS select	a.DT_REFERENCIA,a.CD_ESTABELECIMENTO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.CD_CONVENIO,a.CD_SETOR_ATENDIMENTO,a.IE_TIPO_ATENDIMENTO,a.VL_PROV_SEM_ALTA,a.VL_PROV_COM_ALTA,a.VL_CONTA_DEF,a.VL_PROT_PROV,a.VL_PROT_DEF,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,
	(VL_PROV_SEM_ALTA+VL_PROV_COM_ALTA+VL_CONTA_DEF+VL_PROT_PROV+VL_PROT_DEF) vl_total,
	trunc(a.dt_referencia, 'Month') dt_referencia_mensal,
	substr(obter_nome_convenio(a.cd_convenio),1,200) ds_convenio,
	substr(obter_nome_setor(a.cd_setor_atendimento),1,200) ds_setor_atendimento,
	substr(obter_valor_dominio(12, a.ie_tipo_atendimento),1,200) ds_tipo_atendimento
FROM	eis_fatur_diario a;

