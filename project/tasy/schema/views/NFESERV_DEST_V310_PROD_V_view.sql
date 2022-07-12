-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW nfeserv_dest_v310_prod_v (cnpj, email, cpf, idestrangeiro, xnome, xfant, ie, indiedest, iest, im, cnae, crt, xlgr, nro, xcpl, xbairro, cmun, xmun, uf, cep, cpais, xpais, fone, cd_pessoa_fisica, nr_sequencia) AS select 	CASE WHEN a.cd_cgc IS NULL THEN null  ELSE CASE WHEN obter_se_pf_pj_estrangeiro(null,a.cd_cgc)='N' THEN LPAD(a.cd_cgc,14,0)  ELSE null END  END  CNPJ,
		substr(elimina_caractere_esp_asc(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'M'),'S','N'),1,60) email,
		CASE WHEN a.cd_cgc IS NULL THEN CASE WHEN obter_se_pf_pj_estrangeiro(a.cd_pessoa_fisica,null)='N' THEN LPAD(Obter_Cpf_Pessoa_Fisica(a.cd_pessoa_fisica),11,0)  ELSE null END   ELSE null END  CPF, 
		CASE WHEN obter_se_pf_pj_estrangeiro(a.cd_pessoa_fisica, a.cd_cgc)='S' THEN  
		elimina_acentos(substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_NOME_PF(a.cd_pessoa_fisica)  ELSE nfe_obter_dados_pj(a.cd_cgc,'RZ') END ,1,60)) xNome, 	
		elimina_acentos(substr(CASE WHEN a.cd_cgc IS NULL THEN ''  ELSE nfe_obter_dados_pj(a.cd_cgc,'NM') END ,1,60)) xFant, 	
		substr(CASE WHEN  upper(CASE WHEN a.cd_cgc IS NULL THEN ''  ELSE CASE WHEN obter_se_pf_pj_estrangeiro(null,a.cd_cgc)='N' THEN nfe_obter_dados_pj(a.cd_cgc,'IN')  ELSE null END  END )='ISENTO' THEN 
		CASE WHEN obter_se_pf_pj_estrangeiro(a.cd_pessoa_fisica, a.cd_cgc)='S' THEN '9'  ELSE CASE WHEN upper(CASE WHEN a.cd_cgc IS NULL THEN ''  ELSE nfe_obter_dados_pj(a.cd_cgc,'IN') END )='ISENTO' THEN '2' WHEN upper(CASE WHEN a.cd_cgc IS NULL THEN ''  ELSE nfe_obter_dados_pj(a.cd_cgc,'IN') END ) IS NULL THEN '9'  ELSE coalesce(nfe_obter_dados_pj(a.cd_cgc,'TC'),1) END  END  indIEDest,
		null IEST, 
		null IM, 
		null CNAE, 
		'3' CRT, 	
		elimina_acentos(substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'EN')  ELSE nfe_obter_dados_pj(a.cd_cgc,'EN') END ,1,60)) xLgr, 	
		substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'NR')  ELSE nfe_obter_dados_pj(a.cd_cgc,'NR') END ,1,60) nro, 	
		substr(elimina_caractere_esp_asc(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'CO')  ELSE nfe_obter_dados_pj(a.cd_cgc,'CM') END ,'S','N'),1,60) xCpl, 	
		substr(elimina_caractere_esp_asc(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'B')  ELSE nfe_obter_dados_pj(a.cd_cgc,'BA') END ,'S','N'),1,60) xBairro,	
		CASE WHEN nfse_obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'UF')='DF' THEN '5300108' WHEN nfse_obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'UF')='IN' THEN '9999999'  ELSE coalesce(nfse_obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'CDMNF'),nfse_obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'CDMDV')) END  cMun,
		substr(elimina_caractere_esp_asc(CASE WHEN a.cd_cgc IS NULL THEN  CASE WHEN obter_se_pf_pj_estrangeiro(a.cd_pessoa_fisica,null)='N' THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'DM')  ELSE 'EXTERIOR' END   ELSE CASE WHEN obter_se_pf_pj_estrangeiro(null,a.cd_cgc)='N' THEN nfe_obter_dados_pj(a.cd_cgc,'MU')  ELSE 'EXTERIOR' END  END ,'S','N'),1,60) xMun, 	
		substr(CASE WHEN a.cd_cgc IS NULL THEN CASE WHEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'UF')='IN' THEN 'EX'  ELSE OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'UF') END   ELSE CASE WHEN nfe_obter_dados_pj(a.cd_cgc,'UF')='IN' THEN 'EX'  ELSE nfe_obter_dados_pj(a.cd_cgc,'UF') END  END ,1,2) UF, 	
		substr(CASE WHEN a.cd_cgc IS NULL THEN CASE WHEN obter_se_pf_pj_estrangeiro(a.cd_pessoa_fisica,null)='N' THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'CEP')  ELSE null END   ELSE CASE WHEN obter_se_pf_pj_estrangeiro(null,a.cd_cgc)='N' THEN nfe_obter_dados_pj(a.cd_cgc,'CEP')  ELSE null END  END ,1,8) CEP, 
		CASE WHEN a.cd_cgc IS NULL THEN CASE WHEN obter_se_pf_pj_estrangeiro(a.cd_pessoa_fisica,null)='N' THEN '1058'  ELSE obter_dados_pf_pj(a.cd_pessoa_fisica,null,'CBPAIS') END   ELSE CASE WHEN obter_se_pf_pj_estrangeiro(null,a.cd_cgc)='N' THEN '1058'  ELSE lpad(obter_dados_pf_pj(null,a.cd_cgc,'CDPAIS'),4,'0') END  END  cPais,
		elimina_caractere_esp_asc(CASE WHEN a.cd_cgc IS NULL THEN CASE WHEN obter_se_pf_pj_estrangeiro(a.cd_pessoa_fisica,null)='N' THEN 'BRASIL'  ELSE obter_nome_pais_bacen(obter_dados_pf_pj(a.cd_pessoa_fisica,null,'CBPAIS')) END   ELSE CASE WHEN obter_se_pf_pj_estrangeiro(null,a.cd_cgc)='N' THEN 'BRASIL'  ELSE obter_dados_pf_pj(null,a.cd_cgc,'PAIS') END  END ,'S','N') xPais, 
		Elimina_Caracteres_Especiais(substr(CASE WHEN a.cd_cgc IS NULL THEN OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'DDT') ||OBTER_COMPL_PF(a.cd_pessoa_fisica,1,'T')  ELSE nfe_obter_dados_pj(a.cd_cgc,'DDDT') END ,1,14)) fone, 
		a.cd_pessoa_fisica,
		a.nr_sequencia
	FROM 	nota_fiscal a,
		natureza_operacao n
	where	a.cd_natureza_operacao = n.cd_natureza_operacao;
