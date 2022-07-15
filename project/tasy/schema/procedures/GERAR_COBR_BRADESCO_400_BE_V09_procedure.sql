-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobr_bradesco_400_be_v09 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

/*	Versao 09
	Data: 11/03/2010
	------------------- Com registro ----------------------

*/

/* Header */

ds_conteudo_w			varchar(400);
cd_empresa_w			varchar(20);
nm_empresa_w			varchar(30);
dt_geracao_w			varchar(6);
ds_branco_8_w			varchar(8);
nr_seq_arquivo_w			varchar(7);
ds_brancos_277_w			varchar(277);
nr_seq_registro_w			varchar(10);
cd_convenio_banco_w	banco_estab_interf.cd_convenio_banco%type;															

/* Transacao */

ie_digito_agencia_w		varchar(1);
cd_agencia_debito_w		varchar(5);
cd_agencia_bancaria_w		varchar(5);
cd_conta_w			varchar(7);
ie_digito_conta_w			varchar(1);
id_empresa_w			varchar(17);
nr_controle_partic_w		varchar(25);
cd_banco_w			varchar(3);
ie_multa_w			varchar(1);
pr_multa_w			varchar(4);
nr_dig_nosso_numero_w		varchar(1);
vl_desconto_dia_w			varchar(10);
cd_condicao_w			varchar(1);
ie_emite_papeleta_w		varchar(1);
ie_rateio_w			varchar(1);
ie_endereco_w			varchar(1);
ds_brancos_2_w			varchar(2);
ie_ocorrencia_w			varchar(2);
nr_documento_w			varchar(10);
dt_vencimento_w			varchar(6);
vl_titulo_w			varchar(13);
cd_banco_cobranca_w		varchar(3);
cd_agencia_deposito_w		varchar(5);
ie_especie_w			varchar(2);
ie_aceite_w			varchar(1);
dt_emissao_w			varchar(6);
ie_instrucao_1_w			varchar(2);
ie_instrucao_2_w			varchar(2);
vl_acrescimo_w			varchar(13);
dt_desconto_w			varchar(6);
vl_desconto_w			varchar(13);
vl_iof_w				varchar(13);
vl_abatimento_w			varchar(13);
ie_tipo_inscricao_w			varchar(2);
nr_inscricao_w			varchar(14);
nm_sacado_w			varchar(40);
ds_endereco_sacado_w		varchar(40);
nm_avalista_w			varchar(60);
cd_cep_w			varchar(8);
nr_nosso_numero_w		varchar(11);
ds_brancos_10_w			varchar(10);
ds_branco_12_w			varchar(12);
cd_carteira_w			varchar(3);
nr_seq_reg_arquivo_w		bigint	:= 1;
ds_mensagem_1_w			varchar(80);
ds_mensagem_2_w			varchar(80);
ds_mensagem_3_w			varchar(80);
ds_mensagem_4_w			varchar(80);
vl_juros_diario_w			varchar(13);
nr_titulo_w			bigint;
dt_limite_desconto_2_w      titulo_receber.dt_limite_desconto%type;
vl_desconto_2_w             titulo_receber.vl_desc_previsto%type;

/* Trailler */

ds_brancos_393_w			varchar(393);

/*Contador*/

nr_seq_apres_w			bigint	:= 1;
ie_gerar_cob_esc_prim_mens_w	varchar(1) 	:= null;


C01 CURSOR FOR
	SELECT	lpad(coalesce(pls_obter_dados_pagador_fin(d.nr_seq_pagador,'A'),coalesce(x.cd_agencia_bancaria, '0')),5,'0') cd_agencia_debito,
		lpad(coalesce(substr(pls_obter_dados_pagador_fin(d.nr_seq_pagador,'DA'),1,1), ' '),1,' ') ie_digito_agencia,
		lpad('0', 5, '0') cd_agencia_bancaria,	
		lpad(coalesce(pls_obter_dados_pagador_fin(d.nr_seq_pagador,'C'),coalesce(x.cd_conta, '0')),7,'0') cd_conta,		
		coalesce(coalesce(pls_obter_dados_pagador_fin(d.nr_seq_pagador,'DC'),x.ie_digito_conta),'0') ie_digito_conta,
		'0' || lpad(coalesce(x.cd_carteira,'0'),3,'0') || lpad(coalesce(x.cd_agencia_bancaria,'0'),5,'0') ||
			lpad(coalesce(x.cd_conta,'0'),7,'0') || coalesce(x.ie_digito_conta,'0') id_empresa,
		lpad(coalesce(substr(pls_obter_dados_segurado(pls_obter_segurado_pagador(d.nr_seq_pagador),'C'),1,25),'0'),25,'0') nr_controle_partic,
		lpad(a.cd_banco,3,'0') cd_banco,
		CASE WHEN coalesce(b.tx_multa,0)=0 THEN '0'  ELSE '2' END  ie_multa,
		lpad(somente_numero(to_char(b.tx_multa,'09.99')),4,'0') pr_multa,
		--lpad(elimina_caracteres_especiais(obter_nosso_numero_banco(a.cd_banco, b.nr_titulo)),11,'0') nr_nosso_numero,
		lpad(coalesce(coalesce(b.nr_nosso_numero,b.nr_titulo),'0'),11,0) nr_nosso_numero,
		coalesce(CASE WHEN calcula_digito('MODULO11_BRAD',lpad(substr(x.cd_carteira,2,2),2,'0') || lpad(b.nr_titulo,11,'0'))='-1' THEN 'P'  ELSE calcula_digito('MODULO11_BRAD',lpad(substr(x.cd_carteira,2,2),2,'0') || lpad(b.nr_titulo,11,'0')) END ,' ') nr_dig_nosso_numero,
		lpad('0',10,'0') vl_desconto_dia,
		coalesce(a.ie_emissao_bloqueto,'1') cd_condicao,
		' ' ie_emite_papeleta,
		' ' ie_rateio,
		'2' ie_endereco,
		lpad(coalesce(c.cd_ocorrencia,'1'),2,'0') ie_ocorrencia,
		lpad(coalesce(b.nr_titulo,'0'),10,'0') nr_documento,
		to_char(coalesce(b.dt_pagamento_previsto, b.dt_vencimento),'ddmmyy') dt_vencimento,
		replace(to_char(b.vl_saldo_titulo, 'fm00000000000.00'),'.',null) vl_titulo,
		lpad('0',3,'0') cd_banco_cobranca,
		lpad('0',5,'0') cd_agencia_deposito,
		'99' ie_especie,
		'N' ie_aceite,
		to_char(b.dt_emissao,'ddmmyy') dt_emissao,
		lpad(coalesce(c.cd_instrucao, '0'),2,'0') ie_instrucao1,
		'00' ie_instrucao2,
		replace(to_char(coalesce(c.vl_acrescimo,0), 'fm00000000000.00'),'.',null) vl_acrescimo,
		'000000' dt_desconto,
		replace(to_char(coalesce(c.vl_desconto,0), 'fm00000000000.00'),'.',null) vl_desconto,
		lpad('0',13,'0') vl_iof,
		lpad('0',13,'0') vl_abatimento,
		CASE WHEN coalesce(b.cd_cgc::text, '') = '' THEN '01'  ELSE '02' END  ie_tipo_inscricao,
		lpad(coalesce(b.cd_cgc_cpf,'0'),14, '0') nr_inscricao,
		rpad(upper(elimina_acentuacao(substr(b.nm_pessoa,1,40))),40, ' ') nm_sacado,
		rpad(upper(elimina_acentuacao(substr(
		coalesce((SELECT	max(x.ds_endereco)
		from	pessoa_juridica_compl x
		where	x.ie_tipo_complemento	= 5
		and	x.cd_cgc		= b.cd_cgc),
		CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN 			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'EN')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'E') END ) || ' ' ||
		CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN 			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'NR')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'NR') END  || ' ' ||
		CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN 			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CO')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'CO') END ,1,40))),40, ' ') ds_endereco_sacado,
		substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN 			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CEP')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'CEP') END ,1,8) cd_cep,
		lpad(' ',60,' ') nm_avalista,
		lpad(substr(coalesce(a.nr_sequencia,null),1,6),6,'0') nr_seq_arquivo,
		lpad(coalesce(x.cd_carteira,'0'),3,'0'),
		rpad(obter_instrucao_boleto(b.nr_titulo,a.cd_banco,1),80, ' ') ds_mensagem_1,
		rpad(obter_instrucao_boleto(b.nr_titulo,a.cd_banco,2),80, ' ') ds_mensagem_2,
		rpad(obter_instrucao_boleto(b.nr_titulo,a.cd_banco,3),80, ' ') ds_mensagem_3,
		rpad(obter_instrucao_boleto(b.nr_titulo,a.cd_banco,4),80, ' ') ds_mensagem_4,
		replace(to_char(coalesce(obter_vl_juros_diario_tit(null,b.nr_titulo),0), 'fm00000000000.00'),'.', null) vl_juros_diario,
		b.nr_titulo,
        to_char(b.dt_limite_desconto,'ddmmyy') dt_limite_desconto_2,
        replace(to_char(coalesce(b.vl_desc_previsto,0), 'fm00000000000.00'),'.',null) vl_desconto_2
	FROM banco_estabelecimento x, cobranca_escritural a, titulo_receber_v b
LEFT OUTER JOIN pls_mensalidade d ON (b.nr_seq_mensalidade = d.nr_sequencia)
LEFT OUTER JOIN banco_carteira e ON (b.nr_seq_carteira_cobr = e.nr_sequencia)
LEFT OUTER JOIN pls_contrato_pagador f ON (d.nr_seq_pagador = f.nr_sequencia)
LEFT OUTER JOIN pls_lote_mensalidade z ON (d.nr_seq_lote = z.nr_sequencia)
, titulo_receber_cobr c
LEFT OUTER JOIN titulo_receber_mensagem g ON (c.nr_titulo = g.nr_titulo)
WHERE a.nr_sequencia		= c.nr_seq_cobranca and c.nr_titulo			= b.nr_titulo and a.nr_seq_conta_banco	= x.nr_sequencia      and ((coalesce(z.ie_primeira_mensalidade::text, '') = '' or z.ie_primeira_mensalidade = 'N') 
	or	ie_gerar_cob_esc_prim_mens_w = 'S') and a.nr_sequencia		= nr_seq_cobr_escrit_p;


BEGIN

delete from w_envio_banco where nm_usuario = nm_usuario_p;

select	coalesce(max(a.cd_convenio_banco),'X')
into STRICT	cd_convenio_banco_w
from	banco_estab_interf a,
		banco_estabelecimento b,
		cobranca_escritural	c
where	a.nr_seq_conta_banco 	= b.nr_sequencia
and		b.nr_sequencia			= c.nr_seq_conta_banco
and		c.nr_sequencia			= (nr_seq_cobr_escrit_p)::numeric
and		upper(a.ds_objeto)		= upper('gerar_cobr_bradesco_400_be_v09');

/* Pega o parametro para ver se considera os titulos gerados por lotes de primera mensalidade */

select	coalesce(max(ie_gerar_cob_esc_prim_mens),'S')
into STRICT	ie_gerar_cob_esc_prim_mens_w
from	pls_parametros_cr
where	cd_estabelecimento = cd_estabelecimento_p;

select	lpad(' ',8,' '),
	lpad(' ',277,' '),
	lpad(' ',2,' '),
	lpad(' ',393,' '),
	lpad(' ',10,' '),
	lpad(' ',12,' ')
into STRICT	ds_branco_8_w,
	ds_brancos_277_w,
	ds_brancos_2_w,
	ds_brancos_393_w,
	ds_brancos_10_w,
	ds_branco_12_w
;

/* Header */

select	lpad(substr(coalesce(c.cd_convenio_banco,'0'),1,20), 20,'0'),
	rpad(upper(elimina_acentuacao(substr(obter_nome_pf_pj(null, b.cd_cgc),1,30))),30, ' '),
	to_char(a.dt_remessa_retorno,'ddmmyy'),
	lpad(coalesce(to_char(a.nr_remessa),'0'),7,'0')
into STRICT	cd_empresa_w,
	nm_empresa_w,
	dt_geracao_w,
	nr_seq_arquivo_w
from	estabelecimento		b,
	cobranca_escritural	a,
	banco_estabelecimento	c
where	a.cd_estabelecimento	= b.cd_estabelecimento
and	a.nr_seq_conta_banco	= c.nr_sequencia
and	a.nr_sequencia		= nr_seq_cobr_escrit_p;

select	nextval('w_envio_banco_seq')
into STRICT	nr_seq_registro_w
;

if (cd_convenio_banco_w = 'X') then
	cd_convenio_banco_w := cd_empresa_w;
end if;

ds_conteudo_w	:= 	'01' ||
			'REMESSA' ||
			'01' ||
			'COBRANCA       ' ||
			lpad(substr(cd_convenio_banco_w,1,20), 20,'0') ||
			nm_empresa_w ||
			'237' ||
			'BRADESCO       ' ||
			dt_geracao_w ||
			rpad(' ',8,' ') ||
			'MX' ||
			nr_seq_arquivo_w ||
			ds_brancos_277_w ||
			lpad(nr_seq_reg_arquivo_w,6,'0');

nr_seq_apres_w := nr_seq_apres_w + 1;
insert into w_envio_banco(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_estabelecimento,
	ds_conteudo,
	nr_seq_apres,
	nr_seq_apres_2)
values (nr_seq_registro_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_estabelecimento_p,
	ds_conteudo_w,
	nr_seq_apres_w,
	0);
/* Fim Header */



/* Transacao */


--begin
open C01;
loop
fetch C01 into	
	cd_agencia_debito_w,
	ie_digito_agencia_w,
	cd_agencia_bancaria_w,
	cd_conta_w,
	ie_digito_conta_w,
	id_empresa_w,
	nr_controle_partic_w,
	cd_banco_w,
	ie_multa_w,
	pr_multa_w,
	nr_nosso_numero_w,
	nr_dig_nosso_numero_w,
	vl_desconto_dia_w,
	cd_condicao_w,
	ie_emite_papeleta_w,
	ie_rateio_w,
	ie_endereco_w,
	ie_ocorrencia_w,
	nr_documento_w,
	dt_vencimento_w,
	vl_titulo_w,
	cd_banco_cobranca_w,
	cd_agencia_deposito_w,
	ie_especie_w,
	ie_aceite_w,
	dt_emissao_w,
	ie_instrucao_1_w,
	ie_instrucao_2_w,
	vl_acrescimo_w,
	dt_desconto_w,
	vl_desconto_w,
	vl_iof_w,
	vl_abatimento_w,
	ie_tipo_inscricao_w,
	nr_inscricao_w,
	nm_sacado_w,
	ds_endereco_sacado_w,
	cd_cep_w,
	nm_avalista_w,
	nr_seq_arquivo_w,
	cd_carteira_w,
	ds_mensagem_1_w,
	ds_mensagem_2_w,
	ds_mensagem_3_w,
	ds_mensagem_4_w,
	vl_juros_diario_w,
	nr_titulo_w,
    dt_limite_desconto_2_w,
    vl_desconto_2_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	/*Transacao Tipo 1*/

	select	nextval('w_envio_banco_seq')
	into STRICT	nr_seq_registro_w
	;

	nr_seq_reg_arquivo_w	:= nr_seq_reg_arquivo_w + 1;
	ds_conteudo_w	:=	'1' || --001 a 001
				cd_agencia_debito_w || --002 a 006
				ie_digito_agencia_w || --007 a 007
				cd_agencia_bancaria_w || --008 a 012
				cd_conta_w || --013 a 019
				ie_digito_conta_w || --020 a 020
				id_empresa_w || --021 a 037
				nr_controle_partic_w || --038 a 062
				'237' || --063 a 065
				ie_multa_w || --066 a 066
				pr_multa_w || --067 a 070
				nr_nosso_numero_w || --071 a 081
				nr_dig_nosso_numero_w || --082 a 082
				vl_desconto_dia_w || --083 a 092
				cd_condicao_w || -- 093 a 093   pmgoncalves - 08/01/2016 - OS 981226
				' ' || -- 094 a 094
				ds_brancos_10_w ||
				ie_rateio_w ||
				ie_endereco_w ||
				ds_brancos_2_w ||
				ie_ocorrencia_w ||
				nr_documento_w ||
				dt_vencimento_w ||
				vl_titulo_w ||
				cd_banco_cobranca_w ||
				cd_agencia_deposito_w ||

				'01' ||
				ie_aceite_w ||
				dt_emissao_w ||
				ie_instrucao_1_w ||
				ie_instrucao_2_w ||
				vl_juros_diario_w ||
				--vl_acrescimo_w ||
				dt_desconto_w ||
				vl_desconto_w ||
				vl_iof_w ||
				vl_abatimento_w ||
				ie_tipo_inscricao_w ||
				nr_inscricao_w ||
				nm_sacado_w ||
				ds_endereco_sacado_w ||
				ds_branco_12_w ||
				coalesce(cd_cep_w, '        ') ||
				nm_avalista_w ||
				lpad(nr_seq_reg_arquivo_w,6,'0');

	nr_seq_apres_w := nr_seq_apres_w + 1;
	insert into w_envio_banco(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_estabelecimento,
		ds_conteudo,
		nr_seq_apres,
		nr_seq_apres_2,
		nr_titulo)
	values (nr_seq_registro_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_estabelecimento_p,
		ds_conteudo_w,
		nr_seq_apres_w,
		0,
		nr_titulo_w);
	/*Fim Transacao Tipo 1*/



	/*Transacao Tipo 2*/

	select	nextval('w_envio_banco_seq')
	into STRICT	nr_seq_registro_w
	;

	nr_seq_reg_arquivo_w	:= nr_seq_reg_arquivo_w + 1;

	ds_conteudo_w	:=	'2' ||
				rpad(coalesce(ds_mensagem_1_w, ' '), 80, ' ') ||
				rpad(coalesce(ds_mensagem_2_w, ' '), 80, ' ') ||
				rpad(coalesce(ds_mensagem_3_w, ' '), 80, ' ') ||
				rpad(coalesce(ds_mensagem_4_w, ' '), 80, ' ') ||
				lpad(coalesce(elimina_caracteres_especiais(dt_limite_desconto_2_w),'0'),6,'0') ||
				lpad(vl_desconto_2_w, 13, '0') ||
				rpad(' ', 6, ' ') ||
				rpad(' ', 13, ' ') ||
				rpad(' ', 7, ' ') ||
				cd_carteira_w ||
				cd_agencia_debito_w ||
				cd_conta_w ||
				ie_digito_conta_w ||
				nr_nosso_numero_w ||
				nr_dig_nosso_numero_w ||
				lpad(nr_seq_reg_arquivo_w,6,'0');

	nr_seq_apres_w := nr_seq_apres_w + 1;
	insert into w_envio_banco(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_estabelecimento,
		ds_conteudo,
		nr_seq_apres,
		nr_seq_apres_2)
	values (nr_seq_registro_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_estabelecimento_p,
		ds_conteudo_w,
		nr_seq_apres_w,
		0);		
	/*Fim Transacao Tipo 2*/

	end;
end loop;
close C01;
/*exception
when others then
	R aise_application_error(-20011,nr_dig_nosso_numero_w||'-' || vl_desconto_dia_w||'-' || cd_condicao_w||'-' ||
				ie_emite_papeleta_w||'-' || ie_rateio_w||'-' || ie_endereco_w||'-' || ds_brancos_2_w||'-' || ie_ocorrencia_w  ||'-'|| nr_documento_w||'-' || dt_vencimento_w||'-' ||
				vl_titulo_w||'-' || cd_banco_cobranca_w||'-' || cd_agencia_deposito_w||'-' || ie_especie_w ||'-'|| ie_aceite_w||'-' || dt_emissao_w||'-' || ie_instrucao_1_w||'-' ||
				ie_instrucao_2_w||'-' || vl_acrescimo_w||'-' || dt_desconto_w ||'-'|| vl_desconto_w||'-' || vl_iof_w||'-' || vl_abatimento_w||'-' || ie_tipo_inscricao_w||'-' ||
				nr_inscricao_w||'-' || nm_sacado_w||'-' || ds_endereco_sacado_w||'-' || nm_avalista_w||'-' || nr_seq_arquivo_w||'#@#@');
end;*/

/* Fim Transacao */



/* Trailler */

nr_seq_reg_arquivo_w	:= nr_seq_reg_arquivo_w + 1;

ds_conteudo_w	:= '9' ||
		   ds_brancos_393_w ||
		   lpad(nr_seq_reg_arquivo_w,6,'0');

select	nextval('w_envio_banco_seq')
into STRICT	nr_seq_registro_w
;

nr_seq_apres_w := nr_seq_apres_w + 1;
insert into w_envio_banco(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_estabelecimento,
	ds_conteudo,
	nr_seq_apres,
	nr_seq_apres_2)
values (nr_seq_registro_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_estabelecimento_p,
	ds_conteudo_w,
	nr_seq_apres_w,
	0);
	

/* Fim Trailler*/

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobr_bradesco_400_be_v09 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

