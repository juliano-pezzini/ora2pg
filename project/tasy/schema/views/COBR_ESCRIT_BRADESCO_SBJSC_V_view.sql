-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cobr_escrit_bradesco_sbjsc_v (tp_registro, nr_seq_envio, cd_empresa, nm_empresa, dt_gravacao, cd_agencia_bancaria, cd_sacado, cd_conta, id_empresa, nr_controle_partic, cd_banco, nr_nosso_numero, nr_dig_nosso_numero, vl_desconto_dia, cd_condicao, ie_emite_papeleta, ie_rateio, ie_endereco, ie_ocorrencia, nr_documento, dt_vencimento, vl_titulo, cd_banco_cobranca, cd_agencia_deposito, ie_especie, ie_aceite, dt_emissao, ie_instrucao1, ie_instrucao2, dt_desconto, vl_desconto, vl_acrescimo, vl_abatimento, vl_iof, ie_tipo_inscricao, nr_inscricao, nm_sacado, ds_endereco_sacado, cd_cep, nr_seq_arquivo) AS select	0 				tp_registro,
	a.nr_sequencia			nr_seq_envio, 
	128996				cd_empresa, 
	upper(elimina_acentuacao(substr(obter_nome_pf_pj(null, b.cd_cgc),1,30))) nm_empresa, 
	a.dt_remessa_retorno		dt_gravacao, 
	0				cd_agencia_bancaria, 
	0				cd_sacado, 
	0				cd_conta, 
	' '				id_empresa, 
	' '				nr_controle_partic, 
	0				cd_banco, 
	0				nr_nosso_numero, 
	' '				nr_dig_nosso_numero, 
	0				vl_desconto_dia, 
	0				cd_condicao, 
	' '				ie_emite_papeleta, 
	' '				ie_rateio, 
	0				ie_endereco, 
	0				ie_ocorrencia, 
	0				nr_documento, 
	LOCALTIMESTAMP				dt_vencimento, 
	0				vl_titulo, 
	0				cd_banco_cobranca, 
	0				cd_agencia_deposito, 
	0				ie_especie, 
	' '				ie_aceite, 
	LOCALTIMESTAMP				dt_emissao, 
	0				ie_instrucao1, 
	0				ie_instrucao2, 
	LOCALTIMESTAMP				dt_desconto, 
	0				vl_desconto, 
	0				vl_acrescimo, 
	0				vl_abatimento, 
	0				vl_iof, 
	0				ie_tipo_inscricao, 
	0				nr_inscricao, 
	' '				nm_sacado, 
	' '				ds_endereco_sacado, 
	' '				cd_cep, 
	coalesce(a.nr_remessa,0)		nr_seq_arquivo 
FROM	estabelecimento b, 
	cobranca_escritural a 
where	a.cd_estabelecimento	= b.cd_estabelecimento 

union all
 
select	1				tp_registro, 
	a.nr_sequencia			nr_seq_envio, 
	0				cd_empresa, 
	' '				nm_empresa, 
	LOCALTIMESTAMP				dt_gravacao, 
	/*(select	somente_numero(x.cd_agencia_bancaria) 
	from	banco_estabelecimento x 
	where	x.nr_sequencia	= a.nr_seq_conta_banco)	cd_agencia_bancaria, 
	0				cd_sacado, 
	(select	somente_numero(X.cd_conta || x.ie_digito_conta) 
	from	banco_estabelecimento x 
	where	x.nr_sequencia	= a.nr_seq_conta_banco)	cd_conta,*/
 
	0 cd_agencia_bancaria, 
	0 cd_sacado, 
	0 cd_conta, 
	lpad(e.cd_carteira,4,'0') || 
		(select lpad(substr(x.cd_agencia_bancaria,1,4),5,'0') || lpad(x.cd_conta,7,'0') || coalesce(x.ie_digito_conta,'0') 
		from	banco_estabelecimento_v x 
		where x.nr_sequencia = a.nr_seq_conta_banco) id_empresa, 
	substr(b.nr_titulo,1,25)	nr_controle_partic, 
	--237				cd_banco, 
	0 cd_banco, 
	--somente_numero(c.nr_titulo)	nr_nosso_numero, 
	0 nr_nosso_numero, 
	' '				nr_dig_nosso_numero, 
	0				vl_desconto_dia, 
	1				cd_condicao, 
	'N'				ie_emite_papeleta, 
	' '				ie_rateio, 
	1				ie_endereco, 
	somente_numero(coalesce(c.cd_ocorrencia,'1'))	ie_ocorrencia, 
	(obter_dados_titulo_receber(b.nr_titulo,'NE'))::numeric 	nr_documento,  --Elton OS 130990 - alterado de nr_titulo para nr_nota_fiscal --- OS185942 - Alterado para NR_NFE_IMP 
	coalesce(b.dt_pagamento_previsto, b.dt_vencimento) dt_vencimento, 
	coalesce(b.vl_titulo,0)		vl_titulo, 
	b.cd_banco			cd_banco_cobranca, 
	somente_numero(b.cd_agencia_bancaria) cd_agencia_deposito, 
	12				ie_especie, 
	'A'				ie_aceite, 
	b.dt_emissao			dt_emissao, 
	somente_numero(c.cd_instrucao)	ie_instrucao1, 
	0				ie_instrucao2, 
	LOCALTIMESTAMP				dt_desconto, 
	coalesce(c.vl_desconto,0)		vl_desconto, 
	coalesce(c.vl_acrescimo,0)		vl_acrescimo, 
	0				vl_abatimento, 
	0				vl_iof, 
	CASE WHEN b.cd_cgc IS NULL THEN  1  ELSE 2 END 	ie_tipo_inscricao, 
	somente_numero(b.cd_cgc_cpf)	nr_inscricao, 
	upper(elimina_acentuacao(substr(b.nm_pessoa,1,30))) nm_sacado, 
	upper(elimina_acentuacao(substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'EN'),1,50) || ', ' || 
	substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'NR'),1,10) || ' ' || 
	substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CO'),1,50) || ' ' || 
	substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'B'),1,50) || ' ' || 
	substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CI'),1,50) || ' ' || 
	substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'UF'),1,2))) ds_endereco_sacado, 
	substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CEP'),1,50) cd_cep, 
	coalesce(a.nr_remessa,0)		nr_seq_arquivo 
FROM titulo_receber_cobr c, cobranca_escritural a, titulo_receber_v b
LEFT OUTER JOIN banco_carteira e ON (b.nr_seq_carteira_cobr = e.nr_sequencia)
WHERE a.nr_sequencia		= c.nr_seq_cobranca and c.nr_titulo		= b.nr_titulo  
union all
 
select	9				tp_registro, 
	a.nr_sequencia			nr_seq_envio, 
	0				cd_empresa, 
	' '				nm_empresa, 
	LOCALTIMESTAMP				dt_gravacao, 
	0				cd_agencia_bancaria, 
	0				cd_sacado, 
	0				cd_conta, 
	' '				id_empresa, 
	' '				nr_controle_partic, 
	0				cd_banco, 
	0				nr_nosso_numero, 
	' '				nr_dig_nosso_numero, 
	0				vl_desconto_dia, 
	0				cd_condicao, 
	' '				ie_emite_papeleta, 
	' '				ie_rateio, 
	0				ie_endereco, 
	0				ie_ocorrencia, 
	0				nr_documento, 
	LOCALTIMESTAMP				dt_vencimento, 
	0				vl_titulo, 
	0				cd_banco_cobranca, 
	0				cd_agencia_deposito, 
	0				ie_especie, 
	' '				ie_aceite, 
	LOCALTIMESTAMP				dt_emissao, 
	0				ie_instrucao1, 
	0				ie_instrucao2, 
	LOCALTIMESTAMP				dt_desconto, 
	0				vl_desconto, 
	0				vl_acrescimo, 
	0				vl_abatimento, 
	0				vl_iof, 
	0				ie_tipo_inscricao, 
	0				nr_inscricao, 
	' '				nm_sacado, 
	' '				ds_endereco_sacado, 
	' '				cd_cep, 
	coalesce(a.nr_remessa,0)		nr_seq_arquivo 
from	cobranca_escritural a;

