-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobr_bradesco_240_reg ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
-- Febraban v08.4 - 01/02/2012 - Bradesco 
						 
ds_conteudo_w			varchar(240);
ds_brancos_205_w			varchar(205);
ds_brancos_165_w			varchar(165);
nm_empresa_w			varchar(80);
nm_pessoa_w			varchar(80);
ds_brancos_54_w			varchar(54);
ds_endereco_w			varchar(40);
ds_bairro_w			varchar(40);
ds_brancos_80_w			varchar(80);
ds_banco_w			varchar(30);
ds_brancos_25_w			varchar(25);
cd_convenio_banco_w		varchar(20);
ds_cidade_w			varchar(20);
ds_nosso_numero_w		varchar(20);
ds_complemento_w			varchar(18);
vl_juros_w			varchar(17);
ds_brancos_17_w			varchar(17);
nr_conta_corrente_w		varchar(15);
dt_remessa_retorno_w		varchar(14);
dt_geracao_arquivo_w		varchar(14);
nr_inscricao_w			varchar(15);
vl_liquidacao_w			varchar(15);
vl_cobranca_w			varchar(15);
vl_desconto_w			varchar(15);
dt_desconto_w			varchar(8);
vl_mora_w			varchar(15);
nr_seq_registro_w			bigint;
ds_brancos_10_w			varchar(10);
qt_reg_lote_w			varchar(10);
dt_vencimento_w			varchar(8);
dt_emissao_w			varchar(8);
dt_pagamento_w			varchar(8);
cd_cep_w			varchar(8);
nr_seq_lote_w			bigint;
nr_seq_arquivo_w			varchar(6);
nr_seq_envio_w			varchar(8);
cd_agencia_bancaria_w		varchar(5);
ie_tipo_inscricao_w			varchar(5);
nr_endereco_w			varchar(5);
cd_banco_w			varchar(3);
ie_emissao_bloqueto_w		varchar(3);
nr_digito_agencia_w		varchar(2);
sg_uf_w				varchar(2);
ie_protesto_w			varchar(2);
ie_tipo_registro_w			varchar(1);
qt_reg_arquivo_w			bigint := 0;
ds_brancos_69_w			varchar(69);
ds_brancos_33_w			varchar(33);
dt_gravacao_w			varchar(8);
nr_nosso_numero_w		varchar(20);
nr_seq_carteira_cobr_w		varchar(1);
nr_documento_cobr_w		varchar(15);
nr_titulo_w			varchar(25);
nm_pessoa_titulo_w		varchar(40);
sg_estado_w			varchar(15);
nr_seq_apres_w			bigint	:= 1;
ds_brancos_9_w			varchar(9);
ds_brancos_2_w			varchar(2);
ds_zeros_23_w			varchar(23);
ds_brancos_8_w			varchar(8);
ds_brancos_55_w			varchar(55);
ds_brancos_28_w			varchar(28);
ds_brancos_119_w			varchar(119);
ie_codigo_desconto_w		varchar(1);
nr_seq_contrato_w			bigint;
nr_seq_mensalidade_w		bigint;
cd_mov_remessa_w		varchar(2);
qt_registro_lote_w			varchar(6) := 0;
vl_juros_acobrar_w			varchar(15);
nr_seq_total_linhas_w		bigint;

/* Mensagens */
 
nr_seq_mensagem_w		bigint;
pr_juros_w			varchar(255);
pr_multa_w			varchar(255);
dt_mensalidade_w			varchar(255);
nr_contrato_w			varchar(255);
ds_plano_w			varchar(255);
nr_protocolo_ans_w		varchar(255);
dt_proximo_reajuste_w		varchar(255);
cd_usuario_plano_w		varchar(255);
dt_contratacao_w			varchar(255);
vl_mensalidade_w			varchar(255);
vl_coparticipacao_w		varchar(255);
cd_pessoa_fisica_w		varchar(255);
dt_solicitacao_w			varchar(255);
dt_resposta_w			varchar(255);
vl_outros_n_w			double precision;
vl_outros_w			varchar(255)	:= null;
vl_total_w			varchar(255)	:= null;
ie_adiciona_linhas_w		varchar(255)	:= 'N';
nr_seq_plano_w			bigint;
nr_seq_segurado_w		bigint;
nr_seq_segurado_mens_w		bigint;
qt_itens_w			bigint	:= 0;
nr_seq_pagador_w			bigint;
qt_coparticipacao_w		bigint;
nr_seq_mensalidade_seg_w		bigint;
vl_item_w				double precision;
dt_reajuste_prox_w			timestamp;
dt_ref_mensalidade_w		timestamp;
dt_reajuste_w			timestamp;
dt_remessa_retorno_w		timestamp;
cd_cgc_estip_w			varchar(14);
nr_linha_w			bigint := 0;
ds_mensagem_w			varchar(100);

C01 CURSOR FOR 
	SELECT	lpad(c.cd_banco,3,'0') cd_banco, 
		substr(a.nr_sequencia,1,5) nr_seq_envio, 
		'3' ie_tipo_registro, 
		lpad(somente_numero(to_char(c.vl_liquidacao,'9999999999990.00')),15,'0') vl_liquidacao, 
		rpad('BRADESCO',30,' ') nm_cedente, 
		to_char(b.dt_pagamento_previsto,'ddmmyyyy') dt_vencimento, 
		lpad(somente_numero(to_char(c.vl_cobranca,'9999999999990.00')),15,'0') vl_cobranca, 
		lpad(somente_numero(to_char(c.vl_desconto,'9999999999990.00')),15,'0') vl_desconto, 
		CASE WHEN coalesce(c.vl_desconto,0)=0 THEN '00000000'  ELSE to_char(clock_timestamp(),'ddmmyyyy') END  dt_desconto, 
		lpad(somente_numero(to_char(coalesce(c.vl_juros,0) + coalesce(c.vl_multa,0),'9999999999990.00')),15,'0') vl_mora, 
		to_char(c.dt_liquidacao,'ddmmyyyy') dt_pagamento, 
		rpad(coalesce(b.nr_nosso_numero,' '),11,' ') ds_nosso_numero, 
		lpad(substr(coalesce(c.cd_agencia_bancaria,'0'),1,5),5,'0') cd_agencia_bancaria, 
		rpad(coalesce(calcula_digito('Modulo11',coalesce(c.cd_agencia_bancaria,'0')),'0'),1,'0') nr_digito_agencia, 
		lpad(substr(coalesce(e.cd_conta,'0'),1,12),12,'0') || rpad(substr(coalesce(e.ie_digito_conta,'0'),1,1),1,'0') nr_conta_corrente, 
		rpad(coalesce(b.nr_nosso_numero,' '),20,' ') nr_nosso_numero, 
		lpad(coalesce(b.nr_seq_carteira_cobr,0),1,'1') nr_seq_carteira_cobr, 
		rpad(a.nr_sequencia,15,' ') nr_documento_cobr, 
		to_char(b.dt_emissao,'ddmmyyyy') dt_emissao, 
		b.nr_titulo, 
		CASE WHEN coalesce(b.cd_pessoa_fisica::text, '') = '' THEN '2'  ELSE '1' END  ie_tipo_inscricao, 
		lpad(CASE WHEN coalesce(b.cd_pessoa_fisica::text, '') = '' THEN b.cd_cgc  ELSE (	SELECT	x.nr_cpf 								from	pessoa_fisica x 								where	x.cd_pessoa_fisica	= b.cd_pessoa_fisica) END ,15,'0') nr_inscricao, 
		rpad(upper(coalesce(substr(obter_nome_pf_pj(b.cd_pessoa_fisica,b.cd_cgc),1,40),' ')),40,' ') nm_pessoa_titulo, 
		rpad(upper(coalesce(substr(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'EN'),1,40),' ')),40,' ') ds_endereco, 
		rpad(upper(coalesce(substr(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'B'),1,15),' ')),15,' ') ds_bairro, 
		lpad(coalesce(substr(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'CEP'),1,8),' '),8,'0') cd_cep, 
		rpad(upper(coalesce(substr(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'CI'),1,15),' ')),15,' ') ds_cidade, 
		rpad(upper(coalesce(substr(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'UF'),1,2),' ')),2,' ') sg_estado, 
		CASE WHEN coalesce(c.vl_desconto,0)=0 THEN '0'  ELSE '1' END  ie_codigo_desconto, 
		k.nr_sequencia, 
		f.nr_seq_contrato, 
		lpad(coalesce(substr(c.cd_ocorrencia,1,2),'01'),2,'0') cd_mov_remessa, 
		campo_mascara_virgula_casas(obter_dados_titulo_receber(b.nr_titulo,'PDJ'),3) pr_juros_diario, 
		campo_mascara_virgula(obter_dados_titulo_receber(b.nr_titulo,'TXM')) pr_multa_diario 
	FROM banco_estabelecimento e, titulo_receber_cobr c, titulo_receber_v b
LEFT OUTER JOIN pls_mensalidade k ON (b.nr_seq_mensalidade = k.nr_sequencia)
LEFT OUTER JOIN pls_contrato_pagador f ON (k.nr_seq_pagador = f.nr_sequencia)
, cobranca_escritural a
LEFT OUTER JOIN banco_carteira d ON (a.nr_seq_carteira_cobr = d.nr_sequencia)
WHERE a.nr_sequencia		= c.nr_seq_cobranca and c.nr_titulo		= b.nr_titulo and a.nr_seq_conta_banco	= e.nr_sequencia    and a.nr_sequencia		= nr_seq_cobr_escrit_p;


BEGIN 
 
delete from w_envio_banco where nm_usuario = nm_usuario_p;
 
select	lpad(' ',17,' '), 
	lpad(' ',10,' '), 
	lpad(' ',54,' '), 
	lpad(' ',80,' '), 
	lpad(' ',25,' '), 
	lpad(' ',165,' '), 
	lpad(' ',205,' '), 
	lpad(' ',69,' '), 
	lpad(' ',33,' '), 
	lpad(' ',9,' '), 
	lpad(' ',2,' '), 
	lpad('0',23,'0'), 
	lpad(' ',8,' '), 
	lpad(' ',55,' '), 
	lpad(' ',28,' '), 
	lpad(' ',119,' ') 
into STRICT	ds_brancos_17_w, 
	ds_brancos_10_w, 
	ds_brancos_54_w, 
	ds_brancos_80_w, 
	ds_brancos_25_w, 
	ds_brancos_165_w, 
	ds_brancos_205_w, 
	ds_brancos_69_w, 
	ds_brancos_33_w, 
	ds_brancos_9_w, 
	ds_brancos_2_w, 
	ds_zeros_23_w, 
	ds_brancos_8_w, 
	ds_brancos_55_w, 
	ds_brancos_28_w, 
	ds_brancos_119_w
;
 
/* Header Arquivo*/
 
select	'0' ie_tipo_registro, 
	lpad(c.cd_banco,3,'0') cd_banco, 
	to_char(clock_timestamp(),'DDMMYYYYHHMISS') dt_geracao_arquivo, 
	rpad('BRADESCO',30,' ') ds_banco, 
	lpad(c.cd_agencia_bancaria,5,'0') cd_agencia_bancaria, 
	rpad(calcula_digito('Modulo11',c.cd_agencia_bancaria),1,'0') nr_digito_agencia, 
	lpad(c.cd_conta,12,'0') || rpad(c.ie_digito_conta,1,'0') nr_conta_corrente, 
	rpad(upper(substr(obter_razao_social(b.cd_cgc),1,30)),30,' ') nm_empresa, 
	lpad(b.cd_cgc,14,'0') nr_inscricao, 
	substr(coalesce(d.cd_convenio_banco,c.cd_convenio_banco),1,20) cd_convenio_banco, 
	lpad(a.nr_sequencia,6,'0') 
into STRICT	ie_tipo_registro_w, 
	cd_banco_w, 
	dt_geracao_arquivo_w, 
	ds_banco_w, 
	cd_agencia_bancaria_w, 
	nr_digito_agencia_w, 
	nr_conta_corrente_w, 
	nm_empresa_w, 
	nr_inscricao_w, 
	cd_convenio_banco_w, 
	nr_seq_arquivo_w 
FROM banco_estabelecimento c, estabelecimento b, cobranca_escritural a
LEFT OUTER JOIN banco_carteira d ON (a.nr_seq_carteira_cobr = d.nr_sequencia)
WHERE a.cd_estabelecimento	= b.cd_estabelecimento and a.nr_seq_conta_banco	= c.nr_sequencia  and a.nr_sequencia		= nr_seq_cobr_escrit_p;
 
ds_conteudo_w	:=	cd_banco_w || 
			'0000' || 
			'0'	|| 
			rpad(' ',9,' ') || 
			'2' || 
			nr_inscricao_w || 
			'00000000000004645949' || 
			cd_agencia_bancaria_w || 
			nr_digito_agencia_w || 
			nr_conta_corrente_w || 
			' ' || 
			nm_empresa_w || 
			ds_banco_w || 
			ds_brancos_10_w || 
			'1' || 
			dt_geracao_arquivo_w || 
			nr_seq_arquivo_w || 
			'084' || 
			lpad('0',5,'0') || 
			ds_brancos_69_w;
 
insert into w_envio_banco(	nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_estabelecimento, 
		ds_conteudo, 
		nr_seq_apres) 
values (	nextval('w_envio_banco_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		ds_conteudo_w, 
		nr_seq_apres_w);
 
qt_reg_arquivo_w	:= qt_reg_arquivo_w + 1;
qt_registro_lote_w	:= qt_registro_lote_w + 1;
/* Fim Header Arquivo */
 
 
/* Header Lote */
 
select	'1' ie_tipo_registro, 
	lpad(c.cd_banco,3,'0') cd_banco, 
	lpad(a.nr_sequencia,8,'0') nr_seq_envio, 
	lpad(c.cd_agencia_bancaria,5,'0') cd_agencia_bancaria, 
	rpad(calcula_digito('Modulo11',c.cd_agencia_bancaria),1,'0') nr_digito_agencia, 
	lpad(c.cd_conta,12,'0') || rpad(c.ie_digito_conta,1,'0') nr_conta_corrente, 
	rpad(upper(substr(obter_razao_social(b.cd_cgc),1,30)),30,' ') nm_empresa, 
	lpad(b.cd_cgc,15,'0') nr_inscricao, 
	coalesce(d.cd_convenio_banco,c.cd_convenio_banco) cd_convenio_banco, 
	rpad(a.nr_sequencia,6,'0'), 
	rpad(obter_dados_pf_pj(null, b.cd_cgc,'EN'),40,' '), 
	rpad(obter_dados_pf_pj(null, b.cd_cgc,'NR'),5,' '), 
	rpad(obter_dados_pf_pj(null, b.cd_cgc,'CM'),18,' '), 
	rpad(obter_dados_pf_pj(null, b.cd_cgc,'MU'),20,' '), 
	rpad(obter_dados_pf_pj(null, b.cd_cgc,'CEP'),8,' '), 
	rpad(obter_dados_pf_pj(null, b.cd_cgc,'UF'),2,' '), 
	to_char(clock_timestamp(),'DDMMYYYY') dt_gravacao 
into STRICT	ie_tipo_registro_w, 
	cd_banco_w, 
	nr_seq_envio_w, 
	cd_agencia_bancaria_w, 
	nr_digito_agencia_w, 
	nr_conta_corrente_w, 
	nm_empresa_w, 
	nr_inscricao_w, 
	cd_convenio_banco_w, 
	nr_seq_arquivo_w, 
	ds_endereco_w, 
	nr_endereco_w, 
	ds_complemento_w, 
	ds_cidade_w, 
	cd_cep_w, 
	sg_uf_w, 
	dt_gravacao_w 
FROM banco_estabelecimento c, estabelecimento b, cobranca_escritural a
LEFT OUTER JOIN banco_carteira d ON (a.nr_seq_carteira_cobr = d.nr_sequencia)
WHERE a.cd_estabelecimento	= b.cd_estabelecimento and a.nr_seq_conta_banco	= c.nr_sequencia  and a.nr_sequencia		= nr_seq_cobr_escrit_p;
 
nr_seq_lote_w	:= 1;
nr_seq_total_linhas_w	:= coalesce(nr_seq_total_linhas_w,0) + 1;
 
ds_conteudo_w	:= 	cd_banco_w || 
					lpad(coalesce(nr_seq_lote_w,0),4,'0') || 
					'1' || 
					'R' || 
					'01' || 
					rpad(' ',2,' ') || 
					'042' || 
					' ' || 
					'2' || 
					nr_inscricao_w || 	 
					'00000000000004645949' || 
					cd_agencia_bancaria_w || 
					nr_digito_agencia_w || 
					nr_conta_corrente_w || 
					' ' || 
					nm_empresa_w || 
					ds_brancos_80_w || 
					lpad(coalesce(nr_seq_cobr_escrit_p,'0'),8,'0')|| 
					substr(dt_geracao_arquivo_w,1,8) || 
					rpad(' ',8,' ') || 
					ds_brancos_33_w;
 
nr_seq_apres_w	:= nr_seq_apres_w + 1;
 
insert into w_envio_banco(	nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_estabelecimento, 
		ds_conteudo, 
		nr_seq_apres) 
values (	nextval('w_envio_banco_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		ds_conteudo_w, 
		nr_seq_apres_w);
		 
qt_reg_arquivo_w	:= qt_reg_arquivo_w + 1;
/* Fim Header Lote */
 
 
/* Detalhe */
 
open C01;
loop 
fetch C01 into	 
	cd_banco_w, 
	nr_seq_envio_w, 
	ie_tipo_registro_w, 
	vl_liquidacao_w, 
	ds_banco_w, 
	dt_vencimento_w, 
	vl_cobranca_w, 
	vl_desconto_w, 
	dt_desconto_w, 
	vl_mora_w, 
	dt_pagamento_w, 
	ds_nosso_numero_w, 
	cd_agencia_bancaria_w, 
	nr_digito_agencia_w, 
	nr_conta_corrente_w, 
	nr_nosso_numero_w, 
	nr_seq_carteira_cobr_w, 
	nr_documento_cobr_w, 
	dt_emissao_w, 
	nr_titulo_w, 
	ie_tipo_inscricao_w, 
	nr_inscricao_w, 
	nm_pessoa_titulo_w, 
	ds_endereco_w, 
	ds_bairro_w, 
	cd_cep_w, 
	ds_cidade_w, 
	sg_estado_w, 
	ie_codigo_desconto_w, 
	nr_seq_mensalidade_w, 
	nr_seq_contrato_w, 
	cd_mov_remessa_w, 
	pr_multa_w, 
	pr_juros_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	nr_seq_registro_w	:= coalesce(nr_seq_registro_w,0) + 1;
 
	/* Segmento P */
 
	nr_seq_apres_w		:= nr_seq_apres_w + 1;
 
	if (length(coalesce(cd_convenio_banco_w,' ')) = 7) then 
		ds_nosso_numero_w	:= cd_convenio_banco_w || lpad(nr_titulo_w,10,'0');
	elsif (length(coalesce(cd_convenio_banco_w,' ')) >= 5) then 
		ds_nosso_numero_w	:= lpad(cd_convenio_banco_w,6,'0') || lpad(nr_titulo_w,5,'0');
		ds_nosso_numero_w	:= ds_nosso_numero_w || calcula_digito('MODULO11',ds_nosso_numero_w);
	elsif (length(coalesce(cd_convenio_banco_w,' ')) <= 4) then 
		ds_nosso_numero_w	:= lpad(cd_convenio_banco_w,4,'0') || lpad(nr_titulo_w,7,'0');
		ds_nosso_numero_w	:= ds_nosso_numero_w || calcula_digito('MODULO11',ds_nosso_numero_w);
	end if;
 
	vl_juros_acobrar_w	:= coalesce(obter_juros_multa_titulo(nr_titulo_w,clock_timestamp(),'R','J'),0);
		 
	ds_conteudo_w	:=	cd_banco_w || 
				lpad(coalesce(nr_seq_lote_w,0),4,'0') || 
				'3' || 
				lpad(nr_seq_registro_w,5,'0') || 
				'P' || 
				' ' || 
				'01' || 
				cd_agencia_bancaria_w || 
				nr_digito_agencia_w || 
				nr_conta_corrente_w ||			 
				' ' || 
				'009' || 
				'00000' || 
				lpad(ds_nosso_numero_w,12,'0') || 
				nr_seq_carteira_cobr_w || 
				'1' || 
				'2' || 
				'1' || 
				'1' || 
				rpad(nr_documento_cobr_w,15,' ') || 
				dt_vencimento_w || 
				vl_cobranca_w || 
				'00000' || 
				' ' || 
				'02' || 
				'N' || 
				dt_emissao_w || 
				'1' || 
				'00000000' || 
				lpad(somente_numero(to_char(coalesce(vl_juros_acobrar_w,0),'9999999999990.00')),15,'0') || 
				ie_codigo_desconto_w || 
				dt_desconto_w || 
				vl_desconto_w || 
				'000000000000000' || 
				'000000000000000' || 
				rpad(nr_titulo_w,25,' ') || 
				'3' || 
				'00' || 
				'1' || 
				'000' || 
				'09' || 
				'0000000000' || 
				' ';
	qt_registro_lote_w	:= qt_registro_lote_w + 1;
	nr_seq_total_linhas_w	:= coalesce(nr_seq_total_linhas_w,0) + 1;
	 
	insert into w_envio_banco(	nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			cd_estabelecimento, 
			ds_conteudo, 
			nr_seq_apres) 
	values (	nextval('w_envio_banco_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_estabelecimento_p, 
			ds_conteudo_w, 
			nr_seq_apres_w);
	/* Fim segmento P */
 
 
	/* Segmento Q */
 
	nr_seq_apres_w	:= nr_seq_apres_w + 1;
 
	ds_conteudo_w	:= 	cd_banco_w || 
				lpad(coalesce(nr_seq_lote_w,0),4,'0') || 
				'3' || 
				lpad(nr_seq_registro_w,5,'0') || 
				'Q' || 
				' ' || 
				'01'|| 
				ie_tipo_inscricao_w || 
				nr_inscricao_w || 
				nm_pessoa_titulo_w || 
				ds_endereco_w || 
				ds_bairro_w || 
				cd_cep_w || 
				ds_cidade_w || 
				substr(sg_estado_w,1,2) || 
				'0' || 
				rpad('0',15,'0') || 
				lpad(' ',40,' ') || 
				'000' || 
				ds_brancos_28_w;
 
	insert into w_envio_banco(	nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			cd_estabelecimento, 
			ds_conteudo, 
			nr_seq_apres) 
	values (	nextval('w_envio_banco_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_estabelecimento_p, 
			ds_conteudo_w, 
			nr_seq_apres_w);
 
	nr_seq_total_linhas_w	:= coalesce(nr_seq_total_linhas_w,0) + 1;
	/* Fim segmento Q */
 
	nr_seq_lote_w	:= coalesce(nr_seq_lote_w,0) + 1;
	nr_seq_total_linhas_w	:= coalesce(nr_seq_total_linhas_w,0) + 1;
end;	
end loop;
close C01;
/* Fim detalhe */
 
 
/* Trailler Lote*/
 
select (count(*) * 2) + 2, 
	'9' ie_tipo_registro, 
	'0001' nr_seq_envio, 
	somente_numero(to_char(sum(b.vl_liquidacao),'000000000000.00')) 
into STRICT	qt_reg_lote_w, 
	ie_tipo_registro_w, 
	nr_seq_envio_w, 
	vl_liquidacao_w 
from	titulo_receber_cobr b, 
	cobranca_escritural a 
where	a.nr_sequencia		= b.nr_seq_cobranca 
and	a.nr_sequencia		= nr_seq_cobr_escrit_p 
group by a.nr_sequencia, 
	 a.dt_remessa_retorno, 
	 a.dt_remessa_retorno, 
	 a.cd_banco, 
	a.ie_emissao_bloqueto;
	 
ds_conteudo_w	:= 			cd_banco_w || 
					nr_seq_envio_w || 
					'5' || 
					ds_brancos_9_w || 
					lpad(nr_seq_total_linhas_w,6,'0') || 
					'000000' || 
					lpad(vl_liquidacao_w,15,'0') || 
					lpad('0',63,'0') || 
					rpad(' ',133,' ');
 
nr_seq_apres_w	:= nr_seq_apres_w + 1;
 
	 
insert into w_envio_banco(	nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_estabelecimento, 
		ds_conteudo, 
		nr_seq_apres) 
values (	nextval('w_envio_banco_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		ds_conteudo_w, 
		nr_seq_apres_w);
		 
qt_reg_arquivo_w	:= qt_reg_arquivo_w + 1;
qt_registro_lote_w	:= qt_registro_lote_w + 1;
/* Fim Trailler Lote*/
 
 
/* Trailler Arquivo*/
 
select (count(*) * 2) + 4, 
	'9' ie_tipo_registro, 
	'99999' nr_seq_envio 
into STRICT	qt_reg_lote_w, 
	ie_tipo_registro_w, 
	nr_seq_envio_w 
from	titulo_receber_cobr b, 
	cobranca_escritural a 
where	a.nr_sequencia		= b.nr_seq_cobranca 
and	a.nr_sequencia		= nr_seq_cobr_escrit_p;
	 
qt_reg_arquivo_w := qt_reg_arquivo_w + 1;
 
ds_conteudo_w	:=	cd_banco_w || 
					'9999' || 
					'9' || 
					ds_brancos_9_w || 
					'000001' || 
					lpad(nr_seq_total_linhas_w + 1,6,'0') || 
					'000000' || 
					ds_brancos_205_w;
 
nr_seq_apres_w	:= nr_seq_apres_w + 1;
 
insert into w_envio_banco(	nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_estabelecimento, 
		ds_conteudo, 
		nr_seq_apres) 
values (	nextval('w_envio_banco_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		ds_conteudo_w, 
		nr_seq_apres_w);
/* Fim Trailler Arquivo*/
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobr_bradesco_240_reg ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

