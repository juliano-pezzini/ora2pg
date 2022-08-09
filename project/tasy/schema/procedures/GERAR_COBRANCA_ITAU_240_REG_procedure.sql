-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobranca_itau_240_reg ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

					
					
/*===========================================================
	             =>>>>>	A T E N C A O        <<<<<<=

Esta procedure e uma copia da GERAR_COBRANCA_ITAU_240
com alteracao apenas na carteira para contemplar o projeto
de cobrancas registradas, OS 1170310.

Como se trata de um projeto e nao possuimos cliente para validar junto 
ao banco, os defeitos devem ser verificados com Peterson antes
de serem documentados. 
============================================================*/
					

ds_conteudo_w			varchar(240);
nr_seq_apres_w			w_envio_banco.nr_seq_apres%type := 0;

/* Header do arquivo */

nm_empresa_w			varchar(30);
nm_banco_w			varchar(30);
cd_cgc_w			varchar(14);
cd_agencia_bancaria_w		varchar(4);
nr_conta_estab_w			banco_estabelecimento.cd_conta%type;
ie_digito_conta_w			banco_estabelecimento.ie_digito_conta%type;
dt_remessa_retorno_w		timestamp;

/* Detalhe */

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

/* Trailer de Lote */

vl_titulos_cobr_w		varchar(15);
qt_titulos_cobr_w		integer;
qt_registro_lote_w		smallint	:= 0;

/* Trailer do Arquivo */

qt_registro_w			integer	:= 0;

nr_conta_w				varchar(5);
nr_dac_w				varchar(1);
nr_carteira_w			varchar(3);

C01 CURSOR FOR
SELECT	lpad(coalesce(c.cd_agencia_bancaria,'0'),4,'0'),
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
	rpad(substr(coalesce(elimina_caractere_especial(pls_obter_compl_pagador(d.nr_seq_pagador,'UF')),' '),1,2),2,' ') ds_uf,
	lpad((SELECT substr(coalesce(max(x.cd_conta),'0'),1,5) from banco_estabelecimento x where x.nr_sequencia = a.nr_seq_conta_banco),5,'0') nr_conta,
	lpad((select substr(coalesce(max(x.ie_digito_conta),'0'),1,1) from banco_estabelecimento x where x.nr_sequencia = a.nr_seq_conta_banco),1,'0') nr_dac,
	lpad((select substr(coalesce(max(cd_carteira),'0'),1,3) from banco_carteira x where x.nr_sequencia =  coalesce(a.nr_seq_carteira_cobr,b.nr_seq_carteira_cobr)),3,'0')
FROM titulo_receber_cobr c, cobranca_escritural a, titulo_receber b
LEFT OUTER JOIN pls_mensalidade d ON (b.nr_seq_mensalidade = d.nr_sequencia)
WHERE a.nr_sequencia		= c.nr_seq_cobranca and c.nr_titulo		= b.nr_titulo  and a.nr_sequencia		= nr_seq_cobr_escrit_p;
	

BEGIN

delete
from	w_envio_banco
where	nm_usuario = nm_usuario_p;

/* Header do Arquivo */

select	lpad(b.cd_cgc,14,'0'),
	lpad(coalesce(c.cd_agencia_bancaria,'0'),4,'0') cd_agencia_bancaria,
	lpad(somente_numero(substr(c.cd_conta,1,5)),5,'0'),
	coalesce(somente_numero(substr(c.ie_digito_conta,1,1)),'0'),
	rpad(substr(coalesce(elimina_caractere_especial(obter_razao_social(b.cd_cgc)),' '),1,30),30,' ') nm_empresa,
	rpad('BANCO ITAU SA', 30, ' ') nm_banco,
	coalesce(a.dt_remessa_retorno,clock_timestamp())
into STRICT	cd_cgc_w,
	cd_agencia_bancaria_w,
	nr_conta_estab_w,
	ie_digito_conta_w,
	nm_empresa_w,
	nm_banco_w,
	dt_remessa_retorno_w
from	banco_estabelecimento c,
	estabelecimento b,
	cobranca_escritural a
where	a.cd_estabelecimento	= b.cd_estabelecimento
and	a.nr_seq_conta_banco	= c.nr_sequencia
and	a.nr_sequencia		= nr_seq_cobr_escrit_p;

nr_seq_apres_w	:= nr_seq_apres_w + 1;

ds_conteudo_w	:= 	'341' ||
			'0000' ||
			'0' || 
			rpad(' ',9,' ') ||
			'2' ||
			cd_cgc_w ||
			rpad(' ',20,' ') ||
			'0' || 
			cd_agencia_bancaria_w ||
			' ' ||
			'0000000' ||
			nr_conta_estab_w ||
			' ' ||
			ie_digito_conta_w ||
			nm_empresa_w ||
			nm_banco_w ||
			rpad(' ',10,' ') ||
			'1' ||
			lpad(to_char(dt_remessa_retorno_w,'DDMMYYYY'),8,'0') ||
			lpad(to_char(dt_remessa_retorno_w,'hh24miss'),6,'0') ||
			'000001' ||
			'040' ||
			'00000' ||
			rpad(' ',54,' ') ||
			'000' ||
			rpad(' ',12,' ');

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
	nr_seq_apres_w,
	nr_seq_apres_w);

/*	Header do Lote	*/

qt_registro_lote_w	:= qt_registro_lote_w + 1;
nr_seq_apres_w	:= nr_seq_apres_w + 1;

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
				rpad(' ',20,' ') ||
				'0' || 
				cd_agencia_bancaria_w ||
				' ' ||
				'0000000' ||
				nr_conta_estab_w ||
				' ' ||
				ie_digito_conta_w ||
				nm_empresa_w ||
				rpad(' ',80,' ') ||
				'00000001' ||
				to_char(dt_remessa_retorno_w,'DDMMYYYY') ||
				'00000000' ||
				rpad(' ',33,' ');

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
	nr_seq_apres_w,
	nr_seq_apres_w);
				
/* Segmento P, Segmento Q, Segmento R */

open	C01;
loop
fetch	C01 into
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
	ds_uf_w,
	nr_conta_w,
	nr_dac_w,
	nr_carteira_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	/* Segmento P */

	qt_registro_w		:= qt_registro_w + 1;
	nr_seq_apres_w		:= nr_seq_apres_w + 1;

	ds_conteudo_w		:=	'341' 						|| /* Pos 1 a 3 */
						lpad(qt_registro_lote_w,4,'0') 	|| /* Pos 4 a 7 */
						'3' 							|| /*Pos 8*/
						lpad(qt_registro_w,5,'0') 	|| /*Pos 9 a 13*/
						'P' 							|| /*Pos 14*/
 
						' ' 							|| /*Pos 15*/
 
						'01' 							|| /*Pos 16 a 17*/
						'0'								|| /*Pos 18*/
						cd_agencia_bancaria_w 			|| /*Pos 19 a 22*/
						' ' 							|| /*Pos 23*/
						'0000000' 						|| /*Pos 24 a 30*/
						nr_conta_w						|| /*Pos 31 a 35*/
						' ' 							|| /*Pos 36*/
						nr_dac_w						|| /*Pos 37*/
						nr_carteira_w					|| /*Pos 38 a 40*/
 
						'00000000' 						|| /*Pos 41  a 48 - Vai zerado conforme nota no layout.*/
						'0' 							|| /*Pos 49 - Dac do nosso numero*/
						rpad(' ',8,' ') 				|| /*Pos 50 a 57*/
	
						'00000' 						|| /*Pos 58 a 62*/
						nr_titulo_w 					|| /*Pos 63 a 72*/
						rpad(' ',5,' ') 				|| /*Pos 73a 77*/
						dt_vencimento_w					|| /*Pos 78 a 85*/
						vl_titulo_w 					|| /*Pos 86 a 100*/
						'00000' 						|| /*Pos 101 a 105*/
						'0' 							|| /*Pos 106*/
						'99' 							|| /*Pos 107 a 108*/
						'A' 							|| /*Pos 109*/
						dt_emissao_w 					|| /*Pos 110 a 117*/
						'0' 							|| /*Pos 118*/
						'00000000' 						|| /*Pos 119 a 126*/
						vl_juros_mora_w 				|| /*Pos 127 a  141*/
						'0' 							|| /*Pos 142*/
						'00000000' 						|| /*Pos 143 a 150*/
		
						vl_desconto_w 					|| /*Pos 151 a 165*/
						'000000000000000' 				|| /*Pos 166 a 180 */
						'000000000000000' 				|| /*Pos 181 a 195*/
						lpad(nr_titulo_w, 25, ' ') 		|| /*Pos 196 a 220*/
						'0' 							|| /*Pos 221*/
						'00' 							|| /*Pos 222 a 223*/
						'0' 							|| /*Pos 224*/
						'00' 							|| /*Pos 225 a 226*/
						'0000000000000' 				|| /*Pos *227 a 239*/
						' ';							   /*Pos 240*/
					
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
		nr_seq_apres_w,
		nr_seq_apres_w);

	/* Segmento Q */

	qt_registro_w		:= qt_registro_w + 1;
	nr_seq_apres_w	:= nr_seq_apres_w + 1;
	
	ds_conteudo_w		:=	'341' ||
					lpad(qt_registro_lote_w, 4, '0') ||
					'3' ||
					lpad(qt_registro_w, 5, '0') ||
					'Q' ||
					' ' ||
					'01' ||
					ie_tipo_inscricao_w ||
					nr_inscricao_w ||
					nm_pessoa_w ||
					rpad(' ',10,' ') ||
					ds_endereco_w ||
					ds_bairro_w ||
					cd_cep_w ||
					ds_cidade_w ||
					ds_uf_w ||
					'0' ||
					'000000000000000' ||
					rpad(' ',30,' ') ||
					rpad(' ',10,' ') ||
					'000' ||
					rpad(' ',28,' ');

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
		nr_seq_apres_w,
		nr_seq_apres_w);

end	loop;
close	C01;

/*	Trailer de Lote	*/

select	lpad(count(1),6,'0'),
	replace(to_char(sum(c.vl_titulo), 'fm0000000000000.00'),'.','')
into STRICT	qt_titulos_cobr_w,
	vl_titulos_cobr_w
from	titulo_receber c,
	titulo_receber_cobr b,
	cobranca_escritural a
where	b.nr_titulo	= c.nr_titulo
and	a.nr_sequencia	= b.nr_seq_cobranca
and	a.nr_sequencia	= nr_seq_cobr_escrit_p;

qt_registro_lote_w	:= qt_registro_lote_w + 1;

ds_conteudo_w		:=	'341' ||
				'0001' ||
				'5' ||
				rpad(' ',9,' ') ||
				lpad(qt_registro_w,6,'0') ||
				lpad(qt_titulos_cobr_w,6,'0') ||
				lpad(vl_titulos_cobr_w,17,'0') ||
				lpad(qt_titulos_cobr_w,6,'0') ||
				lpad(vl_titulos_cobr_w,17,'0') ||
				rpad(' ',46,' ') ||
				rpad(' ',8,' ') ||
				rpad(' ',117,' ');

qt_registro_w		:= qt_registro_w + 1;
nr_seq_apres_w		:= nr_seq_apres_w + 1;

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
	nr_seq_apres_w,
	nr_seq_apres_w);

/* Trailer do Arquivo */

qt_registro_w	:= qt_registro_w + 1;
nr_seq_apres_w	:= nr_seq_apres_w + 1;

ds_conteudo_w	:=	'341' ||
			'9999' ||
			'9' ||
			rpad(' ',9,' ') ||
			'000001' ||
			lpad(qt_registro_w,6,'0') ||
			'000000' ||
			rpad(' ',205,' ');

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
	nr_seq_apres_w,
	nr_seq_apres_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobranca_itau_240_reg ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
