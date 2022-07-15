-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_pagto_bradesco_cnab_500 ( nr_seq_envio_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* PADRAO CNAB 500 */

ds_conteudo_w		varchar(500);
nr_sequencia_w		bigint	:= 1;

/* Header de arquivo */

cd_convenio_banco_w	varchar(8);
cd_cgc_w		varchar(14);
nm_empresa_w		varchar(40);
nr_remessa_w		bigint;
dt_arquivo_w		varchar(14);
cd_estabelecimento_w	smallint;

/* Transacao */

ie_tipo_inscricao_w	varchar(1);
nr_inscricao_w		varchar(15);
nm_pessoa_w		varchar(30);
ds_endereco_w		varchar(40);
nr_cep_w		varchar(8);
cd_banco_w		smallint;
cd_agencia_bancaria_w	varchar(5);
ie_digito_agencia_w	varchar(1);
nr_conta_w		varchar(13);
ie_digito_conta_w	varchar(2);
nr_titulo_w		bigint;
dt_vencimento_w		timestamp;
dt_emissao_w		varchar(8);
nr_fator_vencimento_w	varchar(4);
vl_titulo_w		double precision;
ie_tipo_pagamento_w	varchar(3);
ie_modalidade_w		varchar(2);
nr_lote_servico_w	bigint	:= 1;	/* o primeiro tem que ser dois */
vl_escritural_w		double precision;
vl_acrescimo_w		double precision;
vl_desconto_w		double precision;
vl_juros_w		double precision;
vl_multa_w		double precision;
vl_despesa_w		double precision;
nr_conta_estab_w	varchar(7);
nr_conta_complementar_w	varchar(7);
dt_desconto_w		varchar(8);
ds_inf_compl_w		varchar(40);
ie_titularidade_w	varchar(1);
cd_banco_estab_w	smallint;
nr_bloqueto_w		varchar(44);
dt_remessa_retorno_w	timestamp;
ie_tipo_conta_fornec_w	varchar(1);
cd_conta_extrato_w	varchar(5);
ie_tipo_conta_w		varchar(3);
cd_pessoa_fisica_w	varchar(10);
cd_cgc_estab_w		varchar(14);
hr_pagamento_w		varchar(4);
qt_favorecido_w		bigint;

ie_data_pagamento_w	banco_estabelecimento.ie_data_pagamento%type;
dt_pagamento_w		timestamp;
nr_bloqueto_orig_w	titulo_pagar.nr_bloqueto%type;
vl_bloqueto_w		double precision;
cd_banco_bloqueto_w		varchar(3);
cd_carteira_bloqueto_w	varchar(3);
nr_nosso_numero_bloq_w	varchar(12);

c01 CURSOR FOR
SELECT	CASE WHEN coalesce(b.cd_pessoa_fisica::text, '') = '' THEN '2'  ELSE '1' END  ie_tipo_inscricao,
	lpad(CASE WHEN coalesce(b.cd_pessoa_fisica::text, '') = '' THEN b.cd_cgc  ELSE substr(lpad(c.nr_cpf,11,'0'),1,9) || '0000' || substr(lpad(c.nr_cpf,11,'0'),10,2) END ,15,'0') nr_inscricao,
	rpad(upper(elimina_acentuacao(substr(obter_nome_pf_pj(b.cd_pessoa_fisica,b.cd_cgc),1,30))),30,' ') nm_pessoa,
	rpad(coalesce(upper(elimina_acentuacao(substr(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'R'),1,40))),' '),40,' ') ds_endereco,
	lpad(substr(somente_numero(obter_dados_pf_pj(b.cd_pessoa_fisica,b.cd_cgc,'CEP')),1,8),8,'0') nr_cep,
	coalesce(a.cd_banco,0),
	lpad(substr(coalesce(a.cd_agencia_bancaria,'0'),1,5),5,'0') cd_agencia_bancaria,
	substr(coalesce(a.ie_digito_agencia,' '),1,1) ie_digito_agencia,
	lpad(substr(coalesce(a.nr_conta,'0'),1,13),13,'0') nr_conta,
	rpad(substr(coalesce(a.ie_digito_conta,' '),1,2),2,' ') ie_digito_conta,
	a.nr_titulo,
	b.dt_vencimento_atual,
	to_char(b.dt_emissao,'yyyymmdd'),
	lpad(coalesce(substr(b.nr_bloqueto,6,4),'0'),4,'0') nr_fator_vencimento,
	b.vl_titulo,
	a.vl_escritural,
	a.vl_acrescimo,
	a.vl_desconto,
	a.ie_tipo_pagamento,
	CASE WHEN a.ie_tipo_pagamento='CC' THEN '05' WHEN a.ie_tipo_pagamento='CCP' THEN '05' WHEN a.ie_tipo_pagamento='OP' THEN '02' WHEN a.ie_tipo_pagamento='DOC' THEN '03' WHEN a.ie_tipo_pagamento='TED' THEN '08'  ELSE '31' END  ie_modalidade,
	a.vl_juros,
	a.vl_multa,
	a.vl_despesa,
	rpad(coalesce(substr(b.nr_bloqueto,1,44),'0'),44,'0') nr_bloqueto,
	CASE WHEN a.ie_tipo_pagamento='CC' THEN '1' WHEN a.ie_tipo_pagamento='CCP' THEN '2'  ELSE ' ' END  ie_tipo_conta_fornec,
	b.cd_pessoa_fisica,
	b.cd_cgc,
	nr_bloqueto,
	lpad(coalesce(a.hr_pagamento,' '),4,' ')
FROM titulo_pagar_escrit a, titulo_pagar b
LEFT OUTER JOIN pessoa_fisica c ON (b.cd_pessoa_fisica = c.cd_pessoa_fisica)
WHERE a.nr_titulo		= b.nr_titulo and a.nr_seq_escrit		= nr_seq_envio_p;

/* Trailer do arquivo */

vl_total_w		double precision	:= 0;


BEGIN

delete	from w_envio_banco
where	nm_usuario	= nm_usuario_p;

/* Header do arquivo */

select	lpad(substr(coalesce(b.cd_convenio_banco,' '),1,8),8,'0') cd_convenio_banco,
	coalesce(a.nr_remessa,a.nr_sequencia),
	to_char(clock_timestamp(),'yyyymmddhhmiss') dt_arquivo,
	a.cd_estabelecimento,
	lpad(substr(coalesce(b.cd_conta,'0'),1,7),7,'0') nr_conta_estab,
	b.cd_banco,
	a.dt_remessa_retorno,
	c.cd_cgc,
	rpad(upper(elimina_acentuacao(substr(obter_nome_pf_pj(null,c.cd_cgc),1,255))),40,' ') nm_empresa,
	lpad(coalesce(b.cd_conta_extrato,'0'),5,'0') cd_conta_extrato,
	coalesce(b.ie_data_pagamento,'R')
into STRICT	cd_convenio_banco_w,
	nr_remessa_w,
	dt_arquivo_w,
	cd_estabelecimento_w,
	nr_conta_estab_w,
	cd_banco_estab_w,
	dt_remessa_retorno_w,
	cd_cgc_estab_w,
	nm_empresa_w,
	cd_conta_extrato_w,
	ie_data_pagamento_w
from	estabelecimento c,
	banco_estabelecimento b,
	banco_escritural a
where	c.cd_estabelecimento	= coalesce(b.cd_estabelecimento,a.cd_estabelecimento)
and	a.nr_seq_conta_banco	= b.nr_sequencia
and	a.nr_sequencia		= nr_seq_envio_p;

select	lpad(substr(coalesce(max(a.nr_conta),'0'),1,7),7,'0')
into STRICT	nr_conta_complementar_w
from	pessoa_juridica_conta a
where	a.cd_banco	= cd_banco_estab_w
and	a.cd_cgc	= cd_cgc_estab_w;

if (somente_numero(nr_conta_complementar_w) = 0) then

	nr_conta_complementar_w	:= nr_conta_estab_w;

end if;

ds_conteudo_w	:=	'0' ||
			cd_convenio_banco_w ||
			'2' ||
			lpad(cd_cgc_estab_w,15,'0') ||
			nm_empresa_w ||
			'20' ||
			'1' ||
			lpad(nr_remessa_w,5,'0') ||
			'00000' ||
			dt_arquivo_w ||
			rpad(' ',5,' ') ||
			rpad(' ',3,' ') ||
			rpad(' ',5,' ') ||
			'0' ||
			rpad(' ',74,' ') ||
			rpad(' ',80,' ') ||
			rpad(' ',217,' ') ||
			/* lpad(nr_remessa_w,9,'0') || */

			lpad(' ',9,' ') ||
			rpad(' ',8,' ') ||
			lpad(nr_sequencia_w,6,'0');

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
	nr_lote_servico_w,
	nr_lote_servico_w,
	nextval('w_envio_banco_seq'));

/* Transacao */

open	c01;
loop
fetch	c01 into
	ie_tipo_inscricao_w,
	nr_inscricao_w,
	nm_pessoa_w,
	ds_endereco_w,
	nr_cep_w,
	cd_banco_w,
	cd_agencia_bancaria_w,
	ie_digito_agencia_w,
	nr_conta_w,
	ie_digito_conta_w,
	nr_titulo_w,
	dt_vencimento_w,
	dt_emissao_w,
	nr_fator_vencimento_w,
	vl_titulo_w,
	vl_escritural_w,
	vl_acrescimo_w,
	vl_desconto_w,
	ie_tipo_pagamento_w,
	ie_modalidade_w,
	vl_juros_w,
	vl_multa_w,
	vl_despesa_w,
	nr_bloqueto_w,
	ie_tipo_conta_fornec_w,
	cd_pessoa_fisica_w,
	cd_cgc_w,
	nr_bloqueto_orig_w,
	hr_pagamento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	select	count(*)
	into STRICT	qt_favorecido_w
	from	titulo_pagar_favorecido a
	where	a.nr_titulo	= nr_titulo_w;

	if (coalesce(qt_favorecido_w,0)	> 0) then

		select	somente_numero(substr(obter_conta_pessoa(coalesce(a.cd_cgc,a.cd_pessoa_fisica),CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN 'F'  ELSE 'J' END ,'B'),1,3)) cd_banco,
			lpad(substr(obter_conta_pessoa(coalesce(a.cd_cgc,a.cd_pessoa_fisica),CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN 'F'  ELSE 'J' END ,'A'),1,5),5,'0') ie_digito_agencia,
			substr(coalesce(obter_conta_pessoa(coalesce(a.cd_cgc,a.cd_pessoa_fisica),CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN 'F'  ELSE 'J' END ,'DA'),' '),1,1) cd_digito_agencia,
			lpad(replace(substr(obter_conta_pessoa(coalesce(a.cd_cgc,a.cd_pessoa_fisica),CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN 'F'  ELSE 'J' END ,'C'),1,255),'X','0'),13,'0') nr_conta,
			rpad(replace(coalesce(substr(obter_conta_pessoa(coalesce(a.cd_cgc,a.cd_pessoa_fisica),CASE WHEN coalesce(a.cd_cgc::text, '') = '' THEN 'F'  ELSE 'J' END ,'DC'),1,1),'0'),'X','0'),2,' ') ie_digito_conta,
			lpad(CASE WHEN coalesce(a.cd_pessoa_fisica::text, '') = '' THEN a.cd_cgc  ELSE substr(lpad(b.nr_cpf,11,'0'),1,9) || '0000' || substr(lpad(b.nr_cpf,11,'0'),10,2) END ,15,'0') nr_inscricao,
			CASE WHEN coalesce(a.cd_pessoa_fisica::text, '') = '' THEN '2'  ELSE '1' END  ie_tipo_inscricao
		into STRICT	cd_banco_w,
			cd_agencia_bancaria_w,
			ie_digito_agencia_w,
			nr_conta_w,
			ie_digito_conta_w,
			nr_inscricao_w,
			ie_tipo_inscricao_w
		FROM titulo_pagar_favorecido a
LEFT OUTER JOIN pessoa_fisica b ON (a.cd_pessoa_fisica = b.cd_pessoa_fisica)
WHERE a.nr_titulo	= nr_titulo_w;

	end if;

	if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then

		select	max(a.ie_tipo_conta)
		into STRICT	ie_tipo_conta_w
		from	pessoa_juridica_conta a
		where	a.ie_situacao			= 'A'
		and	a.ie_tipo_conta			= 'CS'
		and	somente_numero(a.nr_conta)	= somente_numero(nr_conta_w)
		and	a.cd_cgc			= cd_cgc_w;

	else

		select	max(a.ie_tipo_conta)
		into STRICT	ie_tipo_conta_w
		from	pessoa_fisica_conta a
		where	a.ie_situacao			= 'A'
		and	a.ie_tipo_conta			= 'CS'
		and	somente_numero(a.nr_conta)	= somente_numero(nr_conta_w)
		and	a.cd_pessoa_fisica		= cd_pessoa_fisica_w;

	end if;

	if (coalesce(ie_tipo_conta_w,'X')	<> 'CS') then

		cd_conta_extrato_w	:= lpad('0',5,'0');

	end if;

	nr_lote_servico_w	:= coalesce(nr_lote_servico_w,0) + 1;

	if (ie_modalidade_w	= '01') or (ie_modalidade_w	= '05') then

		ds_inf_compl_w	:= rpad(' ',40,' ');

	elsif (ie_modalidade_w	= '02') then

		ds_inf_compl_w	:= rpad(' ',40,' ');

	elsif (ie_modalidade_w	= '08') or (ie_modalidade_w	= '03') then

		if (cd_banco_w	= cd_banco_estab_w) then
			ds_inf_compl_w	:= 'D';
		else
			ds_inf_compl_w	:= 'C';
		end if;

		ds_inf_compl_w	:=	ds_inf_compl_w ||
					lpad('0',6,'0') ||
					'01' ||
					'01' ||
					lpad(' ',18,' ') ||
					rpad(' ',11,' ');

		dt_emissao_w	:= '00000000';

	elsif (ie_modalidade_w	= '30') then

		ds_inf_compl_w	:=	rpad(' ',25,' ') ||
					nr_inscricao_w;
		cd_conta_extrato_w	:= lpad('0',5,'0');

	elsif (ie_modalidade_w	= '31') then

		ds_inf_compl_w	:=	substr(nr_bloqueto_w,20,25) ||
					substr(nr_bloqueto_w,5,1) ||
					substr(nr_bloqueto_w,4,1) ||
					rpad(' ',13,' ');
		cd_conta_extrato_w	:= lpad('0',5,'0');
		dt_emissao_w		:= '00000000';

		if (cd_banco_w	<> cd_banco_estab_w) then

			cd_agencia_bancaria_w	:= '00000';
			ie_digito_agencia_w	:= ' ';
			nr_conta_w		:= '0000000000000';
			ie_digito_conta_w	:= '  ';

		end if;

	else

		cd_conta_extrato_w	:= lpad('0',5,'0');

	end if;

	if (coalesce(ie_data_pagamento_w,'R')	= 'R') then

		dt_pagamento_w	:= dt_remessa_retorno_w;

	else

		dt_pagamento_w	:= dt_vencimento_w;

	end if;

	if (nr_bloqueto_orig_w IS NOT NULL AND nr_bloqueto_orig_w::text <> '') then

		begin

			vl_bloqueto_w	:= (obter_dados_cod_barras(nr_bloqueto_orig_w,'V'))::numeric;

			if (coalesce(vl_bloqueto_w,0) = 0) or (coalesce(vl_bloqueto_w,0)	> coalesce(vl_escritural_w,0)) then

				vl_desconto_w	:= coalesce(vl_bloqueto_w,0) - coalesce(vl_escritural_w,0);

			end if;

		exception
		when others then

			vl_bloqueto_w	:= null;

		end;
		
		begin
		/*Buscar o banco do bloqueto do titulo*/

		cd_banco_bloqueto_w := substr(nr_bloqueto_orig_w,1,3);
		
		/*Buscar a carteira e nosso numero do bloqueto do titulo*/

		if (cd_banco_bloqueto_w = '237') then
			cd_carteira_bloqueto_w := lpad(substr(nr_bloqueto_orig_w,24,2),3,'0');
			nr_nosso_numero_bloq_w := lpad(substr(nr_bloqueto_orig_w,26,11),12,'0');
		else
			cd_carteira_bloqueto_w := '000';
			nr_nosso_numero_bloq_w := '000000000000';
		end if;		
		
		exception when others then
			cd_banco_bloqueto_w := '000';
			cd_carteira_bloqueto_w := '000';
			nr_nosso_numero_bloq_w := '000000000000';
		end;

	else

		vl_bloqueto_w	:= null;
		cd_banco_bloqueto_w := '000';
		cd_carteira_bloqueto_w := '000';
		nr_nosso_numero_bloq_w := '000000000000';
	end if;

	if (coalesce(vl_desconto_w,0) <> 0) then
		dt_desconto_w	:= to_char(dt_vencimento_w,'yyyymmdd');
	else
		dt_desconto_w	:= '00000000';
	end if;

	if (coalesce(vl_bloqueto_w,0)	<> 0) and (coalesce(vl_bloqueto_w,0)	< coalesce(vl_escritural_w,0)) then

		vl_acrescimo_w	:= coalesce(vl_escritural_w,0) - coalesce(vl_bloqueto_w,0);

	end if;

	vl_total_w		:= coalesce(vl_total_w,0) + coalesce(vl_bloqueto_w,coalesce(vl_escritural_w,0)) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0) + coalesce(vl_despesa_w,0);

	ds_conteudo_w	:=	'1' ||
				ie_tipo_inscricao_w ||
				nr_inscricao_w ||
				nm_pessoa_w ||
				ds_endereco_w ||
				nr_cep_w ||
				lpad(cd_banco_w,3,'0') ||
				cd_agencia_bancaria_w ||
				ie_digito_agencia_w ||
				nr_conta_w ||
				ie_digito_conta_w ||
				rpad(nr_titulo_w,16,' ') ||
				cd_carteira_bloqueto_w ||
				nr_nosso_numero_bloq_w ||
				rpad(nr_titulo_w,15,' ') ||
				to_char(dt_vencimento_w,'yyyymmdd') ||
				dt_emissao_w ||
				dt_desconto_w ||
				'0' ||
				nr_fator_vencimento_w ||
				lpad(somente_numero(to_char(coalesce(vl_bloqueto_w,0),'99999990.00')),10,'0') ||
				lpad(somente_numero(to_char(coalesce(vl_bloqueto_w,coalesce(vl_escritural_w,0)) - coalesce(vl_desconto_w,0) + coalesce(vl_acrescimo_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0) + coalesce(vl_despesa_w,0),'9999999999990.00')),15,'0') ||
				lpad(somente_numero(to_char(coalesce(vl_desconto_w,0),'9999999999990.00')),15,'0') ||
				lpad(somente_numero(to_char(coalesce(vl_acrescimo_w,0) + coalesce(vl_despesa_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0),'9999999999990.00')),15,'0') ||
				'05' ||
				'0000000000' ||
				rpad(' ',2,' ') ||
				ie_modalidade_w ||
				to_char(dt_pagamento_w,'yyyymmdd') ||
				rpad(' ',3,' ') ||
				'01' ||
				rpad(' ',10,' ') ||
				'0' ||
				'00' ||
				hr_pagamento_w ||
				rpad(' ',15,' ') ||
				rpad(' ',15,' ') ||
				rpad(' ',6,' ') ||
				rpad(' ',40,' ') ||
				' ' ||
				' ' ||
				ds_inf_compl_w ||
				'00' ||
				rpad(' ',35,' ') ||
				rpad(' ',22,' ') ||
				cd_conta_extrato_w ||
				' ' ||
				ie_tipo_conta_fornec_w ||
				nr_conta_complementar_w ||
				rpad(' ',8,' ') ||
				lpad(nr_lote_servico_w,6,'0');

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
		nr_lote_servico_w,
		nr_lote_servico_w,
		nextval('w_envio_banco_seq'));

end	loop;
close	c01;

/* Trailer do arquivo */

nr_lote_servico_w	:= coalesce(nr_lote_servico_w,0) + 1;

ds_conteudo_w	:=	'9' ||
			lpad(nr_lote_servico_w,6,'0') ||
			lpad(somente_numero(to_char(coalesce(vl_total_w,0),'999999999999990.00')),17,'0') ||
			rpad(' ',470,' ') ||
			lpad(nr_lote_servico_w,6,'0');

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
	nr_lote_servico_w,
	nr_lote_servico_w,
	nextval('w_envio_banco_seq'));
	

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_pagto_bradesco_cnab_500 ( nr_seq_envio_p bigint, nm_usuario_p text) FROM PUBLIC;

