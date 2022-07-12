-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_dialise_diabeticos_v (cd_estabelecimento, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, dt_referencia, nr_seq_unid_dialise, cd_cid_principal, qt_entrada_agudo, qt_entrada_cronico, cd_empresa, qt_obito_cronico_menos_90_dias, qt_obito_agudo, qt_obito_cronico_mais_90_dias, qt_saida_tx, qt_desistencia, qt_transferencia, qt_hd_hp, qt_alta_cronico, qt_alta_agudo, qt_agudos_fim_dia, qt_cronicos_fim_dia, qt_pac_transito, qt_sessoes_dialise, qt_acesso_adequado, qt_acesso_inadequado, qt_cateter_dl, qt_permcath, qt_protese, cd_pessoa_fisica, qt_acessos_realizados, qt_pressao_alta_pre, qt_pressao_alta_pos, qt_transfusoes, qt_culturas, qt_perdas_acessos, qt_perdas_dl, qt_perdas_permcath, qt_novos_cateter_dl, qt_novos_permcatch, qt_pirogenia, qt_internados, qt_pac_diabeticos, qt_cronicos_fim_mes_ant, qt_agudos_fim_mes_ant, qt_mes_atual, cd_cid_direta, qt_sessoes_dialise_agudo, qt_sessoes_dialise_cronico, nr_seq_dialisador, cd_convenio, qt_sessoes_dialise_dia, nr_seq_unid_dialise_atual, qt_hipertenso, cd_setor_atendimento, ds_unid_dialise, ds_cid_morte, nm_pessoa_fisica, nm_empresa, nm_estabelecimento, ds_setor_atendimento, ds_convenio) AS select	a.CD_ESTABELECIMENTO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.DT_REFERENCIA,a.NR_SEQ_UNID_DIALISE,a.CD_CID_PRINCIPAL,a.QT_ENTRADA_AGUDO,a.QT_ENTRADA_CRONICO,a.CD_EMPRESA,a.QT_OBITO_CRONICO_MENOS_90_DIAS,a.QT_OBITO_AGUDO,a.QT_OBITO_CRONICO_MAIS_90_DIAS,a.QT_SAIDA_TX,a.QT_DESISTENCIA,a.QT_TRANSFERENCIA,a.QT_HD_HP,a.QT_ALTA_CRONICO,a.QT_ALTA_AGUDO,a.QT_AGUDOS_FIM_DIA,a.QT_CRONICOS_FIM_DIA,a.QT_PAC_TRANSITO,a.QT_SESSOES_DIALISE,a.QT_ACESSO_ADEQUADO,a.QT_ACESSO_INADEQUADO,a.QT_CATETER_DL,a.QT_PERMCATH,a.QT_PROTESE,a.CD_PESSOA_FISICA,a.QT_ACESSOS_REALIZADOS,a.QT_PRESSAO_ALTA_PRE,a.QT_PRESSAO_ALTA_POS,a.QT_TRANSFUSOES,a.QT_CULTURAS,a.QT_PERDAS_ACESSOS,a.QT_PERDAS_DL,a.QT_PERDAS_PERMCATH,a.QT_NOVOS_CATETER_DL,a.QT_NOVOS_PERMCATCH,a.QT_PIROGENIA,a.QT_INTERNADOS,a.QT_PAC_DIABETICOS,a.QT_CRONICOS_FIM_MES_ANT,a.QT_AGUDOS_FIM_MES_ANT,a.QT_MES_ATUAL,a.CD_CID_DIRETA,a.QT_SESSOES_DIALISE_AGUDO,a.QT_SESSOES_DIALISE_CRONICO,a.NR_SEQ_DIALISADOR,a.CD_CONVENIO,a.QT_SESSOES_DIALISE_DIA,a.NR_SEQ_UNID_DIALISE_ATUAL,a.QT_HIPERTENSO,
	(select	d.cd_setor_atendimento 
	FROM	HD_DIALISE_DIALISADOR b, 
			hd_ponto_acesso c, 
			setor_atendimento d 
	where	a."NR_SEQ_DIALISADOR" = b.nr_sequencia 
	and		b.nr_seq_ponto_acesso = c.nr_sequencia 
	and		c.cd_setor_atendimento = d.cd_setor_atendimento) cd_setor_atendimento,	 
	substr(hd_obter_desc_unid_dialise(a.nr_seq_unid_dialise_atual),1,80) ds_unid_dialise, 
	substr(obter_desc_cid_doenca(a.cd_cid_direta),1,240) ds_cid_morte, 
	substr(obter_nome_pf(a.cd_pessoa_fisica),1,254) nm_pessoa_fisica, 
	substr(obter_nome_empresa(a.cd_empresa),1,80) nm_empresa, 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) nm_estabelecimento, 
	(select	d.ds_setor_atendimento 
	from	HD_DIALISE_DIALISADOR b, 
			hd_ponto_acesso c, 
			setor_atendimento d 
	where	a."NR_SEQ_DIALISADOR" = b.nr_sequencia 
	and		b.nr_seq_ponto_acesso = c.nr_sequencia 
	and		c.cd_setor_atendimento = d.cd_setor_atendimento) ds_setor_atendimento, 
	substr(OBTER_DESC_CONVENIO(a.cd_convenio),1,100) ds_convenio 
	from	eis_dialise a 
	where	a.qt_pac_diabeticos > 0;

