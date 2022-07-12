-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW sus_aih_unificado_coord_v (ds_registro, tp_registro, nr_seq_protocolo, qt_aih_lote, nr_seq_lote, qt_aih_protocolo, dt_mesano_apres, nr_seq_aih_prot, cd_orgao_emissor_aih, cd_cnes_hospital, cd_mun_ibge_hosp, nr_aih, ie_identificacao_aih, ie_especialidade_aih, ie_mod_atendimento, nr_seq_aih, nr_proxima_aih, nr_anterior_aih, nr_seq_conta, dt_emissao, dt_internacao, dt_saida, cd_procedimento_solic, ie_mudanca_proc, cd_procedimento_real, ie_carater_inter_sus, ie_motivo_saida, ie_doc_medico_solic, cd_doc_medico_solic, ie_doc_medico_resp, cd_doc_medico_resp, ie_doc_diretor_cli, cd_doc_diretor_cli, ie_doc_medico_aut, cd_doc_medico_aut, cd_cid_principal, cd_cid_secundario, cd_cid_causa_compl, cd_cid_causa_morte, cd_solic_liberacao, nm_paciente, dt_nascimento, ie_sexo, nm_mae, nm_responsavel, ie_doc_paciente, nr_doc_paciente, nr_cns, cd_nacionalidade, tp_logradouro, ds_logradouro, nr_logradouro, ds_compl_logradouro, ds_bairro, cd_municipio_ibge, sg_estado, cd_cep, nr_prontuario, nr_enfermaria, nr_leito, ds_registro_proc, ie_saida_utineo, qt_peso_utineo, qt_mes_gestacao, cd_cgc_empregador, cd_cbor, cd_cnaer, ie_vinculo_prev, qt_nascido_vivo, qt_nascido_morto, qt_saida_alta, qt_saida_transferencia, qt_saida_obito, nr_gestante_prenatal, qt_filho, ie_grau_instrucao, cd_cid_indicacao, cd_cid_associado, ie_metodo_contracep_um, ie_metodo_contracep_dois, ie_alto_risco, nr_seq_cor_pele, cd_etnia, nr_telefone_pac, ds_filler_aih11, ie_datasus_aih89, ds_filler_aih82, ds_filler_aih90, ds_filler_aih45, ds_registro_civil, ds_filler_civil21, ds_registro_opm, ds_filler_opm21, ie_ordem, dt_inicial, dt_final) AS select	'AIH' ds_registro,
	1 tp_registro,
	a.nr_seq_protocolo,
	a.qt_aih_lote,
	a.nr_seq_lote,
	a.qt_aih_protocolo,
	a.dt_mesano_apres,
	a.nr_seq_aih_prot,
	a.cd_orgao_emissor_aih,
	a.cd_cnes_hospital,
	a.cd_mun_ibge_hosp,
	a.nr_aih,
	b.ie_identificacao_aih,
	a.ie_especialidade_aih,
	b.cd_modalidade ie_mod_atendimento,
	b.nr_seq_aih,
	b.nr_proxima_aih,
	b.nr_anterior_aih,
	b.nr_sequencia nr_seq_conta,
	b.dt_emissao,
	b.dt_internacao,
	b.dt_saida,
	b.cd_procedimento_solic,
	b.ie_mudanca_proc,
	b.cd_procedimento_real,
	b.ie_carater_inter_sus,
	b.ie_motivo_saida,
	b.ie_doc_medico_solic,
	CASE WHEN b.ie_doc_medico_solic=1 THEN b.nr_cpf_medico_solic  ELSE cd_cns_medico_solic END  cd_doc_medico_solic,
	b.ie_doc_medico_resp,
	CASE WHEN b.ie_doc_medico_resp=1 THEN b.nr_cpf_medico_resp  ELSE cd_cns_medico_resp END  cd_doc_medico_resp,
	b.ie_doc_diretor_cli,
	coalesce(b.nr_cpf_diretor_cli, cd_cns_diretor_cli) cd_doc_diretor_cli,
	b.ie_doc_medico_aut,
	CASE WHEN b.ie_doc_medico_aut=1 THEN b.nr_cpf_medico_aut  ELSE cd_cns_medico_aut END  cd_doc_medico_aut,
	b.cd_cid_principal,
	b.cd_cid_secundario,
	b.cd_cid_causa_compl,
	b.cd_cid_causa_morte,
	b.cd_solic_liberacao,
	b.nm_paciente,
	b.dt_nascimento,
	b.ie_sexo,
	b.nm_mae,
	b.nm_responsavel,
	b.ie_doc_paciente,
	b.nr_doc_paciente,
	b.nr_cns,
	b.cd_nacionalidade,
	b.tp_logradouro,
	substr(replace(upper(b.ds_logradouro),upper(sus_obter_desc_tipo_logr(lpad(b.tp_logradouro,3,'0')))||' ',''),1,50) ds_logradouro,
	b.nr_logradouro,
	b.ds_compl_logradouro,
	b.ds_bairro,
	b.cd_municipio_ibge,
	b.sg_estado,
	b.cd_cep,
	b.nr_prontuario,
	b.nr_enfermaria,
	b.nr_leito,
	b.ds_registro_proc,
	b.ie_saida_utineo,
	b.qt_peso_utineo,
	b.qt_mes_gestacao,
	b.cd_cgc_empregador,
	b.cd_cbor,
	b.cd_cnaer,
	b.ie_vinculo_prev,
	b.qt_nascido_vivo,
	b.qt_nascido_morto,
	b.qt_saida_alta,
	b.qt_saida_transferencia,
	b.qt_saida_obito,
	b.nr_gestante_prenatal,
	b.qt_filho,
	b.ie_grau_instrucao,
	b.cd_cid_indicacao,
	b.cd_cid_associado,
	b.ie_metodo_contracep_um,
	b.ie_metodo_contracep_dois,
	b.ie_alto_risco,
	b.nr_seq_cor_pele,
	b.cd_etnia,
	b.nr_telefone_pac,
	0 ds_filler_aih11,
	0 ie_datasus_aih89,
	0 ds_filler_aih82,
	0 ds_filler_aih90,
	0 ds_filler_aih45,
	'' ds_registro_civil,
	0 ds_filler_civil21,
	'' ds_registro_opm,
	0 ds_filler_opm21,
	sus_obter_ordem_ident_aih(b.ie_identificacao_aih) ie_ordem,
	c.dt_inicial,
	c.dt_final
FROM	w_susaih_interf_cab_coord	c,
	w_susaih_interf_conta		b,
	w_susaih_interf_cab		a
where	a.nr_interno_conta	= b.nr_interno_conta
and	a.nr_interno_conta	= c.nr_interno_conta

union

select	'REGISTRO CIVIL' ds_registro,
	2 tp_registro,
	a.nr_seq_protocolo,
	a.qt_aih_lote,
	a.nr_seq_lote,
	a.qt_aih_protocolo,
	a.dt_mesano_apres,
	a.nr_seq_aih_prot,
	a.cd_orgao_emissor_aih,
	a.cd_cnes_hospital,
	a.cd_mun_ibge_hosp,
	a.nr_aih,
	'04' ie_identificacao_aih,
	a.ie_especialidade_aih,
	0 ie_mod_atendimento,
	0 nr_seq_aih,
	0 nr_proxima_aih,
	0 nr_anterior_aih,
	0 nr_seq_conta,
	LOCALTIMESTAMP dt_emissao,
	LOCALTIMESTAMP dt_internacao,
	LOCALTIMESTAMP dt_saida,
	0 cd_procedimento_solic,
	0 ie_mudanca_proc,
	0 cd_procedimento_real,
	'' ie_carater_inter_sus,
	'' ie_motivo_saida,
	0 ie_doc_medico_solic,
	'' cd_doc_medico_solic,
	0 ie_doc_medico_resp,
	'' cd_doc_medico_resp,
	0 ie_doc_diretor_cli,
	'' cd_doc_diretor_cli,
	0 ie_doc_medico_aut,
	'' cd_doc_medico_aut,
	'' cd_cid_principal,
	'' cd_cid_secundario,
	'' cd_cid_causa_compl,
	'' cd_cid_causa_morte,
	'' cd_solic_liberacao,
	'' nm_pessoa_fisica,
	LOCALTIMESTAMP dt_nascimento,
	'' ie_sexo,
	'' nm_mae,
	'' nm_responsavel,
	0 ie_doc_paciente,
	'' nr_doc_paciente,
	0 nr_cns,
	'' cd_nacionalidade,
	0 tp_logradouro,
	'' ds_logradouro,
	0 nr_logradouro,
	'' ds_compl_logradouro,
	'' ds_bairro,
	'' cd_municipio_ibge,
	'' sg_estado,
	'' cd_cep,
	0 nr_prontuario,
	'' nr_enfermaria,
	'' nr_leito,
	'' ds_registro_proc,
	0 ie_saida_utineo,
	0 qt_peso_utineo,
	0 qt_mes_gestacao,
	'' cd_cgc_empregador,
	'' cd_cbor,
	'' cd_cnaer,
	'' ie_vinculo_prev,
	0 qt_nascido_vivo,
	0 qt_nascido_morto,
	0 qt_saida_alta,
	0 qt_saida_transferencia,
	0 qt_saida_obito,
	0 nr_gestante_prenatal,
	0 qt_filho,
	0 ie_grau_instrucao,
	'' cd_cid_indicacao,
	'' cd_cid_associado,
	0 ie_metodo_contracep_um,
	0 ie_metodo_contracep_dois,
	0 ie_alto_risco,
	99 nr_seq_cor_pele,
	'0000' cd_etnia,
	'' nr_telefone_pac,
	0 ds_filler_aih11,
	0 ie_datasus_aih89,
	0 ds_filler_aih82,
	0 ds_filler_aih90,
	0 ds_filler_aih45,
	b.ds_registro_civil,
	0 ds_filler_civil21,
	'' ds_registro_opm,
	0 ds_filler_opm21,
	sus_obter_ordem_ident_aih('04') ie_ordem,
	c.dt_inicial,
	c.dt_final
from	w_susaih_interf_cab_coord	c,
	w_susaih_interf_regcivil	b,
	w_susaih_interf_cab		a
where	a.nr_interno_conta	= b.nr_interno_conta
and	a.nr_interno_conta	= c.nr_interno_conta

union

select	'OPM' ds_registro,
	3 tp_registro,
	a.nr_seq_protocolo,
	a.qt_aih_lote,
	a.nr_seq_lote,
	a.qt_aih_protocolo,
	a.dt_mesano_apres,
	a.nr_seq_aih_prot,
	a.cd_orgao_emissor_aih,
	a.cd_cnes_hospital,
	a.cd_mun_ibge_hosp,
	a.nr_aih,
	'07' ie_identificacao_aih,
	a.ie_especialidade_aih,
	0 ie_mod_atendimento,
	0 nr_seq_aih,
	0 nr_proxima_aih,
	0 nr_anterior_aih,
	0 nr_seq_conta,
	LOCALTIMESTAMP dt_emissao,
	LOCALTIMESTAMP dt_internacao,
	LOCALTIMESTAMP dt_saida,
	0 cd_procedimento_solic,
	0 ie_mudanca_proc,
	0 cd_procedimento_real,
	'' ie_carater_inter_sus,
	'' ie_motivo_saida,
	0 ie_doc_medico_solic,
	'' cd_doc_medico_solic,
	0 ie_doc_medico_resp,
	'' cd_doc_medico_resp,
	0 ie_doc_diretor_cli,
	'' cd_doc_diretor_cli,
	0 ie_doc_medico_aut,
	'' cd_doc_medico_aut,
	'' cd_cid_principal,
	'' cd_cid_secundario,
	'' cd_cid_causa_compl,
	'' cd_cid_causa_morte,
	'' cd_solic_liberacao,
	'' nm_pessoa_fisica,
	LOCALTIMESTAMP dt_nascimento,
	'' ie_sexo,
	'' nm_mae,
	'' nm_responsavel,
	0 ie_doc_paciente,
	'' nr_doc_paciente,
	0 nr_cns,
	'' cd_nacionalidade,
	0 tp_logradouro,
	'' ds_logradouro,
	0 nr_logradouro,
	'' ds_compl_logradouro,
	'' ds_bairro,
	'' cd_municipio_ibge,
	'' sg_estado,
	'' cd_cep,
	0 nr_prontuario,
	'' nr_enfermaria,
	'' nr_leito,
	'' ds_registro_proc,
	0 ie_saida_utineo,
	0 qt_peso_utineo,
	0 qt_mes_gestacao,
	'' cd_cgc_empregador,
	'' cd_cbor,
	'' cd_cnaer,
	'' ie_vinculo_prev,
	0 qt_nascido_vivo,
	0 qt_nascido_morto,
	0 qt_saida_alta,
	0 qt_saida_transferencia,
	0 qt_saida_obito,
	0 nr_gestante_prenatal,
	0 qt_filho,
	0 ie_grau_instrucao,
	'' cd_cid_indicacao,
	'' cd_cid_associado,
	0 ie_metodo_contracep_um,
	0 ie_metodo_contracep_dois,
	0 ie_alto_risco,
	99 nr_seq_cor_pele,
	'0000' cd_etnia,
	'' nr_telefone_pac,
	0 ds_filler_aih11,
	0 ie_datasus_aih89,
	0 ds_filler_aih82,
	0 ds_filler_aih90,
	0 ds_filler_aih45,
	'' ds_registro_civil,
	0 ds_filler_civil21,
	b.ds_registro_opm,
	0 ds_filler_opm21,
	sus_obter_ordem_ident_aih('07') ie_ordem,
	c.dt_inicial,
	c.dt_final
from	w_susaih_interf_cab_coord	c,
	w_susaih_interf_opm		b,
	w_susaih_interf_cab		a
where	a.nr_interno_conta	= b.nr_interno_conta
and	a.nr_interno_conta	= c.nr_interno_conta
order by  nr_seq_aih_prot, tp_registro, ie_ordem, nr_seq_conta;
