-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobr_bancoob_240 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

			 
ds_conteudo_w			varchar(240);
nr_remessa_w			varchar(8);
qt_lote_arquivo_w		varchar(6) := 0;
nr_seq_arquivo_w		varchar(6) := 0;
nr_seq_registro_w		varchar(5) := 0;
nm_empresa_w			varchar(30);
cd_cgc_w			varchar(15);
nm_banco_w			varchar(30);
dt_geracao_w			varchar(8);
nr_lote_w_w			varchar(4) := 0;
nr_lote_w			varchar(4);
cd_agencia_mantedora_w		varchar(5);
ie_dig_verificador_conta_w	varchar(1);
nr_conta_corrente_w		varchar(12);
ie_dig_conta_corrente_w		varchar(1);
ie_ver_ag_conta_w		varchar(1);
cd_carteira_w			varchar(1);
nr_ddd_telefone_w		varchar(3);
nr_telefone_w			varchar(8);
nr_ramal_w			varchar(4);
dt_nascimento_w			varchar(8);
nr_endereco_w			varchar(6);
ds_complemento_w		varchar(20);
cd_municipio_ibge_w		varchar(7);
cd_convenio_banco_w		varchar(20);
ds_grupo_sac_w			varchar(40);

/* Segmentos */
 
nr_nosso_numero_w		varchar(20);
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
cd_agencia_w			varchar(5);
ie_digito_agencia_w		varchar(1);
nr_conta_w			varchar(12);
ie_digito_conta_w		varchar(1);
cd_conta_cobr_w			varchar(9);
ie_conta_cobr_w			varchar(1);
ie_tipo_cobranca_w		varchar(1);
ie_forma_cad_w			varchar(1);
nr_seu_numero_w			varchar(15);
cd_agencia_cobr_w		varchar(5);
ie_agencia_cobr_w		varchar(1);
ie_ident_titulo_w		varchar(1);
cd_baixa_w			varchar(1);
nr_dias_baixa_w			varchar(3);
ie_tipo_inscricao_w		varchar(1);
nr_inscricao_w			varchar(15);
nm_sacado_w			varchar(50);
ds_endereco_sacado_w		varchar(40);
ds_bairro_sacado_w		varchar(30);
cd_cep_sacado_w			varchar(8);
ds_municipio_sacado_w		varchar(40);
ds_estado_sacado_w		varchar(2);
ds_avalista_w			varchar(50);
nr_avalista_w			varchar(16);
cd_mov_remessa_w		varchar(2);
ie_carne_w			varchar(3);
nr_parcela_w			varchar(3);
qt_total_parcela_w		varchar(3);
nr_plano_w			varchar(3);
cd_transmissao_w		varchar(15);
nm_cedente_w			varchar(30);

/* Ds_Brancos */
 
ds_brancos_8_w			varchar(8);
ds_brancos_25_w			varchar(25);
ds_brancos_28_w			varchar(28);
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
		lpad(to_char(x.cd_agencia_bancaria),5,'0') cd_agencia, 
		lpad(substr(coalesce(pls_obter_dados_pagador_fin(d.nr_seq_pagador,'DA'),' '),1,1),1,' ') ie_digito_agencia, 
		lpad(coalesce(substr(x.cd_conta,1,12),'0'),12,'0') nr_conta, 
		lpad(coalesce(substr(c.ie_digito_conta,1,1),'0'),1,'0') ie_digito_conta, 
		lpad(coalesce(substr(x.cd_conta,1,9),'0'),9,'0') cd_conta_cobr, 
		rpad(coalesce(substr(x.ie_digito_conta,1,1),'0'),1,'0') ie_conta_cobr, 
		lpad(substr(obter_nosso_numero_interf(x.cd_banco,b.nr_titulo),1,20),20,'0') nr_nosso_numero,		 
		'5' ie_tipo_cobranca, 
		'1' ie_forma_cad, 
		'2' ie_documento, 
		rpad(substr(b.nr_titulo,1,15),15,'0') nr_seu_numero, 
		to_char(coalesce(b.dt_pagamento_previsto, b.dt_vencimento),'ddmmyyyy') dt_vencimento, 
		lpad(coalesce(elimina_caracteres_especiais(b.vl_titulo),0),15,'0') vl_titulo, 
		'00000' cd_agencia_cobr, 
		'0' ie_agencia_cobr, 
		'04' ie_titulo, 
		'N' ie_ident_titulo, 
		to_char(b.dt_emissao,'ddmmyyyy') dt_emissao, 
		'2' cd_juros_mora, 
		'00000000' dt_juros_mora, 
		--lpad(nvl(elimina_caracteres_especiais(obter_vl_juros_diario_tit(null,b.nr_titulo)),0),15,'0') vl_juros_diario, 
		lpad('0',15,'0') vl_juros_diario, 
		'0' cd_desconto, 
		'00000000' dt_desconto, 
		lpad('0',15,'0') vl_desconto_dia, 
		lpad('0',15,'0') vl_iof, 
		lpad('0',15,'0') vl_abatimento, 
		lpad(' ',25,' ') ds_ident_titulo_emp, 
		'0' cd_protesto, 
		'00' qt_dias_protestos, 
		'3' cd_baixa, 
		'000' nr_dias_baixa, 
		'00' cd_moeda, 
/* Segmentos Q */
	CASE WHEN coalesce(b.cd_cgc::text, '') = '' THEN '1'  ELSE '2' END  ie_tipo_inscricao, 
		lpad(coalesce(b.cd_cgc_cpf,'0'),15,'0') nr_inscricao, 
		rpad(upper(elimina_acentuacao(substr(b.nm_pessoa,1,50))),50,' ') nm_sacado, 
		rpad(substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'E')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'E') END ,1,40),40,' ') ds_endereco_sacado, 
		rpad(substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'B')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'B') END ,1,30),30,' ') ds_bairro_sacado, 
		lpad(substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CEP')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'CEP') END ,1,8),8,'0') cd_cep_sacado, 
		rpad(substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CI')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'CI') END ,1,40),40,' ') ds_municipio_sacado, 
		rpad(substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'UF')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'UF') END ,1,2),2,' ') ds_estado_sacado, 
		lpad('0',16,'0') nr_avalista, 
		rpad(' ',50,' ') ds_avalista, 
		'000' ie_carne, 
		'000' nr_parcela, 
		'000' qt_total_parcela, 
		'000' nr_plano, 
		coalesce(substr(x.cd_carteira,1,1),' ') cd_carteira, 
		lpad(coalesce(substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'DDT'),1,3),'0'),3,'0') nr_ddd_telefone, 
		lpad(coalesce(substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'T'),1,8),'0'),8,'0') nr_telefone, 
		'0000'nr_ramal, 
		lpad(coalesce(CASE WHEN coalesce(b.cd_pessoa_fisica::text, '') = '' THEN '0'  ELSE to_char(obter_data_nascto_pf(b.cd_pessoa_fisica),'ddmmyyyy') END ,'0'),8,'0') dt_nascimento, 
		rpad(coalesce(substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'NR')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'NR') END ,1,6),' '),6,' ') nr_endereco_sacado, 
		rpad(coalesce(substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CO')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'CO') END ,1,20),' '),20,' ') ds_complemento_w, 
		lpad(coalesce(substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CDM')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'IBGE') END ,1,7),'0'),7,'0') cd_municipio_ibge 
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
	lpad('0',15,'0'), 
	rpad(' ',28,' '), 
	rpad(' ',40,' ') 
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
	ds_branco_15_w, 
	ds_brancos_28_w, 
	ds_grupo_sac_w
;
 
nr_lote_w_w	:= nr_lote_w_w + 1;
nr_lote_w	:= lpad(nr_lote_w_w,4,'0');
 
select	lpad(b.cd_cgc,15,'0') cd_cgc, 
	rpad(upper(elimina_acentuacao(substr(obter_nome_pf_pj(null, b.cd_cgc),1,30))),30, ' ') nm_cedente, 
	lpad(coalesce(substr(a.nr_remessa,1,8),'0'),8,'0') nr_remessa, 
	to_char(clock_timestamp(), 'ddmmyyyy') dt_geracao, 
	rpad(coalesce(substr(c.cd_agencia_bancaria,1,5),' '),5,' ') cd_agencia_mantedora, 
	coalesce(substr(c.ie_digito_conta,1,1),' ') ie_dig_verificador_conta, 
	rpad(coalesce(substr(c.cd_conta,1,12),' '),12,' ') nr_conta_corrente, 
	coalesce(substr(c.ie_digito_conta,1,1),' ') ie_dig_conta_corrente, 
	coalesce(substr(c.ie_digito_conta,1,1),' ') ie_ver_ag_conta, 
	rpad(coalesce(substr(c.cd_convenio_banco,1,20),' '),20,' ') cd_convenio_banco 
into STRICT	cd_cgc_w, 
	nm_cedente_w, 
	nr_remessa_w, 
	dt_geracao_w, 
	cd_agencia_mantedora_w, 
	ie_dig_verificador_conta_w, 
	nr_conta_corrente_w, 
	ie_dig_conta_corrente_w, 
	ie_ver_ag_conta_w, 
	cd_convenio_banco_w 
FROM banco_estabelecimento c, estabelecimento b, cobranca_escritural a
LEFT OUTER JOIN banco_carteira d ON (a.nr_seq_carteira_cobr = d.nr_sequencia)
WHERE a.cd_estabelecimento	= b.cd_estabelecimento and a.nr_seq_conta_banco	= c.nr_sequencia  and a.nr_sequencia		= nr_seq_cobr_escrit_p;
 
ds_conteudo_w	:=	'756' || nr_lote_w || '1' || 'R' || '01' || ds_brancos_2_w || '040' || ds_brancos_1_w || '2' || cd_cgc_w || 
			cd_convenio_banco_w || cd_agencia_mantedora_w || ie_dig_verificador_conta_w || nr_conta_corrente_w || ie_dig_conta_corrente_w || 
			ie_ver_ag_conta_w || nm_cedente_w || ds_mensagen_1_w || ds_mensagen_2_w || nr_remessa_w || dt_geracao_w || ds_brancos_41_w;
 
insert into w_envio_banco(nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	cd_estabelecimento, 
	ds_conteudo, 
	nr_seq_apres) 
values (nextval('w_envio_banco_seq'), 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	cd_estabelecimento_p, 
	ds_conteudo_w, 
	1);
	 
qt_lote_arquivo_w	:= qt_lote_arquivo_w + 1;
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
	nr_plano_w, 
	cd_carteira_w, 
	nr_ddd_telefone_w, 
	nr_telefone_w, 
	nr_ramal_w, 
	dt_nascimento_w, 
	nr_endereco_w, 
	ds_complemento_w, 
	cd_municipio_ibge_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	/* Segmento P*/
 
	nr_seq_registro_w:= nr_seq_registro_w + 1;
 
	ds_conteudo_w	:=	'756' || nr_lote_w || '3' || lpad(nr_seq_registro_w,5,'0') || 'P' || ds_brancos_1_w || '01' || cd_agencia_w || 
				ie_digito_agencia_w || nr_conta_w || ie_digito_conta_w || ie_digito_conta_w || nr_nosso_numero_w || cd_carteira_w || 
				ie_forma_cad_w || ie_documento_w || '0' || ' ' || nr_seu_numero_w || dt_vencimento_w || vl_titulo_w || 
				cd_agencia_cobr_w || ie_agencia_cobr_w || '00' || ie_ident_titulo_w || dt_emissao_w || cd_juros_mora_w || 
				dt_juros_mora_w || vl_juros_diario_w || cd_desconto_w || dt_desconto_w || vl_desconto_dia_w || vl_iof_w || 
				vl_abatimento_w || ds_ident_titulo_emp_w || cd_protesto_w || qt_dias_protestos_w || cd_baixa_w || nr_dias_baixa_w || 
				cd_moeda_w || ds_brancos_11_w;
	 
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
 
	 
	qt_lote_arquivo_w	:= qt_lote_arquivo_w + 1;
 
	/* Segmento Q1*/
 
	ds_conteudo_w	 :=	null;
	nr_seq_registro_w:= 	nr_seq_registro_w + 1;
	 
	ds_conteudo_w	:=	'756' || nr_lote_w || '3' || lpad(nr_seq_registro_w,5,'0') || 'Q11' || ie_tipo_inscricao_w || nr_inscricao_w || 
				nm_sacado_w || nr_ddd_telefone_w || nr_telefone_w || nr_ramal_w || dt_nascimento_w || ' ' || '00' || ds_grupo_sac_w || 
				ds_avalista_w || '756' || nr_nosso_numero_w || lpad('0',17,'0') || ' ';
				 
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
		 
	/* Fim segmento Q1*/
	 
	qt_lote_arquivo_w	:= qt_lote_arquivo_w + 1;
	 
	/* Segmento Q2*/
 
	ds_conteudo_w	 :=	null;
	nr_seq_registro_w:= 	nr_seq_registro_w + 1;
	 
	ds_conteudo_w	:=	'756' || nr_lote_w || '3' || lpad(nr_seq_registro_w,5,'0') || 'Q201' || substr(nr_inscricao_w,1,8) || 
				ds_endereco_sacado_w || ds_brancos_10_w || nr_endereco_w || ' ' || ds_complemento_w || ds_bairro_sacado_w || 
				ds_municipio_sacado_w || cd_cep_sacado_w || ds_estado_sacado_w || '756' || nr_nosso_numero_w || 
				cd_municipio_ibge_w || ds_brancos_28_w;
				 
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
		 
	/* Fim segmento Q2*/
	 
	qt_lote_arquivo_w	:= qt_lote_arquivo_w + 1;
	end;	
				 
end loop;
close C01;
/*Fim Segmentos */
 
 
/* Trailler Lote*/
 
begin 
qt_lote_arquivo_w	:= qt_lote_arquivo_w + 1;
	 
ds_conteudo_w	:= '756' || nr_lote_w || '5' || ds_brancos_9_w || lpad(qt_lote_arquivo_w,6,'0') || ds_brancos_217_w;
 
	insert into w_envio_banco(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_estabelecimento, 
		ds_conteudo, 
		nr_seq_apres) 
	values (nextval('w_envio_banco_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		ds_conteudo_w, 
		5);
end;
/* Fim Trailler Lote*/
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobr_bancoob_240 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

