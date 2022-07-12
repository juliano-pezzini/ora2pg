-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW exp_nota_fiscal_saida_v (tp_registro, ie_tipo_servico, ie_tipo_documento, nr_nota_fiscal, dt_mesano_referencia, ie_pf_pj_prestador, cd_cpf_cnpj_prestador, ie_pf_pj_tomador, cd_cpf_cnpj_tomador, dt_emissao, vl_total_nota, ie_situacao, ds_observacao, ie_simples_nacional, cd_estabelecimento, cd_operacao_nf, cd_serie_nf, nr_sequencia, cd_servico, pr_aliquota, vl_mercadoria, vl_deducao, vl_retido, cd_municipio, cd_situacao_tributaria, cd_local_prest_servico, nm_pessoa_nota, ds_endereco, nr_endereco, ds_complemento, ds_bairro, ds_municipio, sg_estado, cd_cep, nr_telefone, nr_fax) AS select	10				tp_registro,
	CASE WHEN substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1)='S' THEN  '1'  ELSE '2' END  ie_tipo_servico, 
	'01'				ie_tipo_documento, 
	substr(rpad(n.nr_nota_fiscal,15,' '),1,15) nr_nota_fiscal, 
	to_char(n.dt_emissao,'mm/yyyy') dt_mesano_referencia, 
	'J' ie_pf_pj_prestador, 
	substr(n.cd_cgc_emitente,1,14) cd_cpf_cnpj_prestador, 
	CASE WHEN n.cd_cgc IS NULL THEN  'F'  ELSE 'J' END 		ie_pf_pj_tomador, 
	lpad(substr(CASE WHEN n.cd_operacao_nf=3 THEN obter_cgc_estabelecimento(n.cd_estabelecimento)  ELSE coalesce(obter_cpf_pessoa_fisica(n.cd_pessoa_fisica),n.cd_cgc_emitente) END ,1,14),14,0) cd_cpf_cnpj_tomador, 
	trunc(n.dt_emissao,'dd') dt_emissao, 
	coalesce(n.vl_total_nota,0) + obter_valor_tipo_tributo_nota(n.nr_sequencia,'V','ISS') vl_total_nota, 
	CASE WHEN n.ie_situacao='1' THEN  'E'  ELSE 'C' END  	ie_situacao, 
	replace(replace(substr(rpad('0' || n.ds_observacao,101,' '),2,101),chr(13),' '),chr(10),' ') ds_observacao, 
	'N'				ie_simples_nacional, 
	n.cd_estabelecimento, 
	n.cd_operacao_nf, 
	n.cd_serie_nf, 
	n.nr_sequencia, 
	'0'				cd_servico, 
	0				pr_aliquota, 
	0				vl_mercadoria, 
	0				vl_deducao, 
	0				vl_retido, 
	''				cd_municipio, 
	CASE WHEN substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1)='S' THEN  '0'  ELSE '13' END  cd_situacao_tributaria, 
	CASE WHEN substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1)='S' THEN  '4218202'  ELSE '4218202' END  cd_local_prest_servico, 
	''				nm_pessoa_nota, 
	''				ds_endereco, 
	''				nr_endereco, 
	''				ds_complemento, 
	''				ds_bairro, 
	''				ds_municipio, 
	''				sg_estado, 
	''				cd_cep, 
	''				nr_telefone, 
	''				nr_fax 
FROM	nota_fiscal n, 
		operacao_nota o 
where	1=1 
and	n.ie_tipo_nota <> 'ST' 
AND	substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1) = 'S' 
and	n.ie_situacao <> 2 
and	n.dt_atualizacao_estoque is not null 
and n.cd_operacao_nf = o.cd_operacao_nf 
and	ie_servico = 'S' 
and n.ie_situacao <> '3' 
and n.ie_situacao <> '9' 

union all
 
select	20				tp_registro, 
	CASE WHEN substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1)='S' THEN  '1'  ELSE '2' END  ie_tipo_servico, 
	'01'				ie_tipo_documento, 
	substr(rpad(n.nr_nota_fiscal,15,' '),1,15) nr_nota_fiscal, 
	to_char(n.dt_emissao,'mm/yyyy') dt_mesano_referencia, 
	'J'				ie_pf_pj_prestador, 
	substr(n.cd_cgc_emitente,1,14) cd_cpf_cnpj_prestador, 
	CASE WHEN n.cd_cgc IS NULL THEN  'F'  ELSE 'J' END 		ie_pf_pj_tomador, 
	lpad(substr(CASE WHEN n.cd_operacao_nf=3 THEN obter_cgc_estabelecimento(n.cd_estabelecimento)  ELSE coalesce(obter_cpf_pessoa_fisica(n.cd_pessoa_fisica),n.cd_cgc_emitente) END ,1,14),14,0) cd_cpf_cnpj_tomador, 
	trunc(n.dt_emissao,'dd') dt_emissao, 
	0				vl_total_nota, 
	CASE WHEN n.ie_situacao='1' THEN  'E'  ELSE 'C' END  	ie_situacao, 
	substr(n.ds_observacao,1,100) ds_observacao, 
	'N'				ie_simples_nacional, 
	n.cd_estabelecimento, 
	n.cd_operacao_nf, 
	n.cd_serie_nf, 
	n.nr_sequencia, 
	lpad(403,7,0)	cd_servico, 
	0				pr_aliquota, 
	max(coalesce(n.vl_mercadoria,0))	vl_mercadoria, 
	0				vl_deducao, 
	CASE WHEN obter_se_nota_entrada_saida(n.nr_sequencia)='E' THEN obter_valor_tipo_tributo_nota(n.nr_sequencia,'V','ISS')  ELSE 0 END  vl_retido, 
	substr(obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc,'CDM'),1,15) cd_municipio, 
	CASE WHEN substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1)='S' THEN  '0'  ELSE '13' END  cd_situacao_tributaria, 
	CASE WHEN substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1)='S' THEN  '4218202'  ELSE '4218202' END  cd_local_prest_servico, 
	''				nm_pessoa_nota, 
	''				ds_endereco, 
	''				nr_endereco, 
	''				ds_complemento, 
	''				ds_bairro, 
	''				ds_municipio, 
	''				sg_estado, 
	''				cd_cep, 
	''				nr_telefone, 
	''				nr_fax 
from	nota_fiscal_item i, 
	nota_fiscal n, 
	operacao_nota o 
where	n.nr_sequencia = i.nr_sequencia 
and	n.ie_tipo_nota <> 'ST' 
AND	substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1) = 'S' 
and	n.ie_situacao <> 2 
and	n.dt_atualizacao_estoque is not null 
and n.cd_operacao_nf = o.cd_operacao_nf 
and	ie_servico = 'S' 
and n.ie_situacao <> '3' 
and n.ie_situacao <> '9' 
group by 
	n.nr_sequencia, 
	n.nr_nota_fiscal, 
	n.cd_cgc, 
	n.cd_cgc_emitente, 
	n.cd_pessoa_fisica, 
	n.dt_emissao, 
	n.ie_situacao, 
	n.cd_estabelecimento, 
	n.cd_operacao_nf, 
	n.cd_serie_nf, 
	n.nr_sequencia, 
	substr(n.ds_observacao,1,100) 

union all
 
select	30				tp_registro, 
	CASE WHEN substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1)='S' THEN  '1'  ELSE '2' END  ie_tipo_servico, 
	'01'				ie_tipo_documento, 
	substr(rpad(n.nr_nota_fiscal,15,' '),1,15) nr_nota_fiscal, 
	to_char(n.dt_emissao,'mm/yyyy') dt_mesano_referencia, 
	'J'				ie_pf_pj_prestador, 
	substr(n.cd_cgc_emitente,1,14) cd_cpf_cnpj_prestador, 
	''				ie_pf_pj_tomador, 
	''				cd_cpf_cnpj_tomador, 
	trunc(n.dt_emissao,'dd') dt_emissao, 
	0				vl_total_nota, 
	''				ie_situacao, 
	substr(n.ds_observacao,1,100) ds_observacao, 
	'N'				ie_simples_nacional, 
	n.cd_estabelecimento, 
	n.cd_operacao_nf, 
	n.cd_serie_nf, 
	n.nr_sequencia, 
	'0'				cd_servico, 
	0				pr_aliquota, 
	0				vl_mercadoria, 
	0				vl_deducao, 
	0				vl_retido, 
	''				cd_municipio, 
	CASE WHEN substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1)='S' THEN  '0'  ELSE '13' END  cd_situacao_tributaria, 
	CASE WHEN substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1)='S' THEN  '4218202'  ELSE '4218202' END  cd_local_prest_servico, 
	rpad(substr(coalesce(obter_nome_pf_pj(n.cd_pessoa_fisica, n.cd_cgc),'nome'),1,40),40,' ') nm_pessoa_nota, 
	rpad(substr(coalesce(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'R'),'Endereço'),1,40),40,' ') ds_endereco, 
	rpad(substr(coalesce(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'NR'),'S/N'),1,6),6,' ') nr_endereco, 
	rpad(substr(coalesce(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CO'),'Compl'),1,20),20,' ') ds_complemento, 
	rpad(substr(coalesce(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'B'),'Bairro'),1,20),20,' ') ds_bairro, 
	rpad(substr(coalesce(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CI'),'Cidade'),1,20),30,' ') ds_municipio, 
	substr(coalesce(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'UF'),'SC'),1,2) sg_estado, 
	replace(replace(substr(coalesce(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CEP'),'0'),1,15),'-',''),'.','') cd_cep, 
	rpad(substr(coalesce(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'T'),'0'),1,12),12,'0') nr_telefone, 
	rpad(substr(coalesce(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'FAX'),'0'),1,12),12,'0') nr_fax 
from	nota_fiscal n, 
		operacao_nota o 
where	1=1 
and	n.ie_tipo_nota <> 'ST' 
AND	substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1) = 'S' 
and	n.ie_situacao <> 2 
and	n.dt_atualizacao_estoque is not null 
and n.cd_operacao_nf = o.cd_operacao_nf 
and	ie_servico = 'S' 
and n.ie_situacao <> '3' 
and n.ie_situacao <> '9';
