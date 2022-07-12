-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW view_mobile_medical_guide (nr_registro, ds_email, nr_sequencia, dt_atualizacao, nm_usuario, nr_seq_prestador, cd_medico, cd_municipio_ibge, ds_website, cd_cgc_prestador, cd_pf_prestador, cd_procedimento, ie_origem_proced, nr_crm, ds_endereco, nr_telefone_prest, ds_especialidades_med, nr_ramal, cd_cep, nr_endereco, ds_complemento, ds_bairro, cd_estabelecimento, cd_prestador, sg_estado, nr_ddd, nr_telefone, ds_fone_adic, nr_ddd_fax, ds_fax, ds_tipo_prestador, ie_ausente, ie_historico_guia_medico, ds_area_atuacao_med, ie_apalc, ie_adicq, ie_aona, ie_acba, ie_aiqg, ie_notivisa, ie_pos_grad_360, ie_residencia, ie_especialista, ie_qualiss, ds_classificacao, nm_prestador, nm_medico, ds_especialidade_grid, nm_municipio_ibge, nm_fantasia, ds_procedimento, ds_tipo_guia_prest, ds_tipo_guia_prest_grid, ds_exibe_portal, ds_nivel_acred, ds_inst_acred, ds_tipo_prestador_f, ie_odontologico) AS select row_number() OVER (ORDER BY pls_obter_dados_prestador(nr_seq_prestador, 'NGM')) nr_registro,
     a.DS_EMAIL,a.NR_SEQUENCIA,a.DT_ATUALIZACAO,a.NM_USUARIO,a.NR_SEQ_PRESTADOR,a.CD_MEDICO,a.CD_MUNICIPIO_IBGE,a.DS_WEBSITE,a.CD_CGC_PRESTADOR,a.CD_PF_PRESTADOR,a.CD_PROCEDIMENTO,a.IE_ORIGEM_PROCED,a.NR_CRM,a.DS_ENDERECO,a.NR_TELEFONE_PREST,a.DS_ESPECIALIDADES_MED,a.NR_RAMAL,a.CD_CEP,a.NR_ENDERECO,a.DS_COMPLEMENTO,a.DS_BAIRRO,a.CD_ESTABELECIMENTO,a.CD_PRESTADOR,a.SG_ESTADO,a.NR_DDD,a.NR_TELEFONE,a.DS_FONE_ADIC,a.NR_DDD_FAX,a.DS_FAX,a.DS_TIPO_PRESTADOR,a.IE_AUSENTE,a.IE_HISTORICO_GUIA_MEDICO,a.DS_AREA_ATUACAO_MED,a.IE_APALC,a.IE_ADICQ,a.IE_AONA,a.IE_ACBA,a.IE_AIQG,a.IE_NOTIVISA,a.IE_POS_GRAD_360,a.IE_RESIDENCIA,a.IE_ESPECIALISTA,a.IE_QUALISS, 
     substr(pls_obter_dados_prestador(nr_seq_prestador, 'CLA'),1,255) DS_CLASSIFICACAO , 
     substr(pls_obter_dados_prestador(nr_seq_prestador, 'NGM'),1,80) NM_PRESTADOR , 
     substr(obter_nome_pf(cd_medico),1,255) NM_MEDICO , 
     substr(DS_ESPECIALIDADES_MED,1,255) DS_ESPECIALIDADE_GRID , 
     substr(obter_desc_municipio_ibge_guia(cd_municipio_ibge),1,255) NM_MUNICIPIO_IBGE , 
     substr(obter_dados_pf_pj(null, cd_cgc_prestador, 'F'),1,255) NM_FANTASIA , 
     substr(Obter_Descricao_Procedimento(cd_procedimento,ie_origem_proced),1,255) DS_PROCEDIMENTO , 
     substr(pls_obter_desc_tipo_guia_prest(nr_seq_prestador), 1, 2000) DS_TIPO_GUIA_PREST , 
     substr(pls_obter_desc_tipo_guia_prest(nr_seq_prestador), 1, 255) DS_TIPO_GUIA_PREST_GRID , 
     CASE WHEN substr(pls_obter_se_tp_guia_med_exibe(nr_seq_prestador), 1, 1)='S' THEN  'Sim'  ELSE 'Não' END  DS_EXIBE_PORTAL , 
     substr(pls_obter_dados_prestador(nr_seq_prestador, 'NA'),1,80) DS_NIVEL_ACRED , 
     substr(pls_obter_dados_prestador(nr_seq_prestador, 'IA'),1,80) DS_INST_ACRED , 
     substr(ds_tipo_prestador,1,255) DS_TIPO_PRESTADOR_F , 
     substr(pls_obter_dados_prest_odont(nr_seq_prestador,'PO'),1,1) IE_ODONTOLOGICO 
 FROM W_PLS_GUIA_MEDICO a;

