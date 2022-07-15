-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_remessa_itau_cnab_240_tb ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/*	Brancos		*/
 
ds_brancos_211_w		varchar(211);
ds_brancos_205_w		varchar(205);
ds_brancos_148_w		varchar(148);
ds_brancos_117_w		varchar(117);
ds_brancos_80_w			varchar(80);
ds_brancos_54_w			varchar(54);
ds_brancos_48_w			varchar(48);
ds_brancos_46_w			varchar(46);
ds_brancos_40_w			varchar(40);
ds_brancos_33_w			varchar(33);
ds_brancos_30_w			varchar(30);
ds_brancos_28_w			varchar(28);
ds_brancos_25_w			varchar(25);
ds_brancos_20_w			varchar(20);
ds_brancos_12_w			varchar(12);
ds_brancos_10_w			varchar(10);
ds_brancos_9_w			varchar(9);
ds_brancos_8_w			varchar(8);
ds_brancos_5_w			varchar(5);
ds_brancos_4_w			varchar(4);

/*	Header do arquivo	*/
 
nm_empresa_w			varchar(30);
nm_banco_w			varchar(30);
cd_cgc_w			varchar(14);
cd_agencia_bancaria_w		varchar(5);
dt_remessa_retorno_w		timestamp;

/*	Segmento P, Segmento Q, Segmento R	 */
 
nm_pessoa_w			varchar(40);
ds_endereco_w			varchar(40);
ds_bairro_w			varchar(15);
ds_cidade_w			varchar(15);
nr_inscricao_w			varchar(15);
ds_nosso_numero_w		varchar(15);
vl_titulo_w			varchar(15);
vl_desconto_w			varchar(15);
vl_juros_mora_w			varchar(15);
nr_titulo_w			varchar(11);
cd_cep_w			varchar(8);
dt_emissao_w			varchar(8);
dt_vencimento_w			varchar(8);	
ds_uf_w				varchar(2);
ie_tipo_inscricao_w		varchar(1);

/*	Trailer de Lote	*/
 
vl_titulos_cobr_w		varchar(15);
qt_titulos_cobr_w		integer;
qt_registro_lote_w		smallint	:= 0;

/*	Trailer do Arquivo	*/
 
qt_registro_w			integer	:= 0;	
qt_registro_P_w			integer	:= 0;
qt_registro_Q_w			integer	:= 0;

ds_conteudo_w			varchar(240);

C01 CURSOR FOR 
	SELECT	lpad(c.cd_agencia_bancaria,5,'0'), 
		lpad(82||somente_numero(lpad(b.nr_titulo,8,'0')||'-'|| calcula_digito('Modulo11',(82||lpad(b.nr_titulo,8,'0')))),15,'0') ds_nosso_numero, 
		lpad(b.nr_titulo,10,0) nr_titulo, 
		to_char(coalesce(b.dt_pagamento_previsto,clock_timestamp()),'DDMMYYYY') dt_vencimento, 
		lpad(replace(to_char(b.vl_titulo, 'fm0000000000000.00'),'.',''),15,'0') vl_titulo, 
		to_char(coalesce(b.dt_emissao,clock_timestamp()),'DDMMYYYY') dt_emissao, 
		lpad(replace(to_char(b.vl_titulo * b.tx_juros / 100 / 30, 'fm0000000000000.00'),'.',''),15,'0') vl_juros_mora, 
		lpad(replace(to_char(b.TX_DESC_ANTECIPACAO, 'fm0000000000000.00'),'.',''),15,'0') vl_desconto, 
		coalesce(CASE WHEN coalesce(b.cd_pessoa_fisica::text, '') = '' THEN  '2'  ELSE '1' END ,'0') ie_tipo_inscricao, 
		lpad(CASE WHEN CASE WHEN coalesce(b.cd_pessoa_fisica::text, '') = '' THEN  2  ELSE 1 END =2 THEN obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'C') WHEN CASE WHEN coalesce(b.cd_pessoa_fisica::text, '') = '' THEN  2  ELSE 1 END =1 THEN (substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'C'),1,9) || '0000' || substr(obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'C'),10,2))  ELSE '000000000000000' END ,15,'0') nr_inscricao, 
		rpad(substr(coalesce(elimina_caractere_especial(obter_nome_pf_pj(b.cd_pessoa_fisica, b.cd_cgc)),' '),1,30),30,' ') nm_pessoa, 
		rpad(substr(coalesce(elimina_caractere_especial(pls_obter_compl_pagador(d.nr_seq_pagador,'E')),' '),1,40),40,' ') ds_endereco, 
		rpad(substr(coalesce(elimina_caractere_especial(pls_obter_compl_pagador(d.nr_seq_pagador,'B')),' '),1,15),15,' ') ds_bairro, 
		lpad(substr(coalesce(elimina_caractere_especial(pls_obter_compl_pagador(d.nr_seq_pagador,'CEP')),' '),1,8),8,'0') cd_cep, 
		rpad(substr(coalesce(elimina_caractere_especial(pls_obter_compl_pagador(d.nr_seq_pagador,'CI')),' '),1,15),15,' ') ds_cidade, 
		rpad(substr(coalesce(elimina_caractere_especial(pls_obter_compl_pagador(d.nr_seq_pagador,'UF')),' '),1,2),2,' ') ds_uf 
	FROM titulo_receber_cobr c, cobranca_escritural a, titulo_receber b
LEFT OUTER JOIN pls_mensalidade d ON (b.nr_seq_mensalidade = d.nr_sequencia)
WHERE a.nr_sequencia		= c.nr_seq_cobranca and c.nr_titulo		= b.nr_titulo  and a.nr_sequencia		= nr_seq_cobr_escrit_p;
	

BEGIN 
/*nm_arquivo_w	:= to_char(sysdate,'ddmmyyyy') || to_char(sysdate,'hh24') || to_char(sysdate,'mi') || to_char(sysdate,'ss') || nm_usuario_p || '.rem'; 
 
obter_evento_utl_file(1, null, ds_local_w, ds_erro_w);*/
 
 
/*begin 
arq_texto_w := utl_file.fopen(ds_local_w,nm_arquivo_w,'W'); 
exception 
when others then 
	if (sqlcode = -29289) then 
		ds_erro_w := 'O acesso ao arquivo foi negado pelo sistema operacional (access_denied).'; 
	elsif (sqlcode = -29298) then 
		ds_erro_w := 'O arquivo foi aberto usando FOPEN_NCHAR, mas efetuaram-se operações de I/O usando funções nonchar comos PUTF ou GET_LINE (charsetmismatch).'; 
	elsif (sqlcode = -29291) then 
		ds_erro_w := 'Não foi possível apagar o arquivo (delete_failed).'; 
	elsif (sqlcode = -29286) then 
		ds_erro_w := 'Erro interno desconhecido no package UTL_FILE (internal_error).'; 
	elsif (sqlcode = -29282) then 
		ds_erro_w := 'O handle do arquivo não existe (invalid_filehandle).'; 
	elsif (sqlcode = -29288) then 
		ds_erro_w := 'O arquivo com o nome especificado não foi encontrado neste local (invalid_filename).'; 
	elsif (sqlcode = -29287) then 
		ds_erro_w := 'O valor de MAX_LINESIZE para FOPEN() é inválido; deveria estar na faixa de 1 a 32767 (invalid_maxlinesize).'; 
	elsif (sqlcode = -29281) then 
		ds_erro_w := 'O parâmetro open_mode na chamda FOPEN é inválido (invalid_mode).'; 
	elsif (sqlcode = -29290) then 
		ds_erro_w := 'O parâmetro ABSOLUTE_OFFSET para a chamada FSEEK() é inválido; deveria ser maior do que 0 e menor do que o número total de bytes do arquivo (invalid_offset).'; 
	elsif (sqlcode = -29283) then 
		ds_erro_w := 'O arquivo não pôde ser aberto ou operado da forma desejada - ou o caminho não foi encontrado (invalid_operation).'; 
	elsif (sqlcode = -29280) then 
		ds_erro_w := 'O caminho especificado não existe ou não está visível ao Oracle (invalid_path).'; 
	elsif (sqlcode = -29284) then 
		ds_erro_w := 'Não é possível efetuar a leitura do arquivo (read_error).'; 
	elsif (sqlcode = -29292) then 
		ds_erro_w := 'Não é possível renomear o arquivo.'; 
	elsif (sqlcode = -29285) then 
		ds_erro_w := 'Não foi possível gravar no arquivo (write_error).'; 
	else 
		ds_erro_w := 'Erro desconhecido no package UTL_FILE.'; 
	end if;	 
	wheb_mensagem_pck.exibir_mensagem_abort(186768,'DS_ERRO_W=' || ds_erro_w); 
end; 
--arq_texto_w := utl_file.fopen('/oraprd03/utlfile/',nm_arquivo_w,'W'); 
--\\192.168.0.230\UTLFILE*/ 
 
/*update	cobranca_escritural 
set	ds_arquivo	= ds_local_w || nm_arquivo_w 
where	nr_sequencia	= nr_seq_cobr_escrit_p;*/
 
 
/*	Brancos		*/
 
select	lpad(' ', 211, ' '), 
	lpad(' ', 205, ' '), 
	lpad(' ', 148, ' '), 
	lpad(' ', 117, ' '), 
	lpad(' ', 80, ' '), 
	lpad(' ', 54, ' '), 
	lpad(' ', 48, ' '), 
	lpad(' ', 46, ' '), 
	lpad(' ', 40, ' '), 
	lpad(' ', 33, ' '), 
	lpad(' ', 30, ' '), 
	lpad(' ', 28, ' '), 
	lpad(' ', 25, ' '), 
	lpad(' ', 20, ' '), 
	lpad(' ', 12, ' '), 
	lpad(' ', 10, ' '), 
	lpad(' ', 9, ' '), 
	lpad(' ', 8, ' '), 
	lpad(' ', 5, ' '), 
	lpad(' ', 4, ' ')	 
into STRICT	ds_brancos_211_w, 
	ds_brancos_205_w, 
	ds_brancos_148_w, 
	ds_brancos_117_w, 
	ds_brancos_80_w, 
	ds_brancos_54_w, 
	ds_brancos_48_w, 
	ds_brancos_46_w, 
	ds_brancos_40_w, 
	ds_brancos_33_w, 
	ds_brancos_30_w, 
	ds_brancos_28_w, 
	ds_brancos_25_w, 
	ds_brancos_20_w, 
	ds_brancos_12_w, 
	ds_brancos_10_w, 
	ds_brancos_9_w, 
	ds_brancos_8_w, 
	ds_brancos_5_w, 
	ds_brancos_4_w
;
/*	Fim - Brancos	*/
 
 
/*	Header do Arquivo	*/
 
select	lpad(b.cd_cgc,14,'0'), 
	lpad(coalesce(c.cd_agencia_bancaria,'0'),5,'0') cd_agencia_bancaria, 
	rpad(substr(coalesce(elimina_caractere_especial(obter_razao_social(b.cd_cgc)),' '),1,30),30,' ') nm_empresa, 
	rpad('BANCO ITAÚ SA', 30, ' ') nm_banco, 
	coalesce(a.dt_remessa_retorno,clock_timestamp()) 
into STRICT	cd_cgc_w, 
	cd_agencia_bancaria_w, 
	nm_empresa_w, 
	nm_banco_w, 
	dt_remessa_retorno_w 
from	banco_estabelecimento c, 
	estabelecimento b, 
	cobranca_escritural a 
where	a.cd_estabelecimento	= b.cd_estabelecimento 
and	a.nr_seq_conta_banco	= c.nr_sequencia 
and	a.nr_sequencia		= nr_seq_cobr_escrit_p;
 
qt_registro_w	:= qt_registro_w + 1;
 
ds_conteudo_w	:= 	'341' || 
			'0000' || 
			'0' || 
			ds_brancos_9_w || 
			'2' || 
			cd_cgc_w || 
			ds_brancos_20_w || 
			cd_agencia_bancaria_w || 
			' ' || 
			'0000000' || 
			'00000' || 
			' ' || 
			'0' || 
			nm_empresa_w || 
			nm_banco_w || 
			ds_brancos_10_w || 
			'1' || 
			lpad(to_char(dt_remessa_retorno_w,'DDMMYYYY'),8,'0') || 
			lpad(to_char(dt_remessa_retorno_w,'hh24miss'),6,'0') || 
			'000001' || 
			'040' || 
			'00000' || 
			ds_brancos_54_w || 
			'000' || 
			ds_brancos_12_w;
			 
/*utl_file.put_line(arq_texto_w,ds_conteudo_w); 
utl_file.fflush(arq_texto_w);*/
 
 
delete from w_envio_banco 
where nm_usuario = nm_usuario_p;
 
insert	into w_envio_banco(cd_estabelecimento, 
	ds_conteudo, 
	dt_atualizacao, 
	dt_atualizacao_nrec, 
	nm_usuario, 
	nm_usuario_nrec, 
	nr_sequencia, 
	nr_seq_apres, 
	nr_seq_apres_2) 
values (cd_estabelecimento_p, 
	ds_conteudo_w, 
	clock_timestamp(), 
	clock_timestamp(), 
	nm_usuario_p, 
	nm_usuario_p, 
	nextval('w_envio_banco_seq'), 
	1, 
	1);
 
 
/*	Fim - Header do Arquivo	*/
 
 
/*	Header do Lote	*/
 
qt_registro_lote_w	:= qt_registro_lote_w + 1;
qt_registro_w		:= qt_registro_w + 1;
ds_conteudo_w		:= 	'341' || 
				lpad(qt_registro_lote_w,4,'0') || 
				'1' || 
				'R' || 
				'01' || 
				'00' || 
				'030' || 
				' ' || 
				'2' || 
				lpad(cd_cgc_w,15,'0') || 
				ds_brancos_20_w || 
				cd_agencia_bancaria_w || 
				' ' || 
				'0000000' || 
				'00000' || 
				' ' || 
				'0' || 
				nm_empresa_w || 
				ds_brancos_80_w || 
				'00000001' || 
				to_char(dt_remessa_retorno_w,'DDMMYYYY') || 
				'00000000' || 
				ds_brancos_33_w;		
				 
/*utl_file.put_line(arq_texto_w,ds_conteudo_w); 
utl_file.fflush(arq_texto_w);*/
 
 
insert	into w_envio_banco(cd_estabelecimento, 
	ds_conteudo, 
	dt_atualizacao, 
	dt_atualizacao_nrec, 
	nm_usuario, 
	nm_usuario_nrec, 
	nr_sequencia, 
	nr_seq_apres, 
	nr_seq_apres_2) 
values (cd_estabelecimento_p, 
	ds_conteudo_w, 
	clock_timestamp(), 
	clock_timestamp(), 
	nm_usuario_p, 
	nm_usuario_p, 
	nextval('w_envio_banco_seq'), 
	2, 
	2);
 
 
/*	Fim - Header do Lote	*/
 
 
/*	Segmento P, Segmento Q, Segmento R	 */
 
open C01;
loop 
fetch C01 into	 
	cd_agencia_bancaria_w, 
	ds_nosso_numero_w, 
	nr_titulo_w, 
	dt_vencimento_w, 
	vl_titulo_w, 
	dt_emissao_w, 
	vl_juros_mora_w, 
	vl_desconto_w, 
	ie_tipo_inscricao_w, 
	nr_inscricao_w, 
	nm_pessoa_w, 
	ds_endereco_w, 
	ds_bairro_w, 
	cd_cep_w, 
	ds_cidade_w, 
	ds_uf_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	/* 	Segmento P		*/
 
	--qt_registro_lote_w	:= qt_registro_lote_w + 1; 
	qt_registro_w		:= qt_registro_w + 1;
	qt_registro_P_w		:= qt_registro_P_w + 1;
	ds_conteudo_w		:=	'341' || 
					lpad(qt_registro_lote_w,4,'0') || 
					'3' || 
					lpad(qt_registro_P_w,5,'0') || 
					'P' || 
					' ' || 
					'01' || 
					cd_agencia_bancaria_w || 
					' ' || 
					'0000000' || 
					'00000' || 
					' ' || 
					'0' || 
					'000' || 
					'00000000' || 
					'0' || 
					ds_brancos_8_w || 
					'00000' || 
					nr_titulo_w || 
					ds_brancos_5_w || 
					'00000000' || 
					vl_titulo_w || 
					'00000' || 
					'0' || 
					'99' || 
					'A' || 
					dt_emissao_w || 
					'0' || 
					'00000000' || 
					vl_juros_mora_w || 
					'0' || 
					'00000000' || 
					vl_desconto_w || 
					'000000000000000' || 
					'000000000000000' || 
					lpad(nr_titulo_w, 25, ' ') || 
					'0' || 
					'00' || 
					'0' || 
					'00' || 
					'0000000000000' || 
					' ';
	 
	/*utl_file.put_line(arq_texto_w,ds_conteudo_w); 
	utl_file.fflush(arq_texto_w);*/
 
	 
	insert	into w_envio_banco(cd_estabelecimento, 
		ds_conteudo, 
		dt_atualizacao, 
		dt_atualizacao_nrec, 
		nm_usuario, 
		nm_usuario_nrec, 
		nr_sequencia, 
		nr_seq_apres, 
		nr_seq_apres_2) 
	values (cd_estabelecimento_p, 
		ds_conteudo_w, 
		clock_timestamp(), 
		clock_timestamp(), 
		nm_usuario_p, 
		nm_usuario_p, 
		nextval('w_envio_banco_seq'), 
		3, 
		qt_registro_P_w);
	 
	 
	/*	Fim - Segmento P	*/
 
	 
	/*	Segmento Q	*/
 
	--qt_registro_lote_w	:= qt_registro_lote_w + 1; 
	qt_registro_w		:= qt_registro_w + 1;
	--qt_registro_Q_w		:= qt_registro_Q_w + 1; 
	qt_registro_P_w		:= qt_registro_P_w + 1;
	 
	ds_conteudo_w		:=	'341' || 
					lpad(qt_registro_lote_w, 4, '0') || 
					'3' || 
					lpad(qt_registro_P_w, 5, '0') || 
					'Q' || 
					' ' || 
					'01' || 
					ie_tipo_inscricao_w || 
					nr_inscricao_w || 
					nm_pessoa_w || 
					ds_brancos_10_w || 
					ds_endereco_w || 
					ds_bairro_w || 
					cd_cep_w || 
					ds_cidade_w || 
					ds_uf_w || 
					'0' || 
					'000000000000000' || 
					ds_brancos_30_w || 
					ds_brancos_10_w ||					 
					'000' || 
					ds_brancos_28_w;
						 
	/*utl_file.put_line(arq_texto_w,ds_conteudo_w); 
	utl_file.fflush(arq_texto_w);*/
 
	 
	insert	into w_envio_banco(cd_estabelecimento, 
		ds_conteudo, 
		dt_atualizacao, 
		dt_atualizacao_nrec, 
		nm_usuario, 
		nm_usuario_nrec, 
		nr_sequencia, 
		nr_seq_apres, 
		nr_seq_apres_2) 
	values (cd_estabelecimento_p, 
		ds_conteudo_w, 
		clock_timestamp(), 
		clock_timestamp(), 
		nm_usuario_p, 
		nm_usuario_p, 
		nextval('w_envio_banco_seq'), 
		3, 
		qt_registro_P_w);
	 
	/*	Fim - Segmento Q	*/
 
	end;
end loop;
close C01;
 
/*	Fim - Segmento P, Segmento Q, Segmento R	 */
 
 
/*	Trailer de Lote	*/
 
select	lpad(count(1),6,'0'), 
	replace(to_char(sum(c.vl_titulo), 'fm0000000000000.00'),'.','') 
into STRICT	qt_titulos_cobr_w, 
	vl_titulos_cobr_w 
from	titulo_receber		c, 
	titulo_receber_cobr	b, 
	cobranca_escritural 	a 
where	b.nr_titulo	= c.nr_titulo 
and	a.nr_sequencia	= b.nr_seq_cobranca 
and	a.nr_sequencia	= nr_seq_cobr_escrit_p;
 
qt_registro_lote_w	:= qt_registro_lote_w + 1;
ds_conteudo_w		:=	'341' || 
				'0001' || 
				'5' || 
				ds_brancos_9_w || 
				lpad(qt_registro_w,6,'0') || 
				lpad(qt_titulos_cobr_w,6,'0') || 
				lpad(vl_titulos_cobr_w,17,'0') || 
				lpad(qt_titulos_cobr_w,6,'0') || 
				lpad(vl_titulos_cobr_w,17,'0') || 
				ds_brancos_46_w || 
				ds_brancos_8_w || 
				ds_brancos_117_w;
 
qt_registro_w		:= qt_registro_w + 1;				
				 
/*utl_file.put_line(arq_texto_w,ds_conteudo_w); 
utl_file.fflush(arq_texto_w);*/
 
 
insert	into w_envio_banco(cd_estabelecimento, 
	ds_conteudo, 
	dt_atualizacao, 
	dt_atualizacao_nrec, 
	nm_usuario, 
	nm_usuario_nrec, 
	nr_sequencia, 
	nr_seq_apres, 
	nr_seq_apres_2) 
values (cd_estabelecimento_p, 
	ds_conteudo_w, 
	clock_timestamp(), 
	clock_timestamp(), 
	nm_usuario_p, 
	nm_usuario_p, 
	nextval('w_envio_banco_seq'), 
	5, 
	5);
 
/*	Fim - Trailer de Lote	*/
 
 
/*	Trailer do Arquivo	*/
 
qt_registro_w	:= qt_registro_w + 1;
ds_conteudo_w	:=	'341' || 
			'9999' || 
			'9' || 
			ds_brancos_9_w || 
			'000001' || 
			lpad(qt_registro_w,6,'0') || 
			'000000' || 
			ds_brancos_205_w;
			 
			 
/*utl_file.put_line(arq_texto_w,ds_conteudo_w); 
utl_file.fflush(arq_texto_w);*/
 
 
insert	into w_envio_banco(cd_estabelecimento, 
	ds_conteudo, 
	dt_atualizacao, 
	dt_atualizacao_nrec, 
	nm_usuario, 
	nm_usuario_nrec, 
	nr_sequencia, 
	nr_seq_apres, 
	nr_seq_apres_2) 
values (cd_estabelecimento_p, 
	ds_conteudo_w, 
	clock_timestamp(), 
	clock_timestamp(), 
	nm_usuario_p, 
	nm_usuario_p, 
	nextval('w_envio_banco_seq'), 
	6, 
	6);
 
 
/*	Fim - Trailer do Arquivo	*/
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_remessa_itau_cnab_240_tb ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

