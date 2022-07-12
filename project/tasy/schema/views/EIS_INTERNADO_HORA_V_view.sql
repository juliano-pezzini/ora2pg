-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_internado_hora_v (nr_sequencia, cd_estabelecimento, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, nr_atendimento, cd_pessoa_fisica, cd_procedencia, ie_tipo_atendimento, cd_medico_resp, cd_motivo_alta, ie_clinica, nr_seq_classificacao, cd_setor_atendimento, cd_convenio, cd_categoria, cd_religiao, dt_referencia, hr_internado, ds_convenio, ds_setor_atendimento, ds_tipo_atendimento, nm_medico, ds_estabelecimento, ds_procedencia, ds_motivo_alta, ds_religiao, ds_categoria_conv) AS select	a.NR_SEQUENCIA,a.CD_ESTABELECIMENTO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.NR_ATENDIMENTO,a.CD_PESSOA_FISICA,a.CD_PROCEDENCIA,a.IE_TIPO_ATENDIMENTO,a.CD_MEDICO_RESP,a.CD_MOTIVO_ALTA,a.IE_CLINICA,a.NR_SEQ_CLASSIFICACAO,a.CD_SETOR_ATENDIMENTO,a.CD_CONVENIO,a.CD_CATEGORIA,a.CD_RELIGIAO,a.DT_REFERENCIA,a.HR_INTERNADO,
	obter_nome_convenio(a.cd_convenio) ds_convenio, 
	obter_nome_setor(a.cd_setor_atendimento) ds_setor_atendimento, 
	obter_valor_dominio(12, a.ie_tipo_atendimento) ds_tipo_atendimento, 
	obter_nome_pf(a.cd_medico_resp) nm_medico, 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
	substr(obter_desc_procedencia(a.cd_procedencia),1,40) ds_procedencia, 
	substr(obter_desc_motivo_alta(a.cd_motivo_alta),1,80) ds_motivo_alta, 
	substr(obter_desc_religiao(a.cd_religiao),1,100) ds_religiao, 
	substr(obter_categoria_convenio(a.cd_convenio,a.cd_categoria),1,100) ds_categoria_conv 
FROM	eis_internado_hora a;
