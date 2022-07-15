-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_pagto_banrisul_240_v89 ( nr_seq_envio_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* Layout CNAB 240 Banrisul
Rotina criada para atender as necessidades da OS 2424673.  Baseada na estrutura da procedure GERAR_PAGTO_FEBRABAN_240_V89*/
ds_conteudo_w		varchar(240);
cd_estabelecimento_w	smallint;
nr_seq_apres_w		bigint	:= 0;

/* header de arquivo */

cd_agencia_estab_w	varchar(6);
cd_cgc_estab_w		varchar(14);
cd_convenio_banco_w	varchar(20);
dt_geracao_w		varchar(14);
nm_empresa_w		varchar(30);
nr_conta_estab_w	varchar(12);
nr_remessa_w		bigint;
ie_digito_estab_w	varchar(1);
ds_banco_w		varchar(30);
cd_banco_pagto_w		smallint;

/* header de lote - DOC */

nr_lote_servico_w	bigint;
ie_forma_lanc_w		varchar(2);
ie_tipo_pagamento_w	varchar(3);
ie_finalidade_w		varchar(2);
ie_finalidade_c_w	varchar(2);
ds_endereco_w		varchar(30);
nr_endereco_w		varchar(5);
ds_complemento_w	varchar(15);
ds_municipio_w		varchar(20);
nr_cep_w		varchar(8);
sg_estado_w		varchar(15);
ie_forma_pagto_w	varchar(2);
cd_finalidade_compl_w	varchar(2);
IE_TIPO_SERVICO_PAGTO_W bigint;

c01 CURSOR FOR
SELECT	distinct
	CASE WHEN b.ie_tipo_pagamento='CC' THEN '01' WHEN b.ie_tipo_pagamento='DOC' THEN '03' WHEN b.ie_tipo_pagamento='TED' THEN '41' WHEN b.ie_tipo_pagamento='OP' THEN '30'  ELSE '03' END ,
	b.ie_tipo_pagamento,
	CASE WHEN b.ie_tipo_pagamento='CC' THEN '01'  ELSE '99' END
from	titulo_pagar_escrit b,
	banco_escritural a
where	b.ie_tipo_pagamento	in ('DOC','CC','OP','TED')
and	a.nr_sequencia		= b.nr_seq_escrit
and	a.nr_sequencia		= nr_seq_envio_p;

/* detalhe - DOC */

nr_sequencia_w		bigint;
cd_camara_compensacao_w	varchar(3);
cd_banco_w		smallint;
cd_agencia_bancaria_w	varchar(6);
nr_conta_w		varchar(20);
nm_pessoa_w		varchar(30);
nr_titulo_w		bigint;
dt_remessa_retorno_w	timestamp;
vl_escritural_w		double precision;
vl_acrescimo_w		double precision;
vl_desconto_w		double precision;
vl_despesa_w		double precision;
ie_tipo_inscricao_w	varchar(1);
nr_inscricao_w		varchar(14);
dt_vencimento_w		timestamp;
vl_juros_w		double precision;
vl_multa_w		double precision;
cd_agencia_conta_w	varchar(20);
ie_digito_conta_w	varchar(1);
ds_endereco_det_w	varchar(30);
nr_endereco_det_w	varchar(5);
ds_complemento_det_w	varchar(15);
ds_municipio_det_w	varchar(20);
nr_cep_det_w		varchar(8);
sg_estado_det_w		varchar(15);
ds_bairro_det_w		varchar(15);
cd_camara_w		varchar(3);
qt_favorecido_w		bigint;

cd_finalidade_doc_w		varchar(2);
cd_finalidade_ted_w		varchar(5);
cd_digito_agencia_w		varchar(1);
ie_tipo_pessoa_w		varchar(1);
ie_tipo_conta_w			varchar(3);
cd_pessoa_w				varchar(15);

c02 CURSOR FOR
SELECT	b.cd_banco,
	lpad(substr(coalesce(b.cd_agencia_bancaria,'0'),1,5),5,'0'),
	substr(coalesce(b.ie_digito_agencia,'0'),1,1),
	rpad(elimina_caractere_especial(substr(obter_nome_pf_pj(c.cd_pessoa_fisica,c.cd_cgc),1,30)),30,' '),
	c.nr_titulo,
	b.vl_escritural,
	b.vl_acrescimo,
	b.vl_desconto,
	b.vl_despesa,
	lpad(coalesce(d.nr_cpf,c.cd_cgc),14,'0'),
	replace(b.nr_conta,'X','0'),
	replace(substr(coalesce(b.ie_digito_conta,'0'),1,1),'X','0'),
	c.dt_vencimento_atual,
	b.vl_juros,
	b.vl_multa,
	CASE WHEN coalesce(c.cd_pessoa_fisica::text, '') = '' THEN '2'  ELSE '1' END  ie_tipo_inscricao,
	rpad(coalesce(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'R'),1,30),' '),30,' '),
	lpad(coalesce(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'NR'),1,5),'0'),5,'0'),
	rpad(coalesce(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'CO'),1,15),' '),15,' '),
	rpad(coalesce(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'CI'),1,20),' '),20,' '),
	lpad(coalesce(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'CEP'),1,8),'0'),8,'0'),
	rpad(coalesce(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'UF'),1,2),' '),2,' '),
	rpad(coalesce(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'B'),1,15),' '),15,' '),
	CASE WHEN b.ie_tipo_pagamento='DOC' THEN '700' WHEN b.ie_tipo_pagamento='TED' THEN '018'  ELSE '000' END  cd_camara,
	CASE WHEN coalesce(c.cd_pessoa_fisica::text, '') = '' THEN 'J'  ELSE 'F' END ,
	coalesce(c.cd_pessoa_fisica,c.cd_cgc)
FROM titulo_pagar_escrit b, banco_escritural a, titulo_pagar c
LEFT OUTER JOIN pessoa_fisica d ON (c.cd_pessoa_fisica = d.cd_pessoa_fisica)
WHERE b.nr_titulo		= c.nr_titulo and b.ie_tipo_pagamento	= ie_tipo_pagamento_w and a.nr_sequencia		= b.nr_seq_escrit and a.nr_sequencia		= nr_seq_envio_p;

/* trailer lote - DOC */

vl_total_w		double precision;

/* header de lote - BLQ */

c03 CURSOR FOR
SELECT	distinct
	CASE WHEN(select	count(*)		from	gps_titulo x		where	x.nr_titulo	= b.nr_titulo)=0 THEN 		CASE WHEN(select	count(*)			from	darf_titulo_pagar x			where	x.nr_titulo	= b.nr_titulo)=0 THEN 			CASE WHEN 	b.ie_tipo_pagamento='PC' THEN '11'  ELSE CASE WHEN 	CASE WHEN coalesce(d.cd_banco_externo::text, '') = '' THEN b.cd_banco  ELSE somente_numero(d.cd_banco_externo) END =cd_banco_pagto_w THEN '30'  ELSE CASE WHEN(select	count(*)						from	banco x						where	CASE WHEN coalesce(x.cd_banco_externo::text, '') = '' THEN x.cd_banco  ELSE somente_numero(x.cd_banco_externo) END 	= somente_numero(substr(c.nr_bloqueto,1,3)))=0 THEN '11'  ELSE '31' END  END  END   ELSE CASE WHEN 	coalesce(c.nr_bloqueto::text, '') = '' THEN '16'  ELSE '11' END  END   ELSE CASE WHEN coalesce(c.nr_bloqueto::text, '') = '' THEN '17'  ELSE '11' END  END  ie_forma_lanc,
	b.ie_tipo_pagamento,
	b.IE_TIPO_SERVICO
FROM titulo_pagar c, banco_escritural a, titulo_pagar_escrit b
LEFT OUTER JOIN banco d ON (b.cd_banco = d.cd_banco)
WHERE b.nr_titulo		= c.nr_titulo and (b.ie_tipo_pagamento in ('BLQ','PC') or
	exists (select	1
	from	darf_titulo_pagar x
	where	x.nr_titulo	= b.nr_titulo) or
	exists (select	1
	from	gps_titulo x
	where	x.nr_titulo	= b.nr_titulo)) and a.nr_sequencia		= b.nr_seq_escrit and a.nr_sequencia		= nr_seq_envio_p order by	1;

/* detalhe - BLQ */

nr_bloqueto_w		varchar(44);
nr_nosso_numero_w	varchar(20);
ie_tipo_servico_w	varchar(2);
ie_converte_bloq_w	varchar(1);
ie_tipo_identificacao_w	varchar(2);
qt_banco_w		bigint;
dt_apuracao_w		timestamp;
cd_darf_w		varchar(6);
nr_referencia_w		varchar(17);
cd_pagamento_w		varchar(6);
dt_referencia_w		varchar(6);
vl_inss_w		double precision;
vl_outras_entidades_w	double precision;
nr_versao_w		varchar(3);

c04 CURSOR FOR
SELECT	rpad(elimina_caractere_especial(substr(obter_nome_pf_pj(c.cd_pessoa_fisica,c.cd_cgc),1,30)),30,' '),
	coalesce(c.nr_titulo,0),
	b.vl_escritural,
	b.vl_acrescimo,
	b.vl_desconto,
	b.vl_despesa,
	c.dt_vencimento_atual,
	b.vl_juros,
	b.vl_multa,
	rpad(substr(CASE WHEN coalesce(ie_converte_bloq_w,'N')='S' THEN converte_codigo_bloqueto('Lido_Barra',c.nr_bloqueto)  ELSE c.nr_bloqueto END ,1,44),44,' '),
	rpad(substr(coalesce(c.nr_nosso_numero,' '),1,20),20,' '),
	CASE WHEN coalesce(c.cd_cgc::text, '') = '' THEN '01'  ELSE '02' END  ie_tipo_identificacao,
	lpad(coalesce(c.cd_cgc,d.nr_cpf),14,'0') nr_inscricao
FROM banco_escritural a, titulo_pagar c
LEFT OUTER JOIN pessoa_fisica d ON (c.cd_pessoa_fisica = d.cd_pessoa_fisica)
, titulo_pagar_escrit b
LEFT OUTER JOIN banco e ON (b.cd_banco = e.cd_banco)
WHERE b.nr_titulo		= c.nr_titulo and CASE WHEN(select	count(*)		from	gps_titulo x		where	x.nr_titulo	= b.nr_titulo)=0 THEN 		CASE WHEN(select	count(*)			from	darf_titulo_pagar x			where	x.nr_titulo	= b.nr_titulo)=0 THEN 			CASE WHEN 	b.ie_tipo_pagamento='PC' THEN '11'  ELSE CASE WHEN 	CASE WHEN coalesce(e.cd_banco_externo::text, '') = '' THEN b.cd_banco  ELSE somente_numero(e.cd_banco_externo) END =cd_banco_pagto_w THEN '30'  ELSE CASE WHEN(select	count(*)						from	banco x						where	CASE WHEN coalesce(x.cd_banco_externo::text, '') = '' THEN x.cd_banco  ELSE somente_numero(x.cd_banco_externo) END 	= somente_numero(substr(c.nr_bloqueto,1,3)))=0 THEN '11'  ELSE '31' END  END  END   ELSE CASE WHEN 	coalesce(c.nr_bloqueto::text, '') = '' THEN '16'  ELSE '11' END  END   ELSE CASE WHEN coalesce(c.nr_bloqueto::text, '') = '' THEN '17'  ELSE '11' END  END 	= ie_forma_lanc_w  and (b.ie_tipo_pagamento in ('BLQ','PC') or
	exists (select	1
	from	darf_titulo_pagar x
	where	x.nr_titulo	= b.nr_titulo) or
	exists (select	1
	from	gps_titulo x
	where	x.nr_titulo	= b.nr_titulo)) and a.nr_sequencia		= b.nr_seq_escrit and a.nr_sequencia		= nr_seq_envio_p;

/* trailer do arquivo */

qt_registro_w		bigint;


BEGIN

delete	from w_envio_banco
where	nm_usuario	= nm_usuario_p;

/* header de arquivo */

nr_seq_apres_w		:= coalesce(nr_seq_apres_w,0) + 1;

select	lpad(b.cd_cgc,14,'0'),
	rpad(substr(coalesce(c.cd_convenio_banco,' '),1,20),20,' '),
	lpad(substr(c.cd_agencia_bancaria,1,5) || substr(coalesce(d.ie_digito, '0'),1,1),6,'0'),
	lpad(somente_numero(replace(substr(c.cd_conta,1,12),'X','0')),12,'0'),
	rpad(elimina_caractere_especial(substr(obter_nome_estabelecimento(b.cd_estabelecimento),1,30)),30,' '),
	to_char(clock_timestamp(),'ddmmyyyyhh24miss'),
	coalesce(a.nr_remessa,a.nr_sequencia),
	b.cd_estabelecimento,
	a.dt_remessa_retorno,
	rpad(coalesce(substr(obter_dados_pf_pj(null,b.cd_cgc,'R'),1,30),' '),30,' '),
	lpad(coalesce(substr(obter_dados_pf_pj(null,b.cd_cgc,'NR'),1,5),'0'),5,'0'),
	rpad(coalesce(substr(obter_dados_pf_pj(null,b.cd_cgc,'CO'),1,15),' '),15,' '),
	rpad(coalesce(substr(obter_dados_pf_pj(null,b.cd_cgc,'CI'),1,20),' '),20,' '),
	lpad(coalesce(substr(obter_dados_pf_pj(null,b.cd_cgc,'CEP'),1,8),'0'),8,'0'),
	rpad(coalesce(substr(obter_dados_pf_pj(null,b.cd_cgc,'UF'),1,2),' '),2,' '),
	replace(coalesce(substr(c.ie_digito_conta,1,1),'0'),'X','0'),
	somente_numero(coalesce(e.cd_banco_externo,to_char(e.cd_banco))) cd_banco,
	substr(e.ds_banco,1,30) ds_banco
into STRICT	cd_cgc_estab_w,
	cd_convenio_banco_w,
	cd_agencia_estab_w,
	nr_conta_estab_w,
	nm_empresa_w,
	dt_geracao_w,
	nr_remessa_w,
	cd_estabelecimento_w,
	dt_remessa_retorno_w,
	ds_endereco_w,
	nr_endereco_w,
	ds_complemento_w,
	ds_municipio_w,
	nr_cep_w,
	sg_estado_w,
	ie_digito_estab_w,
	cd_banco_pagto_w,
	ds_banco_w
from	banco e,
	agencia_bancaria d,
	banco_estabelecimento c,
	estabelecimento b,
	banco_escritural a
where	c.cd_banco		= e.cd_banco
and	c.cd_banco		= d.cd_banco
and	c.cd_agencia_bancaria	= d.cd_agencia_bancaria
and	a.nr_seq_conta_banco	= c.nr_sequencia
and	a.cd_estabelecimento	= b.cd_estabelecimento
and	a.nr_sequencia		= nr_seq_envio_p;

ie_converte_bloq_w := obter_param_usuario(857, 36, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_converte_bloq_w);

ds_conteudo_w	:=	lpad(cd_banco_pagto_w,3,'0') || -- 1 ate 3
			'0000' || --4 ate 7
			'0' || -- 8
			rpad(' ',9,' ') || -- 9 ate 17
			'2' || -- 18
			cd_cgc_estab_w || -- 19 ate 32
			cd_convenio_banco_w || --33 ate 52
			cd_agencia_estab_w || -- 53 ate 58 (separar Digito)
			nr_conta_estab_w || -- 59 ate 70
			ie_digito_estab_w || --71
			' ' || --72
			nm_empresa_w || --73 ate 102
			rpad(upper(ds_banco_w),30,' ') || --103 ate 132 (nome do banco)
			rpad(' ',10,' ') || --133 ate 142
			'1' || --143 (1 para remessa)
			dt_geracao_w || --144 ate 157
			lpad(nr_remessa_w,6,'0') || --158 ate 163
			'089' || -- 164 ate 166
			'01600' || --Densidade do arquivo: 6250 BPI || 1600 BPI (Nota G020)
			rpad(' ',69,' ');

insert	into w_envio_banco(cd_estabelecimento,
	ds_conteudo,
	dt_atualizacao,
	nm_usuario,
	nr_seq_apres,
	nr_seq_apres_2,
	nr_sequencia)
values (cd_estabelecimento_w,
	ds_conteudo_w,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_apres_w,
	nr_seq_apres_w,
	nextval('w_envio_banco_seq'));

open	c01;
loop
fetch	c01 into
	ie_forma_lanc_w,
	ie_tipo_pagamento_w,
	ie_finalidade_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	/* header de lote */

	nr_lote_servico_w	:= coalesce(nr_lote_servico_w,0) + 1;
	nr_seq_apres_w		:= coalesce(nr_seq_apres_w,0) + 1;
	nr_sequencia_w		:= 0;
	vl_total_w		:= 0;

	if (ie_forma_lanc_w in ('01','03','30','41') ) then
		ie_forma_pagto_w := '01';
	else
		ie_forma_pagto_w := '  ';
	end if;

	ds_conteudo_w	:=	lpad(cd_banco_pagto_w,3,'0') ||  /*Pos 01 a 03*/
						lpad(nr_lote_servico_w,4,'0') || /*Pos 04 a 07*/
						'1' || /*Pos 08*/
						'C' || /*Pos 09*/
						'20' || /*Pos 10 a 11*/
						--'30' || /*Pos 10 a 11*/
						ie_forma_lanc_w || /*Pos  12 a 13*/
						'045' || /*Pos 14 a 16*/
						' ' || /*Pos 17*/
						'2' || /*Pos 18*/
						cd_cgc_estab_w || /*Pos 19 a 32*/
						cd_convenio_banco_w || /*Pos 33 a 52*/
						cd_agencia_estab_w || /*Pos 53 a 58*/
						nr_conta_estab_w || /*Pos 59 a 70*/
						ie_digito_estab_w || /*Pos 71*/
						' ' || /*Pos 72*/
						nm_empresa_w || /*Pos 73 a 102*/
						rpad(' ',40,' ') || /*Pos 103 a 142*/
						ds_endereco_w || /*Pos 143 a 172*/
						nr_endereco_w || /*Pos 173 a 177*/
						ds_complemento_w || /*Pos 178 a 192*/
						ds_municipio_w || /*Pos 193 a 212*/
						nr_cep_w || /*Pos  213 a 220*/
						substr(sg_estado_w,1,2) || /*Pos 221 a 222*/
						ie_forma_pagto_w || /*Pos 223 a 224*/
						rpad(' ',16,' '); /*Pos 225 a 240*/
	insert	into w_envio_banco(cd_estabelecimento,
		ds_conteudo,
		dt_atualizacao,
		nm_usuario,
		nr_seq_apres,
		nr_seq_apres_2,
		nr_sequencia)
	values (cd_estabelecimento_w,
		ds_conteudo_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_apres_w,
		nr_seq_apres_w,
		nextval('w_envio_banco_seq'));

	open	c02;
	loop
	fetch	c02 into
		cd_banco_w,
		cd_agencia_bancaria_w,
		cd_digito_agencia_w,
		nm_pessoa_w,
		nr_titulo_w,
		vl_escritural_w,
		vl_acrescimo_w,
		vl_desconto_w,
		vl_despesa_w,
		nr_inscricao_w,
		nr_conta_w,
		ie_digito_conta_w,
		dt_vencimento_w,
		vl_juros_w,
		vl_multa_w,
		ie_tipo_inscricao_w,
		ds_endereco_det_w,
		nr_endereco_det_w,
		ds_complemento_det_w,
		ds_municipio_det_w,
		nr_cep_det_w,
		sg_estado_det_w,
		ds_bairro_det_w,
		cd_camara_w,
		ie_tipo_pessoa_w,
		cd_pessoa_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

		select	count(*)
		into STRICT	qt_favorecido_w
		from	titulo_pagar_favorecido a
		where	a.nr_titulo	= nr_titulo_w;

		if (coalesce(qt_favorecido_w,0)	> 0) then

			select	somente_numero(substr(obter_conta_pessoa(coalesce(a.cd_cgc,a.cd_pessoa_fisica),CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN 'F'  ELSE 'J' END ,'B'),1,3)) cd_banco,
				lpad(substr(obter_conta_pessoa(coalesce(a.cd_cgc,a.cd_pessoa_fisica),CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN 'F'  ELSE 'J' END ,'A'),1,5),5,'0') cd_agencia_bancaria,
				substr(obter_conta_pessoa(coalesce(a.cd_cgc,a.cd_pessoa_fisica),CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN 'F'  ELSE 'J' END ,'DA'),1,1) cd_digito_agencia,
				replace(substr(obter_conta_pessoa(coalesce(a.cd_cgc,a.cd_pessoa_fisica),CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN 'F'  ELSE 'J' END ,'C'),1,255),'X','0') nr_conta,
				replace(coalesce(substr(obter_conta_pessoa(coalesce(a.cd_cgc,a.cd_pessoa_fisica),CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN 'F'  ELSE 'J' END ,'DC'),1,1),'0'),'X','0') ie_digito_conta
			into STRICT	cd_banco_w,
				cd_agencia_bancaria_w,
				cd_digito_agencia_w,
				nr_conta_w,
				ie_digito_conta_w
			from	titulo_pagar_favorecido a
			where	a.nr_titulo	= nr_titulo_w;

		end if;
		/*Obter tipo de conta para identificacao de  FInalidade TED*/

		ie_tipo_conta_w := ' ';
		if ie_tipo_pessoa_w = 'F' then
			select	max(ie_tipo_conta)
			into STRICT	ie_tipo_conta_w
			from	pessoa_fisica_conta a
			where	cd_pessoa_fisica	= cd_pessoa_w
			and	ie_situacao		= 'A';
		else
			select	max(ie_tipo_conta)
			into STRICT	ie_tipo_conta_w
			from	pessoa_juridica_conta a
			where	cd_cgc		= cd_pessoa_w
			and	ie_situacao	= 'A';
		end if;

		if cd_camara_w = '018' then -- TED
			ie_finalidade_c_w := '  ';
		else
			ie_finalidade_c_w := '07';
			ie_tipo_conta_w := ' ';
		end if;

		if ie_tipo_conta_w = 'CP' then --Conta Poupanca
			ie_tipo_conta_w := 'PP';
		end if;

		/* segmento A */

		nr_sequencia_w	:= coalesce(nr_sequencia_w,0) + 1;
		nr_seq_apres_w	:= coalesce(nr_seq_apres_w,0) + 1;
		qt_registro_w	:= coalesce(qt_registro_w,0) + 1;
		vl_total_w	:= coalesce(vl_total_w,0) + (coalesce(vl_escritural_w,0) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0));

		if (ie_forma_lanc_w = '03') then /*DOC*/
			cd_finalidade_doc_w := '07';
			cd_finalidade_ted_w := lpad(' ',5,' ');
			cd_finalidade_compl_w := 'CC';

		elsif (ie_forma_lanc_w = '41') then /*TED*/
			cd_finalidade_doc_w := lpad(' ',2,' ');
			cd_finalidade_ted_w	:= '00005';
			cd_finalidade_compl_w := 'CC';

		else

			cd_finalidade_doc_w := lpad(' ',2,' ');
			cd_finalidade_ted_w	:= lpad(' ',5,' ');
			cd_finalidade_compl_w := '  ';

		end if;

		ds_conteudo_w	:=	lpad(cd_banco_pagto_w,3,'0') || /*1 a 3*/
					lpad(nr_lote_servico_w,4,'0') || /*4 a 7*/
					'3' || /*8*/
					lpad(nr_sequencia_w,5,'0') || /*9 a 13*/
					'A' || /*14*/
					'000' || /*15 a 17*/
					cd_camara_w || /*18 a 20*/
					lpad(cd_banco_w,3,'0') || /*21 a 23*/
					lpad(coalesce(cd_agencia_bancaria_w,'0'),5,'0') || /*24 a 28*/
					coalesce(cd_digito_agencia_w,'0') || /*29*/
					lpad(substr(nr_conta_w,1,12),12,'0') || /*30 a 41*/
					ie_digito_conta_w || /*42*/
					' ' || /*43*/
					nm_pessoa_w || /*44 a 73*/
					rpad(nr_titulo_w,20,' ') || /*74 a 93*/
					to_char(dt_remessa_retorno_w,'ddmmyyyy') || /*94 a 101*/
					'BRL' || /*102 a 104*/
					'000000000000000' || /*105 a 119*/
					lpad(somente_numero(to_char(coalesce(vl_escritural_w,0) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0),'9999999999990.00')),15,'0') || /*120 a 134*/
					rpad(' ',20,' ') || /*135 a 154*/
					'00000000' || /*155 a 162*/
					'000000000000000' || /*163 a 177*/
					rpad(' ',40,' ') || /*178 a 217*/
					cd_finalidade_doc_w || -- 07 - Pagamento a Fornecedores 218 a 219
					cd_finalidade_ted_w || --Codigo de Finalidade da TED, disponivel no site do Banco Central do Brasil 220 a 224
					cd_finalidade_compl_w || --Compl. Finalidade de Pagamento 225 a 226
					rpad(' ',3,' ') || /*227 a 229*/
					'0' || /*230*/
					rpad(' ',10,' '); /*231 a 240*/
		insert	into w_envio_banco(cd_estabelecimento,
			ds_conteudo,
			dt_atualizacao,
			nm_usuario,
			nr_seq_apres,
			nr_seq_apres_2,
			nr_sequencia)
		values (cd_estabelecimento_w,
			ds_conteudo_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_apres_w,
			nr_seq_apres_w,
			nextval('w_envio_banco_seq'));

		/* segmento B */

		nr_sequencia_w	:= coalesce(nr_sequencia_w,0) + 1;
		nr_seq_apres_w	:= coalesce(nr_seq_apres_w,0) + 1;
		qt_registro_w	:= coalesce(qt_registro_w,0) + 1;

		ds_conteudo_w	:=	lpad(cd_banco_pagto_w,3,'0') ||
					lpad(nr_lote_servico_w,4,'0') ||
					'3' ||
					lpad(nr_sequencia_w,5,'0') ||
					'B' ||
					rpad(' ',3,' ') ||
					ie_tipo_inscricao_w ||
					nr_inscricao_w ||
					ds_endereco_det_w ||
					nr_endereco_det_w ||
					ds_complemento_det_w ||
					ds_bairro_det_w ||
					ds_municipio_det_w ||
					nr_cep_det_w ||
					substr(sg_estado_det_w,1,2) ||
					to_char(dt_vencimento_w,'ddmmyyyy') ||
					lpad(somente_numero(to_char(coalesce(vl_escritural_w,0),'9999999999990.00')),15,'0') ||
					'000000000000000' ||
					lpad(somente_numero(to_char(coalesce(vl_desconto_w,0),'9999999999990.00')),15,'0') ||
					lpad(somente_numero(to_char(coalesce(vl_juros_w,0),'9999999999990.00')),15,'0') ||
					lpad(somente_numero(to_char(coalesce(vl_multa_w,0),'9999999999990.00')),15,'0') ||
					rpad(' ',15,' ') ||
					'0' ||
					rpad(' ',14,' ');

		insert	into w_envio_banco(cd_estabelecimento,
			ds_conteudo,
			dt_atualizacao,
			nm_usuario,
			nr_seq_apres,
			nr_seq_apres_2,
			nr_sequencia)
		values (cd_estabelecimento_w,
			ds_conteudo_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_apres_w,
			nr_seq_apres_w,
			nextval('w_envio_banco_seq'));

	end	loop;
	close	c02;

	/* trailer de lote */

	nr_seq_apres_w	:= coalesce(nr_seq_apres_w,0) + 1;

	ds_conteudo_w	:=	lpad(cd_banco_pagto_w,3,'0') ||
				lpad(nr_lote_servico_w,4,'0') || --4 ate 7
				'5' || --Tipo de registro 5 - Trailer de Lote
				rpad(' ',9,' ') || --9 ate 17
				lpad(nr_sequencia_w + 2,6,'0') || --18 ate 23
				lpad(somente_numero(to_char(coalesce(vl_total_w,0),'9999999999999990.00')),18,'0') || --24 ate 41
				'000000000000000000' || --42 ate 59
				'000000' || --60 ate 65
				rpad(' ',175,' '); --66 ate 240
	insert	into w_envio_banco(cd_estabelecimento,
		ds_conteudo,
		dt_atualizacao,
		nm_usuario,
		nr_seq_apres,
		nr_seq_apres_2,
		nr_sequencia)
	values (cd_estabelecimento_w,
		ds_conteudo_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_apres_w,
		nr_seq_apres_w,
		nextval('w_envio_banco_seq'));

end	loop;
close	c01;

open	c03;
loop
fetch	c03 into
	ie_forma_lanc_w,
	ie_tipo_pagamento_w,
	IE_TIPO_SERVICO_PAGTO_W;
EXIT WHEN NOT FOUND; /* apply on c03 */

	/* header de lote - BLQ */

	nr_lote_servico_w	:= coalesce(nr_lote_servico_w,0) + 1;
	nr_seq_apres_w		:= coalesce(nr_seq_apres_w,0) + 1;
	nr_sequencia_w		:= 0;
	vl_total_w		:= 0;

	if (ie_forma_lanc_w	= '16') or (ie_forma_lanc_w	= '17') or (ie_forma_lanc_w	= '11') then

		ie_tipo_servico_w	:= '22'; /*Pagamento de Contas, Tributos e Impostos*/
		nr_versao_w		:= '012'; /*/*Versao para header de lote - Segmento O*/
	else

		if (cd_banco_pagto_w	= 237) then

			ie_tipo_servico_w	:= '20'; /*Pagamento Fornecedor*/
		else

			ie_tipo_servico_w	:= '03'; /*Bloqueto Eletronico*/
		end if;

		nr_versao_w	:= '089'; /*Versao para header de lote - Segmento J*/
	end if;
	
	if	((IE_TIPO_SERVICO_PAGTO_W = 00094) or (IE_TIPO_SERVICO_PAGTO_W = 00095) or (IE_TIPO_SERVICO_PAGTO_W = 00100) or (IE_TIPO_SERVICO_PAGTO_W = 00105) or (IE_TIPO_SERVICO_PAGTO_W = 00110) or (IE_TIPO_SERVICO_PAGTO_W = 00115) or (IE_TIPO_SERVICO_PAGTO_W = 00120) or (IE_TIPO_SERVICO_PAGTO_W = 00125) or (IE_TIPO_SERVICO_PAGTO_W = 00130) or (IE_TIPO_SERVICO_PAGTO_W = 00098)) then
		
		ie_tipo_servico_w := '98';
		
	elsif (IE_TIPO_SERVICO_PAGTO_W = 00010 ) then
		ie_tipo_servico_w := '10';
	elsif (IE_TIPO_SERVICO_PAGTO_W = 00020 ) then
		ie_tipo_servico_w := '20';
	elsif (IE_TIPO_SERVICO_PAGTO_W = 00030 ) then
		ie_tipo_servico_w := '30';
	elsif (IE_TIPO_SERVICO_PAGTO_W = 00022 ) then
		ie_tipo_servico_w := '22';
	elsif (IE_TIPO_SERVICO_PAGTO_W = 00050 ) then
		ie_tipo_servico_w := '50';
	elsif (IE_TIPO_SERVICO_PAGTO_W = 00060 ) then
		ie_tipo_servico_w := '60';
	elsif (IE_TIPO_SERVICO_PAGTO_W = 00070 ) then
		ie_tipo_servico_w := '70';	
	elsif (IE_TIPO_SERVICO_PAGTO_W = 00075 ) then
		ie_tipo_servico_w := '75';
	elsif (IE_TIPO_SERVICO_PAGTO_W = 00080 ) then
		ie_tipo_servico_w := '80';
	elsif (IE_TIPO_SERVICO_PAGTO_W = 00090 ) then
		ie_tipo_servico_w := '90';		
	end if;


	ds_conteudo_w	:=	lpad(cd_banco_pagto_w,3,'0') ||
				lpad(nr_lote_servico_w,4,'0') ||
				'1' ||
				'C' ||
				ie_tipo_servico_w ||
				ie_forma_lanc_w ||
				nr_versao_w || /*040 para Segmento J e 012 para Segmento O*/
				' ' ||
				'2' || --18
				cd_cgc_estab_w ||
				cd_convenio_banco_w ||
				cd_agencia_estab_w ||
				nr_conta_estab_w ||
				ie_digito_estab_w ||
				' ' ||
				nm_empresa_w || --72 ate 102
				rpad(' ',40,' ') || --103 ate 142
				ds_endereco_w ||
				nr_endereco_w ||
				ds_complemento_w ||
				ds_municipio_w ||
				nr_cep_w ||
				substr(sg_estado_w,1,2) ||
				'01' || --223 a 224
				rpad(' ',16,' ');

	insert	into w_envio_banco(cd_estabelecimento,
		ds_conteudo,
		dt_atualizacao,
		nm_usuario,
		nr_seq_apres,
		nr_seq_apres_2,
		nr_sequencia)
	values (cd_estabelecimento_w,
		ds_conteudo_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_apres_w,
		nr_seq_apres_w,
		nextval('w_envio_banco_seq'));

	open	c04;
	loop
	fetch	c04 into
		nm_pessoa_w,
		nr_titulo_w,
		vl_escritural_w,
		vl_acrescimo_w,
		vl_desconto_w,
		vl_despesa_w,
		dt_vencimento_w,
		vl_juros_w,
		vl_multa_w,
		nr_bloqueto_w,
		nr_nosso_numero_w,
		ie_tipo_identificacao_w,
		nr_inscricao_w;
	EXIT WHEN NOT FOUND; /* apply on c04 */

		nr_sequencia_w	:= coalesce(nr_sequencia_w,0) + 1;
		nr_seq_apres_w	:= coalesce(nr_seq_apres_w,0) + 1;
		qt_registro_w	:= coalesce(qt_registro_w,0) + 1;
		vl_total_w	:= coalesce(vl_total_w,0) + (coalesce(vl_escritural_w,0) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0));

		select	count(*)
		into STRICT	qt_banco_w
		from	banco a
		where	CASE WHEN coalesce(a.cd_banco_externo::text, '') = '' THEN a.cd_banco  ELSE somente_numero(a.cd_banco_externo) END 	= somente_numero(substr(nr_bloqueto_w,1,3));

		/* segmento N - DARF normal */

		if (ie_forma_lanc_w	= '16') then

			select	max(b.dt_apuracao) dt_apuracao,
				lpad(substr(coalesce(max(b.cd_darf),'0'),1,6),6,'0') cd_darf,
				lpad(substr(coalesce(max(b.nr_referencia),'0'),1,17),17,'0') nr_referencia
			into STRICT	dt_apuracao_w,
				cd_darf_w,
				nr_referencia_w
			from	darf b,
				darf_titulo_pagar a
			where	a.nr_seq_darf	= b.nr_sequencia
			and	a.nr_titulo	= nr_titulo_w;

			ds_conteudo_w	:=	lpad(cd_banco_pagto_w,3,'0') ||
						lpad(nr_lote_servico_w,4,'0') ||
						'3' ||
						lpad(nr_sequencia_w,5,'0') ||
						'N' ||
						'0' ||
						'00' ||
						rpad(nr_titulo_w,20,' ') ||
						rpad(' ',20,' ') ||
						nm_empresa_w ||
						to_char(dt_remessa_retorno_w,'ddmmyyyy') ||
						lpad(somente_numero(to_char(coalesce(vl_escritural_w,0) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0),'9999999999990.00')),15,'0') ||
						cd_darf_w ||
						'01' ||
						cd_cgc_estab_w ||
						'16' ||
						to_char(dt_apuracao_w,'ddmmyyyy') ||
						nr_referencia_w ||
						lpad(somente_numero(to_char(coalesce(vl_escritural_w,0),'9999999999990.00')),15,'0') ||
						lpad(somente_numero(to_char(coalesce(vl_multa_w,0),'9999999999990.00')),15,'0') ||
						lpad(somente_numero(to_char(coalesce(vl_juros_w,0),'9999999999990.00')),15,'0') ||
						to_char(dt_vencimento_w,'ddmmyyyy') ||
						rpad(' ',18,' ') ||
						rpad(' ',10,' ');

		/* segmento N - GPS */

		elsif (ie_forma_lanc_w	= '17') then

			select	to_char(max(b.dt_referencia),'mmyyyy') dt_referencia,
				lpad(substr(coalesce(max(b.cd_pagamento),'0'),1,6),6,'0') cd_pagamento,
				max(b.vl_inss) vl_inss,
				max(b.vl_outras_entidades) vl_outras_entidades
			into STRICT	dt_referencia_w,
				cd_pagamento_w,
				vl_inss_w,
				vl_outras_entidades_w
			from	gps b,
				gps_titulo a
			where	a.nr_seq_gps	= b.nr_sequencia
			and	a.nr_titulo	= nr_titulo_w;

			ds_conteudo_w	:=	lpad(cd_banco_pagto_w,3,'0') ||
						lpad(nr_lote_servico_w,4,'0') ||
						'3' ||
						lpad(nr_sequencia_w,5,'0') ||
						'N' ||
						'0' ||
						'00' ||
						rpad(nr_titulo_w,20,' ') ||
						rpad(' ',20,' ') ||
						nm_empresa_w ||
						to_char(dt_remessa_retorno_w,'ddmmyyyy') ||
						lpad(somente_numero(to_char(coalesce(vl_escritural_w,0) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0),'9999999999990.00')),15,'0') ||
						cd_pagamento_w ||
						'01' ||
						cd_cgc_estab_w ||
						'17' ||
						dt_referencia_w ||
						lpad(somente_numero(to_char(coalesce(vl_inss_w,0),'9999999999990.00')),15,'0') ||
						lpad(somente_numero(to_char(coalesce(vl_outras_entidades_w,0),'9999999999990.00')),15,'0') ||
						lpad('0',15,'0') ||
						rpad(' ',45,' ') ||
						rpad(' ',10,' ');

		/* segmento O */

		elsif (ie_forma_lanc_w	= '11') or (qt_banco_w		= 0) then

			ds_conteudo_w	:=	lpad(cd_banco_pagto_w,3,'0') ||
						lpad(nr_lote_servico_w,4,'0') ||
						'3' ||
						lpad(nr_sequencia_w,5,'0') ||
						'O' ||
						'0' ||
						'00' ||
						nr_bloqueto_w || --18 ate 61
						nm_pessoa_w ||
						to_char(dt_vencimento_w,'ddmmyyyy') ||
						to_char(dt_remessa_retorno_w,'ddmmyyyy') ||
						lpad(somente_numero(to_char(coalesce(vl_escritural_w,0) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0),'9999999999990.00')),15,'0') ||
						rpad(nr_titulo_w,20,' ') ||
						rpad(' ',20,' ') || --143 ate 162
						rpad(' ',78,' ');

		/* segmento J */

		else

			ds_conteudo_w	:=	lpad(cd_banco_pagto_w,3,'0') || --1 ate 3
						lpad(nr_lote_servico_w,4,'0') || --4 ate 7
						'3' || --8
						lpad(nr_sequencia_w,5,'0') || --9 ate 13
						'J' || --14
						'0' || --15
						'00' || --16 ate 17
						nr_bloqueto_w || --18 ate 61
						nm_pessoa_w || --62 ate 91
						to_char(dt_vencimento_w,'ddmmyyyy') || --92 ate 99
						lpad(somente_numero(to_char(coalesce(vl_escritural_w,0),'9999999999990.00')),15,'0') ||
						lpad(somente_numero(to_char(coalesce(vl_desconto_w,0),'9999999999990.00')),15,'0') ||
						lpad(somente_numero(to_char(coalesce(vl_multa_w,0) + coalesce(vl_juros_w,0),'9999999999990.00')),15,'0') ||
						to_char(dt_remessa_retorno_w,'ddmmyyyy') || -- 145 ate 152
						lpad(somente_numero(to_char(coalesce(vl_escritural_w,0) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0),'9999999999990.00')),15,'0') ||
						'000000000000000' || --168 ate 182
						rpad(nr_titulo_w,20,' ') || --183 ate 202
						rpad(nr_nosso_numero_w,20,' ') ||
						'09' ||
						rpad(' ',16,' ');

			insert	into w_envio_banco(cd_estabelecimento,
				ds_conteudo,
				dt_atualizacao,
				nm_usuario,
				nr_seq_apres,
				nr_seq_apres_2,
				nr_sequencia)
			values (cd_estabelecimento_w,
				ds_conteudo_w,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_apres_w,
				nr_seq_apres_w,
				nextval('w_envio_banco_seq'));

			nr_sequencia_w	:= coalesce(nr_sequencia_w,0) + 1;
			nr_seq_apres_w	:= coalesce(nr_seq_apres_w,0) + 1;
			qt_registro_w	:= coalesce(qt_registro_w,0) + 1;

			ds_conteudo_w	:=	lpad(cd_banco_pagto_w,3,'0') ||		--1/3
						lpad(nr_lote_servico_w,4,'0') ||	--4/7
						'3' ||					--8/8
						lpad(nr_sequencia_w,5,'0') ||		--9/13
						'J' ||					--14/14
						' ' ||					--15/15
						'01' ||					--16/17
						'52' ||					--18/19
						'2' ||					--20/20
						lpad(cd_cgc_estab_w,15,'0') ||		--21/35
						rpad(nm_empresa_w,40,' ') ||		--36/75
						substr(ie_tipo_identificacao_w,2,1) ||	--76/76
						lpad(nr_inscricao_w,15,'0') ||		--77/91
						rpad(nm_pessoa_w,40,' ') ||		--92/131
						'2' ||					--132/132
						lpad(cd_cgc_estab_w,15,'0') ||			--133/147
						rpad(nm_empresa_w,40,' ') ||			--148/187
						rpad(' ',52,' ');			--188/240
		end if;

		insert	into w_envio_banco(cd_estabelecimento,
			ds_conteudo,
			dt_atualizacao,
			nm_usuario,
			nr_seq_apres,
			nr_seq_apres_2,
			nr_sequencia)
		values (cd_estabelecimento_w,
			ds_conteudo_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_apres_w,
			nr_seq_apres_w,
			nextval('w_envio_banco_seq'));

	end	loop;
	close	c04;

	/* trailer de lote */

	nr_seq_apres_w	:= coalesce(nr_seq_apres_w,0) + 1;

	ds_conteudo_w	:=	lpad(cd_banco_pagto_w,3,'0') ||
				lpad(nr_lote_servico_w,4,'0') ||
				'5' ||
				rpad(' ',9,' ') ||
				lpad(nr_sequencia_w + 2,6,'0') ||
				lpad(somente_numero(to_char(coalesce(vl_total_w,0),'9999999999999990.00')),18,'0') ||
				'000000000000000000' ||
				'000000' ||
				rpad(' ',175,' ');

	insert	into w_envio_banco(cd_estabelecimento,
		ds_conteudo,
		dt_atualizacao,
		nm_usuario,
		nr_seq_apres,
		nr_seq_apres_2,
		nr_sequencia)
	values (cd_estabelecimento_w,
		ds_conteudo_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_apres_w,
		nr_seq_apres_w,
		nextval('w_envio_banco_seq'));

end	loop;
close	c03;

/* trailer de arquivo */

nr_seq_apres_w	:= coalesce(nr_seq_apres_w,0) + 1;

ds_conteudo_w	:=	lpad(cd_banco_pagto_w,3,'0') ||
			'9999' ||
			'9' ||
			rpad(' ',9,' ') ||
			lpad(nr_lote_servico_w,6,'0') ||
			lpad(coalesce(qt_registro_w,0) + (coalesce(nr_lote_servico_w,0) * 2) + 2,6,'0') ||	/* registros detalhe + header e trailer dos lotes + header e trailer do arquivo */
			'000000' ||
			rpad(' ',205,' ');

insert	into w_envio_banco(cd_estabelecimento,
	ds_conteudo,
	dt_atualizacao,
	nm_usuario,
	nr_seq_apres,
	nr_seq_apres_2,
	nr_sequencia)
values (cd_estabelecimento_w,
	ds_conteudo_w,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_apres_w,
	nr_seq_apres_w,
	nextval('w_envio_banco_seq'));

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_pagto_banrisul_240_v89 ( nr_seq_envio_p bigint, nm_usuario_p text) FROM PUBLIC;

