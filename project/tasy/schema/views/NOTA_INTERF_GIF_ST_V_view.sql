-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW nota_interf_gif_st_v (tp_registro, ds_registro, versao_sefinnet, nr_cmc, cnpj, ds_razao, ds_nome, insc_estadual, junta_comercial, endereco, numero, complemento, bairro, cidade, uf, cep, ddd, fone, fax, email, ie_indicador_sem_mov, ie_indicador_gif, retificadora, tp_declaracao, cnae, cfps, cst, matricula_cei, cd_estabelecimento, dt_emissao, base_calculo_total_param, vl_iss_param, aliquota_iss_param) AS select	1		tp_registro,
	'H'		ds_registro, 
	'3.00.0001'	versao_sefinnet, 
	'' 		nr_cmc, 
	'' 		cnpj, 
	'' 		ds_razao, 
	'' 		ds_nome, 
	'' 		insc_estadual, 
	'' 		junta_comercial, 
	'' 		endereco, 
	'' 		numero, 
	'' 		complemento, 
	'' 		bairro, 
	'' 		cidade, 
	'' 		uf, 
	'' 		cep, 
	'' 		ddd, 
	''		fone, 
	''		fax, 
	''		email, 
	''		ie_indicador_sem_mov, 
	''		ie_indicador_gif, 
	''		retificadora, 
	''		tp_declaracao, 
	''		cnae, 
	''		cfps, 
	''		cst, 
	''		matricula_cei, 
	n.cd_estabelecimento cd_estabelecimento, 
	null 		dt_emissao, 
	'' base_calculo_total_param, 
	'' vl_iss_param, 
	'' aliquota_iss_param	 
FROM	estabelecimento n 

union ALL
 
select	2		tp_registro, 
	'C' 		ds_registro, 
	'' 		versao_sefinnet, 
	Lpad(substr(j.nr_inscricao_municipal,1,7),7,'0')	nr_cmc, 
	Rpad(substr(j.cd_cgc,1,14),14,' ') 			cnpj, 
	Rpad(substr(j.ds_razao_social,1,80),80,' ') 		ds_razao, 
	Rpad(substr(j.nm_fantasia,1,50),50,' ') 		ds_nome, 
	Rpad(substr(j.nr_inscricao_estadual,1,20),20,' ') 	insc_estadual, 
	'          ' 					junta_comercial, 
	Rpad(substr(j.ds_endereco,1,80),80,' ') 		endereco, 
	Rpad(substr(j.nr_endereco,1,10),10,' ') 		numero, 
	Rpad(substr(j.ds_complemento,1,30),30,' ') 		complemento, 
	Rpad(substr(j.ds_bairro,1,50),50,' ') 			bairro, 
	Rpad(substr(j.ds_municipio,1,50),50,' ') 		cidade, 
	Rpad(substr(j.sg_estado,1,2),2,' ') 			uf, 
	Rpad(substr(j.cd_cep,1,8),8,' ') 			cep, 
	Rpad(substr(j.nr_ddd_telefone,1,2),2,' ') 		ddd, 
	Rpad(substr(j.nr_telefone,1,8),8,' ') 			fone, 
	Rpad(substr(j.nr_fax,1,8),8,' ') 			fax, 
	Rpad(substr(j.ds_email,1,80),80,' ') 			email, 
	'' 		ie_indicador_sem_mov, 
	'' 		ie_indicador_gif, 
	'' 		retificadora, 
	'' 		tp_declaracao, 
	'' 		cnae, 
	'' 		cfps, 
	'' 		cst, 
	'' 		matricula_cei, 
	a.cd_estabelecimento cd_estabelecimento, 
	null dt_emissao, 
	'' base_calculo_total_param, 
	'' vl_iss_param, 
	'' aliquota_iss_param 
from 	estabelecimento a, 
	pessoa_juridica j 
where	a.cd_cgc = j.cd_cgc 

union all
 
SELECT	distinct 3 		tp_registro, 
	'I' 		ds_registro, 
	'' 		versao_sefinnet, 
	Lpad(substr(j.nr_inscricao_municipal,1,7),7,'0')	nr_cmc, 
	Rpad(substr(j.cd_cgc,1,14),14,' ') 			cnpj, 
	'' 		ds_razao, 
	'' 		ds_nome, 
	'' 		insc_estadual, 
	'' 		junta_comercial, 
	'' 		endereco, 
	'' 		numero, 
	'' 		complemento, 
	'' 		bairro, 
	'' 		cidade, 
	'' 		uf, 
	'' 		cep, 
	'' 		ddd, 
	'' 		fone, 
	'' 		fax, 
	'' 		email, 
	'0' 		ie_indicador_sem_mov, 
	'1' 		ie_indicador_gif, 
	'0' 		retificadora, 
	'' 		tp_declaracao, 
	''		cnae, 
	'' 		cfps, 
	'' 		cst, 
	''		matricula_cei, 
	a.cd_estabelecimento cd_estabelecimento, 
	null	dt_emissao, 
	'' base_calculo_total_param, 
	'' vl_iss_param, 
	'' aliquota_iss_param 
from 	estabelecimento a, 
	pessoa_juridica j 
where	a.cd_cgc = j.cd_cgc 

union all
 
select	distinct 4 		tp_registro, 
	'J' 		ds_registro, 
	'' 		versao_sefinnet, 
	Lpad(substr(obter_dados_pf_pj(null, e.cd_cgc,'IM'),1,7),7,'0') nr_cmc, 
	Rpad(substr(e.cd_cgc,1,14),14,' ') cnpj, 
	'' 		ds_razao, 
	'' 		ds_nome, 
	'' 		insc_estadual, 
	'' 		junta_comercial, 
	'' 		endereco, 
	'' 		numero, 
	'' 		complemento, 
	'' 		bairro, 
	'' 		cidade, 
	'' 		uf, 
	'' 		cep, 
	'' 		ddd, 
	'' 		fone, 
	'' 		fax, 
	'' 		email, 
	'' 		ie_indicador_sem_mov, 
	'' 		ie_indicador_gif, 
	'' 		retificadora, 
	'1' 		tp_declaracao,	 
	Lpad(substr(obter_cnae_florianopolis(n.cd_estabelecimento,n.nr_sequencia),1, 11),11,'00000000000') cnae,	 
	obter_cfps_municipio(n.cd_estabelecimento,n.cd_cgc,n.cd_pessoa_fisica,'FLORIANOPOLIS',n.ie_tipo_nota,n.cd_cgc_emitente) cfps, 
	lpad(substr(s.cd_situacao,1,3),3,'0') cst, 
	'      '	matricula_cei, 
	n.cd_estabelecimento cd_estabelecimento, 
	n.dt_emissao dt_emissao, 
	coalesce(to_char(x.vl_base_calculo),'0') base_calculo_total_param, 
	coalesce(to_char(x.vl_tributo),'0') vl_iss_param, 
	coalesce(to_char(x.tx_tributo),'0') aliquota_iss_param	 
from	nota_fiscal_item_trib x, 
	nota_fiscal n, 
	tributo t, 
	estabelecimento e, 
	situacao_trib_prest_serv s, 
	operacao_nota a 
where	x.nr_sequencia = n.nr_sequencia 
and	x.cd_tributo  = t.cd_tributo 
and	a.cd_operacao_nf = n.cd_operacao_nf 
and	t.ie_tipo_tributo = 'ISS' 
and	substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1) = 'E' 
and	n.ie_situacao = '1' 
and	n.cd_cgc_emitente <> e.cd_cgc 
and	n.cd_estabelecimento = e.cd_estabelecimento 
and	x.nr_seq_sit_trib = s.nr_sequencia 
and	n.dt_atualizacao_estoque is not null 
and	a.ie_servico = 'S' 

union all
 
select DISTINCT 5	tp_registro, 
	'L' 		ds_registro, 
	'' 		versao_sefinnet, 
	'' 		nr_cmc, 
	'' 		cnpj, 
	'' 		ds_razao, 
	'' 		ds_nome, 
	'' 		insc_estadual, 
	'' 		junta_comercial, 
	'' 		endereco, 
	'' 		numero, 
	'' 		complemento, 
	'' 		bairro, 
	'' 		cidade, 
	'' 		uf, 
	'' 		cep, 
	'' 		ddd, 
	'' 		fone, 
	'' 		fax, 
	'' 		email, 
	'' 		ie_indicador_sem_mov, 
	'' 		ie_indicador_gif, 
	'' 		retificadora, 
	'' 		tp_declaracao, 
	'' 		cnae, 
	'' 		cfps, 
	'' 		cst, 
	'' 		matricula_cei, 
	n.cd_estabelecimento cd_estabelecimento, 
	null		dt_emissao, 
	'' base_calculo_total_param, 
	'' vl_iss_param, 
	'' aliquota_iss_param	 
from estabelecimento n 
ORDER BY tp_registro;
