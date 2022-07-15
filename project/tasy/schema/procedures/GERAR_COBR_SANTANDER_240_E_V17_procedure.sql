-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobr_santander_240_e_v17 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
-- 	Interface ja esta sendo utilizada e contem alguns campo fixos		-- 
-- 		Se for utilizar, fazer uma cópia			-- 
			 
ds_conteudo_w			varchar(240);
nr_remessa_w			varchar(8);
qt_lote_arquivo_w		varchar(6) := 0;
qt_reg_lote_w			varchar(6) := 0;
nr_seq_arquivo_w		varchar(6) := 0;
nr_seq_registro_w		varchar(5) := 0;
nm_empresa_w			varchar(30);
cd_cgc_w			varchar(15);
nm_banco_w			varchar(30);
dt_geracao_w			varchar(8);
nr_lote_w_w			varchar(4) := 0;
nr_lote_w			varchar(4);

/* Segmentos */
 
nr_nosso_numero_w		varchar(13);
ie_documento_w			varchar(1);
dt_vencimento_w			varchar(8);
vl_titulo_w			varchar(15);
ie_titulo_w			varchar(2);
dt_emissao_w			varchar(8);
cd_juros_mora_w			varchar(1);
dt_juros_mora_w			varchar(8);
vl_juros_diario_w		varchar(15);
cd_desconto_w			varchar(1);
dt_desconto_w			varchar(8);
vl_desconto_dia_w		varchar(15);
vl_iof_w			varchar(15);
vl_abatimento_w			varchar(15);
ds_ident_titulo_emp_w		varchar(25);
cd_protesto_w			varchar(1);
qt_dias_protestos_w		varchar(2);
cd_moeda_w			varchar(2);
cd_agencia_w			varchar(4);
ie_digito_agencia_w		varchar(1);
nr_conta_w			varchar(9);
ie_digito_conta_w		varchar(1);
cd_conta_cobr_w			varchar(9);
ie_conta_cobr_w			varchar(1);
ie_tipo_cobranca_w		varchar(1);
ie_forma_cad_w			varchar(1);
nr_seu_numero_w			varchar(15);
cd_agencia_cobr_w		varchar(4);
ie_agencia_cobr_w		varchar(1);
ie_ident_titulo_w		varchar(1);
cd_baixa_w			varchar(1);
nr_dias_baixa_w			varchar(2);
ie_tipo_inscricao_w		varchar(1);
nr_inscricao_w			varchar(15);
nm_sacado_w			varchar(40);
ds_endereco_sacado_w		varchar(40);
ds_bairro_sacado_w		varchar(15);
cd_cep_sacado_w			varchar(8);
ds_municipio_sacado_w		varchar(15);
ds_estado_sacado_w		varchar(2);
ds_avalista_w			varchar(40);
nr_avalista_w			varchar(16);
cd_mov_remessa_w		varchar(2);
ie_carne_w			varchar(3);
nr_parcela_w			varchar(3);
qt_total_parcela_w		varchar(3);
nr_plano_w			varchar(3);

/* Ds_Brancos */
 
ds_brancos_8_w			varchar(8);
ds_brancos_25_w			varchar(25);
ds_brancos_10_w			varchar(10);
ds_brancos_6_w			varchar(6);
ds_brancos_74_w			varchar(74);
ds_brancos_2_w			varchar(2);
ds_brancos_1_w			varchar(1);
ds_brancos_20_w			varchar(20);
ds_brancos_5_w			varchar(5);
ds_brancos_41_w			varchar(41);
ds_brancos_9_w			varchar(9);
ds_brancos_217_w		varchar(217);
ds_brancos_211_w		varchar(211);
ds_brancos_19_w			varchar(19);
ds_brancos_11_w			varchar(11);
ds_branco_15_w			varchar(15);
ds_mensagen_1_w			varchar(40);
ds_mensagen_2_w			varchar(40);

/* Segmento P */
 
C01 CURSOR FOR 
	SELECT	rpad(coalesce(substr(c.cd_ocorrencia,1,2),'0'),2,'0') cd_mov_remessa, 
		lpad(to_char(c.cd_agencia_bancaria),4,'0') cd_agencia, 
		rpad(substr(coalesce(pls_obter_dados_pagador_fin(d.nr_seq_pagador,'DA'),'0'),1,1),1,'0') ie_digito_agencia, 
		lpad(substr(c.nr_conta,1,9),9,'0') nr_conta, 
		lpad(coalesce(substr(c.ie_digito_conta,1,1),'0'),1,'0') ie_digito_conta, 
		lpad(substr(x.cd_conta,1,9),9,'0') cd_conta_cobr, 
		rpad(coalesce(substr(x.ie_digito_conta,1,1),'0'),1,'0') ie_conta_cobr, 
		lpad(substr(obter_nosso_numero_interf(x.cd_banco,b.nr_titulo),1,13),13,'0') nr_nosso_numero,		 
		'5' ie_tipo_cobranca, 
		'1' ie_forma_cad, 
		'2' ie_documento, 
		rpad(substr(b.nr_titulo,1,15),15,'0') nr_seu_numero, 
		to_char(coalesce(b.dt_pagamento_previsto, b.dt_vencimento),'ddmmyyyy') dt_vencimento, 
		lpad(coalesce(elimina_caracteres_especiais(b.vl_titulo),0),15,'0') vl_titulo, 
		'0000' cd_agencia_cobr, 
		'0' ie_agencia_cobr, 
		'04' ie_titulo, 
		'N' ie_ident_titulo, 
		to_char(b.dt_emissao,'ddmmyyyy') dt_emissao, 
		'0' cd_juros_mora, 
		'00000000' dt_juros_mora, 
		lpad(coalesce(elimina_caracteres_especiais(obter_vl_juros_diario_tit(null,b.nr_titulo)),0),15,'0') vl_juros_diario, 
		'0' cd_desconto, 
		to_char(clock_timestamp(),'ddmmyyyy') dt_desconto, 
		lpad('0',15,'0') vl_desconto_dia, 
		lpad('0',15,'0') vl_iof, 
		lpad('0',15,'0') vl_abatimento, 
		lpad(' ',25,' ') ds_ident_titulo_emp, 
		'0' cd_protesto, 
		'00' qt_dias_protestos, 
		'3' cd_baixa, 
		'00' nr_dias_baixa, 
		lpad(b.cd_moeda,2,'0') cd_moeda, 
/* Segmento Q */
	CASE WHEN coalesce(b.cd_cgc::text, '') = '' THEN '1'  ELSE '2' END  ie_tipo_inscricao, 
		lpad(coalesce(b.cd_cgc_cpf,'0'),15,'0') nr_inscricao, 
		rpad(upper(elimina_acentuacao(substr(b.nm_pessoa,1,40))),40,' ') nm_sacado, 
		rpad(substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'E')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'E') END ,1,40),40,' ') ds_endereco_sacado, 
		rpad(substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'B')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'B') END ,1,15),15,' ') ds_bairro_sacado, 
		lpad(substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CEP')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'CEP') END ,1,8),8,'0') cd_cep_sacado, 
		rpad(substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CI')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'CI') END ,1,15),15,' ') ds_municipio_sacado, 
		rpad(substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'UF')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'UF') END ,1,2),2,' ') ds_estado_sacado, 
		lpad('0',16,'0') nr_avalista, 
		rpad(' ',40,' ') ds_avalista, 
		'000' ie_carne, 
		'000' nr_parcela, 
		'000' qt_total_parcela, 
		'000' nr_plano	 
	FROM banco_estabelecimento x, titulo_receber_cobr c, cobranca_escritural a, titulo_receber_v b
LEFT OUTER JOIN pls_mensalidade d ON (b.nr_seq_mensalidade = d.nr_sequencia)
LEFT OUTER JOIN banco_carteira e ON (b.nr_seq_carteira_cobr = e.nr_sequencia)
LEFT OUTER JOIN pls_contrato_pagador f ON (d.nr_seq_pagador = f.nr_sequencia)
WHERE a.nr_sequencia		= c.nr_seq_cobranca and c.nr_titulo		= b.nr_titulo and a.nr_seq_conta_banco	= x.nr_sequencia    and a.nr_sequencia		= nr_seq_cobr_escrit_p;


BEGIN 
delete from w_envio_banco where nm_usuario = nm_usuario_p;
 
select	rpad(' ',8,' '), 
	rpad(' ',25,' '), 
	rpad(' ',10,' '), 
	rpad(' ',6,' '), 
	rpad(' ',74,' '), 
	rpad(' ',2,' '), 
	rpad(' ',1,' '), 
	rpad(' ',20,' '), 
	rpad(' ',5,' '), 
	rpad(' ',41,' '), 
	lpad(' ',9,' '), 
	rpad(' ',217,' '), 
	rpad(' ',211,' '), 
	rpad(' ',19,' '), 
	rpad(' ',11,' '), 
	rpad(' ',40,' '), 
	rpad(' ',40,' '), 
	lpad('0',15,'0') 
into STRICT	ds_brancos_8_w, 
	ds_brancos_25_w, 
	ds_brancos_10_w, 
	ds_brancos_6_w, 
	ds_brancos_74_w, 
	ds_brancos_2_w, 
	ds_brancos_1_w, 
	ds_brancos_20_w, 
	ds_brancos_5_w, 
	ds_brancos_41_w, 
	ds_brancos_9_w, 
	ds_brancos_217_w, 
	ds_brancos_211_w, 
	ds_brancos_19_w, 
	ds_brancos_11_w, 
	ds_mensagen_1_w, 
	ds_mensagen_2_w, 
	ds_branco_15_w
;
 
/* Header Arquivo*/
 
select	rpad(substr(obter_nome_pf_pj(null,b.cd_cgc),1,30),30,' ') nm_empresa, 
	rpad(substr(obter_nome_banco(c.cd_banco),1,30),30,' ') nm_banco, 
	lpad(b.cd_cgc,15,'0') cd_cgc, 
	lpad(to_char(a.nr_sequencia),6,'0') nr_seq_arquivo, 
	to_char(clock_timestamp(), 'ddmmyyyy') dt_geracao 
into STRICT	nm_empresa_w, 
	nm_banco_w, 
	cd_cgc_w, 
	nr_seq_arquivo_w, 
	dt_geracao_w 
FROM banco_estabelecimento c, estabelecimento b, cobranca_escritural a
LEFT OUTER JOIN banco_carteira d ON (a.nr_seq_carteira_cobr = d.nr_sequencia)
WHERE a.cd_estabelecimento	= b.cd_estabelecimento and a.nr_seq_conta_banco	= c.nr_sequencia  and a.nr_sequencia		= nr_seq_cobr_escrit_p;
 
ds_conteudo_w	:=	'033' || '0000' || '0' || ds_brancos_8_w || '2' || cd_cgc_w || '343100003517012' || ds_brancos_25_w || nm_empresa_w || 
			nm_banco_w || ds_brancos_10_w || '1' || dt_geracao_w || ds_brancos_6_w || nr_seq_arquivo_w || '040' || ds_brancos_74_w;		
 
insert into w_envio_banco(nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	cd_estabelecimento, 
	ds_conteudo, 
	nr_seq_apres, 
	nr_seq_apres_2) 
values (nextval('w_envio_banco_seq'), 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	cd_estabelecimento_p, 
	ds_conteudo_w, 
	1, 
	1);
 
qt_reg_lote_w	:= qt_reg_lote_w + 1;
/* Fim Header Arquivo */
 
 
/* Header Lote */
 
nr_lote_w_w	:= nr_lote_w_w + 1;
nr_lote_w	:= lpad(nr_lote_w_w,4,'0');
 
select	lpad(b.cd_cgc,15,'0') cd_cgc, 
	rpad(substr(obter_nome_banco(c.cd_banco),1,30),30,' ') nm_banco, 
	lpad(substr(a.nr_remessa,1,8),8,'0') nr_remessa, 
	to_char(clock_timestamp(), 'ddmmyyyy') dt_geracao 
into STRICT	cd_cgc_w, 
	nm_banco_w, 
	nr_remessa_w, 
	dt_geracao_w 
FROM banco_estabelecimento c, estabelecimento b, cobranca_escritural a
LEFT OUTER JOIN banco_carteira d ON (a.nr_seq_carteira_cobr = d.nr_sequencia)
WHERE a.cd_estabelecimento	= b.cd_estabelecimento and a.nr_seq_conta_banco	= c.nr_sequencia  and a.nr_sequencia		= nr_seq_cobr_escrit_p;
 
ds_conteudo_w	:=	'033' || nr_lote_w || '1' || 'R' || '01' || ds_brancos_2_w || '030' || ds_brancos_1_w || '2' || cd_cgc_w || 
			ds_brancos_20_w || '343100003517012' || ds_brancos_5_w || nm_banco_w || ds_mensagen_1_w || ds_mensagen_2_w || nr_remessa_w || 
			dt_geracao_w || ds_brancos_41_w;
 
insert into w_envio_banco(nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	cd_estabelecimento, 
	ds_conteudo, 
	nr_seq_apres, 
	nr_seq_apres_2) 
values (nextval('w_envio_banco_seq'), 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	cd_estabelecimento_p, 
	ds_conteudo_w, 
	2, 
	2);
 
qt_reg_lote_w	:= qt_reg_lote_w + 1;
/* Fim Header Lote */
 
 
/* Inicio Segmentos */
 
open C01;
loop 
fetch C01 into	 
	cd_mov_remessa_w, 
	cd_agencia_w, 
	ie_digito_agencia_w, 
	nr_conta_w, 
	ie_digito_conta_w, 
	cd_conta_cobr_w, 
	ie_conta_cobr_w, 
	nr_nosso_numero_w, 
	ie_tipo_cobranca_w, 
	ie_forma_cad_w, 
	ie_documento_w, 
	nr_seu_numero_w, 
	dt_vencimento_w, 
	vl_titulo_w, 
	cd_agencia_cobr_w, 
	ie_agencia_cobr_w, 
	ie_titulo_w, 
	ie_ident_titulo_w, 
	dt_emissao_w, 
	cd_juros_mora_w, 
	dt_juros_mora_w, 
	vl_juros_diario_w, 
	cd_desconto_w, 
	dt_desconto_w, 
	vl_desconto_dia_w, 
	vl_iof_w, 
	vl_abatimento_w, 
	ds_ident_titulo_emp_w, 
	cd_protesto_w, 
	qt_dias_protestos_w, 
	cd_baixa_w, 
	nr_dias_baixa_w, 
	cd_moeda_w, 
	ie_tipo_inscricao_w, 
	nr_inscricao_w, 
	nm_sacado_w, 
	ds_endereco_sacado_w, 
	ds_bairro_sacado_w, 
	cd_cep_sacado_w, 
	ds_municipio_sacado_w, 
	ds_estado_sacado_w, 
	nr_avalista_w, 
	ds_avalista_w, 
	ie_carne_w, 
	nr_parcela_w, 
	qt_total_parcela_w, 
	nr_plano_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	/* Segmento P*/
 
	nr_seq_registro_w:= nr_seq_registro_w + 1;
 
	ds_conteudo_w	:=	'033' || nr_lote_w || '3' || lpad(nr_seq_registro_w,5,'0') || 'P' || ds_brancos_1_w || cd_mov_remessa_w || cd_agencia_w || 
				ie_digito_agencia_w || nr_conta_w || ie_digito_conta_w || cd_conta_cobr_w || ie_conta_cobr_w || ds_brancos_2_w || 
				nr_nosso_numero_w || ie_tipo_cobranca_w || ie_forma_cad_w || ie_documento_w || ds_brancos_2_w || nr_seu_numero_w || 
				dt_vencimento_w || vl_titulo_w || cd_agencia_cobr_w || ie_agencia_cobr_w || ds_brancos_1_w || ie_titulo_w || 
				ie_ident_titulo_w || dt_emissao_w || cd_juros_mora_w || dt_juros_mora_w || vl_juros_diario_w || cd_desconto_w || 
				dt_desconto_w || vl_desconto_dia_w || vl_iof_w || vl_abatimento_w || ds_ident_titulo_emp_w || cd_protesto_w || 
				qt_dias_protestos_w || cd_baixa_w || '0' || nr_dias_baixa_w || cd_moeda_w || ds_brancos_11_w;
	 
	insert into w_envio_banco(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_estabelecimento, 
		ds_conteudo, 
		nr_seq_apres, 
		nr_seq_apres_2) 
	values (nextval('w_envio_banco_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		ds_conteudo_w, 
		3, 
		nr_seq_registro_w);
	/* Fim segmento P*/
 
 
	/* Segmento Q*/
 
	ds_conteudo_w	 :=	null;
	nr_seq_registro_w:= 	nr_seq_registro_w + 1;
	 
	ds_conteudo_w	:=	'033' || nr_lote_w || '3' || lpad(nr_seq_registro_w,5,'0') || 'Q' || ds_brancos_1_w || cd_mov_remessa_w || 
				ie_tipo_inscricao_w || nr_inscricao_w || nm_sacado_w || ds_endereco_sacado_w || ds_bairro_sacado_w || 
				cd_cep_sacado_w || ds_municipio_sacado_w || ds_estado_sacado_w || nr_avalista_w || ds_avalista_w || ie_carne_w || 
				nr_parcela_w || qt_total_parcela_w || nr_plano_w || ds_brancos_19_w;
				 
	insert into w_envio_banco(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_estabelecimento, 
		ds_conteudo, 
		nr_seq_apres, 
		nr_seq_apres_2) 
	values (nextval('w_envio_banco_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		ds_conteudo_w, 
		3, 
		nr_seq_registro_w);
		 
	/* Fim segmento Q*/
 
	qt_reg_lote_w	:= qt_reg_lote_w + 1;
	end;	
				 
end loop;
close C01;
/*Fim Segmentos */
 
 
/* Trailler Lote*/
 
begin 
	 
ds_conteudo_w	:= '033' || nr_lote_w || '5' || ds_brancos_9_w || lpad(qt_reg_lote_w,6,'0') || ds_brancos_217_w;
 
	insert into w_envio_banco(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_estabelecimento, 
		ds_conteudo, 
		nr_seq_apres, 
		nr_seq_apres_2) 
	values (nextval('w_envio_banco_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		ds_conteudo_w, 
		5, 
		5);
		 
qt_lote_arquivo_w	:= qt_lote_arquivo_w + 1;
qt_reg_lote_w 		:= qt_reg_lote_w + 1;
end;
/* Fim Trailler Lote*/
 
 
 
/* Trailler Arquivo*/
 
begin 
qt_reg_lote_w	:= qt_reg_lote_w + 1;
	 
ds_conteudo_w	:= '033' || '9999' || '9' || ds_brancos_9_w || lpad(qt_lote_arquivo_w,6,'0') || lpad(qt_reg_lote_w,6,'0') || ds_brancos_211_w;
	 
	insert into w_envio_banco(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_estabelecimento, 
		ds_conteudo, 
		nr_seq_apres, 
		nr_seq_apres_2) 
	values (nextval('w_envio_banco_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		ds_conteudo_w, 
		6, 
		6);
end;
/* Fim Trailler Arquivo*/
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobr_santander_240_e_v17 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

