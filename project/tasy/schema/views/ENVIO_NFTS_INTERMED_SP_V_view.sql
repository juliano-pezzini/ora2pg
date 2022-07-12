-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW envio_nfts_intermed_sp_v (tp_registro, ds_versao_arquivo, nr_inscricao_munic, ds_tipo_nfts, cd_serie_nf, nr_nota_fiscal, dt_emissao, ie_situacao, cd_tributacao, vl_servico, vl_descontos, cd_servico, cd_subitem_servico, vl_aliquota, ie_iss_retido, ie_cpf_cnpj, cd_cpf_cnpj, nr_inscricao_munic_prestador, nm_prestador, ds_tipo_logradouro, ds_endereco, nr_endereco, ds_complemento, ds_bairro, ds_municipio, sg_estado, cd_cep, ds_email, tp_nfts, regime_tributacao, dt_pagamento_nota, ds_servicos, qt_linhas, cd_estabelecimento, cd_cgc_emitente, cd_operacao_nf, dt_entrada_saida, ie_tipo_nota, cd_natureza_operacao, cd_convenio, indcpfcnpjtomador, cpfcnpjtomador, razaosocialtomador, nr_sequencia) AS SELECT	
		'1'		tp_registro, 
		'001'	ds_versao_arquivo, 
		coalesce(SUBSTR(obter_dados_pf_pj(NULL, cd_cgc, 'IM'), 1, 8), 00000000) nr_inscricao_munic, 
		''   ds_tipo_nfts, 
		''   cd_serie_nf, 
		'0'  nr_nota_fiscal, 
		NULL  dt_emissao, 
		''   ie_situacao, 
		''		cd_tributacao, 
		NULL	vl_servico, 
		NULL	vl_descontos, 
		''   	cd_servico, 
		NULL 	cd_subitem_servico, 
		NULL  vl_aliquota, 
		''		ie_iss_retido, 
		NULL	ie_cpf_cnpj,    
		NULL 	cd_cpf_cnpj, 
		''	  	nr_inscricao_munic_prestador, 
		''		nm_prestador, 
		''   ds_tipo_logradouro, 
		''		ds_endereco, 
		''		nr_endereco, 
		''		ds_complemento, 
		''		ds_bairro, 
		''		ds_municipio, 
		''		sg_estado, 
		''		cd_cep, 
		''		ds_email, 
		''  	tp_nfts, 
		''		regime_tributacao, 
		' '		dt_pagamento_nota, 
		''		ds_servicos, 
		NULL  qt_linhas, 
		cd_estabelecimento, 
		'' cd_cgc_emitente, 
		null 	cd_operacao_nf, 
		null	dt_entrada_saida, 
		null	ie_tipo_nota, 
		null	cd_natureza_operacao, 
		null	cd_convenio, 
		null 	indCpfCnpjTomador, 
		null 	cpfCnpjTomador, 
		null 	razaoSocialTomador, 
		null 	nr_sequencia 
FROM 	estabelecimento 
WHERE	1 = 1 

UNION
 
SELECT	'4'   			 	 			tp_registro, 
	''				 	 			ds_versao_arquivo, 
	NULL					 			nr_inscricao_munic, 
--	DECODE(obter_dados_grupo_servico_item(obter_item_servico_pj(cd_cgc_emitente),'F'),'S','01',DECODE(obter_dados_operacao_nota--(n.cd_operacao_nf,'8'),'S','02','03'))   ds_tipo_nfts, -- verificar 
	--DECODE(obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'CDM'),355030,'03','02') ds_tipo_nfts, 
	coalesce(substr(obter_dados_pj_inf_trib('DOC',n.cd_cgc_emitente),1,2),'00') ds_tipo_nfts, 
	n.cd_serie_nf    			 			cd_serie_nf, 
	substr(n.nr_nota_fiscal,1,12)    		 			nr_nota_fiscal, 
	TRUNC(n.dt_emissao)   		 			dt_emissao, 
	CASE WHEN n.ie_situacao=9 THEN 'C' WHEN n.ie_situacao=2 THEN 'C' WHEN n.ie_situacao=3 THEN 'C' WHEN n.ie_situacao=1 THEN 'N' END  			ie_situacao, 
	obter_trib_serv_item(n.cd_cgc_emitente)				 	cd_tributacao, 
	CASE WHEN n.ie_situacao=1 THEN  n.vl_mercadoria WHEN n.ie_situacao=3 THEN  CASE WHEN n.ie_status_envio IS NULL THEN  n.vl_mercadoria  ELSE 0 END   ELSE 0 END  vl_servico, 
	n.vl_descontos     					vl_descontos, 
	obter_dados_grupo_servico_item(obter_item_servico_pj(cd_cgc_emitente),'CD') cd_servico, 
	elimina_caracteres_especiais(obter_dados_grupo_servico_item(obter_item_servico_pj(cd_cgc_emitente),'P')) cd_subitem_servico,		 
	lpad(elimina_caracteres_especiais(campo_mascara(obter_valor_tipo_tributo_nota(n.nr_sequencia,'X','ISS'),2)),4,0)	vl_aliquota, 		 
	CASE WHEN SUBSTR(obter_se_nf_retem_iss(n.nr_sequencia),1,1)='S' THEN '1'  ELSE '2' END 	ie_iss_retido, 
	CASE WHEN n.cd_pessoa_fisica IS NULL THEN 2  ELSE CASE WHEN obter_cpf_pessoa_fisica(n.cd_pessoa_fisica) IS NULL THEN 3  ELSE 1 END  END  ie_cpf_cnpj,    
	LPAD(CASE WHEN n.cd_cgc_emitente IS NULL THEN  SUBSTR(obter_dados_pf(n.cd_pessoa_fisica, 'CPF'),1,11)  ELSE n.cd_cgc_emitente END ,14,'0') cd_cpf_cnpj, 
	CASE WHEN obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'CDM')=355030 THEN SUBSTR(obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'IM'),1,8)  ELSE '00000000' END  			nr_inscricao_munic_prestador, 
	SUBSTR(obter_razao_social(n.cd_cgc_emitente),1,75) 		 	nm_prestador, 
	'rua'     						 	ds_tipo_logradouro, 
	obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'R') 	     	ds_endereco, 
	SUBSTR(obter_dados_pf_pj(NULL, n.cd_cgc_emitente, 'NR'),1,10) 	 	nr_endereco, 
	SUBSTR(obter_dados_pf_pj(NULL, n.cd_cgc_emitente, 'CO'),1,30)	 	ds_complemento, 
	SUBSTR(obter_dados_pf_pj(NULL, n.cd_cgc_emitente, 'B'),1,30) 	 	ds_bairro, 
	SUBSTR(obter_dados_pf_pj(NULL, n.cd_cgc_emitente, 'CI'),1,50)	 	ds_municipio, 
	SUBSTR(obter_dados_pf_pj(NULL, n.cd_cgc_emitente, 'UF'),1,2) 	 	sg_estado, 
	SUBSTR(elimina_caracteres_especiais(obter_dados_pf_pj(NULL, n.cd_cgc_emitente, 'CEP')),1,15)	 	cd_cep, 
	SUBSTR(obter_dados_pf_pj_estab(n.cd_estabelecimento,NULL,n.cd_cgc_emitente,'M'),1,75)	 	ds_email, 
	'2'  							 	tp_nfts, 
	CASE WHEN obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'TT')='7' THEN '4' WHEN obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'TT')='0' THEN '4' WHEN obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'TT')='6' THEN '0' WHEN obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'TT')='8' THEN '5'  ELSE '0' END  regime_tributacao,       
	' '					 		dt_pagamento_nota, 
	coalesce(replace(replace(substr(obter_descricao_rps(n.cd_estabelecimento, n.nr_sequencia, 'DS_SERVICOS'), 1, 1000), chr(13), '|'), chr(10), '|'), 'Servicos') ds_servicos, 
	NULL     		qt_linhas, 
	n.cd_estabelecimento, 
	n.cd_cgc_emitente 	cd_cgc_emitente, 
	o.cd_operacao_nf 	cd_operacao_nf, 
	n.dt_entrada_saida	dt_entrada_saida, 
	n.ie_tipo_nota		ie_tipo_nota, 
	n.cd_natureza_operacao	cd_natureza_operacao, 
	coalesce(obter_convenio_nf(n.nr_sequencia),n.cd_conv_integracao) cd_convenio, 
	null 	indCpfCnpjTomador, 
	null 	cpfCnpjTomador, 
	null 	razaoSocialTomador, 
	n.nr_sequencia nr_sequencia 
FROM	operacao_nota o, 
	nota_fiscal n, 
	estabelecimento e, 
	pessoa_juridica p 
WHERE 	o.cd_operacao_nf = n.cd_operacao_nf 
AND	e.cd_estabelecimento = n.cd_estabelecimento 
AND 	n.cd_cgc_emitente = p.cd_cgc 
AND	n.ie_tipo_nota <> 'EF' 
and	exists ( select	1 
		from	w_nota_fiscal x 
		where	x.nr_seq_nota_fiscal = n.nr_sequencia) 

UNION
 
SELECT	'4'   			 	 			tp_registro, 
	''				 	 			ds_versao_arquivo, 
	NULL					 			nr_inscricao_munic, 
    coalesce(substr('01',1,2),'00') 					ds_tipo_nfts, 
	n.cd_serie_nf    			 			cd_serie_nf, 
	substr(n.nr_nota_fiscal,1,12)    		 	    nr_nota_fiscal, 
	TRUNC(n.dt_emissao)   		 			dt_emissao, 
	CASE WHEN n.ie_situacao=9 THEN 'C' WHEN n.ie_situacao=2 THEN 'C' WHEN n.ie_situacao=3 THEN 'C' WHEN n.ie_situacao=1 THEN 'N' END  			ie_situacao, 
	'T'								cd_tributacao, 
	CASE WHEN n.ie_situacao=1 THEN  n.vl_mercadoria WHEN n.ie_situacao=3 THEN  CASE WHEN n.ie_status_envio IS NULL THEN  n.vl_mercadoria  ELSE 0 END   ELSE 0 END  vl_servico, 
	n.vl_descontos     					vl_descontos, 
	obter_dados_grupo_servico_item(obter_item_serv_matproc_nf(n.nr_sequencia),'CD') cd_servico, 
	elimina_caracteres_especiais(obter_dados_grupo_servico_item(obter_item_serv_matproc_nf(n.nr_sequencia),'P')) cd_subitem_servico,		 
	lpad(elimina_caracteres_especiais(campo_mascara(obter_valor_tipo_tributo_nota(n.nr_sequencia,'X','ISS'),2)),4,0)	vl_aliquota, 		 
	CASE WHEN SUBSTR(obter_se_nf_retem_iss(n.nr_sequencia),1,1)='S' THEN '1'  ELSE '2' END 	ie_iss_retido, 
	CASE WHEN n.cd_pessoa_fisica IS NULL THEN 2  ELSE CASE WHEN obter_cpf_pessoa_fisica(n.cd_pessoa_fisica) IS NULL THEN 3  ELSE 1 END  END  ie_cpf_cnpj,    
	LPAD(CASE WHEN n.cd_cgc_emitente IS NULL THEN  SUBSTR(obter_dados_pf(n.cd_pessoa_fisica, 'CPF'),1,11)  ELSE n.cd_cgc_emitente END ,14,'0') cd_cpf_cnpj, 
	CASE WHEN obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'CDM')=355030 THEN SUBSTR(obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'IM'),1,8)  ELSE '00000000' END  			nr_inscricao_munic_prestador, 
	SUBSTR(obter_nome_pf_pj(n.cd_pessoa_fisica, null),1,75) 			nm_prestador, 
	'rua'     						 			ds_tipo_logradouro, 
	nfse_obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'EN')	     	ds_endereco, 
	SUBSTR(nfse_obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'NR'),1,10) 	nr_endereco, 
	SUBSTR(nfse_obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CO'),1,30)		ds_complemento, 
	SUBSTR(nfse_obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'B'),1,30) 		ds_bairro, 
	SUBSTR(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc_emitente, 'CI'),1,50)	ds_municipio, 
	SUBSTR(nfse_obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'UF'),1,2) 		sg_estado, 
	SUBSTR(elimina_caracteres_especiais(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc_emitente, 'CEP')),1,15)	 	cd_cep, 
	SUBSTR(obter_dados_pf_pj_estab(n.cd_estabelecimento,n.cd_pessoa_fisica,n.cd_cgc_emitente,'M'),1,75)	 		ds_email, 
	'2'  														 	tp_nfts, 
	CASE WHEN obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc_emitente,'TT')='7' THEN '4' WHEN obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc_emitente,'TT')='0' THEN '4' WHEN obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc_emitente,'TT')='6' THEN '0' WHEN obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc_emitente,'TT')='8' THEN '5'  ELSE '0' END  		regime_tributacao,       
	' '					 										dt_pagamento_nota, 
	coalesce(replace(replace(substr(obter_descricao_rps(n.cd_estabelecimento, n.nr_sequencia, 'DS_SERVICOS'), 1, 1000), chr(13), '|'), chr(10), '|'), 'Servicos') ds_servicos, 
	NULL     		qt_linhas, 
	n.cd_estabelecimento, 
	n.cd_cgc_emitente 	cd_cgc_emitente, 
	o.cd_operacao_nf 	cd_operacao_nf, 
	n.dt_entrada_saida	dt_entrada_saida, 
	n.ie_tipo_nota		ie_tipo_nota, 
	n.cd_natureza_operacao	cd_natureza_operacao, 
	coalesce(obter_convenio_nf(n.nr_sequencia),n.cd_conv_integracao) cd_convenio, 
	null 	indCpfCnpjTomador, 
	null 	cpfCnpjTomador, 
	null 	razaoSocialTomador, 
	n.nr_sequencia nr_sequencia 
FROM	operacao_nota o, 
	nota_fiscal n, 
	estabelecimento e, 
	pessoa_fisica p 
WHERE 	o.cd_operacao_nf = n.cd_operacao_nf 
AND	e.cd_estabelecimento = n.cd_estabelecimento 
AND 	n.cd_pessoa_fisica = p.cd_pessoa_fisica 
AND	n.ie_tipo_nota = 'EF' 
and	exists ( select	1 
		from	w_nota_fiscal x 
		where	x.nr_seq_nota_fiscal = n.nr_sequencia) 

UNION
 
SELECT		'6'	tp_registro, 
		null	ds_versao_arquivo, 
		NULL					 			nr_inscricao_munic, 
	--	DECODE(obter_dados_grupo_servico_item(obter_item_servico_pj(cd_cgc_emitente),'F'),'S','01',DECODE(obter_dados_operacao_nota--(n.cd_operacao_nf,'8'),'S','02','03'))   ds_tipo_nfts, -- verificar 
		--DECODE(obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'CDM'),355030,'03','02') ds_tipo_nfts, 
		coalesce(substr(obter_dados_pj_inf_trib('DOC',n.cd_cgc_emitente),1,2),'00') ds_tipo_nfts, 
		n.cd_serie_nf    			 			cd_serie_nf, 
		substr(n.nr_nota_fiscal,1,12)    		 			nr_nota_fiscal, 
		TRUNC(n.dt_emissao)   		 			dt_emissao, 
		CASE WHEN n.ie_situacao=9 THEN 'C' WHEN n.ie_situacao=2 THEN 'C' WHEN n.ie_situacao=3 THEN 'C' WHEN n.ie_situacao=1 THEN 'N' END  			ie_situacao, 
		obter_trib_serv_item(n.cd_cgc_emitente)				 	cd_tributacao, 
		CASE WHEN n.ie_situacao=1 THEN  n.vl_mercadoria WHEN n.ie_situacao=3 THEN  CASE WHEN n.ie_status_envio IS NULL THEN  n.vl_mercadoria  ELSE 0 END   ELSE 0 END  vl_servico, 
		n.vl_descontos     					vl_descontos, 
		obter_dados_grupo_servico_item(obter_item_servico_pj(cd_cgc_emitente),'CD') cd_servico, 
		elimina_caracteres_especiais(obter_dados_grupo_servico_item(obter_item_servico_pj(cd_cgc_emitente),'P')) cd_subitem_servico,		 
		lpad(elimina_caracteres_especiais(campo_mascara(obter_valor_tipo_tributo_nota(n.nr_sequencia,'X','ISS'),2)),4,0)	vl_aliquota, 		 
		CASE WHEN SUBSTR(obter_se_nf_retem_iss(n.nr_sequencia),1,1)='S' THEN '1'  ELSE '2' END 	ie_iss_retido, 
		CASE WHEN n.cd_pessoa_fisica IS NULL THEN 2  ELSE CASE WHEN obter_cpf_pessoa_fisica(n.cd_pessoa_fisica) IS NULL THEN 3  ELSE 1 END  END  ie_cpf_cnpj,    
		LPAD(CASE WHEN n.cd_cgc_emitente IS NULL THEN  SUBSTR(obter_dados_pf(n.cd_pessoa_fisica, 'CPF'),1,11)  ELSE n.cd_cgc_emitente END ,14,'0') cd_cpf_cnpj, 
		CASE WHEN obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'CDM')=355030 THEN SUBSTR(obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'IM'),1,8)  ELSE '00000000' END  			nr_inscricao_munic_prestador, 
		SUBSTR(obter_razao_social(n.cd_cgc_emitente),1,75) 		 	nm_prestador, 
		'rua'     						 	ds_tipo_logradouro, 
		obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'R') 	     	ds_endereco, 
		SUBSTR(obter_dados_pf_pj(NULL, n.cd_cgc_emitente, 'NR'),1,10) 	 	nr_endereco, 
		SUBSTR(obter_dados_pf_pj(NULL, n.cd_cgc_emitente, 'CO'),1,30)	 	ds_complemento, 
		SUBSTR(obter_dados_pf_pj(NULL, n.cd_cgc_emitente, 'B'),1,30) 	 	ds_bairro, 
		SUBSTR(obter_dados_pf_pj(NULL, n.cd_cgc_emitente, 'CI'),1,50)	 	ds_municipio, 
		SUBSTR(obter_dados_pf_pj(NULL, n.cd_cgc_emitente, 'UF'),1,2) 	 	sg_estado, 
		SUBSTR(elimina_caracteres_especiais(obter_dados_pf_pj(NULL, n.cd_cgc_emitente, 'CEP')),1,15)	 cd_cep, 
		SUBSTR(obter_dados_pf_pj_estab(n.cd_estabelecimento,NULL,n.cd_cgc_emitente,'M'),1,75)	 	ds_email, 
		'2'  							 					tp_nfts, 
		CASE WHEN obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'TT')='7' THEN '4' WHEN obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'TT')='0' THEN '4' WHEN obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'TT')='6' THEN '0' WHEN obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'TT')='8' THEN '5'  ELSE '0' END  regime_tributacao,       
		' '					 		dt_pagamento_nota, 
		coalesce(replace(replace(substr(obter_descricao_rps(n.cd_estabelecimento, n.nr_sequencia, 'DS_SERVICOS'), 1, 1000), chr(13), '|'), chr(10), '|'), 'Servicos') ds_servicos, 
		NULL     		qt_linhas, 
		n.cd_estabelecimento, 
		n.cd_cgc_emitente 	cd_cgc_emitente, 
		o.cd_operacao_nf 	cd_operacao_nf, 
		n.dt_entrada_saida	dt_entrada_saida, 
		n.ie_tipo_nota		ie_tipo_nota, 
		n.cd_natureza_operacao	cd_natureza_operacao, 
		coalesce(obter_convenio_nf(n.nr_sequencia),n.cd_conv_integracao) cd_convenio, 
		CASE WHEN n.ie_tipo_nota='EN' THEN '3'  ELSE CASE WHEN n.cd_cgc IS NULL THEN '1'  ELSE '2' END  END  indCpfCnpjTomador, 
		CASE WHEN n.ie_tipo_nota='EN' THEN '00000000000000'  ELSE rpad(CASE WHEN n.cd_cgc IS NULL THEN lpad(obter_dados_pf(n.cd_pessoa_fisica, 'CPF'),11,'0')  ELSE lpad(n.cd_cgc,14,'0') END ,14,' ') END  cpfCnpjTomador, 
		CASE WHEN n.ie_tipo_nota='EN' THEN '000000000000000000000000000000000000000000000000000000000000000000000000000'  ELSE rpad(substr(tiss_eliminar_caractere(elimina_acentuacao(obter_nome_pf_pj(n.cd_pessoa_fisica, n.cd_cgc))), 1, 75),75,' ') END  razaoSocialTomador, 
		n.nr_sequencia nr_sequencia 
FROM	operacao_nota o, 
	nota_fiscal n, 
	estabelecimento e, 
	pessoa_juridica p 
WHERE 	o.cd_operacao_nf = n.cd_operacao_nf 
AND	e.cd_estabelecimento = n.cd_estabelecimento 
AND 	n.cd_cgc_emitente = p.cd_cgc 
and	n.ie_tipo_nota <> 'EF' 
and	exists ( select	1 
		from	w_nota_fiscal x 
		where	x.nr_seq_nota_fiscal = n.nr_sequencia) 

UNION
 
SELECT		'6'	tp_registro, 
		null	ds_versao_arquivo, 
		NULL					 				nr_inscricao_munic, 
		coalesce(substr('01',1,2),'00') 						ds_tipo_nfts, 
		n.cd_serie_nf    			 				cd_serie_nf, 
		substr(n.nr_nota_fiscal,1,12)    		 			nr_nota_fiscal, 
		TRUNC(n.dt_emissao)   		 				dt_emissao, 
		CASE WHEN n.ie_situacao=9 THEN 'C' WHEN n.ie_situacao=2 THEN 'C' WHEN n.ie_situacao=3 THEN 'C' WHEN n.ie_situacao=1 THEN 'N' END  				ie_situacao, 
		'T'			 						cd_tributacao, 
		CASE WHEN n.ie_situacao=1 THEN  n.vl_mercadoria WHEN n.ie_situacao=3 THEN  CASE WHEN n.ie_status_envio IS NULL THEN  n.vl_mercadoria  ELSE 0 END   ELSE 0 END  vl_servico, 
		n.vl_descontos     							vl_descontos, 
		obter_dados_grupo_servico_item(obter_item_serv_matproc_nf(n.nr_sequencia),'CD') cd_servico, 
		elimina_caracteres_especiais(obter_dados_grupo_servico_item(obter_item_serv_matproc_nf(n.nr_sequencia),'P')) cd_subitem_servico,	 
		lpad(elimina_caracteres_especiais(campo_mascara(obter_valor_tipo_tributo_nota(n.nr_sequencia,'X','ISS'),2)),4,0)	vl_aliquota, 		 
		CASE WHEN SUBSTR(obter_se_nf_retem_iss(n.nr_sequencia),1,1)='S' THEN '1'  ELSE '2' END 	ie_iss_retido, 
		CASE WHEN n.cd_pessoa_fisica IS NULL THEN 2  ELSE CASE WHEN obter_cpf_pessoa_fisica(n.cd_pessoa_fisica) IS NULL THEN 3  ELSE 1 END  END  ie_cpf_cnpj,    
		LPAD(CASE WHEN n.cd_cgc_emitente IS NULL THEN  SUBSTR(obter_dados_pf(n.cd_pessoa_fisica, 'CPF'),1,11)  ELSE n.cd_cgc_emitente END ,14,'0') cd_cpf_cnpj, 
		CASE WHEN obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'CDM')=355030 THEN SUBSTR(obter_dados_pf_pj(NULL,n.cd_cgc_emitente,'IM'),1,8)  ELSE '00000000' END  			nr_inscricao_munic_prestador, 
		SUBSTR(obter_nome_pf_pj(n.cd_pessoa_fisica, null),1,75) 				nm_prestador, 
		'rua'     						 				ds_tipo_logradouro, 
		obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc_emitente,'R') 	     	ds_endereco, 
		SUBSTR(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc_emitente, 'NR'),1,10) 	 	nr_endereco, 
		SUBSTR(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc_emitente, 'CO'),1,30)	 	ds_complemento, 
		SUBSTR(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc_emitente, 'B'),1,30) 	 	ds_bairro, 
		SUBSTR(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc_emitente, 'CI'),1,50)	 	ds_municipio, 
		SUBSTR(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc_emitente, 'UF'),1,2) 	 	sg_estado, 
		SUBSTR(elimina_caracteres_especiais(obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc_emitente, 'CEP')),1,15)	 	cd_cep, 
		SUBSTR(obter_dados_pf_pj_estab(n.cd_estabelecimento,n.cd_pessoa_fisica,n.cd_cgc_emitente,'M'),1,75)	 		ds_email, 
		'2'  							 								tp_nfts, 
		CASE WHEN obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc_emitente,'TT')='7' THEN '4' WHEN obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc_emitente,'TT')='0' THEN '4' WHEN obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc_emitente,'TT')='6' THEN '0' WHEN obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc_emitente,'TT')='8' THEN '5'  ELSE '0' END  		regime_tributacao,       
		' '					 		dt_pagamento_nota, 
		coalesce(replace(replace(substr(obter_descricao_rps(n.cd_estabelecimento, n.nr_sequencia, 'DS_SERVICOS'), 1, 1000), chr(13), '|'), chr(10), '|'), 'Servicos') ds_servicos, 
		NULL     		qt_linhas, 
		n.cd_estabelecimento, 
		n.cd_cgc_emitente 	cd_cgc_emitente, 
		o.cd_operacao_nf 	cd_operacao_nf, 
		n.dt_entrada_saida	dt_entrada_saida, 
		n.ie_tipo_nota		ie_tipo_nota, 
		n.cd_natureza_operacao	cd_natureza_operacao, 
		coalesce(obter_convenio_nf(n.nr_sequencia),n.cd_conv_integracao) cd_convenio, 
		'3' indCpfCnpjTomador, 
		CASE WHEN n.ie_tipo_nota='EF' THEN '00000000000000'  ELSE rpad(CASE WHEN n.cd_cgc IS NULL THEN lpad(obter_dados_pf(n.cd_pessoa_fisica, 'CPF'),11,'0')  ELSE lpad(n.cd_cgc,14,'0') END ,14,' ') END  cpfCnpjTomador, 
		CASE WHEN n.ie_tipo_nota='EF' THEN '000000000000000000000000000000000000000000000000000000000000000000000000000'  ELSE rpad(substr(tiss_eliminar_caractere(elimina_acentuacao(obter_nome_pf_pj(n.cd_pessoa_fisica, n.cd_cgc))), 1, 75),75,' ') END  razaoSocialTomador, 
		n.nr_sequencia nr_sequencia 
FROM	operacao_nota o, 
	nota_fiscal n, 
	estabelecimento e, 
	pessoa_fisica p 
WHERE 	o.cd_operacao_nf = n.cd_operacao_nf 
AND	e.cd_estabelecimento = n.cd_estabelecimento 
AND 	n.cd_pessoa_fisica = p.cd_pessoa_fisica 
and	n.ie_tipo_nota = 'EF' 
and	exists ( select	1 
		from	w_nota_fiscal x 
		where	x.nr_seq_nota_fiscal = n.nr_sequencia) 

UNION
 
SELECT	'9'		tp_registro, 
		''		ds_versao_arquivo, 
		NULL	nr_inscricao_munic, 
		'' 	ds_tipo_nfts, 
		''   cd_serie_nf, 
		'99999999999'   nr_nota_fiscal, 
		null	dt_emissao, 
		''   ie_situacao, 
		''		cd_tributacao, 
		NULL	vl_servico, 
		NULL  vl_descontos, 
		''   	cd_servico, 
		NULL 	cd_subitem_servico, 
		NULL  vl_aliquota, 
		''	ie_iss_retido, 
		NULL	ie_cpf_cnpj,    
		NULL 	cd_cpf_cnpj, 
		''	nr_inscricao_munic_prestador, 
		''	nm_prestador, 
		''   ds_tipo_logradouro, 
		''	ds_endereco, 
		''	nr_endereco, 
		''	ds_complemento, 
		''	ds_bairro, 
		''	ds_municipio, 
		''	sg_estado, 
		''	cd_cep, 
		''	ds_email, 
		''  	tp_nfts, 
		''	regime_tributacao, 
		' '	dt_pagamento_nota, 
		' '	ds_servicos, 
		0    qt_linhas, 
		cd_estabelecimento, 
		'' cd_cgc_emitente, 
		null 	cd_operacao_nf, 
		null	dt_entrada_saida, 
		null	ie_tipo_nota, 
		null	cd_natureza_operacao, 
		null	cd_convenio, 
		null 	indCpfCnpjTomador, 
		null 	cpfCnpjTomador, 
		null 	razaoSocialTomador, 
		null 	nr_sequencia 
from	estabelecimento_v 
where	1 = 1;

