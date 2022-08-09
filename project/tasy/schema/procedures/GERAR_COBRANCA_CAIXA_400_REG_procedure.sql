-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobranca_caixa_400_reg ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_grupo_inst_p bigint) AS $body$
DECLARE

					
/*===========================================================
	             =>>>>>	A T E N C A O        <<<<<<=

Como se trata de um projeto e nao possuimos cliente para validar junto 
ao banco, os defeitos devem ser verificados com o analista (Peterson) antes
de serem documentados. 
============================================================*/
						
	
ds_conteudo_w			varchar(400)	:= null;
nr_seq_reg_arquivo_w		bigint	:= 1;
cd_conta_cobr_w			varchar(6);
cd_agencia_cobr_w		varchar(4);
nm_empresa_w			varchar(30);
dt_geracao_w			varchar(6);
ie_digito_conta_cobr_w		varchar(1);
cd_banco_w			smallint;
nr_seq_carteira_cobr_w		bigint;
nr_carteira_w			varchar(3);
ie_emissao_bloqueto_w	cobranca_escritural.ie_emissao_bloqueto%type;

/* detalhe */

ie_tipo_inscricao_w			varchar(2);
nr_inscricao_empresa_w		varchar(14);
cd_agencia_bancaria_w		varchar(4);
cd_conta_w			varchar(6);
nr_nosso_numero_w		varchar(8);
vl_multa_w			double precision;
nr_titulo_w			bigint;
dt_vencimento_w			timestamp;
vl_titulo_w			double precision;
dt_emissao_w			timestamp;
vl_juros_w			double precision;
vl_desconto_w			double precision;
nm_pessoa_w			varchar(40);
ds_endereco_w			varchar(40);
ds_bairro_w			varchar(12);
cd_cep_w			varchar(8);
ds_cidade_w			varchar(15);
sg_estado_w			varchar(15);
tx_juros_w			double precision;
tx_multa_w			double precision;
ds_tipo_juros_w			varchar(255);
ds_tipo_multa_w			varchar(255);
ie_digito_nosso_num_w		varchar(1);
nr_telefone_w			varchar(15);
nr_seq_carteira_cobr_tit_w		titulo_receber.nr_seq_carteira_cobr%type;
cd_flash_w			banco_estabelecimento.cd_flash%type;
nr_inscricao_w			varchar(14);

nr_seq_grupo_inst_w		bigint;

c01 CURSOR FOR
SELECT	CASE WHEN coalesce(b.cd_pessoa_fisica::text, '') = '' THEN '02'  ELSE '01' END  ie_tipo_inscricao,
	coalesce(c.nr_cpf,b.cd_cgc) nr_inscricao_empresa,
	lpad(a.cd_agencia_bancaria,4,'0') cd_agencia_bancaria,
	lpad(substr(a.nr_conta,1,5) || substr(a.ie_digito_conta,1,1),6,'0') cd_conta,
	lpad(substr(coalesce(b.nr_nosso_numero,'0'),1,8),8,'0') nr_nosso_numero,
	CASE WHEN coalesce(a.vl_multa,0)=0 THEN obter_juros_multa_titulo(b.nr_titulo,clock_timestamp(),'R','M')  ELSE a.vl_multa END ,
	a.nr_titulo,
	b.dt_pagamento_previsto,
	b.vl_saldo_titulo,
	b.dt_emissao,
	CASE WHEN coalesce(a.vl_juros,0)=0 THEN obter_juros_multa_titulo(b.nr_titulo,clock_timestamp(),'R','J')  ELSE a.vl_juros END ,
	a.vl_desconto,
	substr(obter_nome_pf_pj(b.cd_pessoa_fisica,b.cd_cgc),1,40) nm_pessoa,
	rpad(coalesce(substr(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'R'),1,40),' '),40,' ') ds_endereco,
	rpad(coalesce(substr(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'B'),1,12),' '),12,' ') ds_bairro,
	lpad(coalesce(substr(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'CEP'),1,8),'0'),8,'0') cd_cep,
	rpad(coalesce(substr(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'CI'),1,15),' '),15,' ') ds_cidade,
	rpad(coalesce(substr(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'UF'),1,2),' '),2,' ') sg_estado,
	b.tx_juros,
	b.tx_multa,
	substr(obter_valor_dominio(707,b.cd_tipo_taxa_juro),1,255) ds_tipo_juros,
	substr(obter_valor_dominio(707,b.cd_tipo_taxa_multa),1,255) ds_tipo_multa,
	b.nr_seq_carteira_cobr
FROM titulo_receber_cobr a, titulo_receber b
LEFT OUTER JOIN pessoa_fisica c ON (b.cd_pessoa_fisica = c.cd_pessoa_fisica)
WHERE a.nr_titulo		= b.nr_titulo and a.nr_seq_cobranca	= nr_seq_cobr_escrit_p;


BEGIN

delete	FROM w_envio_banco
where	nm_usuario = nm_usuario_p;

if (coalesce(nr_seq_grupo_inst_p,0)	= 0) then

	nr_seq_grupo_inst_w	:= null;

else

	nr_seq_grupo_inst_w	:= nr_seq_grupo_inst_p;

end if;

/* header  */

select	lpad(coalesce(b.cd_conta,'0'),6,'0'),
	lpad(coalesce(b.cd_agencia_bancaria,'0'),4,'0'),
	substr(coalesce(b.ie_digito_conta,'0'),1,1),
	rpad(substr(obter_nome_estabelecimento(cd_estabelecimento_p),1,30),30,' ') nm_empresa,
	to_char(clock_timestamp(),'DDMMYY'),
	a.nr_seq_carteira_cobr,
	b.cd_banco,
	rpad(coalesce(substr(b.cd_flash,1,3),'LWZ'),3,' ') cd_flash,
	c.cd_cgc nr_inscricao,
	a.IE_EMISSAO_BLOQUETO
into STRICT	cd_conta_cobr_w,
	cd_agencia_cobr_w,
	ie_digito_conta_cobr_w,
	nm_empresa_w,
	dt_geracao_w,
	nr_seq_carteira_cobr_w,
	cd_banco_w,
	cd_flash_w,
	nr_inscricao_w,
	ie_emissao_bloqueto_w
from	estabelecimento c,
	banco_estabelecimento b,
	cobranca_escritural a
where	a.cd_estabelecimento	= c.cd_estabelecimento
and	a.nr_seq_conta_banco	= b.nr_sequencia
and	a.nr_sequencia		= nr_seq_cobr_escrit_p;

select	substr(max(a.cd_carteira),1,3) nr_carteira
into STRICT	nr_carteira_w
from	banco_carteira a
where	a.nr_sequencia 	= nr_seq_carteira_cobr_w
and	a.cd_banco	= cd_banco_w;

select	max(b.nr_telefone)
into STRICT	nr_telefone_w
from	pessoa_juridica b,
	estabelecimento a
where	a.cd_cgc		= b.cd_cgc
and	a.cd_estabelecimento	= cd_estabelecimento_p;

/*HEADER DE ARQUIVO*/

ds_conteudo_w	:= 	'0' 								|| /*Pos 01*/
					'1' 								|| /*Pos 02 */
					'REMESSA' 							|| /*Pos 03 a 09*/
					'01' 								|| /*Pos 10 a 11*/
					rpad('COBRANCA',15,' ') 			|| /*Pos 12 a 26*/
					cd_agencia_cobr_w 					|| /*Pos 18 a 21*/
					cd_conta_cobr_w						|| /*Pos 22 a 27*/
					rpad(' ',10,' ')					|| /*Pos 37 a 46*/
					nm_empresa_w 						|| /*Pos 47 a 76*/
					lpad(cd_banco_w,3,'0') 				|| /*Pos 77 a 79*/
					rpad('C ECON FEDERAL',15,' ') 		|| /*Pos 80 a 94*/
					dt_geracao_w 						|| /*Pos 95 a 100*/
					rpad(' ',289,' ') 					|| /*Pos 101 a 389*/
					'00001'								|| /*Pos 390 a 394*/
					lpad(nr_seq_reg_arquivo_w,6,'0');      /*Pos 395 a 400*/
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
	nr_seq_reg_arquivo_w);

/*fim HEADER DE ARQUIVO*/




	
	
/* detalhe */

open	C01;
loop
fetch	C01 into	
	ie_tipo_inscricao_w,
	nr_inscricao_empresa_w,
	cd_agencia_bancaria_w,
	cd_conta_w,
	nr_nosso_numero_w,
	vl_multa_w,
	nr_titulo_w,
	dt_vencimento_w,
	vl_titulo_w,
	dt_emissao_w,
	vl_juros_w,
	vl_desconto_w,
	nm_pessoa_w,
	ds_endereco_w,
	ds_bairro_w,
	cd_cep_w,
	ds_cidade_w,
	sg_estado_w,
	tx_juros_w,
	tx_multa_w,
	ds_tipo_juros_w,
	ds_tipo_multa_w,
	nr_seq_carteira_cobr_tit_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	if (coalesce(nr_carteira_w::text, '') = '') then

		select	substr(max(a.cd_carteira),1,3) nr_carteira
		into STRICT	nr_carteira_w
		from	banco_carteira a
		where	a.nr_sequencia 	= nr_seq_carteira_cobr_tit_w;

	end if;

	nr_seq_reg_arquivo_w	:= nr_seq_reg_arquivo_w + 1;

	/* Registro Detalhe (obrigatorio) */

	ds_conteudo_w	:=	'1' 																		|| /*Pos 01*/
						'02' 																		|| /*Pos 02 a 03*/
						lpad(coalesce(nr_inscricao_w,'0'),14,'0') 										|| /*Pos 04 a 17*/
						lpad(cd_agencia_bancaria_w,4,'0') 											|| /*Pos 18 a 21*/
						lpad(cd_conta_w,6,'0') 														|| /*Pos 22 a 27 */
						ie_emissao_bloqueto_w														|| /*Pos 28 a 28 */
						'0'																			|| /*Pos 29 a 29 */
						'00'																		|| /*Pos 30 a 31*/
						lpad(nr_titulo_w,25,'0') 													|| /*Pos 32 a 56*/
						'11'																		|| /*Pos 57 a 58*/
						lpad(nr_nosso_numero_w,15,'0')												|| /*Pos 59 a 73*/
						rpad(' ',3,' ')	 															|| /*Pos 74 a 76*/
						rpad(' ',30,' ')	 														|| /*Pos 77 a 106*/
						'01'																		|| /*Pos  107a 108*/
						'02'																		|| /*Pos 109 a 110*/
						rpad(' ',10,' ') 															|| /*Pos 111 a 120*/
						to_char(dt_vencimento_w,'ddmmyy') 											|| /*Pos 121 a 126*/
						lpad(somente_numero(to_char(coalesce(vl_titulo_w,0),'99999999990.00')),13,'0') 	|| /*Pos 127 a 139*/
						lpad(cd_banco_w,3,'0') 														|| /*Pos 140 a 142*/
						'00000' 																	|| /*Pos 143 a 147*/
						'99' 																		|| /*Pos 148 a 149*/
						'A' 																		|| /*Pos 150*/
						to_char(dt_emissao_w,'ddmmyy') 												|| /*Pos 151 a 156*/
						'0100' 																		|| /*Pos 157 a 158 a 159 a 160*/
						lpad(somente_numero(to_char(coalesce(vl_juros_w,0),'99999999990.00')),13,'0') 	|| /*Pos 161 a 173*/
						to_char(dt_vencimento_w,'ddmmyy') 											|| /*Pos 174 a 179*/
						lpad(somente_numero(to_char(coalesce(vl_desconto_w,0),'99999999990.00')),13,'0') || /*Pos 180 a 192*/
						lpad('0',26,'0') 															|| /*Pos 193 a 205 a 206 a 218*/
						ie_tipo_inscricao_w 														|| /*Pos 219 a 220*/
						lpad(coalesce(nr_inscricao_empresa_w,'0'),14,'0') 								|| /*Pos 221 a 234*/
						rpad(nm_pessoa_w,40,' ')											 		|| /*Pos 235 a 264 265 a 274*/
						ds_endereco_w 																|| /*Pos 275 a 314*/
						ds_bairro_w 																|| /*Pos 315 a 326*/
						cd_cep_w 																	|| /*Pos 327 a 334*/
						ds_cidade_w 																|| /*Pos 335 a 349*/
						substr(sg_estado_w,1,2) 													|| /*Pos 350 a 351*/
						to_char(dt_vencimento_w,'ddmmyy') 											|| /*Pos 352 a 357*/
						rpad(somente_numero(to_char(coalesce(vl_multa_w,0),'99999999990.00')),10,'0')	|| /*Pos 358 a 367*/
						rpad(' ',22,' ') 															|| /*Pos 368 a 389*/
						'00'																		|| /*Pos 390 a 391*/
																	
						'00' 																		|| /*Pos 392 a 393*/
						'1' 																		|| /*Pos 394*/
						lpad(nr_seq_reg_arquivo_w,6,'0');											   /*Pos 395 a 400*/
	

	insert	into w_envio_banco(nr_sequencia,
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
		nr_seq_reg_arquivo_w);
	
end	loop;
close	C01;

/* trailer */

nr_seq_reg_arquivo_w	:= nr_seq_reg_arquivo_w + 1;

ds_conteudo_w	:= 	'9' 								|| /*Pos 01*/
					rpad(' ',393,' ')	 				|| /*Pos 02 a 394*/
					lpad(nr_seq_reg_arquivo_w,6,'0');      /*Pos 395 a 400*/
insert	into w_envio_banco(nr_sequencia,
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
	nr_seq_reg_arquivo_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobranca_caixa_400_reg ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_grupo_inst_p bigint) FROM PUBLIC;
