-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW deiss_cascavel_v (cd_modelo, ds_branco, nr_seq_documento, dt_emissao, cd_estabelecimento, dt_dia_emissao, dt_mes_emissao, dt_ano_emissao, vl_tributavel, vl_documento, cd_natureza_operacao, cd_atividade, cd_inscicao_tomador, cpf_cnpj_tomador, ds_razao_tomador, cep_tomador, ds_endereco_tomador, nr_endereco_tomador, ds_bairro_tomador, ds_cidade_tomador, ds_estado_tomador, ie_imposto_retido, ie_tributado_municipio, ie_aliquota_nacional) AS select	substr(obter_cd_modelo_nf(nr_seq_modelo),1,255) cd_modelo,
	' ' ds_branco, 
	lpad(nr_nota_fiscal, 9, 0) nr_seq_documento, 
	dt_emissao dt_emissao, 
	cd_estabelecimento, 
	to_char(dt_emissao, 'dd') dt_dia_emissao, 
	to_char(dt_emissao, 'mm') dt_mes_emissao, 
	to_char(dt_emissao, 'yyyy') dt_ano_emissao, 
	CASE WHEN vl_mercadoria=0 THEN  '0.00'  ELSE replace(to_char(campo_mascara(vl_mercadoria, 2)),',','.') END  vl_tributavel, 
	CASE WHEN vl_mercadoria=0 THEN  '0.00'  ELSE replace(to_char(campo_mascara(vl_mercadoria, 2)),',','.') END  vl_documento, 
	CD_NATUREZA_OPERACAO cd_natureza_operacao, 
	obter_dados_pf_pj_estab(cd_estabelecimento, null, cd_cgc_emitente, 'ATIV') cd_atividade, 
	substr(coalesce(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'IM'), '000000000000000'), 1, 30) CD_INSCICAO_TOMADOR, 
	CASE WHEN cd_cgc='' THEN coalesce(substr(obter_dados_pf(cd_pessoa_fisica, 'CPF'), 1, 11), '00000000000')  ELSE cd_cgc END  CPF_CNPJ_TOMADOR, 	 
	upper(substr(tiss_eliminar_caractere(elimina_acentuacao(obter_nome_pf_pj(cd_pessoa_fisica, cd_cgc))), 1, 255)) DS_RAZAO_TOMADOR,   
	somente_numero(substr(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'CEP'), 1, 15)) CEP_TOMADOR, 	 
	upper(coalesce(substr(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'EN'))), 1, 255), 'Endereco')) DS_ENDERECO_TOMADOR, 
	coalesce(substr(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'NR'), 1, 25), '000000') NR_ENDERECO_TOMADOR, 
	upper(coalesce(substr(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'B'))), 1, 255), 'Bairro')) DS_BAIRRO_TOMADOR, 
	upper(coalesce(substr(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'CI'))), 1, 255), 'Cidade')) DS_CIDADE_TOMADOR, 
	upper(coalesce(substr(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'UF'))), 1, 255), 'UF')) DS_ESTADO_TOMADOR, 
	CASE WHEN coalesce(Obter_Valor_tipo_Tributo_Nota(nr_sequencia, 'V', 'ISS'),0)=0 THEN  0  ELSE 1 END  IE_IMPOSTO_RETIDO, 
	0 IE_TRIBUTADO_MUNICIPIO, 
	0 IE_ALIQUOTA_NACIONAL 
FROM 	nota_fiscal 
where	ie_situacao in ('1') 
and	substr(obter_se_nota_entrada_saida(nr_sequencia),1,1) = 'S' 

union all
 
select	substr(obter_cd_modelo_nf(a.nr_seq_modelo),1,255) cd_modelo, 
	' ' ds_branco, 
	lpad(a.nr_nota_fiscal, 9, 0) nr_seq_documento, 
	a.dt_emissao dt_emissao, 
	a.cd_estabelecimento, 
	to_char(a.dt_emissao, 'dd') dt_dia_emissao, 
	to_char(a.dt_emissao, 'mm') dt_mes_emissao, 
	to_char(a.dt_emissao, 'yyyy') dt_ano_emissao, 
	CASE WHEN a.vl_mercadoria=0 THEN  '0.00'  ELSE replace(to_char(campo_mascara(a.vl_mercadoria, 2)),',','.') END  vl_tributavel, 
	CASE WHEN a.vl_mercadoria=0 THEN  '0.00'  ELSE replace(to_char(campo_mascara(a.vl_mercadoria, 2)),',','.') END  vl_documento, 
	a.CD_NATUREZA_OPERACAO cd_natureza_operacao, 
	obter_dados_pf_pj_estab(a.cd_estabelecimento, null, a.cd_cgc_emitente, 'ATIV') cd_atividade, 
	substr(coalesce(obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'IM'), '000000000000000'), 1, 30) CD_INSCICAO_TOMADOR, 
	CASE WHEN a.cd_cgc='' THEN coalesce(substr(obter_dados_pf(a.cd_pessoa_fisica, 'CPF'), 1, 11), '00000000000')  ELSE cd_cgc END  CPF_CNPJ_TOMADOR, 	 
	upper(substr(tiss_eliminar_caractere(elimina_acentuacao(obter_nome_pf_pj(a.cd_pessoa_fisica, cd_cgc))), 1, 255)) DS_RAZAO_TOMADOR,   
	somente_numero(substr(obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'CEP'), 1, 15)) CEP_TOMADOR, 	 
	upper(coalesce(substr(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(a.cd_pessoa_fisica, cd_cgc, 'EN'))), 1, 255), 'Endereco')) DS_ENDERECO_TOMADOR, 
	coalesce(substr(obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'NR'), 1, 25), '000000') NR_ENDERECO_TOMADOR, 
	upper(coalesce(substr(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(a.cd_pessoa_fisica, cd_cgc, 'B'))), 1, 255), 'Bairro')) DS_BAIRRO_TOMADOR, 
	upper(coalesce(substr(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(a.cd_pessoa_fisica, cd_cgc, 'CI'))), 1, 255), 'Cidade')) DS_CIDADE_TOMADOR, 
	upper(coalesce(substr(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(a.cd_pessoa_fisica, cd_cgc, 'UF'))), 1, 255), 'UF')) DS_ESTADO_TOMADOR, 
	CASE WHEN coalesce(Obter_Valor_tipo_Tributo_Nota(a.nr_sequencia, 'V', 'ISS'),0)=0 THEN  0  ELSE 1 END  IE_IMPOSTO_RETIDO, 
	0 IE_TRIBUTADO_MUNICIPIO, 
	0 IE_ALIQUOTA_NACIONAL 
from 	nota_fiscal a, operacao_nota b 
where	a.cd_operacao_nf = b.cd_operacao_nf	 
and	a.ie_situacao in ('1') 
and	substr(obter_se_nota_entrada_saida(nr_sequencia),1,1) = 'E' 
and 	b.ie_servico = 'S';

