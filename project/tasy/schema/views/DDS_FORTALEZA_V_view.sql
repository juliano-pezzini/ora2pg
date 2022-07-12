-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW dds_fortaleza_v (cd_estabelecimento, tp_registro, cd_inscricao_municipal, cd_versao, dt_referencia, dt_emissao, cd_serie_nf, cd_modelo, cd_natureza_operacao, nr_nota_fiscal, vl_bruto, vl_servico, ie_tipo_recolhimento, nr_nota_fiscal_deduzir, vl_bruto_deduzir, vl_deduzir, tx_tributo, nr_parcela, qt_parcela, ds_motivo_nao_retencao, nr_insc_munic_prestador, cd_cnpj_prestador, nr_cpf_prestador, nm_prestador, ie_tipo_rua, ds_endereco_prestador, nr_endereco_prestador, ds_compl_prestador, ie_tipo_bairro, ds_bairro_prestador, ds_municipio, sg_estado, cd_cep, cd_atividade_cnae, cd_subserie_nf, nr_nota_fiscal_final, ds_municipio_tomador, sg_estado_tomador, nr_insc_munic_tomador, cd_cnpj_tomador, nr_cpf_tomador, nm_tomador, ds_endereco_tomador, nr_endereco_tomador, ds_compl_tomador, ds_bairro_tomador, cd_cep_tomador, cd_operacao_nf) AS select	a.cd_estabelecimento,
	1 					tp_registro, 
	lpad(a.CD_INSCRICAO_MUNICIPAL,11,0) CD_INSCRICAO_MUNICIPAL, 
	'012'	 				cd_versao, 
	LOCALTIMESTAMP				dt_referencia, 
	to_date(null)				dt_emissao, 
	'0'					cd_serie_nf, 
	' ' 					cd_modelo, 
	'B' 					cd_natureza_operacao, 
	'0'					nr_nota_fiscal, 
	0		 			vl_bruto, 
	0		 			vl_servico, 
	'A' 					ie_tipo_recolhimento, 
	'0'					nr_nota_fiscal_deduzir, 
	0 					vl_bruto_deduzir, 
	0 					vl_deduzir, 
	0					tx_tributo, 
	0					nr_parcela, 
	0					qt_parcela, 
	' '					ds_motivo_nao_retencao, 
	'0'					NR_INSC_MUNIC_PRESTADOR, 
	'0'					cd_cnpj_prestador, 
	'0'					nr_cpf_prestador, 
	' '					nm_prestador, 
	'RUA' 					ie_tipo_rua, 
	' '					ds_endereco_prestador, 
	'0'					nr_endereco_prestador, 
	'0'					ds_compl_prestador, 
	'BAIRRO' 				ie_tipo_bairro, 
	' '					ds_bairro_prestador, 
	' '					ds_municipio, 
	' '					sg_estado, 
	' '					cd_cep, 
	'0'					cd_atividade_cnae, 
	' '					cd_subserie_nf, 
	'0'					nr_nota_fiscal_final, 
	' '					ds_municipio_tomador, 
	' '					sg_estado_tomador, 
	'0'					nr_insc_munic_tomador, 
	'0'					cd_cnpj_tomador, 
	'0'					nr_cpf_tomador, 
	' '					nm_tomador, 
	' '					ds_endereco_tomador, 
	'0'					nr_endereco_tomador, 
	' '					ds_compl_tomador, 
	' '					ds_bairro_tomador, 
	' '					cd_cep_tomador, 
	0					cd_operacao_nf 
FROM	estabelecimento_v a 

union
 
select	a.cd_estabelecimento			cd_estabelecimento, 
	2 					tp_registro, 
	'0'					CD_INSCRICAO_MUNICIPAL, 
	'100'	 				cd_versao, 
	LOCALTIMESTAMP					dt_referencia, 
	a.dt_emissao				dt_emissao, 
	a.cd_serie_nf				cd_serie_nf, 
	' ' 					cd_modelo, 
	coalesce(obter_conversao_externa(a.cd_cgc, 'NATUREZA_OPERACAO','CD_NATUREZA_OPERACAO', cd_natureza_operacao),'B') cd_natureza_operacao, 
	a.nr_nota_fiscal			nr_nota_fiscal, 
	a.vl_total_nota 			vl_bruto, 
	a.vl_mercadoria 			vl_servico, 
	'A' 					ie_tipo_recolhimento, 
	'0'					nr_nota_fiscal_deduzir, 
	0 					vl_bruto_deduzir, 
	0 					vl_deduzir, 
	0					tx_tributo, 
	0					nr_parcela, 
	0					qt_parcela, 
	' '					ds_motivo_nao_retencao, 
	coalesce(substr(obter_dados_pf_pj(null,a.cd_cgc,'IE'),1,20),'00000000000') NR_INSC_MUNIC_PRESTADOR, 
	coalesce(a.cd_cgc, '00000000000000') 	cd_cnpj_prestador, 
	coalesce(substr(obter_cpf_pessoa_fisica(a.cd_pessoa_fisica),1,14), '00000000000') 	nr_cpf_prestador, 
	coalesce(substr(obter_nome_pf(a.cd_pessoa_fisica),1,30), 'DIVERSOS') nm_prestador, 
	'RUA' 					ie_tipo_rua, 
	coalesce(substr(obter_compl_pf(a.cd_pessoa_fisica,1, 'EN'),1,30), 
		substr(OBTER_DADOS_PF_PJ(null, a.cd_cgc, 'E'),1,30)) ds_endereco_prestador, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc, 'NR'),1,10) nr_endereco_prestador, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc, 'CO'),1,30) ds_compl_prestador, 
	'BAIRRO' 				ie_tipo_bairro, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc, 'B'),1,30) ds_bairro_prestador, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc, 'CI'),1,30) ds_municipio, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc, 'UF'),1,2) sg_estado, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc, 'CEP'),1,10) cd_cep, 
	coalesce(substr(obter_dados_pf(a.cd_pessoa_fisica,'ATC'),1,9),'000000000') cd_atividade_cnae, 
	' '					cd_subserie_nf, 
	'0'					nr_nota_fiscal_final, 
	' '					ds_municipio_tomador, 
	' '					sg_estado_tomador, 
	'0'					nr_insc_munic_tomador, 
	'0'					cd_cnpj_tomador, 
	'0'					nr_cpf_tomador, 
	' '					nm_tomador, 
	' '					ds_endereco_tomador, 
	'0'					nr_endereco_tomador, 
	' '					ds_compl_tomador, 
	' '					ds_bairro_tomador, 
	' '					cd_cep_tomador, 
	a.cd_operacao_nf			cd_operacao_nf 
from	nota_fiscal a 
where	substr(Obter_Se_Nota_Entrada_Saida(a.nr_sequencia),1,1) = 'S' 

union
 
select	a.cd_estabelecimento			cd_estabelecimento, 
	4 					tp_registro, 
	'0'					CD_INSCRICAO_MUNICIPAL, 
	'100'	 				cd_versao, 
	LOCALTIMESTAMP				dt_referencia, 
	a.dt_emissao				dt_emissao, 
	a.cd_serie_nf				cd_serie_nf, 
	' ' 					cd_modelo, 
	coalesce(obter_conversao_externa(a.cd_cgc, 'NATUREZA_OPERACAO','CD_NATUREZA_OPERACAO', cd_natureza_operacao),'B') cd_natureza_operacao, 
	a.nr_nota_fiscal			nr_nota_fiscal, 
	a.vl_total_nota 			vl_bruto, 
	a.vl_mercadoria 			vl_servico, 
	'M' 					ie_tipo_recolhimento, 
	'0'					nr_nota_fiscal_deduzir, 
	0		 			vl_bruto_deduzir, 
	0		 			vl_deduzir, 
	0					tx_tributo, 
	0					nr_parcela, 
	0					qt_parcela, 
	' '					ds_motivo_nao_retencao, 
	coalesce(substr(obter_dados_pf_pj(null,a.cd_cgc_emitente,'IE'),1,20),'00000000000') NR_INSC_MUNIC_PRESTADOR, 
	coalesce(a.cd_cgc_emitente, '00000000000000') 	cd_cnpj_prestador, 
	coalesce(substr(obter_cpf_pessoa_fisica(a.cd_pessoa_fisica),1,14), '00000000000') 	nr_cpf_prestador, 
	coalesce(substr(obter_nome_pf(a.cd_pessoa_fisica),1,30), 'DIVERSOS') nm_prestador, 
	'RUA' 					ie_tipo_rua, 
	coalesce(substr(obter_compl_pf(a.cd_pessoa_fisica,1, 'EN'),1,30), 
		substr(OBTER_DADOS_PF_PJ(null, a.cd_cgc_emitente, 'E'),1,30)) ds_endereco_prestador, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc_emitente, 'NR'),1,10) nr_endereco_prestador, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc_emitente, 'CO'),1,40) ds_compl_prestador, 
	'BAIRRO' 				ie_tipo_bairro, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc_emitente, 'B'),1,30) ds_bairro_prestador, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc_emitente, 'CI'),1,30) ds_municipio, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc_emitente, 'UF'),1,2) sg_estado, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc_emitente, 'CEP'),1,10) cd_cep, 
	'0'					cd_atividade_cnae, 
	' '					cd_subserie_nf, 
	'0'					nr_nota_fiscal_final, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc, 'CI'),1,30) ds_municipio_tomador, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc, 'UF'),1,2) sg_estado_tomador, 
	coalesce(substr(obter_dados_pf_pj(null,a.cd_cgc,'IE'),1,20),'00000000000') nr_insc_munic_tomador, 
	coalesce(a.cd_cgc, '00000000000000') 	cd_cnpj_tomador, 
	coalesce(substr(obter_cpf_pessoa_fisica(a.cd_pessoa_fisica),1,14), '00000000000') 	nr_cpf_tomador, 
	coalesce(substr(obter_nome_pf(a.cd_pessoa_fisica),1,30), 'DIVERSOS') nm_tomador, 
	coalesce(substr(obter_compl_pf(a.cd_pessoa_fisica,1, 'EN'),1,30), 
		substr(OBTER_DADOS_PF_PJ(null, a.cd_cgc, 'E'),1,30)) ds_endereco_tomador, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc, 'NR'),1,10) nr_endereco_tomador, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc, 'CO'),1,40) ds_compl_tomador, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc, 'B'),1,30) ds_bairro_tomador, 
	substr(OBTER_DADOS_PF_PJ(a.cd_pessoa_fisica, a.cd_cgc, 'CEP'),1,10) cd_cep_tomador, 
	a.cd_operacao_nf			cd_operacao_nf 
from	nota_fiscal a 
where	substr(Obter_Se_Nota_Entrada_Saida(a.nr_sequencia),1,1) = 'E';
