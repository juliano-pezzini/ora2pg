-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW exp_rps_unimed_rp_v (tp_registro, assinatura, "naturezadaoperaçao", regimeespecialtributacao, optantesimplesnacional, incentivadorcultural, numerorps, serierps, tiporps, dt_emissao, statusrps, numerorpssubstituido, serierpssubstituido, valorservicos, valordeducoes, valorpis, valorcofins, valorinss, valorir, valorcsll, itemlistaservico, codigocnae, codigotributacaomunicipio, basecalculo, aliquotaservicos, valoriss, valorliquidonfse, outrasretencoes, issretido, valorissretido, valordescontoincondicionado, valordescontocondicionado, discriminacao, municipioprestacaoservico, cpfcnpjtomador, indicacaocpfcnpj, inscricaomunicipaltomador, razaosocialtomador, enderecotomador, numeroenderecotomador, complementoenderecotomador, bairrotomador, cidadetomador, uftomador, ceptomador, emailtomador, telefonetomador, razsocinterserv, incrmunintermserv, cnpjintermediarioservico, inscricaoprestador, cnpjprestador, codigoobra, art, estabelecimento) AS select	1					tp_registro,
	a.CD_ASSINATURA_RPS			Assinatura,
	SUBSTR(nfse_obter_regra('TP', a.cd_estabelecimento),1,2)  NaturezadaOPeraçao,
	SUBSTR(nfse_obter_regra('RET', a.cd_estabelecimento),1,2) RegimeEspecialTributacao,
	SUBSTR(nfse_obter_regra('OSN', a.cd_estabelecimento),1,2) OptanteSimplesNacional,
	SUBSTR(nfse_obter_regra('IC', a.cd_estabelecimento),1,2)  IncentivadorCultural,
	a.nr_rps				NumeroRPS,
	a.cd_serie_rps				SerieRPS,
	SUBSTR(nfse_obter_regra('TP', a.cd_estabelecimento),1,2)  TipoRPS,
	a.DT_EMISSAO_NFE			dt_emissao,
	a.ie_situacao				StatusRPS,
	0					NumeroRPSSubstituido,
	0					SerieRPSSubstituido,
	0	ValorServicos,
	0	ValorDeducoes,
	'' 	ValorPIS,
	'' 	ValorCOFINS,
	''	ValorINSS,
	'' 	ValorIR,
	'' 	ValorCSLL,
	''	itemListaServico,
	'' 	CodigoCNAE,
	'' 	CodigoTributacaoMunicipio,
	0	BaseCalculo,
	0 	AliquotaServicos,
	0 	ValorISS,
	0	VAlorliquidoNFSE,
	'' 	OutrasRetencoes,
	'' 	ISSRetido,
	0 	ValorISSRetido,
	'' 	ValorDescontoIncondicionado,
	'' 	ValorDescontoCondicionado,
	''	Discriminacao,
	''	MunicipioPrestacaoServico,
	''	CPFCNPJTomador,
	0	IndicacaoCPFCNPJ,
	''      InscricaoMunicipalTomador,
	'' 	RazaoSocialTomador,
	'' 	EnderecoTomador,
	'' 	NumeroEnderecoTomador,
	'' 	ComplementoEnderecoTomador,
	'' 	BairroTomador,
	'' 	CidadeTomador,
	''  	UFTomador,
	'' 	CEPTomador,
	'' 	EmailTomador,
	'' 	TelefoneTomador,
	''					RazSocInterServ,
	''					IncrMunIntermServ,
	''					CNPJIntermediarioServico,
	''					InscricaoPrestador,
	''		 			CNPJPrestador,
	''					CodigoObra,
	''		 			ART,
	a.cd_estabelecimento			estabelecimento
FROM	nota_fiscal a
where 	exists (
	select	1
	from	w_nota_fiscal x
	where	x.nr_seq_nota_fiscal = a.nr_sequencia)

union

select	2					tp_registro,
	''					Assinatura,
	''  					NaturezadaOPeraçao,
	'' 					RegimeEspecialTributacao,
	'' 					OptanteSimplesNacional,
	''  					IncentivadorCultural,
	''					NumeroRPS,
	''					SerieRPS,
	''  					TipoRPS,
	null					dt_emissao,
	''					StatusRPS,
	0					NumeroRPSSubstituido,
	0					SerieRPSSubstituido,
	n.vl_total_nota				ValorServicos,
	n.vl_descontos				ValorDeducoes,
	lpad(elimina_caractere_especial(nfe_obter_valores_totais_num(n.nr_sequencia, 'PIS', 'VL')), 15, 0) ValorPIS,
	LPAD(elimina_caractere_especial(nfe_obter_valores_totais_num(n.nr_sequencia, 'COFINS', 'VL')), 15, 0) ValorCOFINS,
	LPAD(elimina_caractere_especial(nfe_obter_valores_totais_num(n.nr_sequencia, 'INSS', 'VL')), 15, 0) ValorINSS,
	LPAD(elimina_caractere_especial(nfe_obter_valores_totais_num(n.nr_sequencia, 'IR', 'VL')), 15, 0) ValorIR,
	LPAD(elimina_caractere_especial(nfe_obter_valores_totais_num(n.nr_sequencia, '', 'VL')), 15, 0) ValorCSLL,
	o.nr_codigo_serv_prest			itemListaServico,
	LPAD(pls_obter_cd_cnae(obter_dados_pf_pj(NULL, n.cd_cgc_emitente,'CNAE')),7,' ') CodigoCNAE,
	obter_dados_grupo_servico_item(obter_item_servico_proced(obter_procedimento_nfse(n.nr_sequencia,'P'), obter_procedimento_nfse(n.nr_sequencia,'O')), 'CD') CodigoTributacaoMunicipio,
	n.vl_total_nota				BaseCalculo,
	obter_valor_tributo_nota(n.nr_sequencia,'X') AliquotaServicos,
	Obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'V', 'ISSQN') ValorISS,
	n.vl_total_nota				VAlorliquidoNFSE,
	lpad(elimina_caracteres_especiais(obter_valor_tipo_tributo_nota(n.nr_sequencia, 'V', 'O')),15,0) OutrasRetencoes,
	substr(obter_se_nf_retem_iss(n.nr_sequencia),1,1) ISSRetido,
	obter_Valor_tipo_Tributo_Nota(n.nr_sequencia, 'V', 'ISSQN') ValorISSRetido,
	lpad(elimina_caracteres_especiais(n.vl_descontos),15,0) ValorDescontoIncondicionado,
	lpad(elimina_caracteres_especiais(0),15,0) 	ValorDescontoCondicionado,
	coalesce(replace(replace(substr(obter_descricao_rps(n.cd_estabelecimento, n.nr_sequencia, 'DS_SERVICOS'), 1, 1000), chr(13), ' '), chr(10), ' '), 'Servicos') Discriminacao,
	LPAD(obter_tom_municipio_ibge(obter_dados_pf_pj(NULL, n.cd_cgc_emitente, 'CDM')),15,0) MunicipioPrestacaoServico,
	''	CPFCNPJTomador,
	0	IndicacaoCPFCNPJ,
	''      InscricaoMunicipalTomador,
	'' 	RazaoSocialTomador,
	'' 	EnderecoTomador,
	'' 	NumeroEnderecoTomador,
	'' 	ComplementoEnderecoTomador,
	'' 	BairroTomador,
	'' 	CidadeTomador,
	''  	UFTomador,
	'' 	CEPTomador,
	'' 	EmailTomador,
	'' 	TelefoneTomador,
	''					RazSocInterServ,
	''					IncrMunIntermServ,
	''					CNPJIntermediarioServico,
	''					InscricaoPrestador,
	''		 			CNPJPrestador,
	''					CodigoObra,
	''		 			ART,
	n.cd_estabelecimento			estabelecimento
from	operacao_nota o,
	nota_fiscal n
where 	exists (
	select	1
	from	w_nota_fiscal x
	where	x.nr_seq_nota_fiscal = n.nr_sequencia)
AND	o.cd_operacao_nf = n.cd_operacao_nf

union

select	3					tp_registro,
	''					Assinatura,
	''  					NaturezadaOPeraçao,
	'' 					RegimeEspecialTributacao,
	'' 					OptanteSimplesNacional,
	''  					IncentivadorCultural,
	''					NumeroRPS,
	''					SerieRPS,
	''  					TipoRPS,
	null					dt_emissao,
	''					StatusRPS,
	0					NumeroRPSSubstituido,
	0					SerieRPSSubstituido,
	0					ValorServicos,
	0					ValorDeducoes,
	'' 					ValorPIS,
	'' 					ValorCOFINS,
	'' 					ValorINSS,
	'' 					ValorIR,
	'' 					ValorCSLL,
	''					itemListaServico,
	'' 					CodigoCNAE,
	'' 					CodigoTributacaoMunicipio,
	0					BaseCalculo,
	0					AliquotaServicos,
	0 					ValorISS,
	0					VAlorliquidoNFSE,
	'' 					OutrasRetencoes,
	'' 					ISSRetido,
	0 					ValorISSRetido,
	'' 					ValorDescontoIncondicionado,
	'' 					ValorDescontoCondicionado,
	'' 					Discriminacao,
	'' 					MunicipioPrestacaoServico,
	n.cd_cgc				CPFCNPJTomador,
	3					IndicacaoCPFCNPJ,
	substr(obter_dados_pf_pj(null,n.cd_cgc,'IM'),1,10) InscricaoMunicipalTomador,
	substr(obter_dados_pf_pj(null,n.cd_cgc,'N'),1,10) RazaoSocialTomador,
	substr(obter_dados_pf_pj(NULL,n.cd_cgc,'LO'),1,5) || ' - ' || substr(obter_dados_pf_pj(NULL,n.cd_cgc,'R'),1,50) EnderecoTomador,
	substr(obter_dados_pf_pj(NULL,n.cd_cgc,'NR'),1,10) NumeroEnderecoTomador,
	substr(obter_dados_pf_pj(NULL,n.cd_cgc,'CO'),1,40) ComplementoEnderecoTomador,
	substr(obter_dados_pf_pj(NULL,n.cd_cgc,'B'),1,50)  BairroTomador,
	LPAD(obter_tom_municipio_ibge(obter_dados_pf_pj(NULL, n.cd_cgc, 'CDM')),15,0) CidadeTomador,
	substr(obter_dados_pf_pj(NULL,n.cd_cgc,'UF'),1,2)  UFTomador,
	to_char(somente_numero(substr(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CEP'),1,15))) CEPTomador,
	substr(obter_dados_pf_pj(NULL,n.cd_cgc,'M'),1,200) EmailTomador,
	substr(obter_dados_pf_pj(NULL,n.cd_cgc,'T'),1,200) TelefoneTomador,
	''					RazSocInterServ,
	''					IncrMunIntermServ,
	''					CNPJIntermediarioServico,
	''					InscricaoPrestador,
	''		 			CNPJPrestador,
	''					CodigoObra,
	''		 			ART,
	n.cd_estabelecimento			estabelecimento
from	operacao_nota o,
	nota_fiscal n
where 	exists (
	select	1
	from	w_nota_fiscal x
	where	x.nr_seq_nota_fiscal = n.nr_sequencia)
AND	o.cd_operacao_nf = n.cd_operacao_nf

union

select	4					tp_registro,
	''					Assinatura,
	''  					NaturezadaOPeraçao,
	'' 					RegimeEspecialTributacao,
	'' 					OptanteSimplesNacional,
	''  					IncentivadorCultural,
	''					NumeroRPS,
	''					SerieRPS,
	''  					TipoRPS,
	null					dt_emissao,
	''					StatusRPS,
	0					NumeroRPSSubstituido,
	0					SerieRPSSubstituido,
	0					ValorServicos,
	0					ValorDeducoes,
	''					ValorPIS,
	'' 					ValorCOFINS,
	'' 					ValorINSS,
	'' 					ValorIR,
	'' 					ValorCSLL,
	''					itemListaServico,
	'' 					CodigoCNAE,
	'' 					CodigoTributacaoMunicipio,
	0					BaseCalculo,
	0 					AliquotaServicos,
	0 					ValorISS,
	0					VAlorliquidoNFSE,
	'' 					OutrasRetencoes,
	'' 					ISSRetido,
	0 					ValorISSRetido,
	'' 					ValorDescontoIncondicionado,
	'' 					ValorDescontoCondicionado,
	'' 					Discriminacao,
	'' 					MunicipioPrestacaoServico,
	''					CPFCNPJTomador,
	0					IndicacaoCPFCNPJ,
	''      				InscricaoMunicipalTomador,
	'' 					RazaoSocialTomador,
	'' 					EnderecoTomador,
	'' 					NumeroEnderecoTomador,
	'' 					ComplementoEnderecoTomador,
	'' 					BairroTomador,
	'' 					CidadeTomador,
	''  					UFTomador,
	'' 					CEPTomador,
	'' 					EmailTomador,
	'' 					TelefoneTomador,
	'0'					RazSocInterServ,
	'0'					IncrMunIntermServ,
	'0'					CNPJIntermediarioServico,
	''					InscricaoPrestador,
	''		 			CNPJPrestador,
	''					CodigoObra,
	''		 			ART,
	n.cd_estabelecimento			estabelecimento
from	operacao_nota o,
	nota_fiscal n
where 	exists (
	select	1
	from	w_nota_fiscal x
	where	x.nr_seq_nota_fiscal = n.nr_sequencia)
AND	o.cd_operacao_nf = n.cd_operacao_nf

union

select	5					tp_registro,
	''					Assinatura,
	''  					NaturezadaOPeraçao,
	'' 					RegimeEspecialTributacao,
	'' 					OptanteSimplesNacional,
	''  					IncentivadorCultural,
	''					NumeroRPS,
	''					SerieRPS,
	''  					TipoRPS,
	null					dt_emissao,
	''					StatusRPS,
	0					NumeroRPSSubstituido,
	0					SerieRPSSubstituido,
	0					ValorServicos,
	0					ValorDeducoes,
	''					ValorPIS,
	'' 					ValorCOFINS,
	'' 					ValorINSS,
	'' 					ValorIR,
	'' 					ValorCSLL,
	''					itemListaServico,
	'' 					CodigoCNAE,
	'' 					CodigoTributacaoMunicipio,
	0					BaseCalculo,
	0 					AliquotaServicos,
	0 					ValorISS,
	0					VAlorliquidoNFSE,
	'' 					OutrasRetencoes,
	'' 					ISSRetido,
	0 					ValorISSRetido,
	'' 					ValorDescontoIncondicionado,
	'' 					ValorDescontoCondicionado,
	'' 					Discriminacao,
	'' 					MunicipioPrestacaoServico,
	''					CPFCNPJTomador,
	0					IndicacaoCPFCNPJ,
	''      				InscricaoMunicipalTomador,
	'' 					RazaoSocialTomador,
	'' 					EnderecoTomador,
	'' 					NumeroEnderecoTomador,
	'' 					ComplementoEnderecoTomador,
	'' 					BairroTomador,
	'' 					CidadeTomador,
	''  					UFTomador,
	'' 					CEPTomador,
	'' 					EmailTomador,
	'' 					TelefoneTomador,
	''					RazSocInterServ,
	''					IncrMunIntermServ,
	''					CNPJIntermediarioServico,
	substr(obter_dados_pf_pj(null,n.cd_cgc_emitente,'IM'),1,10) InscricaoPrestador,
	n.cd_cgc_emitente 			CNPJPrestador,
	''					CodigoObra,
	''		 			ART,
	n.cd_estabelecimento			estabelecimento
from	operacao_nota o,
	nota_fiscal n
where 	exists (
	select	1
	from	w_nota_fiscal x
	where	x.nr_seq_nota_fiscal = n.nr_sequencia)
AND	o.cd_operacao_nf = n.cd_operacao_nf

union

select	6					tp_registro,
	''					Assinatura,
	''  					NaturezadaOPeraçao,
	'' 					RegimeEspecialTributacao,
	'' 					OptanteSimplesNacional,
	''  					IncentivadorCultural,
	''					NumeroRPS,
	''					SerieRPS,
	''  					TipoRPS,
	null					dt_emissao,
	''					StatusRPS,
	0					NumeroRPSSubstituido,
	0					SerieRPSSubstituido,
	0					ValorServicos,
	0					ValorDeducoes,
	''					ValorPIS,
	'' 					ValorCOFINS,
	'' 					ValorINSS,
	'' 					ValorIR,
	'' 					ValorCSLL,
	''					itemListaServico,
	'' 					CodigoCNAE,
	'' 					CodigoTributacaoMunicipio,
	0					BaseCalculo,
	0 					AliquotaServicos,
	0 					ValorISS,
	0					VAlorliquidoNFSE,
	'' 					OutrasRetencoes,
	'' 					ISSRetido,
	0 					ValorISSRetido,
	'' 					ValorDescontoIncondicionado,
	'' 					ValorDescontoCondicionado,
	'' 					Discriminacao,
	'' 					MunicipioPrestacaoServico,
	''					CPFCNPJTomador,
	0					IndicacaoCPFCNPJ,
	''      				InscricaoMunicipalTomador,
	'' 					RazaoSocialTomador,
	'' 					EnderecoTomador,
	'' 					NumeroEnderecoTomador,
	'' 					ComplementoEnderecoTomador,
	'' 					BairroTomador,
	'' 					CidadeTomador,
	''  					UFTomador,
	'' 					CEPTomador,
	'' 					EmailTomador,
	'' 					TelefoneTomador,
	''					RazSocInterServ,
	''					IncrMunIntermServ,
	''					CNPJIntermediarioServico,
	''					InscricaoPrestador,
	''		 			CNPJPrestador,
	'0'					CodigoObra,
	'0'		 			ART,
	n.cd_estabelecimento			estabelecimento
from	operacao_nota o,
	nota_fiscal n
where 	exists (
	select	1
	from	w_nota_fiscal x
	where	x.nr_seq_nota_fiscal = n.nr_sequencia)
AND	o.cd_operacao_nf = n.cd_operacao_nf;
