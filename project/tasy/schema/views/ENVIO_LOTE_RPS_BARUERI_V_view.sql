-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW envio_lote_rps_barueri_v (tp_registro, nr_inscricao_municipal, ds_versao_arquivo, dt_remessa, ds_tipo_rps, cd_serie_rps, cd_serie_nf, nr_rps, nr_nota_fiscal, dt_rps, dt_rps_cancel, hr_rps, ie_situacao_rps, cd_motivo_cancel, nr_nota_cancelada, cd_serie_nota_cancel, ds_cancelamento, cd_servico, cd_local_servico, cd_tipo_local_servico, ds_endereco_prestador, nr_logradouro_prestador, ds_complemento_prestador, nm_bairro_prestador, ds_cidade_prestador, sg_estado_prestador, nr_cep_prestador, qt_servico, vl_servico, ds_reservado, ie_tomador_estrangeiro, cd_pais_estrangeiro, ie_servico_exportacao, ie_tipo_documento_tomador, nr_documento_tomador, nm_tomador, ds_endereco_tomador, nr_endereco_tomador, ds_complemento_tomador, ds_bairro_tomador, ds_cidade_tomador, sg_estado_tomador, nr_cep_tomador, ds_email_tomador, nr_fatura, vl_fatura, ds_forma_pagamento, ds_discriminacao_servico, cd_estabelecimento, ie_tipo_tributo, vl_tributo, dt_emissao, nr_sequencia) AS select	distinct '1'					tp_registro,
	substr(a.cd_inscricao_municipal,1,7)	nr_inscricao_municipal,
	'PMB002' 				ds_versao_arquivo,
	to_char(LOCALTIMESTAMP,'ddmmyyyyss') ||'0' 	dt_remessa,
	'' 					ds_tipo_rps,
	''					cd_serie_rps,
	'' 					cd_serie_nf,
	'' 					nr_rps,
	''					nr_nota_fiscal,
	''					dt_rps,
	''					dt_rps_cancel,
	'' 					hr_rps,
	'' 					ie_situacao_rps,
	'' 					cd_motivo_cancel,
	'' 					nr_nota_cancelada,
	''					cd_serie_nota_cancel,
	'' 					ds_cancelamento,
	'' 					cd_servico,
	'' 					cd_local_servico,
	'' 					cd_tipo_local_servico,
	'' 					ds_endereco_prestador,
	'' 					nr_logradouro_prestador,
	'' 					ds_complemento_prestador,
	'' 					nm_bairro_prestador,
	'' 					ds_cidade_prestador,
	'' 					sg_estado_prestador,
	'' 					nr_cep_prestador,
	'' 					qt_servico,
	'' 					vl_servico,
	'' 					ds_reservado,
	'' 					ie_tomador_estrangeiro,
	'' 					cd_pais_estrangeiro,
	'' 					ie_servico_exportacao,
	'' 					ie_tipo_documento_tomador,
	'' 					nr_documento_tomador,
	'' 					nm_tomador,
	'' 					ds_endereco_tomador,
	'' 					nr_endereco_tomador,
	'' 					ds_complemento_tomador,
	'' 					ds_bairro_tomador,
	'' 					ds_cidade_tomador,
	'' 					sg_estado_tomador,
	'' 					nr_cep_tomador,
	'' 					ds_email_tomador,
	'' 					nr_fatura,
	'' 					vl_fatura,
	'' 					ds_forma_pagamento,
	'' 					ds_discriminacao_servico,
	a.cd_estabelecimento			cd_estabelecimento,
	''					ie_tipo_tributo,
	''					vl_tributo,
	null					dt_emissao,
	1					nr_sequencia
FROM	estabelecimento a

union all

select '2' 										tp_registro,
	substr(e.cd_inscricao_municipal,1,7)						nr_inscricao_municipal,
	'PMB002' 									ds_versao_arquivo,
	to_char(LOCALTIMESTAMP,'ddmmyyyy') 							dt_remessa,
	'RPS  ' 									ds_tipo_rps,
	rpad(substr(n.cd_serie_nf,1,4),4,' ') 						cd_serie_rps,
	'     ' 									cd_serie_nf,
	lpad(substr(CASE WHEN n.ie_situacao=9 THEN '0' WHEN n.ie_situacao=3 THEN '0'  ELSE n.nr_nota_fiscal END ,1,10),10,'0')	nr_rps,
	n.nr_nota_fiscal			 					nr_nota_fiscal,
	to_char(n.dt_emissao,'yyyymmdd')						dt_rps,	
	CASE WHEN n.ie_situacao=9 THEN to_char(n.dt_emissao,'yyyymmdd') WHEN n.ie_situacao=3 THEN to_char(n.dt_emissao,'yyyymmdd')  ELSE '        ' END 	dt_rps_cancel,	
	to_char(n.dt_emissao,'hh24miss') 						hr_rps,
	CASE WHEN n.ie_situacao=9 THEN 'C' WHEN n.ie_situacao=3 THEN 'C'  ELSE 'E' END  						ie_situacao_rps,
	CASE WHEN n.ie_situacao=9 THEN '02' WHEN n.ie_situacao=3 THEN '02'  ELSE '  ' END 	      				cd_motivo_cancel,	
	lpad(substr(CASE WHEN n.ie_situacao=9 THEN n.nr_nota_fiscal WHEN n.ie_situacao=3 THEN n.nr_nota_fiscal  ELSE '0' END ,1,7),7,'0') nr_nota_cancelada,	
	rpad(substr(CASE WHEN n.ie_situacao=9 THEN cd_serie_nf  ELSE '0' END ,1,5),5,' ')			cd_serie_nota_cancel,
	rpad(substr(
	(	select x.ds_motivo
		from motivo_cancel_sc_oc x
		where x.nr_sequencia = n.nr_seq_motivo_cancel),1,180),180,' ') 	ds_cancelamento,
	lpad(substr(elimina_caractere_especial(obter_dados_grupo_servico_item(obter_item_servico_proced(obter_procedimento_nfse(n.nr_sequencia,'P'), obter_procedimento_nfse(n.nr_sequencia,'O')),'CD')),1,9),9,'0') cd_servico,
	'1' 										cd_local_servico,
	'2' 										cd_tipo_local_servico,
	rpad(substr(obter_dados_pf_pj(NULL,e.cd_cgc,'R'),1,75),75,' ')			ds_endereco_prestador,
	rpad(substr(obter_dados_pf_pj(NULL,e.cd_cgc,'NR'),1,9),9,' ')			nr_logradouro_prestador,
	rpad(substr(obter_dados_pf_pj(NULL,e.cd_cgc,'CO'),1,30),30,' ')			ds_complemento_prestador,
	rpad(substr(obter_dados_pf_pj(NULL,e.cd_cgc,'B'),1,40),40,' ')			nm_bairro_prestador,
	rpad(substr(obter_dados_pf_pj(NULL,e.cd_cgc,'CI'),1,40),40,' ')			ds_cidade_prestador,
	rpad(substr(obter_dados_pf_pj(NULL,e.cd_cgc,'UF'),1,2),2,' ')			sg_estado_prestador,
	rpad(substr(obter_dados_pf_pj(NULL,e.cd_cgc,'CEP'),1,8),8,' ') 			nr_cep_prestador,
	(	select lpad(count(*),6,'0')
		from nota_fiscal_item x
		where x.nr_sequencia = n.nr_sequencia) 					qt_servico,
	lpad(elimina_caracteres_especiais(campo_mascara(n.vl_mercadoria,2)),15,0)	vl_servico,
	'     ' 									ds_reservado,
	CASE WHEN nfse_obter_se_brasileiro(n.cd_pessoa_fisica,n.cd_cgc)='S' THEN '2'  ELSE '1' END 	ie_tomador_estrangeiro,
	lpad(substr(CASE WHEN n.cd_pessoa_fisica IS NULL THEN  CASE WHEN nfse_obter_se_brasileiro(n.cd_pessoa_fisica,null)='S' THEN null  ELSE obter_compl_pf(n.cd_pessoa_fisica,1,'CBPAIS') END   ELSE CASE WHEN nfse_obter_se_brasileiro(null,n.cd_cgc)='S' THEN null  ELSE obter_compl_pf(null,n.cd_cgc,'CDPAIS') END  END ,1,3),3,'0') cd_pais_estrangeiro,
	'2' 										ie_servico_exportacao,
	CASE WHEN n.cd_pessoa_fisica IS NULL THEN '2'  ELSE '1' END 						ie_tipo_documento_tomador,
	lpad(substr(CASE WHEN n.cd_pessoa_fisica IS NULL THEN n.cd_cgc  ELSE obter_dados_pf(n.cd_pessoa_fisica,'CPF') END ,1,14),14,'0') nr_documento_tomador,	
	rpad(substr(obter_nome_pf_pj(n.cd_pessoa_fisica,n.cd_cgc),1,60),60, ' ')	nm_tomador,
	rpad(substr(obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc,'R'),1,75),75, ' ')	ds_endereco_tomador,
	rpad(substr(obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc,'NR'),1,9),9, ' ')	nr_endereco_tomador,
	rpad(substr(obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc,'CO'),1,30),30, ' ')	ds_complemento_tomador,
	rpad(substr(obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc,'B'),1,40),40, ' ')	ds_bairro_tomador,
	rpad(substr(obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc,'CI'),1,40),40, ' ')	ds_cidade_tomador,
	rpad(substr(obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc,'UF'),1,2),2, ' ')	sg_estado_tomador,
	rpad(substr(obter_dados_pf_pj(n.cd_pessoa_fisica,n.cd_cgc,'CEP'),1,8),8, ' ')	nr_cep_tomador,	
	rpad(substr(obter_dados_pf_pj_estab(n.cd_estabelecimento,n.cd_pessoa_fisica,n.cd_cgc,'M'),1,152),152, ' ')	ds_email_tomador,
	lpad(substr(coalesce((	select	max(x.nr_titulo)
		from titulo_receber x
		where x.nr_seq_nf_saida = n.nr_sequencia),0),1,6),6,'0') 		nr_fatura,
	lpad(elimina_caracteres_especiais(campo_mascara(n.vl_total_nota,2)),15,0) 	vl_fatura,
	rpad(substr(
	(	select x.ds_condicao_pagamento
		from condicao_pagamento x
		where x.cd_condicao_pagamento = n.cd_condicao_pagamento),1,15),15,' ') 	ds_forma_pagamento,
	coalesce(replace(replace(substr(obter_descricao_rps(n.cd_estabelecimento, n.nr_sequencia, 'DS_SERVICOS'), 1, 1000), chr(13), ' '), chr(10), ' '), 'Servicos') ds_discriminacao_servico,
	e.cd_estabelecimento			cd_estabelecimento,
	''					ie_tipo_tributo,
	''					vl_tributo,
	trunc(n.dt_emissao)			dt_emissao,
	n.nr_sequencia				nr_sequencia
from	estabelecimento e,
	nota_fiscal n,
	operacao_nota o
where 	n.cd_estabelecimento = e.cd_estabelecimento
and	o.cd_operacao_nf = n.cd_operacao_nf
and	substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1) = 'S'
and	exists (select 1 from w_nota_fiscal w where w.nr_seq_nota_fiscal = n.nr_sequencia)

union all

select	'3'					tp_registro,
	substr(e.cd_inscricao_municipal,1,7)						nr_inscricao_municipal,
	'' 					ds_versao_arquivo,
	''				 	dt_remessa,
	'' 					ds_tipo_rps,
	''					cd_serie_rps,
	'' 					cd_serie_nf,
	'' 					nr_rps,
	n.nr_nota_fiscal			nr_nota_fiscal,	
	''					dt_rps,
	''					dt_rps_cancel,
	'' 					hr_rps,
	'' 					ie_situacao_rps,
	'' 					cd_motivo_cancel,
	'' 					nr_nota_cancelada,
	''					cd_serie_nota_cancel,
	'' 					ds_cancelamento,
	'' 					cd_servico,
	'' 					cd_local_servico,
	'' 					cd_tipo_local_servico,
	'' 					ds_endereco_prestador,
	'' 					nr_logradouro_prestador,
	'' 					ds_complemento_prestador,
	'' 					nm_bairro_prestador,
	'' 					ds_cidade_prestador,
	'' 					sg_estado_prestador,
	'' 					nr_cep_prestador,
	'' 					qt_servico,
	'' 					vl_servico,
	'' 					ds_reservado,
	'' 					ie_tomador_estrangeiro,
	'' 					cd_pais_estrangeiro,
	'' 					ie_servico_exportacao,
	'' 					ie_tipo_documento_tomador,
	'' 					nr_documento_tomador,
	'' 					nm_tomador,
	'' 					ds_endereco_tomador,
	'' 					nr_endereco_tomador,
	'' 					ds_complemento_tomador,
	'' 					ds_bairro_tomador,
	'' 					ds_cidade_tomador,
	'' 					sg_estado_tomador,
	'' 					nr_cep_tomador,
	'' 					ds_email_tomador,
	'' 					nr_fatura,
	'' 					vl_fatura,
	'' 					ds_forma_pagamento,
	'' 					ds_discriminacao_servico,
	e.cd_estabelecimento			cd_estabelecimento,
	CASE WHEN t.ie_tipo_tributo='IR' THEN '01' WHEN t.ie_tipo_tributo='PIS' THEN '02' WHEN t.ie_tipo_tributo='COFINS' THEN '03' WHEN t.ie_tipo_tributo='CSLL' THEN '04'  ELSE 'VN' END  ie_tipo_tributo,
	lpad(elimina_caracteres_especiais(campo_mascara(x.vl_tributo,2)),15,0) 	vl_tributo,
	trunc(n.dt_emissao)			dt_emissao,
	n.nr_sequencia 				nr_sequencia
from	estabelecimento e,
	nota_fiscal n,
	nota_fiscal_trib x,
	tributo t,
	operacao_nota o
where 	n.cd_estabelecimento = e.cd_estabelecimento
and	n.nr_sequencia = x.nr_sequencia
and	x.cd_tributo = t.cd_tributo
and	o.cd_operacao_nf = n.cd_operacao_nf
and	substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1) = 'S'
and	exists (select 1 from w_nota_fiscal w where w.nr_seq_nota_fiscal = n.nr_sequencia)

union all

select	'9'					tp_registro,
	substr(e.cd_inscricao_municipal,1,7)						nr_inscricao_municipal,
	'' 					ds_versao_arquivo,
	''				 	dt_remessa,
	'' 					ds_tipo_rps,
	''					cd_serie_rps,
	'' 					cd_serie_nf,
	'' 					nr_rps,
	''					nr_nota_fiscal,	
	''					dt_rps,
	''					dt_rps_cancel,
	'' 					hr_rps,
	'' 					ie_situacao_rps,
	'' 					cd_motivo_cancel,
	'' 					nr_nota_cancelada,
	''					cd_serie_nota_cancel,
	'' 					ds_cancelamento,
	'' 					cd_servico,
	'' 					cd_local_servico,
	'' 					cd_tipo_local_servico,
	'' 					ds_endereco_prestador,
	'' 					nr_logradouro_prestador,
	'' 					ds_complemento_prestador,
	'' 					nm_bairro_prestador,
	'' 					ds_cidade_prestador,
	'' 					sg_estado_prestador,
	'' 					nr_cep_prestador,
	'' 					qt_servico,
	'' 					vl_servico,
	'' 					ds_reservado,
	'' 					ie_tomador_estrangeiro,
	'' 					cd_pais_estrangeiro,
	'' 					ie_servico_exportacao,
	'' 					ie_tipo_documento_tomador,
	'' 					nr_documento_tomador,
	'' 					nm_tomador,
	'' 					ds_endereco_tomador,
	'' 					nr_endereco_tomador,
	'' 					ds_complemento_tomador,
	'' 					ds_bairro_tomador,
	'' 					ds_cidade_tomador,
	'' 					sg_estado_tomador,
	'' 					nr_cep_tomador,
	'' 					ds_email_tomador,
	'' 					nr_fatura,
	'' 					vl_fatura,
	'' 					ds_forma_pagamento,
	'' 					ds_discriminacao_servico,
	n.cd_estabelecimento			cd_estabelecimento,
	''					ie_tipo_tributo,
	''					vl_tributo,
	null					dt_emissao,
	99999999				nr_sequencia
from	nota_fiscal n,
	estabelecimento e
where	substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1) = 'S'
and	n.cd_estabelecimento = e.cd_estabelecimento
and	exists (select 1 from w_nota_fiscal w where w.nr_seq_nota_fiscal = n.nr_sequencia)
group by n.cd_estabelecimento, cd_inscricao_municipal
order by nr_sequencia, tp_registro;

