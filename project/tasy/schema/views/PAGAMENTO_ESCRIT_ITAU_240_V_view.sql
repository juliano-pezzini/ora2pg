-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pagamento_escrit_itau_240_v (tp_registro, ie_forma_pagto, nr_seq_forma_pagto, nr_inscricao, cd_agencia, cd_conta, ds_dac_agencia, nm_empresa, ds_banco, dt_arquivo, nr_seq_envio, ie_tipo_fornecedor, cd_cgc_fornecedor, cd_agencia_bancaria, ds_dac_ag_bancaria, nr_conta_forneced, nm_hospital, ds_endereco, ds_cidade, cd_cep, ds_estado, cd_banco_fornecedor, cd_agencia_fornecedor, cd_agencia_conta, nm_fornecedor, nr_documento, dt_vencimento, vl_saldo_titulo, nr_inscricao_fornec, qt_registros, ie_cod_barras, vl_titulo, vl_desconto, vl_acrescimo, dt_pagto, vl_pagto, vl_total_pagto, qt_lotes_arquivo, qt_total_registros, nr_endereco) AS select	0 tp_registro,
	'0' ie_forma_pagto, 
	0 nr_seq_forma_pagto, 
	a.cd_cgc nr_inscricao, 
	somente_numero(g.cd_agencia_bancaria) cd_agencia, 
	g.cd_conta, 
	coalesce(somente_numero(coalesce(to_char(coalesce(somente_numero(g.ie_digito_conta),0),'0'),'0')),0) ds_dac_agencia, 
	Elimina_Acentuacao(upper(p.ds_razao_social)) nm_empresa, 
	Elimina_Acentuacao(upper(g.ds_banco)) ds_banco, 
	to_char(e.dt_remessa_retorno, 'ddmmyyyyhh24miss') dt_arquivo, 
	e.nr_sequencia nr_seq_envio, 
	'2' ie_tipo_fornecedor, 
	'0' cd_cgc_fornecedor, 
	'0' cd_agencia_bancaria, 
	'' ds_dac_ag_bancaria, 
	'0' nr_conta_forneced, 
	'' nm_hospital, 
	'' ds_endereco, 
	'' ds_cidade, 
	'0' cd_cep, 
	'' ds_estado, 
	0 cd_banco_fornecedor, 
	'0' cd_agencia_fornecedor, 
	'' cd_agencia_conta, 
	'' nm_fornecedor, 
	0 nr_documento, 
	LOCALTIMESTAMP dt_vencimento, 
	0 vl_saldo_titulo, 
	'0' nr_inscricao_fornec, 
	0 qt_registros, 
	'' ie_cod_barras, 
	0 vl_titulo, 
	0 vl_desconto, 
	0 vl_acrescimo, 
	LOCALTIMESTAMP dt_pagto, 
	0 vl_pagto, 
	0 vl_total_pagto, 
	0 qt_lotes_arquivo, 
	0 qt_total_registros, 
	'0' nr_endereco 
FROM	estabelecimento a, 
	banco_estabelecimento_v g, 
	pessoa_juridica p, 
	banco_escritural e 
where	e.cd_estabelecimento  	= a.cd_estabelecimento 
and	a.cd_cgc			= p.cd_cgc 
and	g.nr_sequencia		= e.nr_seq_conta_banco 
and	g.ie_tipo_relacao    	in ('EP','ECC') 

union
 
/* Header do Lote Documento ITAU */
 
select	1 tp_registro, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END  ie_forma_pagto, 
 	1 nr_seq_forma_pagto, 
	e.CD_CGC nr_inscricao, 
	somente_numero(b.cd_agencia_bancaria) cd_agencia, 
	b.cd_conta, 
	coalesce(somente_numero(coalesce(to_char(coalesce(somente_numero(b.ie_digito_conta),0),'0'),'0')),0) ds_dac_agencia, 
	Elimina_Acentuacao(upper(j.ds_razao_social)) nm_empresa, 
	Elimina_Acentuacao(upper(b.ds_banco)), 
	'' dt_arquivo, 
	a.nr_sequencia nr_seq_envio, 
	'2' ie_tipo_fornecedor, 
	e.CD_CGC cd_cgc_fornecedor, 
	' ' cd_agencia_bancaria, 
	' ' ds_dac_ag_bancaria, 
	' ' nr_conta_forneced, 
	Elimina_Acentuacao(upper(j.ds_razao_social)) nm_hospital, 
	Elimina_Acentuacao(upper(j.ds_endereco)) ds_endereco, 
	Elimina_Acentuacao(j.ds_municipio) ds_cidade, 
	j.cd_cep, 
	j.sg_estado ds_estado, 
	0 cd_banco_fornecedor, 
	' ' cd_agencia_fornecedor, 
	' ' cd_agencia_conta, 
	Elimina_Acentuacao(upper(j.ds_razao_social)) nm_fornecedor, 
	0 nr_documento, 
	LOCALTIMESTAMP dt_vencimento, 
	0 vl_saldo_titulo, 
	'0' nr_inscricao_fornec, 
	0 qt_registros, 
	'' ie_cod_barras, 
	0 vl_titulo, 
	0 vl_desconto, 
	0 vl_acrescimo, 
	LOCALTIMESTAMP dt_pagto, 
	0 vl_pagto, 
	0 vl_total_pagto, 
	0 qt_lotes_arquivo, 
	0 qt_total_registros, 
	j.nr_endereco 
from	pessoa_juridica j, 
	Estabelecimento e, 
	banco_estabelecimento_v b, 
	banco_escritural a, 
	titulo_pagar_v2 d, 
	titulo_pagar_v k,	 
	titulo_pagar_escrit c 
where	c.nr_titulo			= d.nr_titulo 
and	k.nr_titulo			= d.nr_titulo 
and	a.nr_sequencia		= c.nr_seq_escrit 
and	e.cd_cgc			= j.cd_cgc 
and	a.cd_estabelecimento  	= e.cd_estabelecimento 
and	b.ie_tipo_relacao    	in ('EP','ECC') 
and	b.nr_sequencia		= a.nr_seq_conta_banco 
and	c.ie_tipo_pagamento		= 'DOC' 
and	a.cd_banco			= 341 
group	by e.CD_CGC, 
	somente_numero(b.cd_agencia_bancaria), 
	b.cd_conta, 
	b.ie_digito_conta, 
	Elimina_Acentuacao(upper(j.ds_razao_social)), 
	Elimina_Acentuacao(upper(b.ds_banco)), 
	a.nr_sequencia, 
	Elimina_Acentuacao(upper(j.ds_razao_social)), 
	Elimina_Acentuacao(upper(j.ds_endereco)), 
	Elimina_Acentuacao(j.ds_municipio), 
	j.cd_cep, 
	j.sg_estado, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END , 
	j.nr_endereco 

Union
 
/* Detalhe Documento ITAU*/
 
select	2 tp_registro, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END  ie_forma_pagto, 
 	1 nr_seq_forma_pagto, 
	'0' nr_inscricao, 
	0 cd_agencia, 
	'0' cd_conta, 
	0 ds_dac_agencia, 
	'' nm_empresa, 
	'' ds_banco, 
	'' dt_arquivo, 
	a.nr_sequencia nr_seq_envio, 
	CASE WHEN k.cd_pessoa_fisica IS NULL THEN '2'  ELSE '1' END  ie_tipo_fornecedor, 
	d.cd_favorecido cd_cgc_fornecedor, 
	'0' cd_agencia_bancaria, 
	'' ds_dac_ag_bancaria, 
	'0' nr_conta_forneced, 
	'' nm_hospital, 
	'' ds_endereco, 
	'' ds_cidade, 
	'0' cd_cep, 
	'' ds_estado, 
	c.cd_banco cd_banco_fornecedor, 
	c.cd_agencia_bancaria cd_agencia_fornecedor, 
	'0' || c.cd_agencia_bancaria || '0000000' || c.nr_conta cd_agencia_conta, 
	Elimina_Acentuacao(upper(d.nm_favorecido)) nm_fornecedor, 
	d.nr_titulo nr_documento, 
	d.dt_vencimento_atual dt_vencimento, 
	d.vl_saldo_titulo, 
	e.cd_cgc nr_inscricao_fornec, 
	0 qt_registros, 
	'' ie_cod_barras, 
	k.vl_titulo vl_titulo, 
	0 vl_desconto, 
	0 vl_acrescimo, 
	LOCALTIMESTAMP dt_pagto, 
	c.vl_escritural vl_pagto, 
	0 vl_total_pagto, 
	0 qt_lotes_arquivo, 
	0 qt_total_registros, 
	'0' nr_endereco 
from	Estabelecimento e, 
	banco_estabelecimento_v b, 
	banco_escritural a, 
	titulo_pagar_v2 d,	 
	titulo_pagar_v k, 
	titulo_pagar_escrit c 
where	c.nr_titulo			= d.nr_titulo 
and	k.nr_titulo			= d.nr_titulo 
and	a.nr_sequencia		= c.nr_seq_escrit 
and	a.cd_estabelecimento		= e.cd_estabelecimento 
and 	b.ie_tipo_relacao		in ('EP','ECC') 
and	b.nr_sequencia		= a.nr_seq_conta_banco 
and 	c.ie_tipo_pagamento		= 'DOC' 

Union
 
/* Trailler do Lote Documento ITAU */
 
select	3 tp_registro, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END  ie_forma_pagto, 
 	1 nr_seq_forma_pagto, 
	'0' nr_inscricao, 
	0 cd_agencia, 
	'0' cd_conta, 
	0 ds_dac_agencia, 
	'' nm_empresa, 
	'' ds_banco, 
	'' dt_arquivo, 
	e.nr_sequencia nr_seq_envio, 
	' ' ie_tipo_fornecedor, 
	'0' cd_cgc_fornecedor, 
	'0' cd_agencia_bancaria, 
	'' ds_dac_ag_bancaria, 
	'0' nr_conta_forneced, 
	'' nm_hospital, 
	'' ds_endereco, 
	'' ds_cidade, 
	'0' cd_cep, 
	'' ds_estado, 
	0 cd_banco_fornecedor, 
	'0' cd_agencia_fornecedor, 
	'' cd_agencia_conta, 
	'' nm_fornecedor, 
	0 nr_documento, 
	LOCALTIMESTAMP dt_vencimento, 
	0 vl_saldo_titulo, 
	'0' nr_inscricao_fornec, 
	count(*) + 2 qt_registros, 
	'' ie_cod_barras, 
	0 vl_titulo, 
	0 vl_desconto, 
	0 vl_acrescimo, 
	LOCALTIMESTAMP dt_pagto, 
	0 vl_pagto, 
	sum(c.vl_escritural - c.vl_desconto + c.vl_acrescimo) vl_total_pagto, 
	0 qt_lotes_arquivo, 
	0 qt_total_registros, 
	'0' nr_endereco 
from	banco_estabelecimento_v b, 
	estabelecimento a,    
	banco_escritural e, 
	titulo_pagar k, 
	titulo_pagar_escrit c 
where	e.nr_sequencia		= c.nr_seq_escrit 
and	e.cd_estabelecimento  	= a.cd_estabelecimento 
and	k.nr_titulo			= c.nr_titulo 
and	b.ie_tipo_relacao   	in ('EP','ECC') 
and	b.nr_sequencia		= e.nr_seq_conta_banco 
and 	c.ie_tipo_pagamento		= 'DOC' 
group by e.nr_sequencia, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END  

union
 
/* Header do Lote Bloquetos ITAU*/
 
select	4 tp_registro, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END  ie_forma_pagto, 
 	1 nr_seq_forma_pagto, 
	e.cd_cgc nr_inscricao, 
	somente_numero(b.cd_agencia_bancaria) cd_agencia, 
	b.cd_conta, 
	coalesce(somente_numero(coalesce(to_char(coalesce(somente_numero(b.ie_digito_conta),0),'0'),'0')),0) ds_dac_agencia, 
	Elimina_Acentuacao(upper(j.ds_razao_social)) nm_empresa, 
	Elimina_Acentuacao(upper(b.ds_banco)), 
	'' dt_arquivo, 
	a.nr_sequencia nr_seq_envio, 
	'2' ie_tipo_fornecedor, 
	e.cd_cgc cd_cgc_fornecedor, 
	'' cd_agencia_bancaria, 
	'' ds_dac_ag_bancaria, 
	'' nr_conta_forneced, 
	Elimina_Acentuacao(upper(j.ds_razao_social)) nm_hospital, 
	Elimina_Acentuacao(upper(j.ds_endereco)) ds_endereco, 
	Elimina_Acentuacao(upper(j.ds_municipio)) ds_cidade, 
	j.cd_cep, 
	j.sg_estado ds_estado, 
	0 cd_banco_fornecedor, 
	'' cd_agencia_fornecedor, 
	'0' || b.cd_agencia_bancaria || '0000000' || b.CD_CONTA cd_agencia_conta, 
	Elimina_Acentuacao(upper(j.ds_razao_social)) nm_fornecedor, 
	0 nr_documento, 
	LOCALTIMESTAMP dt_vencimento, 
	0 vl_saldo_titulo, 
	'0' nr_inscricao_fornec, 
	0 qt_registros, 
	'' ie_cod_barras, 
	0 vl_titulo, 
	0 vl_desconto, 
	0 vl_acrescimo, 
	LOCALTIMESTAMP dt_pagto, 
	0 vl_pagto, 
	0 vl_total_pagto, 
	0 qt_lotes_arquivo, 
	0 qt_total_registros, 
	j.nr_endereco 
from	pessoa_juridica j, 
	Estabelecimento e, 
	banco_estabelecimento_v b, 
	banco_escritural a, 
	titulo_pagar k, 
	titulo_pagar_escrit c 
where	e.cd_cgc			= j.cd_cgc 
and	a.nr_sequencia     	= c.nr_seq_escrit 
and	a.cd_estabelecimento  	= e.cd_estabelecimento 
and	b.ie_tipo_relacao    	in ('EP','ECC') 
and	a.nr_seq_conta_banco		= b.nr_sequencia 
and	c.nr_titulo			= k.nr_titulo 
and 	c.ie_tipo_pagamento		= 'BLQ' 
and	substr(k.nr_bloqueto, 1,3)	= 341 
group	by e.cd_cgc, 
	somente_numero(b.cd_agencia_bancaria), 
	b.cd_conta, 
	b.ie_digito_conta, 
	Elimina_Acentuacao(upper(j.ds_razao_social)), 
	Elimina_Acentuacao(upper(b.ds_banco)), 
	a.nr_sequencia, 
	'0' || b.cd_agencia_bancaria || '0000000' || b.CD_CONTA, 
	Elimina_Acentuacao(upper(j.ds_endereco)), 
	Elimina_Acentuacao(upper(j.ds_municipio)), 
	j.cd_cep, 
	j.sg_estado, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END , 
	j.nr_endereco 

Union
 
/* Detalhe Bloquetos ITAU */
 
select	5 tp_registro, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END  ie_forma_pagto, 
 	1 nr_seq_forma_pagto, 
	'0' nr_inscricao, 
	0 cd_agencia, 
	'0' cd_conta, 
	0 ds_dac_agencia, 
	'' nm_empresa, 
	'' ds_banco, 
	'' dt_arquivo, 
	a.nr_sequencia nr_seq_envio, 
	CASE WHEN k.cd_pessoa_fisica IS NULL THEN '2'  ELSE '1' END  ie_tipo_fornecedor, 
	d.cd_favorecido cd_cgc_fornecedor, 
	c.cd_agencia_bancaria cd_agencia_bancaria, 
	c.ie_digito_conta ds_dac_ag_bancaria, 
	c.nr_conta nr_conta_forneced, 
	'' nm_hospital, 
	'' ds_endereco, 
	'' ds_cidade, 
	'0' cd_cep, 
	'' ds_estado, 
	c.cd_banco cd_banco_fornecedor, 
	c.cd_agencia_bancaria cd_agencia_fornecedor, 
	'0' || c.cd_agencia_bancaria || '0000000' || c.nr_conta cd_agencia_conta, 
	Elimina_Acentuacao(upper(d.nm_favorecido)) nm_fornecedor, 
	d.nr_titulo nr_documento, 
	LOCALTIMESTAMP dt_vencimento, 
	d.vl_saldo_titulo vl_saldo_titulo, 
	'0' nr_inscricao_fornec, 
	0 qt_registros, 
	d.nr_bloqueto ie_cod_barras, 
	d.vl_titulo, 
	c.vl_desconto, 
	c.vl_acrescimo, 
	LOCALTIMESTAMP dt_pagto, 
	c.vl_escritural vl_pagto, 
	0 vl_total_pagto, 
	0 qt_lotes_arquivo, 
	0 qt_total_registros, 
	'0' nr_endereco 
from	Estabelecimento e, 
	banco_estabelecimento_v b, 
	banco_escritural a, 
	titulo_pagar_v2 d,	 
	titulo_pagar_v k, 
	titulo_pagar_escrit c 
where	c.nr_titulo			= d.nr_titulo 
and	k.nr_titulo			= d.nr_titulo 
and	a.nr_sequencia		= c.nr_seq_escrit 
and	a.cd_estabelecimento		= e.cd_estabelecimento 
and 	b.ie_tipo_relacao		in ('EP','ECC') 
and	a.nr_seq_conta_banco		= b.nr_sequencia 
and 	c.ie_tipo_pagamento		= 'BLQ' 
and	substr(k.nr_bloqueto, 1,3)	= 341 

Union
 
/* Trailler do Lote Bloquetos ITAU */
 
select	6 tp_registro, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END  ie_forma_pagto, 
 	1 nr_seq_forma_pagto, 
	'0' nr_inscricao, 
	0 cd_agencia, 
	'0' cd_conta, 
	0 ds_dac_agencia, 
	'' nm_empresa, 
	'' ds_banco, 
	'' dt_arquivo, 
	e.nr_sequencia nr_seq_envio, 
	' ' ie_tipo_fornecedor, 
	'0' cd_cgc_fornecedor, 
	'0' cd_agencia_bancaria, 
	'' ds_dac_ag_bancaria,	 
	'0' nr_conta_forneced, 
	'' nm_hospital, 
	'' ds_endereco, 
	'' ds_cidade, 
	'0' cd_cep, 
	'' ds_estado, 
	0 cd_banco_fornecedor, 
	'0' cd_agencia_fornecedor, 
	'' cd_agencia_conta, 
	'' nm_fornecedor, 
	0 nr_documento, 
	LOCALTIMESTAMP dt_vencimento, 
	0 vl_saldo_titulo, 
	'0' nr_inscricao_fornec, 
	(count(*) + 2) qt_registros, 
	'' ie_cod_barras, 
	sum(d.vl_titulo) vl_titulo, 
	sum(c.vl_desconto) vl_desconto, 
	sum(c.vl_acrescimo) vl_acrescimo, 
	LOCALTIMESTAMP dt_pagto, 
	sum(c.vl_escritural) vl_pagto, 
	sum(c.vl_escritural - c.vl_desconto + c.vl_acrescimo) vl_total_pagto, 
	COUNT(*) qt_lotes_arquivo, 
	COUNT(*) qt_total_registros, 
	'0' nr_endereco 
from	banco_estabelecimento_v b, 
	titulo_pagar_v2 d,	 
	titulo_pagar k, 
	estabelecimento a,    
	banco_escritural e, 
	titulo_pagar_escrit c 
where	e.nr_sequencia		= c.nr_seq_escrit 
and	c.nr_titulo			= d.nr_titulo 
and	k.nr_titulo			= d.nr_titulo 
and	e.cd_estabelecimento  	= a.cd_estabelecimento 
and	b.ie_tipo_relacao    	in ('EP','ECC') 
and	b.nr_sequencia		= e.nr_seq_conta_banco 
and 	c.ie_tipo_pagamento		= 'BLQ' 
and	substr(k.nr_bloqueto, 1,3)	= 341 
group by e.nr_sequencia, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END  

union
 
/* Header do Lote Documento não ITAU */
 
select	1 tp_registro, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END  ie_forma_pagto, 
 	CASE WHEN(select count(*) 		from	titulo_pagar y, 			titulo_pagar_escrit x 		where	x.nr_titulo			= y.nr_titulo 		and	x.nr_seq_escrit		= a.nr_sequencia 		and	substr(y.nr_bloqueto, 1,3)	= 341)=0 THEN  1  ELSE 2 END  nr_seq_forma_pagto, 
	e.CD_CGC nr_inscricao, 
	somente_numero(b.cd_agencia_bancaria) cd_agencia, 
	b.cd_conta, 
	coalesce(somente_numero(coalesce(to_char(coalesce(somente_numero(b.ie_digito_conta),0),'0'),'0')),0) ds_dac_agencia, 
	Elimina_Acentuacao(upper(j.ds_razao_social)) nm_empresa, 
	Elimina_Acentuacao(upper(b.ds_banco)), 
	'' dt_arquivo, 
	a.nr_sequencia nr_seq_envio, 
	'2' ie_tipo_fornecedor, 
	e.cd_cgc cd_cgc_fornecedor, 
	' ' cd_agencia_bancaria, 
	' ' ds_dac_ag_bancaria, 
	' ' nr_conta_forneced, 
	Elimina_Acentuacao(upper(j.ds_razao_social)) nm_hospital, 
	Elimina_Acentuacao(upper(j.ds_endereco)) ds_endereco, 
	Elimina_Acentuacao(upper(j.ds_municipio)) ds_cidade, 
	j.cd_cep, 
	j.sg_estado ds_estado, 
	0 cd_banco_fornecedor, 
	' ' cd_agencia_fornecedor, 
	' ' cd_agencia_conta, 
	Elimina_Acentuacao(upper(j.ds_razao_social)) nm_fornecedor, 
	0 nr_documento, 
	LOCALTIMESTAMP dt_vencimento, 
	0 vl_saldo_titulo, 
	'0' nr_inscricao_fornec, 
	0 qt_registros, 
	'' ie_cod_barras, 
	0 vl_titulo, 
	0 vl_desconto, 
	0 vl_acrescimo, 
	LOCALTIMESTAMP dt_pagto, 
	0 vl_pagto, 
	0 vl_total_pagto, 
	0 qt_lotes_arquivo, 
	0 qt_total_registros, 
	j.nr_endereco 
from	pessoa_juridica j, 
	Estabelecimento e, 
	banco_estabelecimento_v b, 
	banco_escritural a, 
	titulo_pagar_v2 d, 
	titulo_pagar_v k,	 
	titulo_pagar_escrit c 
where	c.nr_titulo			= d.nr_titulo 
and	k.nr_titulo			= d.nr_titulo 
and	a.nr_sequencia		= c.nr_seq_escrit 
and	e.cd_cgc			= j.cd_cgc 
and	a.cd_estabelecimento  	= e.cd_estabelecimento 
and	b.ie_tipo_relacao    	in ('EP','ECC') 
and	b.nr_sequencia		= a.nr_seq_conta_banco 
and	c.ie_tipo_pagamento		= 'DOC' 
and	a.cd_banco		<> 341 
group	by e.CD_CGC, 
	somente_numero(b.cd_agencia_bancaria), 
	b.cd_conta, 
	b.ie_digito_conta, 
	Elimina_Acentuacao(upper(j.ds_razao_social)), 
	Elimina_Acentuacao(upper(b.ds_banco)), 
	a.nr_sequencia, 
	Elimina_Acentuacao(upper(j.ds_razao_social)), 
	Elimina_Acentuacao(upper(j.ds_endereco)), 
	Elimina_Acentuacao(upper(j.ds_municipio)), 
	j.cd_cep, 
	j.sg_estado, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END , 
	j.nr_endereco 

Union
 
/* Detalhe Documento  não ITAU*/
 
select	2 tp_registro, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END  ie_forma_pagto, 
 	1 nr_seq_forma_pagto, 
	'0' nr_inscricao, 
	0 cd_agencia, 
	'0' cd_conta, 
	0 ds_dac_agencia, 
	'' nm_empresa, 
	'' ds_banco, 
	'' dt_arquivo, 
	a.nr_sequencia nr_seq_envio, 
	CASE WHEN k.cd_pessoa_fisica IS NULL THEN '2'  ELSE '1' END  ie_tipo_fornecedor, 
	d.cd_favorecido cd_cgc_fornecedor, 
	'0' cd_agencia_bancaria, 
	'' ds_dac_ag_bancaria, 
	'0' nr_conta_forneced, 
	'' nm_hospital, 
	'' ds_endereco, 
	'' ds_cidade, 
	'0' cd_cep, 
	'' ds_estado, 
	c.cd_banco cd_banco_fornecedor, 
	c.cd_agencia_bancaria cd_agencia_fornecedor, 
	'0' || c.cd_agencia_bancaria || '0000000' || c.nr_conta cd_agencia_conta, 
	Elimina_Acentuacao(upper(d.nm_favorecido)) nm_fornecedor, 
	d.nr_titulo nr_documento, 
	d.dt_vencimento_atual dt_vencimento, 
	d.vl_saldo_titulo, 
	e.cd_cgc nr_inscricao_fornec, 
	0 qt_registros, 
	'' ie_cod_barras, 
	k.vl_titulo vl_titulo, 
	0 vl_desconto, 
	0 vl_acrescimo, 
	LOCALTIMESTAMP dt_pagto, 
	c.vl_escritural vl_pagto, 
	0 vl_total_pagto, 
	0 qt_lotes_arquivo, 
	0 qt_total_registros, 
	'0' nr_endereco 
from	Estabelecimento e, 
	banco_estabelecimento_v b, 
	banco_escritural a, 
	titulo_pagar_v2 d,	 
	titulo_pagar_v k, 
	titulo_pagar_escrit c 
where	c.nr_titulo			= d.nr_titulo 
and	k.nr_titulo			= d.nr_titulo 
and	a.nr_sequencia		= c.nr_seq_escrit 
and	a.cd_estabelecimento		= e.cd_estabelecimento 
and 	b.ie_tipo_relacao		in ('EP','ECC') 
and	b.nr_sequencia		= a.nr_seq_conta_banco 
and 	c.ie_tipo_pagamento		= 'DOC' 

Union
 
/* Trailler do Lote Documento não ITAU */
 
select	3 tp_registro, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END  ie_forma_pagto, 
 	1 nr_seq_forma_pagto, 
	'0' nr_inscricao, 
	0 cd_agencia, 
	'0' cd_conta, 
	0 ds_dac_agencia, 
	'' nm_empresa, 
	'' ds_banco, 
	'' dt_arquivo, 
	e.nr_sequencia nr_seq_envio, 
	' ' ie_tipo_fornecedor, 
	'0' cd_cgc_fornecedor, 
	'0' cd_agencia_bancaria, 
	'' ds_dac_ag_bancaria, 
	'0' nr_conta_forneced, 
	'' nm_hospital, 
	'' ds_endereco, 
	'' ds_cidade, 
	'0' cd_cep, 
	'' ds_estado, 
	0 cd_banco_fornecedor, 
	'0' cd_agencia_fornecedor, 
	'' cd_agencia_conta, 
	'' nm_fornecedor, 
	0 nr_documento, 
	LOCALTIMESTAMP dt_vencimento, 
	0 vl_saldo_titulo, 
	'0' nr_inscricao_fornec, 
	count(*) + 2 qt_registros, 
	'' ie_cod_barras, 
	0 vl_titulo, 
	0 vl_desconto, 
	0 vl_acrescimo, 
	LOCALTIMESTAMP dt_pagto, 
	0 vl_pagto, 
	sum(c.vl_escritural - c.vl_desconto + c.vl_acrescimo) vl_total_pagto, 
	0 qt_lotes_arquivo, 
	0 qt_total_registros, 
	'0' nr_endereco 
from	banco_estabelecimento_v b, 
	estabelecimento a,    
	banco_escritural e, 
	titulo_pagar k, 
	titulo_pagar_escrit c 
where	e.nr_sequencia		= c.nr_seq_escrit 
and	e.cd_estabelecimento  	= a.cd_estabelecimento 
and	k.nr_titulo			= c.nr_titulo 
and	b.ie_tipo_relacao   	in ('EP','ECC') 
and	b.nr_sequencia		= e.nr_seq_conta_banco 
and 	c.ie_tipo_pagamento		= 'DOC' 
group by e.nr_sequencia, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END  

union
 
/* Header do Lote Bloquetos não ITAU*/
 
select	4 tp_registro, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END  ie_forma_pagto, 
 	CASE WHEN(select count(*) 		from	titulo_pagar y, 			titulo_pagar_escrit x 		where	x.nr_titulo			= y.nr_titulo 		and	x.nr_seq_escrit		= a.nr_sequencia 		and	substr(y.nr_bloqueto, 1,3)	= 341)=0 THEN  1  ELSE 2 END  nr_seq_forma_pagto, 
	e.cd_cgc nr_inscricao, 
	somente_numero(b.cd_agencia_bancaria) cd_agencia, 
	b.cd_conta, 
	coalesce(somente_numero(coalesce(to_char(coalesce(somente_numero(b.ie_digito_conta),0),'0'),'0')),0) ds_dac_agencia, 
	Elimina_Acentuacao(upper(j.ds_razao_social)) nm_empresa, 
	Elimina_Acentuacao(upper(b.ds_banco)), 
	'' dt_arquivo, 
	a.nr_sequencia nr_seq_envio, 
	'2' ie_tipo_fornecedor, 
	e.cd_cgc cd_cgc_fornecedor, 
	'' cd_agencia_bancaria, 
	'' ds_dac_ag_bancaria, 
	'' nr_conta_forneced, 
	Elimina_Acentuacao(upper(j.ds_razao_social)) nm_hospital, 
	Elimina_Acentuacao(upper(j.ds_endereco)) ds_endereco, 
	Elimina_Acentuacao(upper(j.ds_municipio)) ds_cidade, 
	j.cd_cep, 
	j.sg_estado ds_estado, 
	0 cd_banco_fornecedor, 
	'' cd_agencia_fornecedor, 
	'0' || b.cd_agencia_bancaria || '0000000' || b.CD_CONTA cd_agencia_conta, 
	Elimina_Acentuacao(upper(j.ds_razao_social)) nm_fornecedor, 
	0 nr_documento, 
	LOCALTIMESTAMP dt_vencimento, 
	0 vl_saldo_titulo, 
	'0' nr_inscricao_fornec, 
	0 qt_registros, 
	'' ie_cod_barras, 
	0 vl_titulo, 
	0 vl_desconto, 
	0 vl_acrescimo, 
	LOCALTIMESTAMP dt_pagto, 
	0 vl_pagto, 
	0 vl_total_pagto, 
	0 qt_lotes_arquivo, 
	0 qt_total_registros, 
	j.nr_endereco 
from	pessoa_juridica j, 
	Estabelecimento e, 
	banco_estabelecimento_v b, 
	banco_escritural a, 
	titulo_pagar k, 
	titulo_pagar_escrit c 
where	e.cd_cgc			= j.cd_cgc 
and	a.nr_sequencia     	= c.nr_seq_escrit 
and	a.cd_estabelecimento  	= e.cd_estabelecimento 
and	b.ie_tipo_relacao    	in ('EP','ECC') 
and	a.nr_seq_conta_banco		= b.nr_sequencia 
and	c.nr_titulo			= k.nr_titulo 
and 	c.ie_tipo_pagamento		= 'BLQ' 
and	substr(k.nr_bloqueto,1,3)	<> 341 
group	by e.cd_cgc, 
	somente_numero(b.cd_agencia_bancaria), 
	b.cd_conta, 
	b.ie_digito_conta, 
	Elimina_Acentuacao(upper(j.ds_razao_social)), 
	Elimina_Acentuacao(upper(b.ds_banco)), 
	a.nr_sequencia, 
	'0' || b.cd_agencia_bancaria || '0000000' || b.CD_CONTA, 
	Elimina_Acentuacao(upper(j.ds_endereco)), 
	Elimina_Acentuacao(upper(j.ds_municipio)), 
	j.cd_cep, 
	j.sg_estado, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END , 
	j.nr_endereco 

Union
 
/* Detalhe Bloquetos não ITAU */
 
select	5 tp_registro, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END  ie_forma_pagto, 
 	CASE WHEN(select count(*) 		from	titulo_pagar y, 			titulo_pagar_escrit x 		where	x.nr_titulo			= y.nr_titulo 		and	x.nr_seq_escrit		= a.nr_sequencia 		and	substr(y.nr_bloqueto, 1,3)	= 341)=0 THEN  1  ELSE 2 END  nr_seq_forma_pagto, 
	'0' nr_inscricao, 
	0 cd_agencia, 
	'0' cd_conta, 
	0 ds_dac_agencia, 
	'' nm_empresa, 
	'' ds_banco, 
	'' dt_arquivo, 
	a.nr_sequencia nr_seq_envio, 
	CASE WHEN k.cd_pessoa_fisica IS NULL THEN '2'  ELSE '1' END  ie_tipo_fornecedor, 
	d.cd_favorecido cd_cgc_fornecedor, 
	c.cd_agencia_bancaria cd_agencia_bancaria, 
	c.ie_digito_conta ds_dac_ag_bancaria, 
	c.nr_conta nr_conta_forneced, 
	'' nm_hospital, 
	'' ds_endereco, 
	'' ds_cidade, 
	'0' cd_cep, 
	'' ds_estado, 
	c.cd_banco cd_banco_fornecedor, 
	c.cd_agencia_bancaria cd_agencia_fornecedor, 
	'0' || c.cd_agencia_bancaria || '0000000' || c.nr_conta cd_agencia_conta, 
	Elimina_Acentuacao(upper(d.nm_favorecido)) nm_fornecedor, 
	d.nr_titulo nr_documento, 
	LOCALTIMESTAMP dt_vencimento, 
	d.vl_saldo_titulo vl_saldo_titulo, 
	'0' nr_inscricao_fornec, 
	0 qt_registros, 
	d.nr_bloqueto ie_cod_barras, 
	d.vl_titulo, 
	c.vl_desconto, 
	c.vl_acrescimo, 
	LOCALTIMESTAMP dt_pagto, 
	c.vl_escritural vl_pagto, 
	0 vl_total_pagto, 
	0 qt_lotes_arquivo, 
	0 qt_total_registros, 
	'0' nr_endereco 
from	Estabelecimento e, 
	banco_estabelecimento_v b, 
	banco_escritural a, 
	titulo_pagar_v2 d,	 
	titulo_pagar_v k, 
	titulo_pagar_escrit c 
where	c.nr_titulo			= d.nr_titulo 
and	k.nr_titulo			= d.nr_titulo 
and	a.nr_sequencia		= c.nr_seq_escrit 
and	a.cd_estabelecimento		= e.cd_estabelecimento 
and 	b.ie_tipo_relacao		in ('EP','ECC') 
and	a.nr_seq_conta_banco		= b.nr_sequencia 
and 	c.ie_tipo_pagamento		= 'BLQ' 
and	substr(k.nr_bloqueto,1,3)	<> 341 

Union
 
/* Trailler do Lote Bloquetos não ITAU */
 
select	6 tp_registro, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END  ie_forma_pagto, 
 	CASE WHEN(select count(*) 		from	titulo_pagar y, 			titulo_pagar_escrit x 		where	x.nr_titulo			= y.nr_titulo 		and	x.nr_seq_escrit		= e.nr_sequencia 		and	substr(y.nr_bloqueto, 1,3)	= 341)=0 THEN  1  ELSE 2 END  nr_seq_forma_pagto, 
	'0' nr_inscricao, 
	0 cd_agencia, 
	'0' cd_conta, 
	0 ds_dac_agencia, 
	'' nm_empresa, 
	'' ds_banco, 
	'' dt_arquivo, 
	e.nr_sequencia nr_seq_envio, 
	' ' ie_tipo_fornecedor, 
	'0' cd_cgc_fornecedor, 
	'0' cd_agencia_bancaria, 
	'' ds_dac_ag_bancaria,	 
	'0' nr_conta_forneced, 
	'' nm_hospital, 
	'' ds_endereco, 
	'' ds_cidade, 
	'0' cd_cep, 
	'' ds_estado, 
	0 cd_banco_fornecedor, 
	'0' cd_agencia_fornecedor, 
	'' cd_agencia_conta, 
	'' nm_fornecedor, 
	0 nr_documento, 
	LOCALTIMESTAMP dt_vencimento, 
	0 vl_saldo_titulo, 
	'0' nr_inscricao_fornec, 
	(count(*) + 2) qt_registros, 
	'' ie_cod_barras, 
	sum(d.vl_titulo) vl_titulo, 
	sum(c.vl_desconto) vl_desconto, 
	sum(c.vl_acrescimo) vl_acrescimo, 
	LOCALTIMESTAMP dt_pagto, 
	sum(c.vl_escritural) vl_pagto, 
	sum(c.vl_escritural - c.vl_desconto + c.vl_acrescimo) vl_total_pagto, 
	COUNT(*) qt_lotes_arquivo, 
	COUNT(*) qt_total_registros, 
	'0' nr_endereco 
from	banco_estabelecimento_v b, 
	titulo_pagar_v2 d,	 
	titulo_pagar k, 
	estabelecimento a,    
	banco_escritural e, 
	titulo_pagar_escrit c 
where	e.nr_sequencia		= c.nr_seq_escrit 
and	c.nr_titulo			= d.nr_titulo 
and	k.nr_titulo			= d.nr_titulo 
and	e.cd_estabelecimento  	= a.cd_estabelecimento 
and	b.ie_tipo_relacao    	in ('EP','ECC') 
and	b.nr_sequencia		= e.nr_seq_conta_banco 
and 	c.ie_tipo_pagamento		= 'BLQ' 
and	substr(k.nr_bloqueto,1,3)	<> 341 
group by e.nr_sequencia, 
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '01' WHEN c.ie_tipo_pagamento='TED' THEN '03' WHEN c.ie_tipo_pagamento='OP' THEN '10' WHEN c.ie_tipo_pagamento='PC' THEN '33' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=341 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' END  

union
 
/* Trailler do Arquivo*/
 
select	7 tp_registro, 
	'99' ie_forma_pagto, 
 	0 nr_seq_forma_pagto, 
	'0' nr_inscricao, 
	0 cd_agencia, 
	'0' cd_conta, 
	0 ds_dac_agencia, 
	'' nm_empresa, 
	'' ds_banco, 
	'' dt_arquivo, 
	e.nr_sequencia nr_seq_envio, 
	' ' ie_tipo_fornecedor, 
	'0' cd_cgc_fornecedor, 
	'0' cd_agencia_bancaria, 
	'' ds_dac_ag_bancaria, 
	'0' nr_conta_forneced, 
	'' nm_hospital, 
	'' ds_endereco, 
	'' ds_cidade, 
	'0' cd_cep, 
	'' ds_estado, 
	0 cd_banco_fornecedor, 
	'0' cd_agencia_fornecedor, 
	'' cd_agencia_conta, 
	'' nm_fornecedor, 
	99999 nr_documento, 
	LOCALTIMESTAMP dt_vencimento, 
	0 vl_saldo_titulo, 
	'0' nr_inscricao_fornec, 
	0 qt_registros, 
	'' ie_cod_barras, 
	0 vl_titulo, 
	0 vl_desconto, 
	0 vl_acrescimo, 
	LOCALTIMESTAMP dt_pagto, 
	0 vl_pagto, 
	0 vl_total_pagto, 
	count(*) qt_lotes_arquisvo, 
	(obter_dados_pagto_escrit(e.nr_sequencia,'QTRI'))::numeric  qt_total_registros, 
	'0' nr_endereco 
from	banco_estabelecimento_v b, 
	estabelecimento a,    
	banco_escritural e 
where	e.cd_estabelecimento  	= a.cd_estabelecimento 
and	b.ie_tipo_relacao    	in ('EP','ECC') 
and	b.nr_sequencia		= e.nr_seq_conta_banco 
group by e.nr_sequencia 
order by ie_forma_pagto, 
	tp_registro, 
	nr_documento;

