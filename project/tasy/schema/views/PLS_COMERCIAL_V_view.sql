-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_comercial_v (nm_pessoa, ie_tipo_pessoa, ie_tipo_item, ie_status_solicitacao, ie_status_proposta, ie_status_prospect, nr_telefone, nm_canal_venda, ds_motivo_reprovacao, dt_solicitacao, dt_aprovacao, dt_reprovacao, dt_geracao_lead, ds_motivo_cancelamento, ds_motivo_reprov_prop, dt_historico) AS select	substr(obter_nome_pf_pj(a.cd_pessoa_fisica,a.cd_cgc),1,255) nm_pessoa,
	CASE WHEN cd_cgc IS NULL THEN 'PF'  ELSE 'PJ' END  ie_tipo_pessoa, 
	'Prospect' ie_tipo_item, 
	null ie_status_solicitacao, 
	b.ie_status ie_status_proposta, 
	a.ie_status ie_status_prospect, 
	substr(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'T'),1,20) nr_telefone, 
	substr(pls_obter_dados_cliente(a.nr_sequencia,'V'),1,255) nm_canal_venda, 
	null ds_motivo_reprovacao, 
	null dt_solicitacao, 
	null dt_aprovacao, 
	null dt_reprovacao, 
	a.dt_aprovacao dt_geracao_lead, 
	substr(pls_obter_desc_motivo_cancel(a.nr_seq_motivo_cancelamento),1,200) ds_motivo_cancelamento, 
	substr(pls_obter_desc_repro_proposta(b.cd_motivo_reprovacao),1,255) ds_motivo_reprov_prop, 
	substr(pls_obter_dados_cliente(a.nr_sequencia,'DH'),1,255) dt_historico 
FROM pls_comercial_cliente a
LEFT OUTER JOIN pls_proposta_adesao b ON (a.nr_sequencia = b.nr_seq_cliente) 
UNION ALL
 
select	a.nm_pessoa_fisica nm_pessoa, 
	CASE WHEN a.nr_cpf IS NULL THEN CASE WHEN a.cd_cgc IS NULL THEN ''  ELSE 'PJ' END   ELSE 'PF' END  ie_tipo_pessoa, 
	'Solicitação de lead' ie_tipo_item, 
	a.ie_status ie_status_solicitacao, 
	null ie_status_proposta, 
	null ie_status_prospect, 
	a.nr_telefone, 
	substr(pls_obter_dados_solicitacao(a.nr_sequencia,'V'),1,255) nm_canal_venda, 
	substr(pls_obter_desc_motivo_lead(nr_seq_motivo_reprovacao),1,255) ds_motivo_reprovacao, 
	a.dt_solicitacao, 
	a.dt_aprovacao, 
	a.dt_reprovacao, 
	null dt_geracao_lead, 
	null ds_motivo_cancelamento, 
	null ds_motivo_reprov_prop, 
	substr(pls_obter_dados_solicitacao(a.nr_sequencia,'DH'),1,255) dt_historico 
from	pls_solicitacao_comercial a;
