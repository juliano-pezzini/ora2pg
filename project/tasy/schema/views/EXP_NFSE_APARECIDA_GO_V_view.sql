-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW exp_nfse_aparecida_go_v (tp_registro, ds_registro, dt_competencia_mes, dt_competencia_ano, ds_geracao_nome_tmd, cd_item_lista_servico, ds_frase_fim, nr_inscricao_mun_tomador, cd_modelo, nr_documento, vl_tributavel, vl_documento, vl_aliquota, dt_emissao, cd_cgc_emitente, nm_razao_social, nr_inscricao_municipal, ie_imposto_retido, cd_cep, ds_endereco_prestador, nr_endereco_prestador, ds_bairro_prestador, ds_cidade, sg_estado, nr_ddd_telefone, ie_tributado_municipio, dt_pagamento, cd_estabelecimento, ds_sepador_fim) AS select  2 tp_registro,
		'H' ds_registro,
		to_char(a.dt_emissao, 'MM')		dt_competencia_mes,
		to_char(a.dt_emissao, 'YYYY')	dt_competencia_ano,
		to_char(a.dt_emissao,'hh24:mi') ||' '|| to_char(a.dt_emissao, 'dd/mm/yyyy') || '' || obter_nome_pf_pj(a.cd_pessoa_fisica, a.cd_cgc) ds_geracao_nome_tmd,
		obter_cod_grupo_ativ(a.cd_estabelecimento, a.nr_sequencia, 'G')	cd_item_lista_servico,
		'EXPORTACAO DECLARACAO ELETRONICA-ONLINE-NOTA CONTROL' ds_frase_fim,
		obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'IM') nr_inscricao_mun_tomador,
		'' cd_modelo,
		'' nr_documento,
		'' vl_tributavel,
		'' vl_documento,
		''	vl_aliquota,
		a.dt_emissao dt_emissao,
		'' cd_cgc_emitente,
		'' nm_razao_social,
		'' nr_inscricao_municipal,
		0 IE_IMPOSTO_RETIDO,
		'' cd_cep,
		'' ds_endereco_prestador,
		'' nr_endereco_prestador,
		'' ds_bairro_prestador,
		'' DS_CIDADE,
		'' sg_estado,
		'' nr_ddd_telefone,
		0 IE_TRIBUTADO_MUNICIPIO,
		null dt_pagamento,
		a.cd_estabelecimento,
		'' ds_sepador_fim
FROM	nota_fiscal a,
		operacao_nota o
where	a.cd_operacao_nf = o.cd_operacao_nf
and		a.ie_situacao in ('1')
and		substr(obter_se_nota_entrada_saida(a.nr_sequencia),1,1) = 'E'
and 	o.ie_servico = 'S'

union  all

select	3 tp_registro,
		'D' ds_registro,
		''	dt_competencia_mes,
		''	dt_competencia_ano,
		''  ds_geracao_nome_tmd,
		''	cd_item_lista_servico,
		'' 	ds_frase_fim,
		'' 	nr_inscricao_mun_tomador,
		'7' cd_modelo,
		a.nr_nota_fiscal nr_documento,
		CASE WHEN a.vl_mercadoria=0 THEN  '0.00'  ELSE replace(to_char(campo_mascara(a.vl_mercadoria, 2)),',','.') END  vl_tributavel,
		CASE WHEN a.vl_mercadoria=0 THEN  '0.00'  ELSE replace(to_char(campo_mascara(a.vl_mercadoria, 2)),',','.') END  vl_documento,
		campo_mascara(obter_valor_tipo_tributo_nota(a.nr_sequencia,'X','ISS'),2)	vl_aliquota,
		a.dt_emissao dt_emissao,
		a.cd_cgc_emitente cd_cgc_emitente,
		obter_nome_pf_pj(null, a.cd_cgc_emitente) nm_razao_social,
		obter_dados_pf_pj(null, a.cd_cgc_emitente, 'IM') nr_inscricao_municipal,
		CASE WHEN coalesce(Obter_Valor_tipo_Tributo_Nota(a.nr_sequencia, 'V', 'ISS'),0)=0 THEN  0  ELSE 1 END  IE_IMPOSTO_RETIDO,
		OBTER_DADOS_PF_PJ(null, a.cd_cgc_emitente, 'CEP') cd_cep,
		substr(OBTER_DADOS_PF_PJ(null, a.cd_cgc_emitente, 'E'),1,125) ds_endereco_prestador,
		substr(OBTER_DADOS_PF_PJ(null, a.cd_cgc_emitente, 'NR'),1,10) nr_endereco_prestador,
		substr(OBTER_DADOS_PF_PJ(null, a.cd_cgc_emitente, 'B'),1,60) ds_bairro_prestador,
		SUBSTR(obter_dados_pf_pj(null, a.cd_cgc_emitente, 'CI'),1,50) DS_CIDADE,
		substr(OBTER_DADOS_PF_PJ(null, a.cd_cgc_emitente, 'UF'),1,2) sg_estado,
		substr(OBTER_DADOS_PF_PJ(null, a.cd_cgc_emitente, 'DDT'),1,2) nr_ddd_telefone,
		0 IE_TRIBUTADO_MUNICIPIO,
		(	select	max(x.dt_vencimento)
			from	nota_fiscal_venc x
			where	a.nr_sequencia = x.nr_sequencia) dt_pagamento,
		a.cd_estabelecimento,
		'' ds_sepador_fim
from	nota_fiscal a,
		operacao_nota o
where	a.cd_operacao_nf = o.cd_operacao_nf
and		a.ie_situacao in ('1')
and		substr(obter_se_nota_entrada_saida(a.nr_sequencia),1,1) = 'E'
and 	o.ie_servico = 'S' LIMIT 1;

