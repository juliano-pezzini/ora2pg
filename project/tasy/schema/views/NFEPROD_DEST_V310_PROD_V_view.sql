-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW nfeprod_dest_v310_prod_v (nr_sequencia, cnpj, email, cpf, idestrangeiro, xnome, xfant, ie, indiedest, iest, im, cnae, crt, xlgr, nro, xcpl, xbairro, cmun, xmun, uf, cep, cpais, xpais, fone, cd_pessoa_fisica) AS select 	a.nr_sequencia nr_sequencia,
		CASE WHEN a.cd_cgc IS NULL THEN null  ELSE LPAD(a.cd_cgc,14,0) END  CNPJ,
		tax_limit_content(substr(nfse_obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'MC'),1,60), ';') email,
		CASE WHEN a.cd_cgc IS NULL THEN LPAD(Obter_Cpf_Pessoa_Fisica(a.cd_pessoa_fisica),11,0)  ELSE null END  CPF, 
		CASE WHEN obter_se_pf_pj_estrangeiro(a.cd_pessoa_fisica, a.cd_cgc)='S' THEN  		CASE WHEN a.cd_pessoa_fisica IS NULL THEN obter_dados_pf_pj(null,a.cd_cgc,'CINT')  ELSE obter_dados_pf(cd_pessoa_fisica,'PA') END   ELSE null END  idEstrangeiro,
		tiss_eliminar_caractere(elimina_acentuacao(substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_NOME_PF(a.cd_pessoa_fisica)  ELSE nfe_obter_dados_pj(a.cd_cgc,'RZ') END ,1,60))) xNome,	
		elimina_caractere_especial(elimina_acentos(substr(CASE WHEN a.cd_cgc IS NULL THEN ''  ELSE nfe_obter_dados_pj(a.cd_cgc,'NM') END ,1,60))) xFant, 	
		substr(CASE WHEN  upper(CASE WHEN a.cd_cgc IS NULL THEN ''  ELSE nfe_obter_dados_pj(a.cd_cgc,'IN') END )='ISENTO' THEN 				null  ELSE CASE WHEN a.cd_cgc IS NULL THEN ''  ELSE nfe_obter_dados_pj(a.cd_cgc,'IN') END  END ,1,14) IE,
		CASE WHEN obter_se_pf_pj_estrangeiro(a.cd_pessoa_fisica, a.cd_cgc)='S' THEN '9'  ELSE CASE WHEN upper(CASE WHEN a.cd_cgc IS NULL THEN ''  ELSE nfe_obter_dados_pj(a.cd_cgc,'IN') END )='ISENTO' THEN '2' WHEN upper(CASE WHEN a.cd_cgc IS NULL THEN ''  ELSE nfe_obter_dados_pj(a.cd_cgc,'IN') END ) IS NULL THEN '9'  ELSE coalesce(nfe_obter_dados_pj(a.cd_cgc,'TC'),1) END  END  indIEDest,
		null IEST, 	
		null IM, 	
		null CNAE, 	
		'3' CRT, 	
		elimina_caractere_especial(elimina_acentos(substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'EN')  ELSE nfe_obter_dados_pj(a.cd_cgc,'EN') END ,1,60))) xLgr, 	
		substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'NR')  ELSE nfe_obter_dados_pj(a.cd_cgc,'NR') END ,1,60) nro, 	
		elimina_caractere_especial(elimina_acentos(substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'CO')  ELSE nfe_obter_dados_pj(a.cd_cgc,'CM') END ,1,60))) xCpl, 	
		elimina_caractere_especial(elimina_acentos(substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'B')  ELSE nfe_obter_dados_pj(a.cd_cgc,'BA') END ,1,60))) xBairro, 
		LPAD(substr(CASE WHEN a.cd_cgc IS NULL THEN  nfse_obter_compl_pf(a.cd_pessoa_fisica,'CDMDV')  ELSE nfe_obter_dados_pj(a.cd_cgc,'IBGE') END ,1,60),7,'0') cMun, 	
		substr(nfe_elimina_caractere_especial(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'DM')  ELSE nfe_obter_dados_pj(a.cd_cgc,'MU') END ),1,60) xMun, 	
		substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'UF')  ELSE nfe_obter_dados_pj(a.cd_cgc,'UF') END ,1,2) UF, 	
		substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'CEP')  ELSE nfe_obter_dados_pj(a.cd_cgc,'CEP') END ,1,8) CEP, 
		'1058' cPais, 
		'BRASIL' xPais, 
		Elimina_Caracteres_Especiais(substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'DDT') ||OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'T')  ELSE nfe_obter_dados_pj(a.cd_cgc,'DDDT') END ,1,14)) fone, 
		a.cd_pessoa_fisica 
	FROM 	nota_fiscal a,
		natureza_operacao n
	where	a.cd_natureza_operacao = n.cd_natureza_operacao
	and (n.ie_tipo_natureza <> 'I' and  n.ie_tipo_natureza <> 'E') 
	and     	obter_se_nota_entrada_nfe(a.nr_sequencia) = 'N'
	
union    all

	select 	a.nr_sequencia nr_sequencia,
		--decode(n.ie_tipo_natureza, 'E', decode(a.cd_cgc,null,null,LPAD(a.cd_cgc,14,0)), null)  CNPJ,         

		null CNPJ,
		tax_limit_content(substr(nfse_obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'MC'),1,60), ';') email,
		CASE WHEN a.cd_cgc IS NULL THEN LPAD(Obter_Cpf_Pessoa_Fisica(a.cd_pessoa_fisica),11,0)  ELSE null END  CPF, 	
		CASE WHEN obter_se_pf_pj_estrangeiro(a.cd_pessoa_fisica, a.cd_cgc)='S' THEN  		CASE WHEN a.cd_pessoa_fisica IS NULL THEN obter_dados_pf_pj(null,a.cd_cgc,'CINT')  ELSE obter_dados_pf(cd_pessoa_fisica,'PA') END   ELSE null END  idEstrangeiro,
		tiss_eliminar_caractere(elimina_acentuacao(substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_NOME_PF(a.cd_pessoa_fisica)  ELSE nfe_obter_dados_pj(a.cd_cgc,'RZ') END ,1,60))) xNome, 	
		substr(CASE WHEN a.cd_cgc IS NULL THEN ''  ELSE nfe_obter_dados_pj(a.cd_cgc,'NM') END ,1,60) xFant, 	
		'' IE,
		CASE WHEN obter_se_pf_pj_estrangeiro(a.cd_pessoa_fisica, a.cd_cgc)='S' THEN '9'  ELSE '2' END  indIEDest,
		null IEST, 	
		null IM, 	
		null CNAE, 	
		'3' CRT, 	
		elimina_caractere_especial(elimina_acentos(substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'EN')  ELSE nfe_obter_dados_pj(a.cd_cgc,'EN') END ,1,60))) xLgr, 	
		substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'NR')  ELSE nfe_obter_dados_pj(a.cd_cgc,'NR') END ,1,60) nro, 	
		elimina_caractere_especial(elimina_acentos(substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'CO')  ELSE nfe_obter_dados_pj(a.cd_cgc,'CM') END ,1,60))) xCpl, 	
		elimina_caractere_especial(elimina_acentos(substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'B')  ELSE nfe_obter_dados_pj(a.cd_cgc,'BA') END ,1,60))) xBairro, 
		'9999999' cMun, 	
		'EXTERIOR' xMun, 	
		'EX' UF, 	
		substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'CEP')  ELSE nfe_obter_dados_pj(a.cd_cgc,'CEP') END ,1,8) CEP,
		substr(lpad(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'CPAIS')   ELSE obter_dados_pf_pj(null, a.cd_cgc, 'CDPAIS') END , 4,'0' ),1, 9) cPais, 
		substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'PAIS')  ELSE obter_dados_pf_pj(null, a.cd_cgc, 'PAIS') END , 1, 60)  xPais, 
		Elimina_Caracteres_Especiais(substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'DDT') ||OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'T')  ELSE nfe_obter_dados_pj(a.cd_cgc,'DDDT') END ,1,14)) fone, 
		a.cd_pessoa_fisica
	from 	nota_fiscal a,
		natureza_operacao n
	where	a.cd_natureza_operacao = n.cd_natureza_operacao
	and     	obter_se_nota_entrada_nfe(a.nr_sequencia) = 'N'
	and (n.ie_tipo_natureza = 'I' or n.ie_tipo_natureza = 'E')
	
union  all
  
	select 		a.nr_sequencia nr_sequencia,
		CASE WHEN a.cd_cgc_emitente IS NULL THEN null  ELSE LPAD(a.cd_cgc_emitente,14,0) END  CNPJ,         
		tax_limit_content(substr(nfse_obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc_emitente,'MC'),1,60), ';') email,
		CASE WHEN a.cd_cgc_emitente IS NULL THEN LPAD(Obter_Cpf_Pessoa_Fisica(a.cd_pessoa_fisica),11,0)  ELSE null END  CPF, 
		CASE WHEN obter_se_pf_pj_estrangeiro(a.cd_pessoa_fisica, a.cd_cgc_emitente)='S' THEN  		CASE WHEN a.cd_pessoa_fisica IS NULL THEN obter_dados_pf_pj(null,a.cd_cgc_emitente,'CINT')  ELSE obter_dados_pf(cd_pessoa_fisica,'PA') END   ELSE null END  idEstrangeiro,
		tiss_eliminar_caractere(elimina_acentuacao(substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_NOME_PF(a.cd_pessoa_fisica)  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'RZ') END ,1,60))) xNome,	
		elimina_caractere_especial(elimina_acentos(substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN ''  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'NM') END ,1,60))) xFant, 	
		substr(CASE WHEN  upper(CASE WHEN a.cd_cgc_emitente IS NULL THEN ''  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'IN') END )='ISENTO' THEN 				null  ELSE CASE WHEN a.cd_cgc_emitente IS NULL THEN ''  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'IN') END  END ,1,14) IE,
		CASE WHEN obter_se_pf_pj_estrangeiro(a.cd_pessoa_fisica, a.cd_cgc_emitente)='S' THEN '9'  ELSE CASE WHEN upper(CASE WHEN a.cd_cgc_emitente IS NULL THEN ''  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'IN') END )='ISENTO' THEN '2' WHEN upper(CASE WHEN a.cd_cgc_emitente IS NULL THEN ''  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'IN') END ) IS NULL THEN '9'  ELSE coalesce(nfe_obter_dados_pj(a.cd_cgc,'TC'),1) END  END  indIEDest,
		null IEST, 	
		null IM, 	
		null CNAE, 	
		'3' CRT, 	
		elimina_caractere_especial(elimina_acentos(substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'EN')  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'EN') END ,1,60))) xLgr, 	
		substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'NR')  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'NR') END ,1,60) nro, 	
		elimina_caractere_especial(elimina_acentos(substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'CO')  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'CM') END ,1,60))) xCpl, 	
		elimina_caractere_especial(elimina_acentos(substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'B')  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'BA') END ,1,60))) xBairro, 
		LPAD(substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN nfse_obter_compl_pf(a.cd_pessoa_fisica,'CDMDV')  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'IBGE') END ,1,60),7,'0') cMun, 	
		substr(nfe_elimina_caractere_especial(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'DM')  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'MU') END ),1,60) xMun, 	
		substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'UF')  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'UF') END ,1,2) UF, 	
		substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'CEP')  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'CEP') END ,1,8) CEP, 
		'1058' cPais, 
		'BRASIL' xPais, 
		Elimina_Caracteres_Especiais(substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'DDT') ||OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'T')  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'DDDT') END ,1,14)) fone, 
		a.cd_pessoa_fisica 
	from 	nota_fiscal a,
		natureza_operacao n
	where	a.cd_natureza_operacao = n.cd_natureza_operacao
	and     	obter_se_nota_entrada_nfe(a.nr_sequencia) = 'S'
	and (n.ie_tipo_natureza <> 'I' and n.ie_tipo_natureza <> 'E') 
	
union   all

	select 	a.nr_sequencia nr_sequencia,
		CASE WHEN n.ie_tipo_natureza='E' THEN  CASE WHEN a.cd_cgc_emitente IS NULL THEN null  ELSE LPAD(a.cd_cgc_emitente,14,0) END   ELSE null END  CNPJ,         
		tax_limit_content(substr(nfse_obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc_emitente,'MC'),1,60), ';') email,
		CASE WHEN a.cd_cgc_emitente IS NULL THEN LPAD(Obter_Cpf_Pessoa_Fisica(a.cd_pessoa_fisica),11,0)  ELSE null END  CPF, 	
		CASE WHEN obter_se_pf_pj_estrangeiro(a.cd_pessoa_fisica, a.cd_cgc_emitente)='S' THEN  		CASE WHEN a.cd_pessoa_fisica IS NULL THEN obter_dados_pf_pj(null,a.cd_cgc_emitente,'CINT')  ELSE obter_dados_pf(cd_pessoa_fisica,'PA') END   ELSE null END  idEstrangeiro,
		tiss_eliminar_caractere(elimina_acentuacao(substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_NOME_PF(a.cd_pessoa_fisica)  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'RZ') END ,1,60))) xNome, 	
		substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN ''  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'NM') END ,1,60) xFant, 	
		'' IE,
		CASE WHEN obter_se_pf_pj_estrangeiro(a.cd_pessoa_fisica, a.cd_cgc_emitente)='S' THEN '9'  ELSE '2' END  indIEDest,
		null IEST, 	
		null IM, 	
		null CNAE, 	
		'3' CRT, 	
		elimina_caractere_especial(elimina_acentos(substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'EN')  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'EN') END ,1,60))) xLgr, 	
		substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'NR')  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'NR') END ,1,60) nro, 	
		elimina_caractere_especial(elimina_acentos(substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'CO')  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'CM') END ,1,60))) xCpl, 	
		elimina_caractere_especial(elimina_acentos(substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'B')  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'BA') END ,1,60))) xBairro, 
		'9999999' cMun, 	
		'EXTERIOR' xMun, 	
		'EX' UF, 	
		substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'CEP')  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'CEP') END ,1,8) CEP,
		substr(lpad(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'CPAIS')   ELSE obter_dados_pf_pj(null, a.cd_cgc_emitente, 'CDPAIS') END , 4,'0' ),1, 9) cPais, 
		substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'PAIS')  ELSE obter_dados_pf_pj(null, a.cd_cgc_emitente, 'PAIS') END , 1, 60)  xPais, 
		Elimina_Caracteres_Especiais(substr(CASE WHEN a.cd_cgc_emitente IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'DDT') ||OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'T')  ELSE nfe_obter_dados_pj(a.cd_cgc_emitente,'DDDT') END ,1,14)) fone, 
		a.cd_pessoa_fisica
	from 	nota_fiscal a,
		natureza_operacao n
	where	a.cd_natureza_operacao = n.cd_natureza_operacao
	and     	obter_se_nota_entrada_nfe(a.nr_sequencia) = 'S'
	and (n.ie_tipo_natureza = 'I' or n.ie_tipo_natureza = 'E');

