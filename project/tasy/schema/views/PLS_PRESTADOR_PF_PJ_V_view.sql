-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_prestador_pf_pj_v (nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, cd_cgc, cd_pessoa_fisica, ie_situacao, nr_seq_prestador_receb, ie_tipo_relacao, ie_abramge, dt_cadastro, nr_seq_contrato, nr_seq_tipo_prestador, cd_estabelecimento, dt_limite_integracao, ie_guia_medico, ie_tipo_complemento, ie_tipo_endereco, ie_tipo_vinculo, qt_dias_protocolo, ie_tipo_guia_medico, ie_regra_data_preco_proc, ie_regra_data_preco_mat, ie_tipo_validacao_aut_solic, qt_dias_envio_contas, ie_tipo_prestador, nr_seq_classificacao, nr_seq_anterior, sg_uf_sip, cd_prestador, cd_prestador_2, nm_prestador, nm_fantasia, cd_prestador_cod, nr_seq_prest_princ, nm_interno, dt_exclusao, cd_cpf, nm_prestador_sem_acento, nm_fantasia_sem_acento, ie_prestador_matriz) AS select	a.nr_sequencia,
	a.dt_atualizacao, 
	a.nm_usuario, 
	a.dt_atualizacao_nrec, 
	a.nm_usuario_nrec, 
	a.cd_cgc, 
	a.cd_pessoa_fisica, 
	a.ie_situacao, 
	a.nr_seq_prestador_receb, 
	a.ie_tipo_relacao, 
	a.ie_abramge, 
	a.dt_cadastro, 
	a.nr_seq_contrato, 
	a.nr_seq_tipo_prestador, 
	a.cd_estabelecimento, 
	a.dt_limite_integracao, 
	a.ie_guia_medico, 
	a.ie_tipo_complemento, 
	a.ie_tipo_endereco, 
	a.ie_tipo_vinculo, 
	a.qt_dias_protocolo, 
	a.ie_tipo_guia_medico, 
	a.ie_regra_data_preco_proc, 
	a.ie_regra_data_preco_mat, 
	a.ie_tipo_validacao_aut_solic, 
	a.qt_dias_envio_contas, 
	a.ie_tipo_prestador, 
	a.nr_seq_classificacao, 
	a.nr_seq_anterior, 
	a.sg_uf_sip, 
	b.cd_pessoa_fisica cd_prestador, 
	b.nr_cpf	cd_prestador_2, 
	coalesce(a.nm_interno, b.nm_pessoa_fisica) nm_prestador, 
	substr(obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'F'),1,254) nm_fantasia, 
	a.cd_prestador cd_prestador_cod, 
	a.nr_seq_prest_princ, 
	a.nm_interno, 
	a.dt_exclusao, 
	b.nr_cpf cd_cpf, 
	upper(elimina_acentuacao(coalesce(a.nm_interno, b.nm_pessoa_fisica))) nm_prestador_sem_acento, 
	upper(elimina_acentuacao(substr(obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'F'),1,254))) nm_fantasia_sem_acento, 
	a.ie_prestador_matriz 
FROM	pessoa_fisica b, 
	pls_prestador a 
where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica 

union
 
select	a.nr_sequencia, 
	a.dt_atualizacao, 
	a.nm_usuario, 
	a.dt_atualizacao_nrec, 
	a.nm_usuario_nrec, 
	a.cd_cgc, 
	a.cd_pessoa_fisica, 
	a.ie_situacao, 
	a.nr_seq_prestador_receb, 
	a.ie_tipo_relacao, 
	a.ie_abramge, 
	a.dt_cadastro, 
	a.nr_seq_contrato, 
	a.nr_seq_tipo_prestador, 
	a.cd_estabelecimento, 
	a.dt_limite_integracao, 
	a.ie_guia_medico, 
	a.ie_tipo_complemento, 
	a.ie_tipo_endereco, 
	a.ie_tipo_vinculo, 
	a.qt_dias_protocolo, 
	a.ie_tipo_guia_medico, 
	a.ie_regra_data_preco_proc, 
	a.ie_regra_data_preco_mat, 
	a.ie_tipo_validacao_aut_solic, 
	a.qt_dias_envio_contas, 
	a.ie_tipo_prestador, 
	a.nr_seq_classificacao, 
	a.nr_seq_anterior, 
	a.sg_uf_sip, 
	b.cd_cgc cd_prestador, 
	a.cd_cgc cd_prestador_2, 
	coalesce(a.nm_interno, b.ds_razao_social) nm_prestador, 
	substr(obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'F'),1,254) nm_fantasia, 
	a.cd_prestador cd_prestador_cod, 
	a.nr_seq_prest_princ, 
	a.nm_interno, 
	a.dt_exclusao, 
	'' cd_cpf, 
	upper(elimina_acentuacao(coalesce(a.nm_interno, b.ds_razao_social))) nm_prestador_sem_acento, 
	upper(elimina_acentuacao(substr(obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'F'),1,254))) nm_fantasia_sem_acento, 
	a.ie_prestador_matriz 
from	pessoa_juridica b, 
	pls_prestador a 
where	a.cd_cgc		= b.cd_cgc;

