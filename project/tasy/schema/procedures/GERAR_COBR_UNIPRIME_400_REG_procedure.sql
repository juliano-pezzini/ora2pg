-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobr_uniprime_400_reg ( nr_seq_cobr_escrit_p cobranca_escritural.nr_sequencia%type, cd_estabelecimento_p cobranca_escritural.cd_estabelecimento%type, nm_usuario_p cobranca_escritural.nm_usuario%type) AS $body$
DECLARE

					
subtype varchar400 	is varchar(400);
subtype varchar30 	is varchar(30);
subtype varchar7 	is varchar(7);
subtype varchar17 	is varchar(17);
subtype varchar5 	is varchar(5);
subtype varchar1 	is varchar(1);

ds_conteudo_w		varchar400;
nm_empresa_w		varchar30;
nr_remessa_w		varchar7;
ds_ident_emp_bco_w	varchar17;
cd_agencia_w		varchar5;
cd_conta_w		varchar7;
ie_digito_conta_w	varchar1;

nr_sequencial_w		cobranca_escritural.nr_sequencia%type;
cd_convenio_banco_w	banco_estabelecimento.cd_convenio_banco%type;
ie_emissao_bloqueto_w	cobranca_escritural.ie_emissao_bloqueto%type;
vl_desc_previsto_w	titulo_receber.vl_desc_previsto%type;

C01 CURSOR FOR
	SELECT	a.nr_titulo nr_titulo,
		a.tx_multa tx_multa,
		ELIMINA_CARACTERE_ESPECIAL(a.nr_nosso_numero) nr_nosso_numero,
		b.cd_ocorrencia cd_ocorrencia,
		a.dt_pagamento_previsto dt_pagamento_previsto,
		a.vl_saldo_titulo vl_saldo_titulo,
		a.dt_emissao dt_emissao,
		a.tx_juros tx_juros,
		--round((a.vl_saldo_titulo * (a.tx_juros/100/30)),2),
		to_char(a.dt_limite_desconto,'DDMMYY') dt_limite_desconto,
		a.vl_desc_previsto vl_desc_previsto,
		CASE WHEN coalesce(a.cd_pessoa_fisica::text, '') = '' THEN '02'  ELSE '01' END  ie_cpf_cnpj,
		substr(CASE WHEN coalesce(a.cd_pessoa_fisica::text, '') = '' THEN  a.cd_cgc  ELSE obter_compl_pf(a.cd_pessoa_fisica, 1, 'C') END ,1,14) nr_cpf_cnpj,
		substr(obter_nome_pf_pj(a.cd_pessoa_fisica, a.cd_cgc),1,40) nm_pf_pj,
		rpad(COALESCE(SUBSTR(pls_obter_compl_pagador(a.nr_seq_pagador,'EN'),1,40),SUBSTR(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'R'),1,40),' '),40,' ') ds_endereco,
		lpad(COALESCE(SUBSTR(pls_obter_compl_pagador(a.nr_seq_pagador,'CEP'),1,8),SUBSTR(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'CEP'),1,8),'0'),8,'0') nr_cep,
		rpad(COALESCE(SUBSTR(pls_obter_compl_pagador(a.nr_seq_pagador,'B'),1,20),SUBSTR(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'B'),1,20),' '),20,' ') ds_bairro,
		rpad(COALESCE(SUBSTR(pls_obter_compl_pagador(a.nr_seq_pagador,'CI'),1,38),SUBSTR(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'CI'),1,38),' '),38,' ') ds_cidade,
		rpad(COALESCE(SUBSTR(pls_obter_compl_pagador(a.nr_seq_pagador,'UF'),1,2),SUBSTR(obter_dados_pf_pj(a.cd_pessoa_fisica,a.cd_cgc,'UF'),1,2),' '),2,' ') sg_estado
	from	titulo_receber a,
		titulo_receber_cobr b
	where	a.nr_titulo		= b.nr_titulo
	and	b.nr_seq_cobranca	= nr_seq_cobr_escrit_p;
	
c01_w	c01%rowtype;


BEGIN

delete	FROM w_envio_banco
where	nm_usuario	= nm_usuario_p;

/* header */

select	rpad(COALESCE(substr(max(b.cd_convenio_banco),1,20),' '),20,' ') cd_convenio_banco,
	rpad(substr(obter_nome_estabelecimento(max(a.cd_estabelecimento)),1,30),30,' ') nm_empresa,
	lpad(substr(COALESCE(max(a.nr_remessa), max(a.nr_sequencia)),1,7),7,'0') nr_remessa,
	rpad(substr('0' || max(b.cd_carteira) || max(b.cd_agencia_bancaria) || max(b.cd_conta),1,17),17,' ') ds_ident_emp_bco,
	max(a.ie_emissao_bloqueto) ie_emissao_bloqueto,
	lpad(coalesce(max(b.cd_agencia_bancaria),'0'),5,'0') cd_agencia, 
	lpad(coalesce(max(b.cd_conta),'0'),7,'0') cd_conta, 
	lpad(coalesce(max(b.ie_digito_conta),'0'),1,'0') ie_digito_conta
into STRICT	cd_convenio_banco_w,
	nm_empresa_w,
	nr_remessa_w,
	ds_ident_emp_bco_w,
	ie_emissao_bloqueto_w,
	cd_agencia_w,
	cd_conta_w,
	ie_digito_conta_w
from	estabelecimento c,
	banco_estabelecimento b,
	cobranca_escritural a
where	a.cd_estabelecimento	= c.cd_estabelecimento
and	a.nr_seq_conta_banco	= b.nr_sequencia
and	a.nr_sequencia		= nr_seq_cobr_escrit_p;

nr_sequencial_w :=	coalesce(nr_sequencial_w,0) + 1;


ds_conteudo_w :=	'0'							|| /*Pos 01*/
			'1'							|| /*Pos 02*/
			'REMESSA'						|| /*Pos 03 a 09*/
			'01'							|| /*Pos 10 a 11*/
			rpad('COBRANCA',15,' ')					|| /*Pos 12 a 26*/
			cd_convenio_banco_w					|| /*Pos 27 a 46*/
			nm_empresa_w						|| /*Pos 47 a 76*/
			'084'							|| /*Pos 77 a 79*/
			rpad('UNIPRIME',15,' ')					|| /*Pos 80 a 94*/
			to_char(clock_timestamp(),'DDMMYY')				|| /*Pos 95 a 100*/
			rpad(' ',8,' ')						|| /*Pos 101 a 108*/
			'MX'							|| /*Pos 109 a 110*/
			nr_remessa_w						|| /*Pos 111 a 117*/
			lpad(' ',277,' ')					|| /*Pos 118 a 394*/
			lpad(nr_sequencial_w,6,'0');				   /*Pos 395 a 400*/
			
insert into w_envio_banco(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_estabelecimento,
	ds_conteudo,
	nr_seq_apres,
	nr_seq_lote)
values (nextval('w_envio_banco_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_estabelecimento_p,
	ds_conteudo_w,
	nr_sequencial_w,
	nr_seq_cobr_escrit_p);

open C01;
loop
fetch C01 into	
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	nr_sequencial_w :=	coalesce(nr_sequencial_w,0) + 1;
	
	if (coalesce(vl_desc_previsto_w,0) = 0) then
		c01_w.dt_limite_desconto := '000000';
	else
		c01_w.dt_limite_desconto := to_char(coalesce(c01_w.dt_limite_desconto,c01_w.dt_pagamento_previsto),'DDMMYY');
	end if;
	
	ds_conteudo_w :=	'1'										|| /*Pos 01*/
				lpad(' ',19,' ')								|| /*Pos 02 a 20*/
				lpad(substr(ds_ident_emp_bco_w,1,3),4,'0')					|| /*Pos 21 a 24 carteira */
				lpad(cd_agencia_w,5,'0')							|| /*Pos 25 a 29 agencia*/
				lpad(cd_conta_w,7,'0')								|| /*Pos 30 a 36 conta*/
				coalesce(ie_digito_conta_w,'0')							|| /*Pos 37 DV conta */
				lpad(c01_w.nr_titulo,25,'0')							|| /*Pos 38 a 62*/
				'084'										|| /*Pos 63 a 65*/
				'2'										|| /*Pos 66*/
				lpad(somente_numero(to_char(coalesce(c01_w.tx_multa,0),'90.00')),4,'0') 		|| /*Pos 67 a 70*/
				lpad(substr(coalesce(c01_w.nr_nosso_numero,'0'),1,12),12,'0')			|| /*Pos 71 a 81 nosso numero e 82 digito nosso numero*/
				lpad(' ',10,' ')								|| /*pos 83 a 92*/
				coalesce(ie_emissao_bloqueto_w,'2')							|| /*Pos 93*/
				lpad(' ',15,' ')								|| /*Pos 94 a 108*/
				coalesce(substr(c01_w.cd_ocorrencia,1,2),'01')					|| /*Pos 109 a 110*/
				lpad(substr(c01_w.nr_titulo,1,10),10,'0')					|| /*Pos 111 a 120*/
				to_char(c01_w.dt_pagamento_previsto,'DDMMYY')					|| /*Pos 121 a 126*/
				lpad(somente_numero(to_char(coalesce(c01_w.vl_saldo_titulo,0),'99999999990.00')),13,'0') || /*Pos 127 a 139*/
				lpad(' ',8,' ')									|| /*Pos 140 a 147*/
				'01'										|| /*Pos 148 a 149*/
				'N'										|| /*Pos 150*/
				to_char(c01_w.dt_emissao,'DDMMYY')						|| /*Pos 151 a 156*/
				lpad('0',4,'0')									|| /*Pos 157 a 160*/
				lpad(somente_numero(to_char(coalesce(c01_w.tx_juros,0),'99999999990.00')),13,'0') || /*Pos 161 a 173*/
				c01_w.dt_limite_desconto							|| /*Pos 174 a 179*/
				lpad(somente_numero(to_char(coalesce(vl_desc_previsto_w,0),'99999999990.00')),13,'0')|| /*Pos 180 a 192*/
				lpad(' ',13,' ')								|| /*Pos 193 a 205*/
				lpad(' ',13,' ')								|| /*Pos 206 a 218*/
				c01_w.ie_cpf_cnpj								|| /*Pos 219 a 220*/
				lpad(coalesce(c01_w.nr_cpf_cnpj,'0'),14,'0')						|| /*Pos 221 a 234*/
				rpad(coalesce(c01_w.nm_pf_pj,' '),40,' ')						|| /*Pos 235 a 274*/
				rpad(coalesce(c01_w.ds_endereco,' '),40,' ')						|| /*Pos 275 a 314*/
	
				lpad(' ',12,' ')								|| /*Pos 315 a 326*/
				lpad(coalesce(c01_w.nr_cep,'0'),8,'0')						|| /*Pos 327 a 334*/
				rpad(coalesce(c01_w.ds_bairro,' '),20,' ')						|| /*Pos 335 a 354*/
				rpad(coalesce(c01_w.ds_cidade,' '),38,' ')						|| /*Pos 355 a 392*/
				rpad(coalesce(c01_w.sg_estado,' '),2,' ')						|| /*Pos 393 a 394*/
				lpad(nr_sequencial_w,6,'0');							   /*Pos 395 a 400*/
				
	insert into w_envio_banco(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_estabelecimento,
		ds_conteudo,
		nr_seq_apres,
		nr_seq_lote)
	values (nextval('w_envio_banco_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_estabelecimento_p,
		ds_conteudo_w,
		nr_sequencial_w,
		nr_seq_cobr_escrit_p);
		
	/*Segmento de Mensagens - vazio por enquanto*/

	nr_sequencial_w :=	coalesce(nr_sequencial_w,0) + 1;
	
	ds_conteudo_w :=	'2'										|| /*Pos 01*/
				lpad(' ',80,' ')								|| /*Pos 02 a 81 Mensagem 1*/
	
				lpad(' ',80,' ')								|| /*Pos 82 a 161 Mensagem 2*/
	
				lpad(' ',80,' ')								|| /*Pos 162 a 241 Mensagem 3*/
	
				lpad(' ',80,' ')								|| /*Pos 242 a 321 Mensagem 4*/
				lpad(' ',73,' ')								|| /*Pos 322 a 394 Brancos*/
				lpad(nr_sequencial_w,6,'0');							   /*Pos 395 a 400*/
				
	insert into w_envio_banco(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_estabelecimento,
		ds_conteudo,
		nr_seq_apres,
		nr_seq_lote)
	values (nextval('w_envio_banco_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_estabelecimento_p,
		ds_conteudo_w,
		nr_sequencial_w,
		nr_seq_cobr_escrit_p);
	end;
end loop;
close C01;

/*Trailler*/

nr_sequencial_w :=	coalesce(nr_sequencial_w,0) + 1;

ds_conteudo_w :=	'9'											|| /*Pos 01*/
			lpad(' ',393,' ')									|| /*Pos 02 a 394*/
			lpad(nr_sequencial_w,6,'0');								   /*Pos 395 a 400*/
			
insert into w_envio_banco(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_estabelecimento,
	ds_conteudo,
	nr_seq_apres,
	nr_seq_lote)
values (nextval('w_envio_banco_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_estabelecimento_p,
	ds_conteudo_w,
	nr_sequencial_w,
	nr_seq_cobr_escrit_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobr_uniprime_400_reg ( nr_seq_cobr_escrit_p cobranca_escritural.nr_sequencia%type, cd_estabelecimento_p cobranca_escritural.cd_estabelecimento%type, nm_usuario_p cobranca_escritural.nm_usuario%type) FROM PUBLIC;

