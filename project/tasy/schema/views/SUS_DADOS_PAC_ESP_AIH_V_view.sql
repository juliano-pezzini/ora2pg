-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW sus_dados_pac_esp_aih_v (nr_seq_protocolo, nr_interno_conta, nr_aih, dt_emissao, nr_anterior_aih, nr_proxima_aih, ds_especialidade_aih, nr_cpf_med_resp, nr_cpf_med_solic, ds_carater_inter, cd_cid_principal, cd_cid_secundario, ie_classif_diag_seq, cd_cid_secundario2, ie_classif_diag_seq2, cd_cid_secundario3, ie_classif_diag_seq3, cd_cid_secundario4, ie_classif_diag_seq4, cd_cid_secundario5, ie_classif_diag_seq5, cd_cid_secundario6, ie_classif_diag_seq6, cd_cid_secundario7, ie_classif_diag_seq7, cd_cid_secundario8, ie_classif_diag_seq8, cd_cid_secundario9, ie_classif_diag_seq9, ds_modalidade, ie_mudanca_proc, cd_procedimento_solic, cd_procedimento_real, ds_procedimento_solic, ds_procedimento_real, cd_cnes_hospital, nm_paciente, nr_cpf_med_autoriza, nr_cpf_dir_clinico, cd_cep, ds_uf, nr_telefone, nr_cns, nm_mae, nr_cpf, nr_rg, ds_endereco, ds_bairro, nm_responsavel, dt_nascimento, cd_municipio_ibge, dt_entrada, dt_alta, cd_motivo_alta, nr_prontuario, ds_nacionalidade, ds_sexo, cd_cid_causa_morte, ie_identificacao_aih, nr_leito, nr_enfermaria, cd_orgao_emissor_aih, dt_apresentacao, nr_atendimento, ds_tipo_doc, nr_doc, ds_raca, ds_lib, cd_etnia, ds_etnia) AS select	cp.nr_seq_protocolo,
	a.nr_interno_conta,
	a.nr_aih,
	a.dt_emissao,	
	a.nr_anterior_aih, 
	a.nr_proxima_aih,
	lpad(a.cd_especialidade_aih,2,0)||' - '||substr(sus_obter_desc_espec(a.cd_especialidade_aih),1,100) ds_especialidade_aih,
	substr(obter_cgc_cpf_editado(obter_cpf_pessoa_fisica(a.cd_medico_responsavel)),1,100) nr_cpf_med_resp,
	substr(obter_cgc_cpf_editado(obter_cpf_pessoa_fisica(a.cd_medico_solic)),1,100) nr_cpf_med_solic,
	a.cd_carater_internacao||' - '||substr(sus_obter_desc_carater_int(a.cd_carater_internacao),1,100) ds_carater_inter,
	a.cd_cid_principal||'-'||obter_desc_cid(a.cd_cid_principal) cd_cid_principal,
	a.cd_cid_secundario||'-'||obter_desc_cid(a.cd_cid_secundario) cd_cid_secundario,
	a.ie_classif_diag_seq,
	a.cd_cid_secundario2,
	a.ie_classif_diag_seq2,
	a.cd_cid_secundario3,
	a.ie_classif_diag_seq3,
	a.cd_cid_secundario4,
	a.ie_classif_diag_seq4,
	a.cd_cid_secundario5,
	a.ie_classif_diag_seq5,
	a.cd_cid_secundario6,
	a.ie_classif_diag_seq6,
	a.cd_cid_secundario7,
	a.ie_classif_diag_seq7,
	a.cd_cid_secundario8,
	a.ie_classif_diag_seq8,
	a.cd_cid_secundario9,
	a.ie_classif_diag_seq9,
	substr(sus_obter_desc_modalidade(a.cd_modalidade),1,100) ds_modalidade,
	substr(obter_valor_dominio(6,a.ie_mudanca_proc),1,40) ie_mudanca_proc,
	sus_obter_procedimento_editado(a.cd_procedimento_solic) cd_procedimento_solic,
	sus_obter_procedimento_editado(a.cd_procedimento_real) cd_procedimento_real,
	substr(obter_descricao_procedimento(a.cd_procedimento_solic,a.ie_origem_proc_solic),1,100) ds_procedimento_solic,
	substr(obter_descricao_procedimento(a.cd_procedimento_real,a.ie_origem_proc_real),1,100) ds_procedimento_real,
	b.cd_cnes_hospital||' - '||p.ds_razao_social cd_cnes_hospital,
	substr(obter_nome_pf(e.cd_pessoa_fisica),1,200) nm_paciente,
	substr(obter_cgc_cpf_editado(sus_obter_autorizador_aih(cp.nr_interno_conta,'CPF')),1,50) nr_cpf_med_autoriza,
	substr(obter_cgc_cpf_editado(obter_cpf_pessoa_fisica(coalesce(b.cd_diretor_tecnico,b.cd_diretor_clinico))),1,100) nr_cpf_dir_clinico,
	cf.cd_cep, 
	cf.sg_estado ds_uf, 
	cf.nr_telefone, 
	substr(obter_dados_pf(e.cd_pessoa_fisica,'CNS'),1,100) nr_cns,
	substr(obter_compl_pf(e.cd_pessoa_fisica,5,'N'),1,100) nm_mae,
	substr(obter_cpf_pessoa_fisica(e.cd_pessoa_fisica),1,100) nr_cpf,
	cf.nr_identidade nr_rg,
	substr(cf.ds_endereco,1,100) || ' - '||coalesce(cf.nr_endereco, cf.ds_compl_end) ds_endereco,
	substr(cf.ds_bairro,1,100) ds_bairro, 
	substr(coalesce(obter_compl_pf(e.cd_pessoa_fisica,3,'N'),obter_nome_pf(e.cd_pessoa_fisica)),1,100) nm_responsavel,
	substr(obter_dados_pf(e.cd_pessoa_fisica, 'DN'),1,100) dt_nascimento,
	substr(cf.cd_municipio_ibge||' - '||cf.ds_municipio,1,100) cd_municipio_ibge,
	coalesce(a.dt_inicial,e.dt_entrada) dt_entrada,
	coalesce(a.dt_final,e.dt_alta) dt_alta,
	a.cd_motivo_cobranca||' - '||sus_obter_mot_cobranca_unif(a.cd_motivo_cobranca) cd_motivo_alta,
	substr(lpad(obter_prontuario_pf(c.cd_estabelecimento,e.cd_pessoa_fisica),15,'0'),1,100) nr_prontuario,
	substr(obter_compl_pf(e.cd_pessoa_fisica,1,'NA'),1,100) ds_nacionalidade,
	substr(obter_sexo_pf(e.cd_pessoa_fisica,'D'),1,100) ds_sexo,
	a.cd_cid_causa_morte,
	lpad(a.ie_identificacao_aih,2,0)||' - '|| substr(obter_valor_dominio(1861,a.ie_identificacao_aih),1,100) ie_identificacao_aih,
	substr(lpad(obter_unidade_atendimento(e.nr_atendimento,'A','UC'),4,'0'),1,100) nr_leito,
	substr(lpad(obter_unidade_atendimento(e.nr_atendimento,'A','UB'),4,'0'),1,100) nr_enfermaria,
	substr(Sus_obter_orgao_emissor_aih(e.nr_atendimento),1,200) cd_orgao_emissor_aih,
	to_char(add_months(to_date(obter_dados_protocolo(cp.nr_seq_protocolo,'DT'),'dd/mm/yyyy'),1),'mm/yyyy') dt_apresentacao,
	e.nr_atendimento,
	sus_obter_tipo_doc(e.cd_pessoa_fisica,'T') ds_tipo_doc,
	sus_obter_tipo_doc(e.cd_pessoa_fisica,'D') nr_doc,
	sus_obter_cor_pele(e.cd_pessoa_fisica,'D') ds_raca,
	substr(Obter_Valor_Dominio(1940,a.ie_codigo_autorizacao),1,100) ds_lib,
	sus_obter_etnia(e.cd_pessoa_fisica, 'C') cd_etnia,
	sus_obter_etnia(e.cd_pessoa_fisica, 'D') ds_etnia
FROM	estabelecimento c,
	compl_pessoa_fisica cf,
	sus_parametros_aih b,
	atendimento_paciente e,
	sus_aih_unif a,
	pessoa_juridica p,
	conta_paciente cp
where	cp.cd_estabelecimento = c.cd_estabelecimento
and	c.cd_cgc = p.cd_cgc
and	c.cd_estabelecimento = b.cd_estabelecimento
and	a.nr_atendimento = e.nr_atendimento
and	a.nr_interno_conta = cp.nr_interno_conta
and	e.cd_pessoa_fisica = cf.cd_pessoa_fisica
and	cf.ie_tipo_complemento = 1
and	trunc(coalesce(a.dt_inicial,e.dt_entrada)) < to_date('01/01/2012','dd/mm/yyyy')

union
 
select	cp.nr_seq_protocolo,
	a.nr_interno_conta,
	a.nr_aih, 
	a.dt_emissao,	
	a.nr_anterior_aih, 
	a.nr_proxima_aih,
	lpad(a.cd_especialidade_aih,2,0)||' - '||substr(sus_obter_desc_espec(a.cd_especialidade_aih),1,100) ds_especialidade_aih,
	substr(obter_dados_pf(a.cd_medico_responsavel,'CNS'),1,100) nr_cpf_med_resp,
	substr(obter_dados_pf(a.cd_medico_solic,'CNS'),1,100) nr_cpf_med_solic,
	a.cd_carater_internacao||' - '||substr(sus_obter_desc_carater_int(a.cd_carater_internacao),1,100) ds_carater_inter,
	a.cd_cid_principal||'-'||obter_desc_cid(a.cd_cid_principal) cd_cid_principal,
	a.cd_cid_secundario||'-'||obter_desc_cid(a.cd_cid_secundario) cd_cid_secundario,
	a.ie_classif_diag_seq,
	a.cd_cid_secundario2,
	a.ie_classif_diag_seq2,
	a.cd_cid_secundario3,
	a.ie_classif_diag_seq3,
	a.cd_cid_secundario4,
	a.ie_classif_diag_seq4,
	a.cd_cid_secundario5,
	a.ie_classif_diag_seq5,
	a.cd_cid_secundario6,
	a.ie_classif_diag_seq6,
	a.cd_cid_secundario7,
	a.ie_classif_diag_seq7,
	a.cd_cid_secundario8,
	a.ie_classif_diag_seq8,
	a.cd_cid_secundario9,
	a.ie_classif_diag_seq9,
	substr(sus_obter_desc_modalidade(a.cd_modalidade),1,100) ds_modalidade,
	substr(obter_valor_dominio(6,a.ie_mudanca_proc),1,40) ie_mudanca_proc,
	sus_obter_procedimento_editado(a.cd_procedimento_solic) cd_procedimento_solic,
	sus_obter_procedimento_editado(a.cd_procedimento_real) cd_procedimento_real,
	substr(obter_descricao_procedimento(a.cd_procedimento_solic,a.ie_origem_proc_solic),1,100) ds_procedimento_solic,
	substr(obter_descricao_procedimento(a.cd_procedimento_real,a.ie_origem_proc_real),1,100) ds_procedimento_real,
	b.cd_cnes_hospital||' - '||p.ds_razao_social cd_cnes_hospital,
	substr(obter_nome_pf(e.cd_pessoa_fisica),1,200) nm_paciente,
	substr(obter_dados_pf(a.cd_medico_autorizador,'CNS'),1,50) nr_cpf_med_autoriza,
	substr(obter_cgc_cpf_editado(obter_cpf_pessoa_fisica(coalesce(b.cd_diretor_tecnico,b.cd_diretor_clinico))),1,100) nr_cpf_dir_clinico,
	cf.cd_cep, 
	cf.sg_estado ds_uf, 
	cf.nr_telefone, 
	substr(obter_dados_pf(e.cd_pessoa_fisica,'CNS'),1,100) nr_cns,
	substr(obter_compl_pf(e.cd_pessoa_fisica,5,'N'),1,100) nm_mae,
	substr(obter_cpf_pessoa_fisica(e.cd_pessoa_fisica),1,100) nr_cpf,
	cf.nr_identidade nr_rg,
	substr(cf.ds_endereco,1,100) || ' - '||coalesce(cf.nr_endereco, cf.ds_compl_end) ds_endereco,
	substr(cf.ds_bairro,1,100) ds_bairro, 
	substr(coalesce(obter_compl_pf(e.cd_pessoa_fisica,3,'N'),obter_nome_pf(e.cd_pessoa_fisica)),1,100) nm_responsavel,
	substr(obter_dados_pf(e.cd_pessoa_fisica, 'DN'),1,100) dt_nascimento,
	substr(cf.cd_municipio_ibge||' - '||cf.ds_municipio,1,100) cd_municipio_ibge,
	coalesce(a.dt_inicial,e.dt_entrada) dt_entrada,
	coalesce(a.dt_final,e.dt_alta) dt_alta,
	a.cd_motivo_cobranca||' - '||sus_obter_mot_cobranca_unif(a.cd_motivo_cobranca) cd_motivo_alta,
	substr(lpad(obter_prontuario_pf(c.cd_estabelecimento,e.cd_pessoa_fisica),15,'0'),1,100) nr_prontuario,
	substr(obter_compl_pf(e.cd_pessoa_fisica,1,'NA'),1,100) ds_nacionalidade,
	substr(obter_sexo_pf(e.cd_pessoa_fisica,'D'),1,100) ds_sexo,
	a.cd_cid_causa_morte,
	lpad(a.ie_identificacao_aih,2,0)||' - '|| substr(obter_valor_dominio(1861,a.ie_identificacao_aih),1,100) ie_identificacao_aih,
	substr(lpad(obter_unidade_atendimento(e.nr_atendimento,'A','UC'),4,'0'),1,100) nr_leito,
	substr(lpad(obter_unidade_atendimento(e.nr_atendimento,'A','UB'),4,'0'),1,100) nr_enfermaria,
	substr(Sus_obter_orgao_emissor_aih(e.nr_atendimento),1,200) cd_orgao_emissor_aih,
	to_char(add_months(to_date(obter_dados_protocolo(cp.nr_seq_protocolo,'DT'),'dd/mm/yyyy'),1),'mm/yyyy') dt_apresentacao,
	e.nr_atendimento,
	sus_obter_tipo_doc(e.cd_pessoa_fisica,'T') ds_tipo_doc,
	sus_obter_tipo_doc(e.cd_pessoa_fisica,'D') nr_doc,
	sus_obter_cor_pele(e.cd_pessoa_fisica,'D') ds_raca,
	substr(Obter_Valor_Dominio(1940,a.ie_codigo_autorizacao),1,100) ds_lib,
	sus_obter_etnia(e.cd_pessoa_fisica, 'C') cd_etnia,
	sus_obter_etnia(e.cd_pessoa_fisica, 'D') ds_etnia
from	estabelecimento c,
	compl_pessoa_fisica cf,
	sus_parametros_aih b,
	atendimento_paciente e,
	sus_aih_unif a,
	pessoa_juridica p,
	conta_paciente cp
where	cp.cd_estabelecimento = c.cd_estabelecimento
and	c.cd_cgc = p.cd_cgc
and	c.cd_estabelecimento = b.cd_estabelecimento
and	a.nr_atendimento = e.nr_atendimento
and	a.nr_interno_conta = cp.nr_interno_conta
and	e.cd_pessoa_fisica = cf.cd_pessoa_fisica
and	cf.ie_tipo_complemento = 1
and	trunc(coalesce(a.dt_inicial,e.dt_entrada)) >= to_date('01/01/2012','dd/mm/yyyy');
