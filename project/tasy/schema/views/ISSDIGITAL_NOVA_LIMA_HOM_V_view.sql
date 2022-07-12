-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW issdigital_nova_lima_hom_v (tp_registro, dt_geracao_arquivo, cd_inscricao_municipal, cd_cgc, ds_razao_social, nr_arquivo, nr_versao_arquivo, ie_envio_arquivo, nm_sistema_envio, nr_linha, cd_cgc_emitente, ie_prestador, dt_competencia, nr_nota_fiscal_inicial, cd_serie_nf, nr_nota_fiscal_final, dt_dia, ie_tipo_lancamento, vl_total_nota, cd_atividade, ie_tipo_escrituracao, cd_estabelecimento, dt_emissao) AS select	distinct
	0					tp_registro, 
	LOCALTIMESTAMP					dt_geracao_arquivo, 
	a.cd_inscricao_municipal			cd_inscricao_municipal,		 
	a.cd_cgc					cd_cgc, 
	a.ds_razao_social				ds_razao_social, 
	1					nr_arquivo, 
	'0202'					nr_versao_arquivo, 
	'T'					ie_envio_arquivo, 
	'ISSDigital'				nm_sistema_envio, 
	null					nr_linha, 
	''					cd_cgc_emitente, 
	''					ie_prestador, 
	null					dt_competencia, 
	null					nr_nota_fiscal_inicial, 
	''					cd_serie_nf, 
	null					nr_nota_fiscal_final, 
	null					dt_dia, 
	''					ie_tipo_lancamento, 
	null					vl_total_nota, 
	''					cd_atividade, 
	''					ie_tipo_escrituracao, 
	a.cd_estabelecimento, 
	null					dt_emissao 
FROM	estabelecimento_v a 

union
 
select	distinct 
	1 					tp_registro, 
	LOCALTIMESTAMP					dt_geracao_arquivo, 
	obter_dados_pf_pj(null, a.cd_cgc_emitente,'IM') cd_inscricao_municipal, 
	''					cd_cgc, 
	''					ds_razao_social, 
	1					nr_arquivo, 
	''					nr_versao_arquivo, 
	''					ie_envio_arquivo, 
	''					nm_sistema_envio, 
	null					nr_linha, 
	a.cd_cgc_emitente				cd_cgc_emitente, 
	'P'					ie_prestador, 
	to_char(a.dt_emissao, 'YYYYMM')		dt_competencia, 
	lpad(coalesce(a.nr_nota_fiscal, 0), 8, 0)		nr_nota_fiscal_inicial, 
	a.cd_serie_nf				cd_serie_nf, 
	lpad(coalesce(a.nr_nota_fiscal, 0), 8, 0)		nr_nota_fiscal_final, 
	to_char(a.dt_emissao, 'dd')			dt_dia, 
	CASE WHEN obter_se_nf_retem_iss(a.nr_sequencia)='N' THEN  'I' WHEN obter_se_nf_retem_iss(a.nr_sequencia)=obter_se_nf_retem_iss(a.nr_sequencia) THEN 'S' WHEN obter_se_nf_retem_iss(a.nr_sequencia)='T' THEN  'C' END 	ie_tipo_lancamento, 
	a.vl_total_nota				vl_total_nota, 
	'003020008'				cd_atividade, 
	'N' 					ie_tipo_escrituracao, 
	a.cd_estabelecimento, 
	a.dt_emissao	 
from	nota_fiscal a 
where	substr(obter_se_nota_entrada_saida(a.nr_sequencia),1,1) = 'S' 

union
 
select	distinct 
	9 					tp_registro, 
	null					dt_geracao_arquivo, 
	''					cd_inscricao_municipal,		 
	''					cd_cgc, 
	''					ds_razao_social, 
	1					nr_arquivo, 
	''					nr_versao_arquivo, 
	''					ie_envio_arquivo, 
	''					nm_sistema_envio, 
	''					nr_linha, 
	''					cd_cgc_emitente, 
	''					ie_prestador, 
	null					dt_competencia, 
	null					nr_nota_fiscal_inicial, 
	''					cd_serie_nf, 
	null					nr_nota_fiscal_final, 
	null					dt_dia, 
	''					ie_tipo_lancamento, 
	null					vl_total_nota, 
	''					cd_atividade, 
	''					ie_tipo_escrituracao, 
	a.cd_estabelecimento, 
	null					dt_emissao 
from	estabelecimento_v a;
