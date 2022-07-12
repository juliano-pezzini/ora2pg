-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW envio_rps_caucaia_v (tp_registro, nr_versao, nr_inscricao_municipal, qt_linhas, vl_total_servicos, vl_total_descontos, vl_total_iss, tp_processamento, nr_rps, cd_verificacao, dt_emissao, situacao_rps, vl_total, vl_servico, vl_deducao, vl_base, vl_aliquota, vl_iss, ie_iss_retido, vl_desconto_incond, vl_liquido, item_servico, cd_cnae, indicador_cpf_cnpj_tomador, cpf_cnpj_tomador, insc_munic_tomador, razao_social_tomador, end_tomador, numero_end_tomador, compl_tomador, bairro_tomador, cidade_tomador, uf_tomador, cep_tomador, email_tomador, ds_servicos, qt_linhas_arq, cd_estabelecimento) AS select	 1									tp_registro,
	'001'									nr_versao,
	Max(substr(obter_dados_pf_pj('', N.cd_cgc_emitente, 'IM'), 1, 30))		nr_inscricao_municipal,
	count(N.nr_nota_fiscal)							qt_linhas,
	sum(N.vl_mercadoria)							vl_total_servicos,
	sum(N.vl_descontos)							vl_total_descontos,
	sum(CASE WHEN obter_se_nf_retem_iss(nr_sequencia)='S' THEN   null  ELSE round_abnt(obter_valor_tipo_tributo_nota(nr_sequencia, 'B', 'ISS') * (obter_valor_tipo_tributo_nota(nr_sequencia, 'X', 'ISS') / 100),2) END )	vl_total_iss,
	'P'									tp_processamento,
	''									nr_rps,
	''									cd_verificacao,
	null									dt_emissao,
	''									situacao_rps,
	null									vl_total,
	null									vl_servico,
	null									vl_deducao,
	null									vl_base,
	null									vl_aliquota,
	null									vl_iss,
	''									ie_iss_retido,
	null									vl_desconto_incond,
	null									vl_liquido,
	''									item_servico,
	''									cd_cnae,
	null									indicador_cpf_cnpj_tomador,
	''									cpf_cnpj_tomador,
	''									insc_munic_tomador,
	''									razao_social_tomador,
	''									end_tomador,
	''									numero_end_tomador,
	''									compl_tomador,
	''									bairro_tomador,
	''									cidade_tomador,
	''									uf_tomador,
	''									cep_tomador,
	''									email_tomador,
	''									ds_servicos,
	null									qt_linhas_arq,
	Max(N.cd_estabelecimento) 						cd_estabelecimento
FROM	NOTA_FISCAL N
WHERE	N.IE_SITUACAO = 1
AND	EXISTS (
	SELECT	1
	FROM	W_NOTA_FISCAL X
	WHERE	X.NR_SEQ_NOTA_FISCAL = N.NR_SEQUENCIA)

union

select	2									tp_registro,
	'001'									nr_versao,
	''									nr_inscricao_municipal,
	null									qt_linhas,
	null									vl_total_servicos,
	null									vl_total_descontos,
	null									vl_total_iss,
	'P'									tp_processamento,
	N.nr_nota_fiscal 							nr_rps,
	N.nr_nfe_imp								cd_verificacao,
	N.dt_emissao								dt_emissao,
	CASE WHEN N.ie_situacao='1' THEN 'N' WHEN N.ie_situacao='2' THEN 'I' WHEN N.ie_situacao='8' THEN 'C'  ELSE 'I' END 			situacao_rps,
	N.VL_TOTAL_NOTA								vl_total,
	N.vl_mercadoria								vl_servico,
	N.vl_descontos								vl_deducao,
	CASE WHEN obter_valor_tipo_tributo_nota(N.nr_sequencia, 'B', 'ISS')=0 THEN  N.vl_mercadoria  ELSE obter_valor_tipo_tributo_nota(N.nr_sequencia, 'B', 'ISS') END 	vl_base,
	obter_valor_tipo_tributo_nota(N.nr_sequencia, 'X', 'ISS')			vl_aliquota,
	CASE WHEN obter_se_nf_retem_iss(N.nr_sequencia)='S' THEN   null  ELSE round_abnt(obter_valor_tipo_tributo_nota(N.nr_sequencia, 'B', 'ISS') * (obter_valor_tipo_tributo_nota(N.nr_sequencia, 'X', 'ISS') / 100),2) END 	vl_iss,
	CASE WHEN obter_se_nf_retem_iss(N.nr_sequencia)='S' THEN  '1'  ELSE '2' END 		ie_iss_retido,
	N.vl_descontos								vl_desconto_incond,
	CASE WHEN obter_se_nf_retem_iss(N.nr_sequencia)='S' THEN (campo_mascara((N.vl_mercadoria) - obter_Valor_Tributo_Nota(N.nr_sequencia, 'V') - coalesce(N.vl_descontos, 0), 2))  ELSE ((N.vl_mercadoria) - (coalesce(obter_valor_tipo_tributo_nota(N.nr_sequencia, 'V', 'PIS'), 0))	- (coalesce(obter_valor_tipo_tributo_nota(N.nr_sequencia, 'V', 'COFINS'), 0))	- (coalesce(obter_valor_tipo_tributo_nota(N.nr_sequencia, 'V', 'INSS'), 0))	- (coalesce(obter_valor_tipo_tributo_nota(N.nr_sequencia, 'V', 'IR'), 0))	- (coalesce(obter_valor_tipo_tributo_nota(N.nr_sequencia, 'V', 'CSLL'), 0))	- (coalesce(obter_valor_tipo_tributo_nota(N.nr_sequencia, 'V', 'O'), 0))	- (CASE WHEN obter_se_nf_retem_iss(N.nr_sequencia)='S' THEN  coalesce(obter_valor_tipo_tributo_nota(N.nr_sequencia, 'V', 'ISS'), 0)  ELSE 0 END )	- (coalesce(N.vl_descontos, 0))) END 						vl_liquido,
	obter_cod_grupo_ativ(N.cd_estabelecimento, N.nr_sequencia, 'G')		item_servico,
	pls_obter_cd_cnae(obter_dados_pf_pj(NULL, N.cd_cgc_emitente, 'CNAE'))	cd_cnae,
	CASE WHEN N.cd_pessoa_fisica IS NULL THEN 2  ELSE 1 END 					indicador_cpf_cnpj_tomador,
	coalesce(substr(obter_cpf_pessoa_fisica(N.cd_pessoa_fisica),1,14),N.cd_cgc) 	cpf_cnpj_tomador,
	substr(obter_dados_pf_pj(null,N.cd_cgc,'IM'),1,20)			insc_munic_tomador,
	substr(tiss_eliminar_caractere(elimina_acentuacao(obter_nome_pf_pj(N.cd_pessoa_fisica, N.cd_cgc))), 1, 255) razao_social_tomador,
	substr(obter_dados_pf_pj(N.cd_pessoa_fisica, N.cd_cgc, 'E'),1,50)	end_tomador,
	substr(obter_dados_pf_pj(N.cd_pessoa_fisica, N.cd_cgc, 'NR'),1,10)	numero_end_tomador,
	substr(obter_dados_pf_pj(N.cd_pessoa_fisica, N.cd_cgc, 'CO'),1,30)	compl_tomador,
	substr(obter_dados_pf_pj(N.cd_pessoa_fisica, N.cd_cgc, 'B'),1,30)	bairro_tomador,
	substr(obter_dados_pf_pj(N.cd_pessoa_fisica, N.cd_cgc, 'CI'),1,50)	cidade_tomador,
	substr(obter_dados_pf_pj(N.cd_pessoa_fisica, N.cd_cgc, 'UF'),1,2)	uf_tomador,
	to_char(somente_numero(substr(obter_dados_pf_pj(N.cd_pessoa_fisica, N.cd_cgc, 'CEP'),1,15)))	cep_tomador,
	substr(obter_dados_pf_pj(N.cd_pessoa_fisica, N.cd_cgc, 'M'),1,60)	email_tomador,
	coalesce(SUBSTR(obter_descricao_rps(N.cd_estabelecimento, N.nr_sequencia, 'DS_SERVICOS'), 1, 1000), 'Servicos')	ds_servicos,
	null									qt_linhas_arq,
	N.cd_estabelecimento							cd_estabelecimento
from	nota_fiscal n
where	N.ie_situacao = 1
and	exists (
	select	1
	from	w_nota_fiscal x
	where	x.nr_seq_nota_fiscal = N.nr_sequencia)

union

select	9									tp_registro,
	''									nr_versao,
	''									nr_inscricao_municipal,
	null									qt_linhas,
	null									vl_total_servicos,
	null									vl_total_descontos,
	null									vl_total_iss,
	'P'									tp_processamento,
	''									nr_rps,
	''									cd_verificacao,
	null									dt_emissao,
	''									situacao_rps,
null										vl_total,
	null									vl_servico,
	null									vl_deducao,
	null									vl_base,
	null									vl_aliquota,
	null									vl_iss,
	''									ie_iss_retido,
	null									vl_desconto_incond,
	null									vl_liquido,
	''									item_servico,
	''									cd_cnae,
	null									indicador_cpf_cnpj_tomador,
	''									cpf_cnpj_tomador,
	''									insc_munic_tomador,
	''									razao_social_tomador,
	''									end_tomador,
	''									numero_end_tomador,
	''									compl_tomador,
	''									bairro_tomador,
	''									cidade_tomador,
	''									uf_tomador,
	''									cep_tomador,
	''									email_tomador,
	''									ds_servicos,
	(count(N.nr_sequencia) + 1)						qt_linhas_arq,
	N.cd_estabelecimento							cd_estabelecimento
from	nota_fiscal n
where	N.ie_situacao = 1
and	exists (
	select	1
	from	w_nota_fiscal x
	where	x.nr_seq_nota_fiscal = N.nr_sequencia)
group by N.cd_estabelecimento;
