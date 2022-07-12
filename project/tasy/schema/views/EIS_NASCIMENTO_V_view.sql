-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_nascimento_v (dt_nascimento, dt_atualizacao, nm_usuario, cd_medico, cd_pediatra, cd_convenio, ie_tipo_parto, ie_sexo, qt_nasc_vivo, qt_nasc_morto, qt_gemelar, cd_municipio_ibge, cd_estabelecimento, ie_tipo_nascimento, qt_total, cd_procedencia, ie_tipo_atendimento, qt_sem_ig, ie_faixa_etaria, qt_morte_materna, qt_sem_ig_cronologica, cd_setor_atendimento, ie_risco_gravidez, ie_acompanhante, ie_parto_normal, ie_parto_episio, ie_parto_cesaria, ie_infeccao, qt_peso_sala_parto, dt_obito, qt_alta, qt_peso, qt_gestacoes_previas, qt_apgar_prim_min, qt_apgar_5_min, cd_pessoa_fisica, nm_medico, nm_pediatra, ds_convenio, ds_tipo_parto, ds_municipio_ibge, ds_procedencia, ds_peso, ds_gestacao, ds_peso_agrupado, nm_acompanhante, sexo, tipo_nascimento, nm_setor_atendimento, nm_pessoa_fisica, risco_gravidez) AS select	a.DT_NASCIMENTO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.CD_MEDICO,a.CD_PEDIATRA,a.CD_CONVENIO,a.IE_TIPO_PARTO,a.IE_SEXO,a.QT_NASC_VIVO,a.QT_NASC_MORTO,a.QT_GEMELAR,a.CD_MUNICIPIO_IBGE,a.CD_ESTABELECIMENTO,a.IE_TIPO_NASCIMENTO,a.QT_TOTAL,a.CD_PROCEDENCIA,a.IE_TIPO_ATENDIMENTO,a.QT_SEM_IG,a.IE_FAIXA_ETARIA,a.QT_MORTE_MATERNA,a.QT_SEM_IG_CRONOLOGICA,a.CD_SETOR_ATENDIMENTO,a.IE_RISCO_GRAVIDEZ,a.IE_ACOMPANHANTE,a.IE_PARTO_NORMAL,a.IE_PARTO_EPISIO,a.IE_PARTO_CESARIA,a.IE_INFECCAO,a.QT_PESO_SALA_PARTO,a.DT_OBITO,a.QT_ALTA,a.QT_PESO,a.QT_GESTACOES_PREVIAS,a.QT_APGAR_PRIM_MIN,a.QT_APGAR_5_MIN,a.CD_PESSOA_FISICA,
	substr(obter_nome_pessoa_fisica(a.cd_medico, null),1,80) nm_medico, 
	substr(obter_nome_pessoa_fisica(a.cd_pediatra, null),1,80) nm_pediatra, 
	substr(obter_nome_convenio(a.cd_convenio),1,255) ds_convenio, 
	substr(obter_valor_dominio(16, a.ie_tipo_parto),1,255) ds_tipo_parto, 
	substr(obter_desc_municipio_ibge(a.cd_municipio_ibge),1,255) ds_municipio_ibge, 
	substr(obter_desc_procedencia(a.cd_procedencia),1,255) ds_procedencia, 
	substr(Eis_Obter_Desc_Peso_RN(QT_PESO_SALA_PARTO),1,50) ds_peso, 
	substr(obter_desc_gestacoes_previas(qt_gestacoes_previas),1,50) ds_gestacao, 
	substr(eis_nascimento_faixa_peso(QT_PESO_SALA_PARTO),1,50) ds_peso_agrupado, 
	substr(obter_valor_dominio(6, coalesce(a.IE_ACOMPANHANTE,'N')),1,254) nm_acompanhante, 
	substr(obter_valor_dominio(4, a.IE_SEXO),1,254) sexo, 
	substr(obter_valor_dominio(1122, a.IE_TIPO_NASCIMENTO),1,254) tipo_nascimento, 
	substr(obter_nome_setor(a.CD_SETOR_ATENDIMENTO),1,255) nm_setor_atendimento, 
	substr(obter_nome_pf(a.CD_PESSOA_FISICA),1,255) nm_pessoa_fisica, 
	coalesce(substr(obter_valor_dominio(3456, IE_RISCO_GRAVIDEZ),1,254),'Não informado') risco_gravidez 
FROM	eis_nascimento a;
