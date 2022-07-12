-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW sus_aih_unif_winsaude_v (ds_registro, tp_registro, nr_seq_protocolo, qt_aih_lote, nr_lote, nr_seq_laudo, qt_aih_protocolo, dt_mesano_apres, nr_seq_aih_prot, cd_orgao_emissor_aih, cd_cnes_hospital, cd_mun_ibge_hosp, nr_aih, ie_identificacao_aih, ie_especialidade_aih, ds_filler_aih11, ie_mod_atendimento, nr_seq_aih, nr_proxima_aih, nr_anterior_aih, nr_seq_conta, dt_emissao, dt_internacao, dt_saida, cd_procedimento_solic, ie_mudanca_proc, cd_procedimento_real, ie_carater_inter_sus, ie_motivo_saida, ie_doc_medico_solic, cd_doc_medico_solic, ie_doc_medico_resp, cd_doc_medico_resp, ie_doc_diretor_cli, cd_doc_diretor_cli, ie_doc_medico_aut, cd_doc_medico_aut, cd_cid_principal, cd_cid_secundario, cd_cid_causa_compl, cd_cid_causa_morte, cd_solic_liberacao, nm_paciente, dt_nascimento, ie_sexo, nr_seq_cor_pele, nm_mae, nm_responsavel, ie_doc_paciente, nr_doc_paciente, nr_cns, cd_nacionalidade, tp_logradouro, ds_logradouro, nr_logradouro, ds_compl_logradouro, ds_bairro, cd_municipio_ibge, sg_estado, cd_cep, nr_prontuario, nr_enfermaria, nr_leito, ds_registro_proc, ie_saida_utineo, qt_peso_utineo, qt_mes_gestacao, cd_cgc_empregador, cd_cbor, cd_cnaer, ie_vinculo_prev, qt_nascido_vivo, qt_nascido_morto, qt_saida_alta, qt_saida_transferencia, qt_saida_obito, ds_filler_aih90, qt_filho, ie_grau_instrucao, cd_cid_indicacao, ie_metodo_contracep_um, ie_metodo_contracep_dois, ie_alto_risco, ie_datasus_aih89, nr_gestante_prenatal, cd_cid_associado, ds_filler_aih44, ds_filler_aih82) AS select	'AIH' ds_registro,
	1 tp_registro, 
	a.nr_seq_lote nr_seq_protocolo, 
	sus_obter_qtd_laudo_lote(a.nr_seq_lote) qt_aih_lote, 
	a.nr_seq_lote nr_lote, 
	a.nr_seq_interno nr_seq_laudo, 
	' ' qt_aih_protocolo, 
	trunc(a.dt_emissao,'mm') dt_mesano_apres, 
	' ' nr_seq_aih_prot, 
	Sus_obter_orgao_emissor_aih(a.nr_atendimento) cd_orgao_emissor_aih, 
	sus_Obter_cnes_estab_unif(c.cd_estabelecimento,'A') cd_cnes_hospital, 
	sus_obter_mun_estab_aih(c.cd_estabelecimento,'C') cd_mun_ibge_hosp, 
	0 nr_aih, 
	'01' ie_identificacao_aih, 
	sus_obter_especialidade_aih(a.cd_procedimento_solic,a.ie_origem_proced,c.cd_pessoa_fisica,b.cd_estabelecimento) ie_especialidade_aih, 
	0 ds_filler_aih11, 
	Sus_Obter_Modalidade_Proc(a.cd_procedimento_solic,a.ie_origem_proced) ie_mod_atendimento, 
	0 nr_seq_aih, 
	0 nr_proxima_aih, 
	0 nr_anterior_aih, 
	a.nr_seq_interno nr_seq_conta, 
	a.dt_emissao, 
	c.dt_entrada dt_internacao, 
	c.dt_alta dt_saida, 
	a.cd_procedimento_solic, 
	2 ie_mudanca_proc, 
	a.cd_procedimento_solic cd_procedimento_real, 
	sus_obter_carater_inter_atend(a.nr_atendimento) ie_carater_inter_sus, 
	Obter_Motivo_Alta_sus(a.nr_atendimento) ie_motivo_saida, 
	CASE WHEN obter_dados_pf(a.cd_medico_requisitante,'CPF')='' THEN CASE WHEN obter_dados_pf(a.cd_medico_requisitante,'CNS')='' THEN null  ELSE 2 END   ELSE 1 END  ie_doc_medico_solic, 
	CASE WHEN substr(obter_dados_pf(a.cd_medico_requisitante,'CPF'),1,11)='' THEN substr(obter_dados_pf(a.cd_medico_requisitante,'CNS'),1,15)  ELSE substr(obter_dados_pf(a.cd_medico_requisitante,'CPF'),1,11) END  cd_doc_medico_solic, 
	CASE WHEN obter_dados_pf(a.cd_medico_responsavel,'CPF')='' THEN CASE WHEN obter_dados_pf(a.cd_medico_responsavel,'CNS')='' THEN null  ELSE 2 END   ELSE 1 END  ie_doc_medico_resp, 
	CASE WHEN substr(obter_dados_pf(a.cd_medico_responsavel,'CPF'),1,11)='' THEN substr(obter_dados_pf(a.cd_medico_responsavel,'CNS'),1,15)  ELSE substr(obter_dados_pf(a.cd_medico_responsavel,'CPF'),1,11) END  cd_doc_medico_resp, 
	CASE WHEN obter_dados_pf(sus_obter_dados_param_aih(c.cd_estabelecimento,'DC'),'CPF')='' THEN  	CASE WHEN obter_dados_pf(sus_obter_dados_param_aih(c.cd_estabelecimento,'DC'),'CNS')='' THEN null  ELSE 2 END   ELSE 1 END  ie_doc_diretor_cli, 
	CASE WHEN substr(obter_dados_pf(sus_obter_dados_param_aih(c.cd_estabelecimento,'DC'),'CPF'),1,11)='' THEN  	substr(obter_dados_pf(sus_obter_dados_param_aih(c.cd_estabelecimento,'DC'),'CNS'),1,15)  ELSE substr(obter_dados_pf(sus_obter_dados_param_aih(c.cd_estabelecimento,'DC'),'CPF'),1,11) END  cd_doc_diretor_cli, 
	CASE WHEN obter_dados_pf(sus_obter_dados_param_aih(c.cd_estabelecimento,'MA'),'CPF')='' THEN  	CASE WHEN obter_dados_pf(sus_obter_dados_param_aih(c.cd_estabelecimento,'MA'),'CNS')='' THEN null  ELSE 2 END   ELSE 1 END  ie_doc_medico_aut, 
	CASE WHEN substr(obter_dados_pf(sus_obter_dados_param_aih(c.cd_estabelecimento,'MA'),'CPF'),1,11)='' THEN  	substr(obter_dados_pf(sus_obter_dados_param_aih(c.cd_estabelecimento,'MA'),'CNS'),1,15)  ELSE substr(obter_dados_pf(sus_obter_dados_param_aih(c.cd_estabelecimento,'MA'),'CPF'),1,11) END  cd_doc_medico_aut, 
	a.cd_cid_principal, 
	a.cd_cid_secundario, 
	a.cd_cid_causa_assoc cd_cid_causa_compl, 
	' ' cd_cid_causa_morte, 
	' ' cd_solic_liberacao, 
	lpad(replace(elimina_acentos(upper(obter_nome_pf(c.cd_pessoa_fisica))),'Ç','C'),70,' ') nm_paciente, 
	obter_dados_pf(c.cd_pessoa_fisica,'DN') dt_nascimento, 
	obter_dados_pf(c.cd_pessoa_fisica,'SE') ie_sexo, 
	Sus_Obter_Cor_Pele(c.cd_pessoa_fisica, 'C') nr_seq_cor_pele, 
	lpad(replace(elimina_acentos(upper(substr(obter_compl_pf(c.cd_pessoa_fisica, 5, 'N'),1,70))),'Ç','C'),70,' ') nm_mae, 
	lpad(replace(elimina_acentos(upper(substr(coalesce(obter_compl_pf(c.cd_pessoa_fisica, 3, 'N'),obter_nome_pf(c.cd_pessoa_fisica)),1,70))),'Ç','C'),70,' ') nm_responsavel, 
	sus_obter_doc_pf(c.cd_pessoa_fisica,'I') ie_doc_paciente, 
	sus_obter_doc_pf(c.cd_pessoa_fisica,'D') nr_doc_paciente, 
	substr(obter_dados_pf(c.cd_pessoa_fisica,'CNS'),1,15) nr_cns, 
	substr(obter_dados_pf(c.cd_pessoa_fisica,'NC'),1,15) cd_nacionalidade, 
	substr(obter_compl_pf(c.cd_pessoa_fisica,1,'TLS'),1,3) tp_logradouro, 
	lpad(substr(replace(upper(substr(obter_compl_pf(c.cd_pessoa_fisica,1,'EN'),1,50)), 
	upper(sus_obter_desc_tipo_logr(lpad(substr(elimina_acentos(obter_compl_pf(c.cd_pessoa_fisica,1,'TLS')),1,3),3,'0')))||' ',''),1,50),50,' ') ds_logradouro, 
	lpad(obter_compl_pf(c.cd_pessoa_fisica,1,'NR'),7,' ') nr_logradouro, 
	lpad(substr(elimina_acentos(obter_compl_pf(c.cd_pessoa_fisica,1,'CO')),1,15),15,' ') ds_compl_logradouro, 
	lpad(substr(elimina_acentos(obter_compl_pf(c.cd_pessoa_fisica,1,'B')),1,30),30,' ') ds_bairro, 
	substr(obter_compl_pf(c.cd_pessoa_fisica,1,'CDM'),1,6) cd_municipio_ibge, 
	substr(obter_compl_pf(c.cd_pessoa_fisica,1,'UF'),1,2) sg_estado, 
	substr(obter_compl_pf(c.cd_pessoa_fisica,1,'CEP'),1,15) cd_cep, 
	Obter_Prontuario_Paciente(c.cd_pessoa_fisica) nr_prontuario, 
	'0000' nr_enfermaria, 
	'0000' nr_leito, 
	0 ds_registro_proc, 
	0 ie_saida_utineo, 
	0 qt_peso_utineo, 
	0 qt_mes_gestacao, 
	0 cd_cgc_empregador, 
	0 cd_cbor, 
	0 cd_cnaer, 
	0 ie_vinculo_prev, 
	0 qt_nascido_vivo, 
	0 qt_nascido_morto, 
	0 qt_saida_alta, 
	0 qt_saida_transferencia, 
	0 qt_saida_obito, 
	0 ds_filler_aih90, 
	0 qt_filho, 
	CASE WHEN obter_dados_pf(c.cd_pessoa_fisica,'GI')='1' THEN 1 WHEN obter_dados_pf(c.cd_pessoa_fisica,'GI')='10' THEN 1 WHEN obter_dados_pf(c.cd_pessoa_fisica,'GI')='11' THEN 1 WHEN obter_dados_pf(c.cd_pessoa_fisica,'GI')='2' THEN 2 WHEN obter_dados_pf(c.cd_pessoa_fisica,'GI')='7' THEN 2 WHEN obter_dados_pf(c.cd_pessoa_fisica,'GI')='3' THEN 3 WHEN obter_dados_pf(c.cd_pessoa_fisica,'GI')='8' THEN 3 WHEN obter_dados_pf(c.cd_pessoa_fisica,'GI')='4' THEN 4 WHEN obter_dados_pf(c.cd_pessoa_fisica,'GI')='5' THEN 4 WHEN obter_dados_pf(c.cd_pessoa_fisica,'GI')='6' THEN 4 WHEN obter_dados_pf(c.cd_pessoa_fisica,'GI')='9' THEN 4 END  ie_grau_instrucao, 
	'0000' cd_cid_indicacao, 
	0 ie_metodo_contracep_um, 
	0 ie_metodo_contracep_dois, 
	' ' ie_alto_risco, 
	0 ie_datasus_aih89, 
	c.nr_gestante_pre_natal nr_gestante_prenatal, 
	' ' cd_cid_associado, 
	0 ds_filler_aih44, 
	0 ds_filler_aih82 
FROM	sus_laudo_paciente	a, 
	sus_lote_autor		b, 
	atendimento_paciente 	c 
where  a.nr_seq_lote  	= b.nr_sequencia 
and	a.nr_atendimento	= c.nr_atendimento;
