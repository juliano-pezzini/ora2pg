-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW plussoft_dados_portab_v (nr_seq_portabilidade, cd_pessoa_fisica, nm_pessoa_fisica, nr_cpf, nr_seq_proposta, dt_solicitacao, dt_resposta, dt_contratacao_origem, vl_preco_origem, nr_seq_portab_operadora, cd_abrangencia_geografica, nr_prot_ans_origem, cd_segmentacao_assistencial, ie_tipo_contratacao, nr_seq_plano, nr_protocolo_ans, nr_seq_tabela, nr_seq_motivo_recusa, ie_status_portabilidade, nr_seq_benef_prop_adesao) AS select	a.nr_sequencia					nr_seq_portabilidade,
		a.cd_pessoa_fisica				cd_pessoa_fisica, 
		obter_nome_pf(a.cd_pessoa_fisica)		nm_pessoa_fisica, 
		obter_dados_pf(a.cd_pessoa_fisica,'CPF')	nr_cpf, 
		null						nr_seq_proposta, 
		a.dt_solicitacao				dt_solicitacao, 
		a.dt_resposta					dt_resposta, 
		a.dt_contratacao_origem				dt_contratacao_origem, 
		a.vl_preco_origem				vl_preco_origem, 
		a.nr_seq_portab_operadora			nr_seq_portab_operadora, 
		a.ie_abrangencia				cd_abrangencia_geografica, 
		a.nr_prot_ans_origem				nr_prot_ans_origem, 
		a.ie_segmentacao				cd_segmentacao_assistencial, 
		a.ie_tipo_contratacao 				ie_tipo_contratacao, 
		a.nr_seq_plano					nr_seq_plano, 
		null						nr_protocolo_ans, 
		a.nr_seq_tabela					nr_seq_tabela, 
		a.nr_seq_motivo_recusa				nr_seq_motivo_recusa, 
		a.ie_status					ie_status_portabilidade, 
		null						nr_seq_benef_prop_adesao 
	FROM	pls_portab_pessoa a 
	where	not exists (	select	1 
				from	pls_proposta_beneficiario x 
				where	x.nr_seq_portabilidade	= a.nr_sequencia) 
	
union all
 
		select	a.nr_sequencia					nr_seq_portabilidade, 
		a.cd_pessoa_fisica					cd_pessoa_fisica, 
		obter_nome_pf(a.cd_pessoa_fisica)			nm_pessoa_fisica, 
		obter_dados_pf(a.cd_pessoa_fisica,'CPF')		nr_cpf, 
		b.nr_seq_proposta					nr_seq_proposta, 
		a.dt_solicitacao					dt_solicitacao, 
		a.dt_resposta						dt_resposta, 
		a.dt_contratacao_origem					dt_contratacao_origem, 
		a.vl_preco_origem					vl_preco_origem, 
		a.nr_seq_portab_operadora				nr_seq_portab_operadora, 
		a.ie_abrangencia					cd_abrangencia_geografica, 
		a.nr_prot_ans_origem					nr_prot_ans_origem, 
		a.ie_segmentacao					cd_segmentacao_assistencial, 
		a.ie_tipo_contratacao 					ie_tipo_contratacao, 
		a.nr_seq_plano						nr_seq_plano, 
		(	select	max(x.nr_protocolo_ans) 
			from	pls_plano x 
			where	x.nr_sequencia = b.nr_seq_plano)	nr_protocolo_ans, 
		a.nr_seq_tabela						nr_seq_tabela, 
		a.nr_seq_motivo_recusa					nr_seq_motivo_recusa, 
		a.ie_status						ie_status_portabilidade, 
		b.nr_sequencia						nr_seq_benef_prop_adesao 
	from	pls_portab_pessoa		a, 
		pls_proposta_beneficiario 	b 
	where	b.nr_seq_portabilidade			= a.nr_sequencia;
