-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW nfse_saoluis_v (nr_seq_nota, assinatura, inscricaomunicipalprestador, razaosocialprestador, tiporps, serierps, numerorps, dataemissaorps, situacaorps, serierpssubstituido, numerorpssubstituido, numeronfsesubstituida, dataemissaonfsesubstituida, serieprestacao, inscricaomunicipaltomador, cpfcnpjtomador, razaosocialtomador, tipologradourotomador, logradourotomador, numeroenderecotomador, complementoenderecotomador, tipobairrotomador, bairrotomador, cidadetomador, cidadetomadordescricao, ceptomador, emailtomador, codigoatividade, codigoservico, aliquotaatividade, tiporecolhimento, municipioprestacao, municipioprestacaodescricao, operacao, tributacao, valorpis, valorcofins, valorinss, valorir, valorcsll, aliquotapis, aliquotacofins, aliquotainss, aliquotair, aliquotacsll, descricaorps, dddprestador, telefoneprestador, dddtomador, telefonetomador, motcancelamento, cpfcnpjintermediario, deducaopor, tipodeducao, cpfcnpjreferencia, numeronfreferencia, valortotalreferencia, percentualdeduzir, valordeduzir) AS select	a.nr_sequencia nr_seq_nota,
	lower(a.cd_assinatura_rps) Assinatura, 
	coalesce(substr(lpad(obter_dados_pf_pj('', a.cd_cgc_emitente, 'IM'), 9, '0'), 1, 30), '0000000') InscricaoMunicipalPrestador, 
	substr(tiss_eliminar_caractere(elimina_acentuacao(obter_nome_pf_pj('', a.cd_cgc_emitente))), 1, 255) RazaoSocialPrestador, 
	'RPS' TipoRPS, 
	a.cd_serie_nf SerieRPS, 
	a.nr_nota_fiscal NumeroRPS, 
	to_char(a.dt_emissao, 'yyyy-mm-dd') || 'T' || to_char(a.dt_emissao, 'hh:mi:ss') DataEmissaoRPS, 
	CASE WHEN a.ie_situacao=1 THEN  'N' WHEN a.ie_situacao=2 THEN  'C' WHEN a.ie_situacao=3 THEN  'C'  ELSE 'N' END  SituacaoRPS, 
	'' SerieRPSSubstituido, 
	'' NumeroRPSSubstituido, 
	'' NumeroNFSeSubstituida, 
	'' DataEmissaoNFSeSubstituida, 
	99 SeriePrestacao, 
	CASE WHEN  		obter_desc_municipio_ibge( 			CASE WHEN 	obter_municipio_ibge(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'CEP'))=0 THEN  				obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'CDM')  ELSE obter_municipio_ibge(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'CEP')) END )='SAOLUIS' THEN  		CASE WHEN cd_cgc='' THEN  coalesce(lpad(obter_dados_pf(cd_pessoa_fisica, 'ISS'), 7, '0'), '0000000')  ELSE coalesce(lpad(substr(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'IM'), 1, 30), 7, '0'), '0000000') END   ELSE '0000000' END  InscricaoMunicipalTomador,	 
	CASE WHEN cd_cgc='' THEN  CASE WHEN obter_se_brasileiro(cd_pessoa_fisica)='N' THEN  '77777777777'  ELSE coalesce(substr(obter_dados_pf(cd_pessoa_fisica, 'CPF'), 1, 11), '00000000000') END   ELSE CASE WHEN obter_se_pf_pj_estrangeiro(null,cd_cgc)='N' THEN cd_cgc  ELSE '77777777777' END  END  CPFCNPJTomador, 
	substr(tiss_eliminar_caractere(elimina_acentuacao(obter_nome_pf_pj(cd_pessoa_fisica, cd_cgc))), 1, 255) RazaoSocialTomador, 
	'Rua' TipoLogradouroTomador, 
	coalesce(substr(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'EN'))), 1, 50), 'Endereco') LogradouroTomador, 
	coalesce(substr(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'NR'), 1, 25), '00') NumeroEnderecoTomador, 
	coalesce(substr(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'CO'))), 1, 30), 'Complemento') ComplementoEnderecoTomador, 
	'Bairro' TipoBairroTomador, 
	coalesce(substr(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'B'))), 1, 255), 'Bairro') BairroTomador,	 
	CASE WHEN substr(obter_dados_pf_pj(cd_pessoa_fisica,cd_cgc,'UF'),1,2)='IN' THEN '0009999'  ELSE lpad((obter_siafi_municipio_ibge(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'CDM'))), 8, '0') END  CidadeTomador,	 
	substr( 
	CASE WHEN substr(obter_dados_pf_pj(cd_pessoa_fisica,cd_cgc,'UF'),1,2)='IN' THEN obter_dados_pf_pj( cd_pessoa_fisica, cd_cgc, 'PAIS')  ELSE obter_desc_municipio_ibge( 			CASE WHEN  				obter_municipio_ibge(elimina_caracteres_especiais(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'CEP')))=0 THEN  				obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'CDM')  ELSE obter_municipio_ibge(elimina_caracteres_especiais(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'CEP'))) END  		) END  
	, 1, 50) CidadeTomadorDescricao, 
	lpad(somente_numero(substr(obter_dados_pf_pj(cd_pessoa_fisica, cd_cgc, 'CEP'), 1, 15)), 8, '0') CEPTomador,	 
	coalesce(substr(tiss_eliminar_caractere(elimina_acentuacao(obter_dados_pf_pj_estab(a.cd_estabelecimento,cd_pessoa_fisica, cd_cgc, 'M'))), 1, 80), '-') EmailTomador, 
	obter_dados_pf_pj_estab(a.cd_estabelecimento, null, a.cd_cgc_emitente, 'ATIV') CodigoAtividade, 
	substr(lpad(obter_cod_grupo_ativ(a.cd_estabelecimento, a.nr_sequencia, 'C'), 5, '0'), 1, 5) CodigoServico, 
	coalesce(campo_mascara(obter_valor_tipo_tributo_nota(a.nr_sequencia, 'X', 'ISS'),2),'2.00') AliquotaAtividade, 
	CASE WHEN cd_cgc='' THEN  'A'  ELSE CASE WHEN obter_se_pj_retem_iss(a.cd_cgc, a.cd_estabelecimento)='S' THEN  'R'  ELSE 'A' END  END  TipoRecolhimento,	 
	coalesce(obter_siafi_municipio_ibge(UDI_obter_cd_ibg(a.cd_cgc_emitente)),0) MunicipioPrestacao, 
	'SAOLUIS' MunicipioPrestacaoDescricao, 
	'A' Operacao, 
	CASE WHEN obter_dados_parametro_compras(a.cd_estabelecimento, 14)='1' THEN  'T' WHEN obter_dados_parametro_compras(a.cd_estabelecimento, 14)='2' THEN  'T' WHEN obter_dados_parametro_compras(a.cd_estabelecimento, 14)='3' THEN  'C' WHEN obter_dados_parametro_compras(a.cd_estabelecimento, 14)='4' THEN  'F'  ELSE 'K' END  Tributacao, 
	CASE WHEN cd_cgc='' THEN  0  ELSE obter_valor_tipo_tributo_nota(a.nr_sequencia, 'V', 'PIS') END  ValorPIS, 
	CASE WHEN cd_cgc='' THEN  0  ELSE obter_valor_tipo_tributo_nota(a.nr_sequencia, 'V', 'COFINS') END  ValorCOFINS, 
	CASE WHEN cd_cgc='' THEN  0  ELSE obter_valor_tipo_tributo_nota(a.nr_sequencia, 'V', 'INSS') END  ValorINSS, 
	CASE WHEN cd_cgc='' THEN  0  ELSE obter_valor_tipo_tributo_nota(a.nr_sequencia, 'V', 'IR') END  ValorIR, 
	CASE WHEN cd_cgc='' THEN  0  ELSE obter_valor_tipo_tributo_nota(a.nr_sequencia, 'V', 'CSLL') END  ValorCSLL, 
	CASE WHEN cd_cgc='' THEN  0  ELSE obter_valor_tipo_tributo_nota(a.nr_sequencia, 'X', 'PIS') END  AliquotaPIS, 
	CASE WHEN cd_cgc='' THEN  0  ELSE obter_valor_tipo_tributo_nota(a.nr_sequencia, 'X', 'COFINS') END  AliquotaCOFINS, 
	CASE WHEN cd_cgc='' THEN  0  ELSE obter_valor_tipo_tributo_nota(a.nr_sequencia, 'X', 'INSS') END  AliquotaINSS, 
	CASE WHEN cd_cgc='' THEN  0  ELSE obter_valor_tipo_tributo_nota(a.nr_sequencia, 'X', 'IR') END  AliquotaIR, 
	CASE WHEN cd_cgc='' THEN  0  ELSE obter_valor_tipo_tributo_nota(a.nr_sequencia, 'X', 'CSLL') END  AliquotaCSLL,	 
	coalesce(substr(obter_descricao_rps(a.cd_estabelecimento, a.nr_sequencia, 'DS_SERVICOS'), 1, 1500), 'Servicos prestados') DescricaoRPS, 
	obter_dados_pf_pj('', a.cd_cgc_emitente, 'DDT') DDDPrestador, 
	substr(Elimina_Caracteres_Especiais(obter_dados_pf_pj('', a.cd_cgc_emitente, 'T')), 1, 8) TelefonePrestador, 
	obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'DDT') DDDTomador, 
	substr(Elimina_Caracteres_Especiais(obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc, 'T')), 1, 8) TelefoneTomador, 
	CASE WHEN a.ie_situacao=2 THEN  'ERRO DE DIGITACAO' WHEN a.ie_situacao=3 THEN  'ERRO DE DIGITACAO'  ELSE '' END  MotCancelamento, 
	'' CPFCNPJIntermediario, 
	CASE WHEN a.vl_descontos=0 THEN  null  ELSE 'Valor' END  DeducaoPor, 
	CASE WHEN a.vl_descontos=0 THEN  null  ELSE 'Despesas com Materiais' END  TipoDeducao, 
	null CPFCNPJReferencia, 
	null NumeroNFReferencia, 
	null ValorTotalReferencia, 
	CASE WHEN a.vl_descontos=0 THEN  null  ELSE '0.00' END  PercentualDeduzir, 
	CASE WHEN a.vl_descontos=0 THEN  null  ELSE campo_mascara(a.vl_descontos, 2) END ValorDeduzir 
FROM 	nota_fiscal_lote_nfe l, 
		nfe_transmissao_nf n, 
		nfe_transmissao t, 
		nota_fiscal a 
where	l.nr_seq_transmissao = t.nr_sequencia 
and	t.nr_sequencia	= n.nr_seq_transmissao 
and	a.nr_sequencia = n.nr_seq_nota_fiscal 
and	t.nr_sequencia = (select max(nr_sequencia) from nfe_transmissao) 
and	l.nr_sequencia = (select max(nr_sequencia) from nota_fiscal_lote_nfe) 
order by 
	a.nr_nota_fiscal;

