-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pagamento_escrit_hsbc_v (tp_registro, nr_inscricao, nr_contrato, nr_seq_envio, cd_agencia, cd_conta, nr_digito_conta, nm_empresa, nm_banco, dt_arquivo, hr_arquivo, ie_tipo_servico, ie_forma_lancamento, ds_mensagem, ds_endereco, nr_endereco, ds_complemento, ds_cidade, cd_cep, sg_estado, ie_emissao_lote, ie_tipo_movimento, cd_movimento, cd_banco, cd_compensacao, nm_favorecido, nr_documento, dt_lancamento, vl_saldo_titulo, ie_emissao_individual, nm_pagador, ds_informacoes, ds_aviso, qt_registros, vl_total_pagto, cd_moeda, nr_digito_barras, dt_vencimento, vl_titulo, vl_desconto, vl_acrescimo, dt_pagamento, vl_pagto, qt_moeda, cd_sacado, qt_lotes_arquivos, qt_total_registros) AS select	0						tp_registro,
	a.cd_cgc					nr_inscricao, 
	g.cd_interno					nr_contrato, 
	e.nr_sequencia					nr_seq_envio, 
	somente_numero(g.cd_agencia_bancaria)		cd_agencia, 
	(g.cd_conta)::numeric 				cd_conta, 
	g.ie_digito_conta				nr_digito_conta, 
	upper(p.ds_razao_social)			nm_empresa, 
	g.ds_banco					nm_banco, 
	e.dt_remessa_retorno				dt_arquivo, 
	e.dt_remessa_retorno				hr_arquivo, 
	0						ie_tipo_servico, 
	0						ie_forma_lancamento, 
	' '						ds_mensagem, 
	' '						ds_endereco, 
	' '						nr_endereco, 
	' '						ds_complemento, 
	' '						ds_cidade, 
	' '						cd_cep, 
	' '						sg_estado, 
	' '						ie_emissao_lote, 
	0						ie_tipo_movimento, 
	0						cd_movimento, 
	0						cd_banco, 
	0						cd_compensacao, 
	' '						nm_favorecido, 
	0						nr_documento, 
	LOCALTIMESTAMP						dt_lancamento, 
	0						vl_saldo_titulo, 
	' '						ie_emissao_individual, 
	' '						nm_pagador, 
	' '						ds_informacoes, 
	' '						ds_aviso, 
	0						qt_registros, 
	0						vl_total_pagto, 
	0						cd_moeda, 
	' '						nr_digito_barras, 
	LOCALTIMESTAMP						dt_vencimento, 
	0						vl_titulo, 
	0						vl_desconto, 
	0						vl_acrescimo, 
	LOCALTIMESTAMP						dt_pagamento, 
	0						vl_pagto, 
	0						qt_moeda, 
	' '						cd_sacado, 
	0						qt_lotes_arquivos, 
	0						qt_total_registros 
FROM	estabelecimento a, 
	banco_estabelecimento_v g, 
	pessoa_juridica p, 
	banco_escritural e 
where	e.cd_estabelecimento  	= a.cd_estabelecimento 
 and	a.cd_cgc		= p.cd_cgc 
 and	g.nr_sequencia		= e.nr_seq_conta_banco 
 and	g.ie_tipo_relacao   	in ('EP','ECC') 

union
 
/*	Header do Lote		*/
 
select	1						tp_registro, 
	e.cd_cgc					nr_inscricao, 
	b.cd_interno					nr_contrato, 
	a.nr_sequencia					nr_seq_lote, 
	somente_numero(b.cd_agencia_bancaria)		cd_agencia, 
	(b.cd_conta)::numeric 				cd_conta, 
	b.ie_digito_conta				nr_digito_conta, 
	upper(j.ds_razao_social)			nm_empresa, 
	' '						nm_banco, 
	LOCALTIMESTAMP						dt_arquivo, 
	LOCALTIMESTAMP						hr_arquivo, 
	20						ie_tipo_servico, 
	0						ie_forma_lancamento, 
	' '						ds_mensagem, 
	upper(j.ds_endereco)				ds_endereco, 
	' '						nr_endereco, 
	j.ds_complemento				ds_complemento, 
	j.ds_municipio					ds_cidade, 
	j.cd_cep					cd_cep, 
	j.sg_estado					sg_estado, 
	'S'						ie_emissao_lote, 
	0						ie_tipo_movimento, 
	0						cd_movimento, 
	0						cd_banco, 
	0						cd_compensacao, 
	' '						nm_favorecido, 
	0						nr_documento, 
	LOCALTIMESTAMP						dt_lancamento, 
	0						vl_saldo_titulo, 
	' '						ie_emissao_individual, 
	' '						nm_pagador, 
	' '						ds_informacoes, 
	' '						ds_aviso, 
	0						qt_registros, 
	0						vl_total_pagto, 
	0						cd_moeda, 
	' '						nr_digito_barras, 
	LOCALTIMESTAMP						dt_vencimento, 
	0						vl_titulo, 
	0						vl_desconto, 
	0						vl_acrescimo, 
	LOCALTIMESTAMP						dt_pagamento, 
	0						vl_pagto, 
	0						qt_moeda, 
	' '						cd_sacado, 
	0						qt_lotes_arquivos, 
	0						qt_total_registros 
from	pessoa_juridica j, 
	Estabelecimento e, 
	banco_estabelecimento_v b, 
	banco_escritural a, 
	titulo_pagar_escrit c 
where	a.nr_sequencia		= c.nr_seq_escrit 
 and	e.cd_cgc		= j.cd_cgc 
 and	a.cd_estabelecimento  = e.cd_estabelecimento 
 and	b.ie_tipo_relacao    in ('EP','ECC') 
 and	b.nr_sequencia		= a.nr_seq_conta_banco 
 and	c.ie_tipo_pagamento	= 'DOC' 

union
 
/*	Detalhe Documento	*/
 
select	2						tp_registro, 
	' '						nr_inscricao, 
	0						nr_contrato, 
	a.nr_sequencia					nr_seq_lote, 
	somente_numero(c.cd_agencia_bancaria)		cd_agencia, 
	(c.nr_conta)::numeric 				cd_conta, 
	c.ie_digito_conta				nr_digito_conta, 
	' '						nm_empresa, 
	' '						nm_banco, 
	LOCALTIMESTAMP						dt_arquivo, 
	LOCALTIMESTAMP 					hr_arquivo, 
	0						ie_tipo_servico, 
	0						ie_forma_lancamento, 
	' '						ds_mensagem, 
	' '						ds_endereco, 
	' '						nr_endereco, 
	' '						ds_complemento, 
	' '						ds_cidade, 
	' '						cd_cep, 
	' '						sg_estado, 
	' '						ie_emissao_lote, 
	0						ie_tipo_movimento, 
	0						cd_movimento, 
	c.cd_banco					cd_banco, 
	c.cd_camara_compensacao				cd_compensacao, 
	d.nm_favorecido					nm_favorecido, 
	d.nr_titulo					nr_documento, 
	d.dt_emissao					dt_lancamento, 
	coalesce(d.vl_saldo_titulo,0)			vl_saldo_titulo, 
	'S'						ie_emissao_individual, 
	' '						nm_pagador, 
	' '						ds_informacoes, 
	' '						ds_aviso, 
	0						qt_registros, 
	0						vl_total_pagto, 
	0						cd_moeda, 
	' '						nr_digito_barras, 
	LOCALTIMESTAMP						dt_vencimento, 
	0						vl_titulo, 
	0						vl_desconto, 
	0						vl_acrescimo, 
	LOCALTIMESTAMP						dt_pagamento, 
	0						vl_pagto, 
	0						qt_moeda, 
	' '						cd_sacado,	 
	0						qt_lotes_arquivos, 
	0						qt_total_registros 
from	estabelecimento e, 
	banco_estabelecimento_v b, 
	banco_escritural a, 
	titulo_pagar_v2 d, 
	titulo_pagar_escrit c 
where	c.nr_titulo		= d.nr_titulo 
and	a.nr_sequencia		= c.nr_seq_escrit 
and	a.cd_estabelecimento	= e.cd_estabelecimento 
and 	b.ie_tipo_relacao	in ('EP','ECC') 
and	b.nr_sequencia		= a.nr_seq_conta_banco 
and 	c.ie_tipo_pagamento	= 'DOC' 

Union
 
/*	Trailler do Lote		*/
 
select	3						tp_registro, 
	' '						nr_inscricao, 
	0						nr_contrato, 
	e.nr_sequencia					nr_seq_lote, 
	0						cd_agencia, 
	0						cd_conta, 
	' '		 				nr_digito_conta, 
	' '						nm_empresa, 
	' '						nm_banco, 
	LOCALTIMESTAMP						dt_arquivo, 
	LOCALTIMESTAMP 					hr_arquivo, 
	0						ie_tipo_servico, 
	0						ie_forma_lancamento, 
	' '						ds_mensagem, 
	' '						ds_endereco, 
	' '						nr_endereco, 
	' '						ds_complemento, 
	' '						ds_cidade, 
	' '						cd_cep, 
	' '						sg_estado, 
	' '						ie_emissao_lote, 
	0						ie_tipo_movimento, 
	0						cd_movimento, 
	0						cd_banco, 
	0						cd_compensacao, 
	' '						nm_favorecido, 
	0						nr_documento, 
	LOCALTIMESTAMP						dt_lancamento, 
	0						vl_saldo_titulo, 
	' '						ie_emissao_individual, 
	' '						nm_pagador, 
	' '						ds_informacoes, 
	' '						ds_aviso, 
	count(*)					qt_registros, 
	sum(coalesce(c.vl_escritural,0) - coalesce(c.vl_desconto,0) + coalesce(c.vl_acrescimo,0)) vl_total_pagto, 
	0						cd_moeda, 
	' '						nr_digito_barras, 
	LOCALTIMESTAMP						dt_vencimento, 
	0						vl_titulo, 
	0						vl_desconto, 
	0						vl_acrescimo, 
	LOCALTIMESTAMP						dt_pagamento, 
	0						vl_pagto, 
	0						qt_moeda, 
	' '						cd_sacado, 
	0						qt_lotes_arquivos, 
	0						qt_total_registros 
from	banco_estabelecimento_v b, 
	estabelecimento a,    
	banco_escritural e, 
	titulo_pagar_escrit c 
where	e.nr_sequencia		= c.nr_seq_escrit 
and	e.cd_estabelecimento  = a.cd_estabelecimento 
and	b.ie_tipo_relacao   	in ('EP','ECC') 
and	b.nr_sequencia		= e.nr_seq_conta_banco 
and 	c.ie_tipo_pagamento	= 'DOC' 
group by	e.nr_sequencia 

union
 
/*	Header do Lote - Bloquetos	*/
 
select	4						tp_registro, 
	e.cd_cgc					nr_inscricao, 
	b.cd_interno					nr_contrato, 
	a.nr_sequencia					nr_seq_lote, 
	somente_numero(b.cd_agencia_bancaria)		cd_agencia, 
	(b.cd_conta)::numeric 				cd_conta, 
	b.ie_digito_conta				nr_digito_conta, 
	upper(j.ds_razao_social)			nm_empresa, 
	b.ds_banco					nm_banco, 
	LOCALTIMESTAMP						dt_arquivo, 
	LOCALTIMESTAMP 					hr_arquivo, 
	01						ie_tipo_servico, 
	31						ie_forma_lancamento, 
	' '						ds_mensagem, 
	upper(j.ds_endereco)				ds_endereco, 
	j.nr_endereco					nr_endereco, 
	j.ds_complemento				ds_complemento, 
	j.ds_municipio					ds_cidade, 
	j.cd_cep					cd_cep, 
	j.sg_estado					sg_estado, 
	'S'						ie_emissao_lote, 
	0						ie_tipo_movimento, 
	0						cd_movimento, 
	0						cd_banco, 
	0						cd_compensacao, 
	upper(j.ds_razao_social)			nm_favorecido, 
	0						nr_documento, 
	LOCALTIMESTAMP						dt_lancamento, 
	0						vl_saldo_titulo, 
	' '						ie_emissao_individual, 
	' '						nm_pagador, 
	' '						ds_informacoes, 
	' '						ds_aviso, 
	0						qt_registros, 
	0						vl_total_pagto, 
	0						cd_moeda, 
	' '						nr_digito_barras, 
	LOCALTIMESTAMP						dt_vencimento, 
	0						vl_titulo, 
	0						vl_desconto, 
	0						vl_acrescimo, 
	LOCALTIMESTAMP						dt_pagamento, 
	0						vl_pagto, 
	0						qt_moeda, 
	' '						cd_sacado, 
	0						qt_lotes_arquivos, 
	0						qt_total_registros 
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

union
 
/*	Detalhe Bloquetos	*/
 
select	5						tp_registro, 
	' '						nr_inscricao, 
	0						nr_contrato, 
	a.nr_sequencia					nr_seq_lote, 
	somente_numero(c.cd_agencia_bancaria)		cd_agencia, 
	(c.nr_conta)::numeric 				cd_conta, 
	c.ie_digito_conta				nr_digito_conta, 
	' '						nm_empresa, 
	' '						nm_banco, 
	LOCALTIMESTAMP						dt_arquivo, 
	LOCALTIMESTAMP 					hr_arquivo, 
	0						ie_tipo_servico, 
	0						ie_forma_lancamento, 
	' '						ds_mensagem, 
	' '						ds_endereco, 
	' '						nr_endereco, 
	' '						ds_complemento, 
	' '						ds_cidade, 
	' '						cd_cep, 
	' '						sg_estado, 
	'S'						ie_emissao_lote, 
	0						ie_tipo_movimento, 
	00						cd_movimento, 
	c.cd_banco					cd_banco, 
	0						cd_compensacao, 
	d.nm_favorecido					nm_favorecido, 
	0						nr_documento, 
	LOCALTIMESTAMP						dt_lancamento, 
	0						vl_saldo_titulo, 
	' '						ie_emissao_individual, 
	' '						nm_pagador, 
	' '						ds_informacoes, 
	' '						ds_aviso, 
	0						qt_registros, 
	0						vl_total_pagto, 
	k.cd_moeda					cd_moeda, 
	d.nr_bloqueto					nr_digito_barras, 
	d.dt_vencimento_atual				dt_vencimento, 
	coalesce(d.vl_titulo,0)				vl_titulo, 
	coalesce(c.vl_desconto,0)				vl_desconto, 
	coalesce(c.vl_acrescimo,0)				vl_acrescimo, 
	k.dt_liquidacao					dt_pagamento, 
	coalesce(c.vl_escritural,0)				vl_pagto, 
	0						qt_moeda, 
	' '						cd_sacado, 
	0						qt_lotes_arquivos, 
	0						qt_total_registros 
from	estabelecimento e, 
	banco_estabelecimento_v b, 
	banco_escritural a, 
	titulo_pagar_v2 d,	 
	titulo_pagar_v k, 
	titulo_pagar_escrit c 
where	c.nr_titulo			= d.nr_titulo 
and	k.nr_titulo			= d.nr_titulo 
and	a.nr_sequencia			= c.nr_seq_escrit 
and	a.cd_estabelecimento		= e.cd_estabelecimento 
and 	b.ie_tipo_relacao		in ('EP','ECC') 
and	a.nr_seq_conta_banco		= b.nr_sequencia 
and 	c.ie_tipo_pagamento		= 'BLQ' 

Union
 
/*	Trailler do Lote - Bloquetos	*/
 
select	6						tp_registro, 
	' '						nr_inscricao, 
	0						nr_contrato, 
	e.nr_sequencia					nr_seq_lote, 
	0						cd_agencia, 
	0						cd_conta, 
	' '						nr_digito_conta, 
	' '						nm_empresa, 
	' '						nm_banco, 
	LOCALTIMESTAMP						dt_arquivo, 
	LOCALTIMESTAMP 					hr_arquivo, 
	0						ie_tipo_servico, 
	0						ie_forma_lancamento, 
	' '						ds_mensagem, 
	' '						ds_endereco, 
	' '						nr_endereco, 
	' '						ds_complemento, 
	' '						ds_cidade, 
	' '						cd_cep, 
	' '						sg_estado, 
	' '						ie_emissao_lote, 
	0						ie_tipo_movimento, 
	00						cd_movimento, 
	0						cd_banco, 
	0						cd_compensacao, 
	' '						nm_favorecido, 
	0						nr_documento, 
	LOCALTIMESTAMP						dt_lancamento, 
	0						vl_saldo_titulo, 
	'S'						ie_emissao_individual, 
	' '						nm_pagador, 
	' '						ds_informacoes, 
	' '						ds_aviso, 
	count(*)					qt_registros, 
	sum(coalesce(c.vl_escritural,0) - coalesce(c.vl_desconto,0) + coalesce(c.vl_acrescimo,0)) vl_total_pagto, 
	0						cd_moeda, 
	' '						nr_digito_barras, 
	LOCALTIMESTAMP						dt_vencimento, 
	0						vl_titulo, 
	0						vl_desconto, 
	0						vl_acrescimo, 
	LOCALTIMESTAMP						dt_pagamento, 
	0						vl_pagto, 
	0						qt_moeda, 
	' '						cd_sacado, 
	0						qt_lotes_arquivos, 
	0						qt_total_registros	 
from	banco_estabelecimento_v b, 
	estabelecimento a,    
	banco_escritural e, 
	titulo_pagar_escrit c 
where	e.nr_sequencia		= c.nr_seq_escrit 
and	e.cd_estabelecimento  = a.cd_estabelecimento 
and	b.ie_tipo_relacao   	in ('EP','ECC') 
and	b.nr_sequencia		= e.nr_seq_conta_banco 
and 	c.ie_tipo_pagamento	= 'BLQ' 
group by e.nr_sequencia 

union
 
/*	Trailler do Arquivo	*/
 
select	7						tp_registro, 
	' '						nr_inscricao, 
	0						nr_contrato, 
	e.nr_sequencia					nr_seq_lote, 
	0						cd_agencia, 
	0						cd_conta, 
	' '						nr_digito_conta, 
	' '						nm_empresa, 
	' '						nm_banco, 
	LOCALTIMESTAMP						dt_arquivo, 
	LOCALTIMESTAMP 					hr_arquivo, 
	0						ie_tipo_servico, 
	0						ie_forma_lancamento, 
	' '						ds_mensagem, 
	' '						ds_endereco, 
	' '						nr_endereco, 
	' '						ds_complemento, 
	' '						ds_cidade, 
	' '						cd_cep, 
	' '						sg_estado, 
	' '						ie_emissao_lote, 
	0						ie_tipo_movimento, 
	0						cd_movimento, 
	0						cd_banco, 
	0						cd_compensacao, 
	' '						nm_favorecido, 
	0						nr_documento, 
	LOCALTIMESTAMP						dt_lancamento, 
	0						vl_saldo_titulo, 
	' '						ie_emissao_individual, 
	' '						nm_pagador, 
	' '						ds_informacoes, 
	' '						ds_aviso, 
	0						qt_registros, 
	0						vl_total_pagto, 
	0						cd_moeda, 
	' '						nr_digito_barras, 
	LOCALTIMESTAMP						dt_vencimento, 
	0						vl_titulo, 
	0						vl_desconto, 
	0						vl_acrescimo, 
	LOCALTIMESTAMP						dt_pagamento, 
	0						vl_pagto, 
	0						qt_moeda, 
	' '						cd_sacado, 
	count(*)					qt_lotes_arquivos, 
	count(*)					qt_total_registros 
from	banco_estabelecimento_v b, 
	estabelecimento a,    
	banco_escritural e 
where	e.cd_estabelecimento  = a.cd_estabelecimento 
and	b.ie_tipo_relacao    in ('EP','ECC') 
and	b.nr_sequencia		= e.nr_seq_conta_banco 
group by e.nr_sequencia 
order by tp_registro, 
	 nr_documento;
