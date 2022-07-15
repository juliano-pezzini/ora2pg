-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobr_mensagem_safra ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

						 
ds_conteudo_w		varchar(400);
cd_agencia_cobr_w	varchar(5);
nm_empresa_w		varchar(30);
dt_geracao_w		varchar(6);
cd_cedente_w		varchar(9);
nr_remessa_w		varchar(3);
nr_titulo_w		varchar(10);
nr_seq_reg_arquivo_w	bigint := 1;
nr_seq_apres_w		bigint := 1;
ds_brancos_4_w		varchar(4);
ds_brancos_6_w		varchar(6);
ds_brancos_7_w		varchar(7);
ds_brancos_291_w		varchar(291);
ds_brancos_390_w		varchar(391);
ds_mensagem_1_w		varchar(42);
ds_mensagem_2_w		varchar(42);
ds_mensagem_3_w		varchar(42);
ds_mensagem_4_w		varchar(42);
ds_mensagem_5_w		varchar(42);
ds_mensagem_6_w		varchar(42);
ds_mensagem_7_w		varchar(42);
ds_mensagem_8_w		varchar(42);
ds_mensagem_9_w		varchar(43);

 
C01 CURSOR FOR 
	SELECT	b.nr_titulo, 
		rpad(substr(obter_instrucao_boleto(b.nr_titulo, a.cd_banco,1),1,42),42,' ') ds_mensagem_1, 
		rpad(substr(obter_instrucao_boleto(b.nr_titulo, a.cd_banco,2),1,42),42,' ') ds_mensagem_2, 
		rpad(substr(obter_instrucao_boleto(b.nr_titulo, a.cd_banco,3),1,42),42,' ') ds_mensagem_3, 
		rpad(substr(obter_instrucao_boleto(b.nr_titulo, a.cd_banco,4),1,42),42,' ') ds_mensagem_4, 
		rpad(substr(obter_instrucao_boleto(b.nr_titulo, a.cd_banco,5),1,42),42,' ') ds_mensagem_5, 
		rpad(substr(obter_instrucao_boleto(b.nr_titulo, a.cd_banco,6),1,42),42,' ') ds_mensagem_6, 
		rpad(substr(obter_instrucao_boleto(b.nr_titulo, a.cd_banco,7),1,42),42,' ') ds_mensagem_7, 
		rpad(substr(obter_instrucao_boleto(b.nr_titulo, a.cd_banco,8),1,42),42,' ') ds_mensagem_8, 
		rpad(substr(obter_instrucao_boleto(b.nr_titulo, a.cd_banco,9),1,43),43,' ') ds_mensagem_9, 
		lpad(coalesce(substr(a.nr_remessa,1,3),'0'),3,'0') nr_remessa 
	from	cobranca_escritural a, 
		titulo_receber_cobr b 
	where	a.nr_sequencia		= b.nr_seq_cobranca 
	and	a.nr_sequencia		= nr_seq_cobr_escrit_p;


BEGIN 
 
delete from w_envio_banco where nm_usuario = nm_usuario_p;
 
select	lpad(' ',4,' '), 
		lpad(' ',6,' '), 
		lpad(' ',7,' '), 
		lpad(' ',291,' '), 
		lpad(' ',390,' ') 
into STRICT	ds_brancos_4_w, 
		ds_brancos_6_w, 
		ds_brancos_7_w, 
		ds_brancos_291_w, 
		ds_brancos_390_w
;
 
/* Header Arquivo*/
 
select	lpad(coalesce(substr(b.cd_agencia_bancaria,1,5),'0'),5,'0') cd_agencia_cobr, 
	rpad(substr(obter_nome_estabelecimento(cd_estabelecimento_p),1,30),30,' ') nm_empresa, 
	to_char(coalesce(a.dt_remessa_retorno, clock_timestamp()), 'DDMMYY') dt_geracao, 
	lpad(substr(coalesce(b.cd_cedente,b.cd_conta || coalesce(b.ie_digito_conta,'0')),1,9),9,'0') cd_cedente, 
	lpad(coalesce(substr(a.nr_remessa,1,3),'0'),3,'0') nr_remessa 
into STRICT	cd_agencia_cobr_w, 
	nm_empresa_w, 
	dt_geracao_w, 
	cd_cedente_w, 
	nr_remessa_w 
from	cobranca_escritural		a, 
	banco_estabelecimento	b 
where	a.nr_seq_conta_banco	= b.nr_sequencia 
and	a.nr_sequencia		= nr_seq_cobr_escrit_p;
 
ds_conteudo_w	:=	'0' || 				--1 1 
			'1' ||				--2 2 
			'REMESSA' ||	 		--3 9 
			'01' || 				--10 11 
			'Cobranca' || 			--12 19 
			ds_brancos_7_w || 			--20 26 
			cd_agencia_cobr_w || cd_cedente_w ||	--27 40 
			ds_brancos_6_w || 			--41 46 
			nm_empresa_w || 			--47 76			 
			'422' ||				--77 79 
			'BANCO SAFRA' || 			--80 90 
			ds_brancos_4_w || 			--91 94 
			dt_geracao_w || 			--95 100 
			ds_brancos_291_w ||		--101 391 
			nr_remessa_w ||			--392 394 
			lpad(nr_seq_reg_arquivo_w,6,'0'); 	--395 400 
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
 
/* Fim Header Arquivo */
 
 
/* Detalhe */
 
open C01;
loop 
fetch C01 into	 
	nr_titulo_w, 
	ds_mensagem_1_w, 
	ds_mensagem_2_w, 
	ds_mensagem_3_w, 
	ds_mensagem_4_w, 
	ds_mensagem_5_w, 
	ds_mensagem_6_w, 
	ds_mensagem_7_w, 
	ds_mensagem_8_w, 
	ds_mensagem_9_w, 
	nr_remessa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	nr_seq_reg_arquivo_w	:= coalesce(nr_seq_reg_arquivo_w,0) + 1;
	nr_seq_apres_w		:= nr_seq_apres_w + 1;
		 
	ds_conteudo_w	:=	'2' ||				--1 1 
				'0' || 				--2 2 
				rpad(coalesce(nr_titulo_w, ' '),10,' ') ||		--3 12 
				ds_mensagem_1_w || 		--13 54 
				ds_mensagem_2_w || 		--55 96 
				ds_mensagem_3_w || 		--97 138 
				ds_mensagem_4_w || 		--139 180 
				ds_mensagem_5_w || 		--181 222 
				ds_mensagem_6_w || 		--223 264 
				ds_mensagem_7_w || 		--265 306 
				ds_mensagem_8_w || 		--307 348 
				ds_mensagem_9_w|| 		--349 391 
				nr_remessa_w || 			--392 394 
				lpad(nr_seq_reg_arquivo_w,6,'0');	--395 400 
	
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
	end;	
	 
end loop;
close C01;
/* Fim detalhe */
 
 
/* Trailler Arquivo*/
	 
nr_seq_reg_arquivo_w	:= coalesce(nr_seq_reg_arquivo_w,0) + 1;
nr_seq_apres_w		:= nr_seq_apres_w + 1;
 
ds_conteudo_w	:=	'9' || 				--1 1 
			ds_brancos_390_w || 		--2 391 
			nr_remessa_w || 			--392 394 
			lpad(nr_seq_reg_arquivo_w,6,'0'); 	--395 400 
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
-- REVOKE ALL ON PROCEDURE gerar_cobr_mensagem_safra ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

