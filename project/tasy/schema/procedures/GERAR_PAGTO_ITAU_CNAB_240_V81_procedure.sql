-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_pagto_itau_cnab_240_v81 ( nr_seq_envio_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* PADRAO CNAB 240 VERSAO 080 DE 07/2010 */

ds_conteudo_w		varchar(250);
cd_estabelecimento_w	smallint;
nr_seq_apres_w		bigint	:= 0;

/* header de arquivo */

cd_agencia_estab_w	varchar(5);
cd_cgc_estab_w		varchar(14);
cd_convenio_banco_w	varchar(20);
dt_geracao_w		varchar(14);
nm_empresa_w		varchar(30);
nr_conta_estab_w	varchar(12);
ie_digito_estab_w	banco_estabelecimento.IE_DIGITO_CONTA%type;

/* header de lote - DOC */

nr_lote_servico_w	bigint;
ie_forma_lanc_w		varchar(2);
ie_tipo_pagamento_w	varchar(3);
ie_finalidade_w		varchar(2);
ds_endereco_w		varchar(30);
nr_endereco_w		varchar(5);
ds_complemento_w	varchar(15);
ds_municipio_w		varchar(20);
nr_cep_w		varchar(8);
sg_estado_w		varchar(15);
ie_converte_bloq_w	varchar(1);
ie_tipo_pagto_w		varchar(2);
nr_versao_w		varchar(3);
ie_forma_lanc_blq_w 	varchar(2);
ie_data_pagamento_w	banco_estabelecimento.ie_data_pagamento%type;
dt_pagamento_w		timestamp;
dt_apuracao_w        timestamp;
cd_darf_w        varchar(4);
nr_referencia_w        varchar(17);
cd_pagamento_w        varchar(6);
dt_referencia_w        varchar(6);
vl_inss_w        double precision;
vl_outras_entidades_w    double precision;
cd_banco_cobr_w        smallint;
ie_trailler_tributo_w    varchar(1) := 'N';
vl_total_outras_entid_w        double precision := 0;
vl_total_acrescimos_w        double precision := 0;

c01 CURSOR FOR
SELECT	distinct
	CASE WHEN b.ie_tipo_pagamento='CC' THEN '01' WHEN b.ie_tipo_pagamento='DOC' THEN '03' WHEN b.ie_tipo_pagamento='TED' THEN '41' WHEN b.ie_tipo_pagamento='OP' THEN '30' WHEN b.ie_tipo_pagamento='BLQ' THEN CASE WHEN b.cd_banco=341 THEN '30'  ELSE '31' END  WHEN b.ie_tipo_pagamento='CCP' THEN '01'  ELSE '03' END ,
	b.ie_tipo_pagamento,
	CASE WHEN b.ie_tipo_pagamento='CC' THEN '01' WHEN b.ie_tipo_pagamento='CCP' THEN '01'  ELSE '99' END ,
	'20' ie_tipo_pagto
from	titulo_pagar_escrit b,
	banco_escritural a
where	b.ie_tipo_pagamento	in ('DOC','CC','OP','TED','CCP')
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
ie_digito_agencia_w	varchar(2);
cd_agencia_w		varchar(8);
nr_nosso_numero_w	varchar(15);
ie_digito_conta_w	varchar(2);

c02 CURSOR FOR
SELECT	b.cd_banco,
	lpad(substr(b.cd_agencia_bancaria,1,5) || substr(b.ie_digito_agencia,1,1),6,'0'),
	rpad(substr(obter_nome_pf_pj(c.cd_pessoa_fisica,c.cd_cgc),1,30),30,' '),
	c.nr_titulo,
	b.vl_escritural,
	b.vl_acrescimo,
	b.vl_desconto,
	b.vl_despesa,
	lpad(coalesce(d.nr_cpf,c.cd_cgc),14,'0'),
	b.nr_conta,
	lpad(coalesce(substr(b.ie_digito_agencia,1,2),' '),2,' '),
	b.cd_agencia_bancaria,
	rpad(substr(c.nr_nosso_numero,1,15),15,' ') nr_nosso_numero,
	c.dt_vencimento_atual,
	lpad(coalesce(substr(b.ie_digito_conta,1,2),' '),2,' '),
	c.nr_bloqueto,
	b.vl_juros,
	b.vl_multa
FROM titulo_pagar_escrit b, banco_escritural a, titulo_pagar c
LEFT OUTER JOIN pessoa_fisica d ON (c.cd_pessoa_fisica = d.cd_pessoa_fisica)
WHERE CASE WHEN b.ie_tipo_pagamento='PC' THEN CASE WHEN(select count(*) from darf_titulo_pagar x where x.nr_titulo = b.nr_titulo)=0 THEN '20'  ELSE '22' END   ELSE '20' END  = ie_tipo_pagto_w  and b.nr_titulo		= c.nr_titulo and b.ie_tipo_pagamento	= ie_tipo_pagamento_w and a.nr_sequencia		= b.nr_seq_escrit and a.nr_sequencia		= nr_seq_envio_p;

/* trailer lote - DOC */

vl_total_w		double precision;

/* header de lote - BLQ */

ie_tipo_bloqueto_w	varchar(1);
ie_tipo_titulo_w	varchar(2);

c03 CURSOR FOR
SELECT	distinct
    CASE WHEN(select    count(*)        from    gps_titulo x        where    x.nr_titulo    = b.nr_titulo)=0 THEN         CASE WHEN(select    count(*)            from    darf_titulo_pagar x            where    x.nr_titulo    = b.nr_titulo)=0 THEN             CASE WHEN     b.ie_tipo_pagamento='PC' THEN '13'  ELSE CASE WHEN     CASE WHEN coalesce(d.cd_banco_externo::text, '') = '' THEN b.cd_banco  ELSE somente_numero(d.cd_banco_externo) END =cd_banco_cobr_w THEN '30'  ELSE CASE WHEN(select	count(*)			from	banco x                        where    CASE WHEN coalesce(x.cd_banco_externo::text, '') = '' THEN x.cd_banco  ELSE somente_numero(x.cd_banco_externo) END     = somente_numero(substr(c.nr_bloqueto,1,3)))=0 THEN '13'  ELSE '31' END  END  END   ELSE CASE WHEN     coalesce(c.nr_bloqueto::text, '') = '' THEN '16'  ELSE '13' END  END   ELSE CASE WHEN coalesce(c.nr_bloqueto::text, '') = '' THEN '17'  ELSE '13' END  END ,
	b.ie_tipo_pagamento,
	CASE WHEN(select	count(*)		from	banco x		where	x.cd_banco	= somente_numero(substr(c.nr_bloqueto,1,3)))=0 THEN     'I'  ELSE 'B' END  ie_tipo_bloqueto,
	'20'
FROM titulo_pagar c, banco_escritural a, titulo_pagar_escrit b
LEFT OUTER JOIN banco d ON (b.cd_banco = d.cd_banco)
WHERE b.nr_titulo        = c.nr_titulo and (b.ie_tipo_pagamento in ('BLQ','PC','DDA') or
    exists (select    1
    from    darf_titulo_pagar x
    where    x.nr_titulo    = b.nr_titulo) or
    exists (select    1
    from    gps_titulo x
    where    x.nr_titulo    = b.nr_titulo)) and a.nr_sequencia		= b.nr_seq_escrit and a.nr_sequencia        = nr_seq_envio_p order by    1;


/* detalhe - BLQ */

nr_bloqueto_w		varchar(48);
ie_tipo_identificacao_w    varchar(1);

c04 CURSOR FOR
SELECT	rpad(substr(obter_nome_pf_pj(c.cd_pessoa_fisica,c.cd_cgc),1,30),30,' '),
	c.nr_titulo,
	b.vl_escritural,
	b.vl_acrescimo,
	b.vl_desconto,
	b.vl_despesa,
	c.dt_vencimento_atual,
	b.vl_juros,
	b.vl_multa,
	substr(CASE WHEN ie_tipo_bloqueto_w='I' THEN c.nr_bloqueto  ELSE CASE WHEN coalesce(ie_converte_bloq_w,'N')='S' THEN converte_codigo_bloqueto('Lido_Barra',c.nr_bloqueto)  ELSE c.nr_bloqueto END  END ,1,48) nr_bloqueto,
	lpad(coalesce(d.nr_cpf,c.cd_cgc),14,'0'),
    CASE WHEN coalesce(c.cd_cgc::text, '') = '' THEN '1'  ELSE '2' END  ie_tipo_identificacao
FROM banco_escritural a, titulo_pagar c
LEFT OUTER JOIN pessoa_fisica d ON (c.cd_pessoa_fisica = d.cd_pessoa_fisica)
, titulo_pagar_escrit b
LEFT OUTER JOIN banco e ON (b.cd_banco = e.cd_banco)
WHERE b.nr_titulo        = c.nr_titulo and CASE WHEN(select    count(*)        from    gps_titulo x        where    x.nr_titulo    = b.nr_titulo)=0 THEN 	CASE WHEN(select	count(*)            from    darf_titulo_pagar x            where    x.nr_titulo    = b.nr_titulo)=0 THEN             CASE WHEN     b.ie_tipo_pagamento='PC' THEN '13'  ELSE CASE WHEN     CASE WHEN coalesce(e.cd_banco_externo::text, '') = '' THEN b.cd_banco  ELSE somente_numero(e.cd_banco_externo) END =cd_banco_cobr_w THEN '30'  ELSE CASE WHEN(select	count(*)			from	banco x                        where    CASE WHEN coalesce(x.cd_banco_externo::text, '') = '' THEN x.cd_banco  ELSE somente_numero(x.cd_banco_externo) END     = somente_numero(substr(c.nr_bloqueto,1,3)))=0 THEN '13'  ELSE '31' END  END  END   ELSE CASE WHEN     coalesce(c.nr_bloqueto::text, '') = '' THEN '16'  ELSE '13' END  END   ELSE CASE WHEN coalesce(c.nr_bloqueto::text, '') = '' THEN '17'  ELSE '13' END  END     = ie_forma_lanc_w  and (b.ie_tipo_pagamento in ('BLQ','PC','DDA') or
    exists (select    1
    from    darf_titulo_pagar x
    where    x.nr_titulo    = b.nr_titulo) or
    exists (select    1
    from    gps_titulo x
    where    x.nr_titulo    = b.nr_titulo)) and a.nr_sequencia		= b.nr_seq_escrit and a.nr_sequencia		= nr_seq_envio_p;

/* trailer do arquivo */

qt_registro_w		bigint;


BEGIN

delete	from w_envio_banco
where	nm_usuario	= nm_usuario_p;

/* header de arquivo */

nr_seq_apres_w		:= coalesce(nr_seq_apres_w,0) + 1;

select	lpad(b.cd_cgc,14,'0'),
	rpad(substr(c.cd_convenio_banco,1,20),20,' '),
	lpad(substr(c.cd_agencia_bancaria,1,5),5,'0'),
	lpad(somente_numero(substr(c.cd_conta,1,12)),12,'0'),
	rpad(substr(obter_nome_estabelecimento(b.cd_estabelecimento),1,30),30,' '),
	to_char(clock_timestamp(),'ddmmyyyyhh24miss'),
	b.cd_estabelecimento,
	a.dt_remessa_retorno,
	rpad(substr(obter_dados_pf_pj(null,b.cd_cgc,'R'),1,30),30,' '),
	lpad(substr(obter_dados_pf_pj(null,b.cd_cgc,'NR'),1,5),5,'0'),
	rpad(coalesce(substr(obter_dados_pf_pj(null,b.cd_cgc,'CO'),1,15),' '),15,' '),
	rpad(substr(obter_dados_pf_pj(null,b.cd_cgc,'CI'),1,20),20,' '),
	lpad(substr(obter_dados_pf_pj(null,b.cd_cgc,'CEP'),1,8),8,'0'),
	rpad(substr(obter_dados_pf_pj(null,b.cd_cgc,'UF'),1,2),2,' '),
	coalesce(substr(c.ie_digito_conta,1,1),'0'),
    coalesce(c.ie_data_pagamento,'R'),
	c.cd_banco
into STRICT	cd_cgc_estab_w,
	cd_convenio_banco_w,
	cd_agencia_estab_w,
	nr_conta_estab_w,
	nm_empresa_w,
	dt_geracao_w,
	cd_estabelecimento_w,
	dt_remessa_retorno_w,
	ds_endereco_w,
	nr_endereco_w,
	ds_complemento_w,
	ds_municipio_w,
	nr_cep_w,
	sg_estado_w,
	ie_digito_estab_w,
    ie_data_pagamento_w,
	cd_banco_cobr_w
from	banco_estabelecimento c,
	estabelecimento b,
	banco_escritural a
where	a.nr_seq_conta_banco	= c.nr_sequencia
and	a.cd_estabelecimento	= b.cd_estabelecimento
and	a.nr_sequencia		= nr_seq_envio_p;

ie_converte_bloq_w := obter_param_usuario(857, 36, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_converte_bloq_w);

ds_conteudo_w	:=	'341' ||
			'0000' ||
			'0' ||
			rpad(' ',6,' ') ||
			'081' ||
			'2' ||
			cd_cgc_estab_w ||
			rpad(' ',20,' ') ||
			cd_agencia_estab_w ||
			' ' ||
			nr_conta_estab_w ||
			' ' ||
			ie_digito_estab_w ||
			nm_empresa_w ||
      rpad('BANCO ITAU',30,' ') ||
			rpad(' ',10,' ') ||
			'1' ||
			dt_geracao_w ||
			'000000000' ||
			'00000' ||
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
	ie_finalidade_w,
	ie_tipo_pagto_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	/* header de lote */

	nr_lote_servico_w	:= coalesce(nr_lote_servico_w,0) + 1;
	nr_seq_apres_w		:= coalesce(nr_seq_apres_w,0) + 1;
	nr_sequencia_w		:= 0;
	vl_total_w		:= 0;

	if (ie_tipo_pagamento_w	= 'PC') then
		nr_versao_w	:= '030';
	else
		nr_versao_w	:= '040';
	end if;

	ds_conteudo_w	:=	'341' ||
				lpad(nr_lote_servico_w,4,'0') ||
				'1' ||
				'C' ||
				ie_tipo_pagto_w ||
				ie_forma_lanc_w ||
				nr_versao_w ||
				' ' ||
				'2' ||
				cd_cgc_estab_w ||
				rpad(' ',20,' ') ||
				cd_agencia_estab_w ||
				' ' ||
				nr_conta_estab_w ||
				' ' ||
				ie_digito_estab_w ||
				nm_empresa_w ||
				rpad(' ',40,' ') ||
				ds_endereco_w ||
				nr_endereco_w ||
				ds_complemento_w ||
				ds_municipio_w ||
				nr_cep_w ||
				substr(sg_estado_w,1,2) ||
				rpad(' ',18,' ');

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
		nm_pessoa_w,
		nr_titulo_w,
		vl_escritural_w,
		vl_acrescimo_w,
		vl_desconto_w,
		vl_despesa_w,
		nr_inscricao_w,
		nr_conta_w,
		ie_digito_agencia_w,
		cd_agencia_w,
		nr_nosso_numero_w,
		dt_vencimento_w,
		ie_digito_conta_w,
		nr_bloqueto_w,
		vl_juros_w,
		vl_multa_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

		/* segmento A */

		nr_sequencia_w	:= coalesce(nr_sequencia_w,0) + 1;
		nr_seq_apres_w	:= coalesce(nr_seq_apres_w,0) + 1;
		qt_registro_w	:= coalesce(qt_registro_w,0) + 1;
		vl_total_w	:= coalesce(vl_total_w,0) + (coalesce(vl_escritural_w,0) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0));

		if (coalesce(ie_data_pagamento_w,'R')	= 'R') then
			dt_vencimento_w	:= dt_remessa_retorno_w;
		end if;

		if (dt_vencimento_w	< clock_timestamp()) then
			dt_vencimento_w	:= clock_timestamp();
		end if;

		if (ie_tipo_pagamento_w	= 'PC') then

			ds_conteudo_w	:=	'341' ||
						lpad(nr_lote_servico_w,4,'0') ||
						'3' ||
						lpad(nr_sequencia_w,5,'0') ||
						'O' ||
						'000' ||
						rpad(coalesce(nr_bloqueto_w,' '),48,' ') ||
						nm_pessoa_w ||
						to_char(dt_vencimento_w,'ddmmyyyy') ||
						'REA' ||
						'000000000000000' ||
						lpad(somente_numero(to_char(coalesce(vl_escritural_w,0),'9999999999990.00')),15,'0') ||
						to_char(dt_vencimento_w,'ddmmyyyy') ||
						lpad(somente_numero(to_char(coalesce(vl_escritural_w,0) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0),'9999999999990.00')),15,'0') ||
						rpad(' ',3,' ') ||
						'000000000' ||
						rpad(' ',3,' ') ||
						rpad(nr_titulo_w,20,' ') ||
						rpad(' ',21,' ') ||
						nr_nosso_numero_w ||
						rpad(' ',10,' ');

        elsif (ie_forma_lanc_w not in ('16','17')) then

			if (cd_banco_w in (341,409)) then

				cd_agencia_conta_w	:=	'0' ||
								lpad(substr(cd_agencia_w,1,4),4,'0') ||
								' ' ||
								'000000' ||
								lpad(substr(nr_conta_w,1,6),6,'0') ||
								ie_digito_conta_w;

			else

				cd_agencia_conta_w	:=	lpad(substr(cd_agencia_w,1,5),5,'0') ||
								' ' ||
								lpad(substr(nr_conta_w,1,12),12,'0') ||
								ie_digito_conta_w;

			end if;


			ds_conteudo_w	:=	'341' ||
						lpad(nr_lote_servico_w,4,'0') ||
						'3' ||
						lpad(nr_sequencia_w,5,'0') ||
						'A' ||
						'000' ||
						'000' ||
						lpad(cd_banco_w,3,'0') ||
						cd_agencia_conta_w ||
						nm_pessoa_w ||
						rpad(nr_titulo_w,20,' ') ||
						to_char(dt_vencimento_w,'ddmmyyyy') ||
						'REA' ||
						'000000000000000' ||
						lpad(somente_numero(to_char(coalesce(vl_escritural_w,0) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0),'9999999999990.00')),15,'0') ||
						rpad(' ',20,' ') ||
						'00000000' || /* to_char(dt_remessa_retorno_w,'ddmmyyyy') || */
						'000000000000000' || /* lpad(somente_numero(to_char(coalesce(vl_escritural_w,0) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0),'9999999999990.00')),15,'0') || */
						rpad(' ',20,' ') ||
						'000000' ||
						nr_inscricao_w ||
						rpad(' ',23,' ');

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
	close	c02;

	/* trailer de lote */

	nr_seq_apres_w	:= coalesce(nr_seq_apres_w,0) + 1;

	ds_conteudo_w	:=	'341' ||
				lpad(nr_lote_servico_w,4,'0') ||
				'5' ||
				rpad(' ',9,' ') ||
				lpad(nr_sequencia_w + 2,6,'0') ||
				lpad(somente_numero(to_char(coalesce(vl_total_w,0),'9999999999999990.00')),18,'0') ||
				'000000000000000000' ||
				rpad(' ',181,' ');

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
	ie_tipo_bloqueto_w,
	ie_tipo_pagto_w;
EXIT WHEN NOT FOUND; /* apply on c03 */

	ie_forma_lanc_blq_w := ie_forma_lanc_w;

    /*if    (ie_tipo_bloqueto_w    = 'I') and
		(ie_tipo_pagamento_w	<> 'PC') then
		if	(ie_tipo_titulo_w	= '16') then
			ie_forma_lanc_blq_w	:= '35';
		elsif	(ie_forma_lanc_blq_w	<> '91') then
			ie_forma_lanc_blq_w	:= '19';
		end if;
    end if;*/
	if (ie_tipo_bloqueto_w	= 'I')
	and (ie_tipo_pagamento_w	<> 'PC') then
		ie_tipo_pagto_w	:= '22';
	else
		ie_tipo_pagto_w	:= '20';
	end if;

	/* header de lote - BLQ Itau */

	nr_lote_servico_w	:= coalesce(nr_lote_servico_w,0) + 1;
	nr_seq_apres_w		:= coalesce(nr_seq_apres_w,0) + 1;
	nr_sequencia_w		:= 0;
	vl_total_w		:= 0;

    ds_conteudo_w    :=    '341' || --1 a 3
                lpad(nr_lote_servico_w,4,'0') || --4 a 7
                '1' || --8
                'C' || --9
                ie_tipo_pagto_w || --10 a 11
                ie_forma_lanc_blq_w || --12  a 13
				'030' ||
				' ' ||
				'2' ||
				cd_cgc_estab_w ||
				rpad(' ',20,' ') ||
				cd_agencia_estab_w ||
				' ' ||
				nr_conta_estab_w ||
				' ' ||
				ie_digito_estab_w ||
				nm_empresa_w ||
				rpad(' ',40,' ') ||
				ds_endereco_w ||
				nr_endereco_w ||
				ds_complemento_w ||
				ds_municipio_w ||
				nr_cep_w ||
				substr(sg_estado_w,1,2) ||
				rpad(' ',18,' ');


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
		nr_inscricao_w,
		ie_tipo_identificacao_w;
	EXIT WHEN NOT FOUND; /* apply on c04 */

		nr_sequencia_w	:= coalesce(nr_sequencia_w,0) + 1;
		nr_seq_apres_w	:= coalesce(nr_seq_apres_w,0) + 1;
		qt_registro_w	:= coalesce(qt_registro_w,0) + 1;
		vl_total_w	:= coalesce(vl_total_w,0) + (coalesce(vl_escritural_w,0) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_multa_w,0) + coalesce(vl_juros_w,0));

		if (dt_vencimento_w	< clock_timestamp()) then
			dt_vencimento_w	:= clock_timestamp();
		end if;


        /* segmento N - DARF normal */

        if (ie_forma_lanc_w    = '16') then

            select    max(b.dt_apuracao) dt_apuracao,
                lpad(substr(coalesce(max(b.cd_darf),'0'),1,4),4,'0') cd_darf,
                lpad(substr(coalesce(max(b.nr_referencia),'0'),1,17),17,'0') nr_referencia
            into STRICT    dt_apuracao_w,
                cd_darf_w,
                nr_referencia_w
            from    darf b,
                darf_titulo_pagar a
            where    a.nr_seq_darf    = b.nr_sequencia
            and    a.nr_titulo    = nr_titulo_w;

            ds_conteudo_w    :=    '341' || -- 1 a 3
                        lpad(nr_lote_servico_w,4,'0') || --4 a 7
                        '3' || -- 8
                        lpad(nr_sequencia_w,5,'0') || -- 9 a 13
                        'N' || --14
                        '0' || --15
                        '02' || --16 a 17
                        '02' || --18 a 19
                        cd_darf_w || /*20 - 23*/
                        ie_tipo_identificacao_w ||  --24
                        cd_cgc_estab_w || --25 a 38
                        to_char(dt_apuracao_w,'ddmmyyyy') || --39 a 46
                        nr_referencia_w ||  --47 a  63
                        lpad(somente_numero(to_char(coalesce(vl_escritural_w,0) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0),'999999999990.00')),14,'0') || --64 a 77
                        lpad(somente_numero(to_char(coalesce(vl_multa_w,0),'999999999990.00')),14,'0') || --78  a 91
                        lpad(somente_numero(to_char(coalesce(vl_juros_w,0),'999999999990.00')),14,'0') || -- 92 a 105
                        lpad(somente_numero(to_char(coalesce(vl_escritural_w,0),'999999999990.00')),14,'0') || --106 a 119
                        to_char(dt_vencimento_w,'ddmmyyyy') || -- 120 a 127
                        to_char(dt_remessa_retorno_w,'ddmmyyyy') || -- 128 a 135
                        rpad(' ',30,' ') || -- 136 165
                        nm_empresa_w || -- 166 a 195
                        rpad(nr_titulo_w,20,' ') ||
                        rpad(' ',15,' ') ||
                        rpad(' ',10,' ');

            ie_trailler_tributo_w := 'S';
        /* segmento N - GPS */

        elsif (ie_forma_lanc_w    = '17') then

            select    to_char(max(b.dt_referencia),'mmyyyy') dt_referencia,
                lpad(substr(coalesce(max(b.cd_pagamento),'0'),1,4),4,'0') cd_pagamento,
                max(b.vl_inss) vl_inss,
                max(b.vl_outras_entidades) vl_outras_entidades
            into STRICT    dt_referencia_w,
                cd_pagamento_w,
                vl_inss_w,
                vl_outras_entidades_w
            from    gps b,
                gps_titulo a
            where    a.nr_seq_gps    = b.nr_sequencia
            and    a.nr_titulo    = nr_titulo_w;

            ds_conteudo_w    :=    '341' || -- 001/003
                        lpad(nr_lote_servico_w,4,'0') || -- 004/007
                        '3' || -- 008/008
                        lpad(nr_sequencia_w,5,'0') || -- 009/013
                        'N' || -- 014/014
                        '000' || -- 015/017
                        '01' || -- 018/019
                        cd_pagamento_w ||  -- 020/023
                        dt_referencia_w || -- 024/029
                        nr_inscricao_w ||
                        lpad(somente_numero(to_char(coalesce(vl_escritural_w,0),'999999999990.00')),14,'0') ||
                        lpad(somente_numero(to_char(coalesce(vl_outras_entidades_w,0),'999999999990.00')),14,'0') ||
                        lpad('0',14,'0') ||
                        lpad(somente_numero(to_char(coalesce(vl_escritural_w,0) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0),'999999999990.00')),14,'0') ||
                        to_char(dt_remessa_retorno_w,'ddmmyyyy') ||
                        rpad(' ',8,' ') ||
                        rpad(' ',50,' ') ||
                        nm_pessoa_w ||
                        rpad(nr_titulo_w,20,' ') ||
                        rpad(' ',15,' ') ||
                        rpad(' ',10,' ');

            ie_trailler_tributo_w := 'S';
            vl_total_outras_entid_w := coalesce(vl_total_outras_entid_w,0) + coalesce(vl_outras_entidades_w,0);
            vl_total_acrescimos_w := coalesce(vl_total_acrescimos_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0);

        elsif (ie_tipo_bloqueto_w    = 'I') then
		/* segmento O */

			ds_conteudo_w	:=	'341' ||
						lpad(nr_lote_servico_w,4,'0') ||
						'3' ||
						lpad(nr_sequencia_w,5,'0') ||
						'O' ||
						'000' ||
						rpad(coalesce(nr_bloqueto_w,' '),48,' ') ||
						nm_pessoa_w ||
						to_char(dt_vencimento_w,'ddmmyyyy') ||
						'REA' ||
						'000000000000000' ||
						lpad(somente_numero(to_char(coalesce(vl_escritural_w,0),'9999999999990.00')),15,'0') ||
						to_char(dt_vencimento_w,'ddmmyyyy') ||
						lpad(somente_numero(to_char(coalesce(vl_multa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0),'9999999999990.00')),15,'0') ||
						rpad(' ',3,' ') ||
						rpad(' ',9,' ') ||
						rpad(' ',3,' ') ||
						rpad(nr_titulo_w,20,' ') ||
						rpad(' ',21,' ') ||
						rpad(' ',15,' ') ||
						rpad(' ',10,' ');
            ie_trailler_tributo_w := 'N';

		/* segmento J */

		else
			if (coalesce(ie_data_pagamento_w,'R')	= 'R') then
				dt_pagamento_w	:= dt_remessa_retorno_w;
			else
				dt_pagamento_w	:= dt_vencimento_w;
			end if;

			ds_conteudo_w	:=	'341' || --001 003
						lpad(nr_lote_servico_w,4,'0') || --004 007
						'3' || --008 008
						lpad(nr_sequencia_w,5,'0') || --009 013
						'J' || --014 014
						'000' || --015 017
						lpad(coalesce(substr(nr_bloqueto_w,1,44),'0'),44,'0') || --018 061
						nm_pessoa_w || --062 091
						to_char(dt_vencimento_w,'ddmmyyyy') || --092 099
						lpad(somente_numero(to_char(coalesce(vl_escritural_w,0),'9999999999990.00')),15,'0') || --100 114
						lpad(somente_numero(to_char(coalesce(vl_desconto_w,0),'9999999999990.00')),15,'0') || --115 129
						lpad(somente_numero(to_char(coalesce(vl_multa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0),'9999999999990.00')),15,'0') || --130 144
						to_char(dt_pagamento_w,'ddmmyyyy') || --145 152
						lpad(somente_numero(to_char(coalesce(vl_escritural_w,0) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_multa_w,0) + coalesce(vl_juros_w,0),'9999999999990.00')),15,'0') || --153 167
						'000000000000000' || --168 182
						rpad(nr_titulo_w,20,' ') || --183 202
						rpad(' ',38,' '); --203 240
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

			/* segmento J-52  se tornou obrigatorio a partir de 01/04/2019  */

			nr_sequencia_w	:= coalesce(nr_sequencia_w,0) + 1;
			nr_seq_apres_w	:= coalesce(nr_seq_apres_w,0) + 1;
			qt_registro_w	:= coalesce(qt_registro_w,0) + 1;

			ds_conteudo_w	:=	'341' ||
						lpad(nr_lote_servico_w,4,'0') ||
						'3' ||
						lpad(nr_sequencia_w,5,'0') ||
						'J' ||
						'000' ||
						'52' ||
						'2' ||
						lpad(cd_cgc_estab_w,15,'0') ||
						rpad(nm_empresa_w,40,' ') ||
            substr(ie_tipo_identificacao_w,1,1) ||
						lpad(nr_inscricao_w,15,'0') ||
						rpad(nm_pessoa_w,40,' ') ||
						'2' ||
						lpad(cd_cgc_estab_w,15,'0') ||
						rpad(nm_empresa_w,40,' ') ||
						rpad(' ',52,' ');

            ie_trailler_tributo_w := 'N';

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

    if (ie_trailler_tributo_w = 'S') then

	/* trailer de lote */

	nr_seq_apres_w	:= coalesce(nr_seq_apres_w,0) + 1;

        ds_conteudo_w    :=    '341' || -- 1 a 3
                            lpad(nr_lote_servico_w,4,'0') || -- 4 a 7
                            '5' || -- 8
                            rpad(' ',9,' ') || -- 9 a 17
                            lpad(nr_sequencia_w + 2,6,'0') || --  18 a 23
                            lpad(somente_numero(to_char(coalesce(vl_total_w,0),'999999999990.00')),14,'0') || --24 a 37
                            lpad(somente_numero(to_char(coalesce(vl_total_outras_entid_w,0),'999999999990.00')),14,'0') || -- 38 a a 51
                            lpad(somente_numero(to_char(coalesce(vl_total_acrescimos_w,0),'999999999990.00')),14,'0') || -- 52 a a 65
                            lpad(somente_numero(to_char(coalesce(vl_total_w,0) + coalesce(vl_total_outras_entid_w,0) + coalesce(vl_total_acrescimos_w,0),'999999999990.00')),14,'0') || --66 a 79
                            rpad(' ',151,' ') || --80 a 230
                            rpad(' ',10,' '); --231 a 240
    else

        /* trailer de lote */

        nr_seq_apres_w    := coalesce(nr_seq_apres_w,0) + 1;

        ds_conteudo_w    :=    '341' || -- 1 a 3
                    lpad(nr_lote_servico_w,4,'0') || -- 4 a 7
                    '5' || -- 8
                    rpad(' ',9,' ') || -- 9 a 17
                    lpad(nr_sequencia_w + 2,6,'0') || --  18 a 23
                    lpad(somente_numero(to_char(coalesce(vl_total_w,0),'9999999999999990.00')),18,'0') || -- 24 a  41
                    '000000000000000000' || --42 a  59
                    rpad(' ',181,' '); --60 a 240
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
close	c03;

/* trailer de arquivo */

nr_seq_apres_w	:= coalesce(nr_seq_apres_w,0) + 1;

ds_conteudo_w	:=	'341' ||
			'9999' ||
			'9' ||
			rpad(' ',9,' ') ||
			lpad(nr_lote_servico_w,6,'0') ||
			lpad(coalesce(qt_registro_w,0) + (coalesce(nr_lote_servico_w,0) * 2) + 2,6,'0') ||	/* registros detalhe + header e trailer dos lotes + header e trailer do arquivo */
			rpad(' ',211,' ');

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
-- REVOKE ALL ON PROCEDURE gerar_pagto_itau_cnab_240_v81 ( nr_seq_envio_p bigint, nm_usuario_p text) FROM PUBLIC;
