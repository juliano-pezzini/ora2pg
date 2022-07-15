-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobr_bradesco_400_de_v09 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

/*	Versão 06 
	Data: 05/06/2009 
*/
 
 
/* HEader */
 
ds_conteudo_w			varchar(400);
ds_brancos_277_w		varchar(277);
nm_empresa_w			varchar(30);
cd_empresa_w			varchar(20);
ds_branco_8_w			varchar(8);
nr_seq_arquivo_w		varchar(7);
dt_geracao_w			varchar(6);
nr_seq_registro_w		varchar(10);

/* Transação */
 
nm_avalista_w			varchar(60);
nm_sacado_w			varchar(40);
ds_endereco_sacado_w		varchar(40);
nr_controle_partic_w		varchar(25);
id_empresa_w			varchar(17);
nr_inscricao_w			varchar(14);
vl_titulo_w			varchar(13);
vl_acrescimo_w			varchar(13);
vl_desconto_w			varchar(13);
vl_iof_w			varchar(13);
vl_abatimento_w			varchar(13);
nr_nosso_numero_w		varchar(11);
vl_desconto_dia_w		varchar(10);
nr_documento_w			varchar(10);
cd_cep_w			varchar(15);
cd_conta_w			varchar(7);
dt_vencimento_w			varchar(6);
dt_emissao_w			varchar(6);
dt_desconto_w			varchar(6);
cd_agencia_debito_w		varchar(5);
cd_agencia_bancaria_w		varchar(5);
cd_agencia_deposito_w		varchar(5);
pr_multa_w			varchar(4);
cd_banco_w			varchar(3);
cd_banco_cobranca_w		varchar(3);
ds_brancos_2_w			varchar(2);
ie_ocorrencia_w			varchar(2);
ie_especie_w			varchar(2);
ie_instrucao_1_w		varchar(2);
ie_instrucao_2_w		varchar(2);
ie_tipo_inscricao_w		varchar(2);
ie_digito_agencia_w		varchar(1);
ie_digito_conta_w		varchar(1);
ie_multa_w			varchar(1);
nr_dig_nosso_numero_w		varchar(1);
cd_condicao_w			varchar(1);
ie_emite_papeleta_w		varchar(1);
ie_rateio_w			varchar(1);
ie_endereco_w			varchar(1);
ie_aceite_w			varchar(1);
ds_brancos_10_w			varchar(10);
ds_brancos_12_w			varchar(12);

/* Trailler */
 
ds_brancos_393_w		varchar(393);

nr_seq_apres_w			bigint	:= 0;
qt_registros_w			bigint	:= 0;
ie_gerar_cob_esc_prim_mens_w	varchar(1) 	:= null;

C01 CURSOR FOR 
	--PMG - 22/01/2016 - OS 984998 
	SELECT	lpad('0',5,'0') cd_agencia_debito, 
		lpad(coalesce(substr(pls_obter_dados_pagador_fin(d.nr_seq_pagador,'DA'),1,1),'0'),1,'0') ie_digito_agencia, 
		lpad('0',5,'0') cd_agencia_bancaria, 
		lpad('0',7,'0') cd_conta, 
		'0' ie_digito_conta, 
		'0' || lpad(coalesce(x.cd_carteira,'0'),3,'0') || lpad(coalesce(substr(x.cd_agencia_bancaria,1,5),'0'),5,'0') || lpad(coalesce(substr(x.cd_conta,1,7),'0'),7,'0') || coalesce(x.ie_digito_conta,'0') id_empresa, 
		lpad(coalesce(f.cd_cgc,'0'),25,'0') nr_controle_partic, 
		lpad(coalesce(substr(a.cd_banco,1,3),'0'),3,'0') cd_banco, 
		'2' ie_multa, 
		lpad(coalesce(elimina_caracteres_especiais(b.tx_multa),0),4,'0') pr_multa, 
		lpad(coalesce(to_char(b.nr_titulo),'0'),11,'0') nr_nosso_numero, 
		CASE WHEN calcula_digito('MODULO11_BRAD',lpad(substr(x.cd_carteira,2,2),2,'0') || lpad(b.nr_titulo,11,'0'))='-1' THEN 'P'  ELSE calcula_digito('MODULO11_BRAD',lpad(substr(x.cd_carteira,2,2),2,'0') || lpad(b.nr_titulo,11,0)) END  nr_dig_nosso_numero, 
		lpad('0',10,'0') vl_desconto_dia, 
		'2' cd_condicao, 
		'N' ie_emite_papeleta, 
		' ' ie_rateio, 
		'1' ie_endereco, 
		lpad(coalesce(substr(c.cd_ocorrencia,1,2),'1'),2,'0') ie_ocorrencia, 
		lpad('0',10,'0') nr_documento, 
		to_char(coalesce(b.dt_pagamento_previsto, b.dt_vencimento),'ddmmyy') dt_vencimento, 
		lpad(coalesce(elimina_caracteres_especiais(b.vl_titulo),0),13,'0') vl_titulo, 
		lpad('0',3,'0') cd_banco_cobranca, 
		lpad('0',5,'0') cd_agencia_deposito, 
		'12' ie_especie, 
		'N' ie_aceite, 
		to_char(b.dt_emissao,'ddmmyy') dt_emissao, 
		lpad(coalesce(substr(c.cd_instrucao,1,2),'0'),2,'0') ie_instrucao1, 
		'00' ie_instrucao2, 
		substr(lpad(CASE WHEN coalesce(elimina_caracteres_especiais(c.vl_acrescimo),0)=0 THEN ' '  ELSE elimina_caracteres_especiais(c.vl_acrescimo) END ,13,'0'),1,13) vl_acrescimo, 
		to_char(clock_timestamp(),'ddmmyy') dt_desconto, 
		substr(lpad(CASE WHEN coalesce(elimina_caracteres_especiais(c.vl_desconto),0)=0 THEN ' '  ELSE elimina_caracteres_especiais(c.vl_desconto) END ,13,'0'),1,13) vl_desconto, 
		lpad('0',13,'0') vl_iof, 
		lpad('0',13,'0') vl_abatimento, 
		CASE WHEN coalesce(b.cd_cgc::text, '') = '' THEN '01'  ELSE '02' END  ie_tipo_inscricao, 
		lpad(coalesce(b.cd_cgc_cpf,' '),14,' ') nr_inscricao, 
		rpad(coalesce(upper(elimina_acentuacao(substr(b.nm_pessoa,1,40))),' '),40,' ') nm_sacado, 
		substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'E')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'E') END ,1,10) || ' ' || 
		substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'NR')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'NR') END ,1,3) || ' ' || 
		substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CO')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'CO') END ,1,5) || ' ' || 
		substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'B')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'B') END ,1,10) || ' ' || 
		substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CI')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'CI') END ,1,10) || ' ' || 
		substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'UF')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'UF') END ,1,2) ds_endereco_sacado, 
		substr(CASE WHEN coalesce(d.nr_sequencia::text, '') = '' THEN  			obter_dados_pf_pj(b.cd_pessoa_fisica, b.cd_cgc, 'CEP')  ELSE pls_obter_compl_pagador(d.nr_seq_pagador,'CEP') END ,1,8) cd_cep, 
		lpad(' ',60,' ') nm_avalista, 
		substr(lpad(coalesce(to_char(a.nr_sequencia),'0'),7,'0'),1,7) nr_seq_arquivo 
	FROM banco_estabelecimento x, titulo_receber_cobr c, cobranca_escritural a, titulo_receber_v b
LEFT OUTER JOIN pls_mensalidade d ON (b.nr_seq_mensalidade = d.nr_sequencia)
LEFT OUTER JOIN banco_carteira e ON (b.nr_seq_carteira_cobr = e.nr_sequencia)
LEFT OUTER JOIN pls_contrato_pagador f ON (d.nr_seq_pagador = f.nr_sequencia)
LEFT OUTER JOIN pls_lote_mensalidade z ON (d.nr_seq_lote = z.nr_sequencia)
WHERE a.nr_sequencia		= c.nr_seq_cobranca and c.nr_titulo		= b.nr_titulo and a.nr_seq_conta_banco	= x.nr_sequencia     and ((coalesce(z.ie_primeira_mensalidade::text, '') = '' or z.ie_primeira_mensalidade = 'N') 
	or	ie_gerar_cob_esc_prim_mens_w = 'S') and a.nr_sequencia		= nr_seq_cobr_escrit_p;


BEGIN 
delete from w_envio_banco 
where nm_usuario = nm_usuario_p;
 
/* Pega o parâmetro para ver se considera os títulos gerados por lotes de primera mensalidade */
 
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
	ds_brancos_12_w
;
 
/* Header */
 
select	lpad(coalesce(substr(c.cd_convenio_banco,1,20),' '),20,' '), 
	lpad(upper(elimina_acentuacao(substr(obter_nome_pf_pj(null, b.cd_cgc),1,30))),30,' '), 
	to_char(a.dt_remessa_retorno,'ddmmyy'), 
	lpad(to_char(a.nr_sequencia),7,'0') 
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
 
ds_conteudo_w	:= 	'01' || 
			'REMESSA' || 
			'01' || 
			'COBRANCA    ' || 
			cd_empresa_w || 
			nm_empresa_w || 
			'237' || 
			'Bradesco    ' || 
			dt_geracao_w || 
			ds_branco_8_w|| 
			'MX' || 
			nr_seq_arquivo_w || 
			ds_brancos_277_w || 
			nr_seq_registro_w;	
		 
insert into w_envio_banco(	nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			cd_estabelecimento, 
			ds_conteudo, 
			nr_seq_apres, 
			nr_seq_apres_2) 
	values (	nr_seq_registro_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_estabelecimento_p, 
			ds_conteudo_w, 
			nr_seq_apres_w, 
			nr_seq_apres_w);
			 
nr_seq_apres_w	:= nr_seq_apres_w + 1;
/* Fim Header */
 
 
/* Transação */
 
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
	nr_seq_arquivo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	select	nextval('w_envio_banco_seq') 
	into STRICT	nr_seq_registro_w 
	;
	 
	ds_conteudo_w	:= 	'1' || 
				cd_agencia_debito_w || 
				ie_digito_agencia_w || 
				cd_agencia_bancaria_w || 
				cd_conta_w || 
				ie_digito_conta_w || 
				id_empresa_w || 
				nr_controle_partic_w || 
				cd_banco_w || 
				ie_multa_w || 
				pr_multa_w || 
				nr_nosso_numero_w || 
				nr_dig_nosso_numero_w || 	 
				vl_desconto_dia_w || 
				cd_condicao_w ||  --PMG - 22/01/2016 - OS 984998 
				ie_emite_papeleta_w || 
				ds_brancos_10_w || 
				'R' || 
				ie_endereco_w || 
				ds_brancos_2_w || 
				ie_ocorrencia_w || 
				nr_documento_w || 
				dt_vencimento_w || 
				vl_titulo_w || 
				cd_banco_cobranca_w || 
				cd_agencia_deposito_w || 
				ie_especie_w || 
				ie_aceite_w || 
				dt_emissao_w || 
				ie_instrucao_1_w || 
				ie_instrucao_2_w || 
				vl_acrescimo_w || 
				dt_desconto_w || 
				vl_desconto_w || 
				vl_iof_w || 
				vl_abatimento_w || 
				ie_tipo_inscricao_w || 
				nr_inscricao_w || 
				nm_sacado_w || 
				rpad(ds_endereco_sacado_w,40,' ') || 
				ds_brancos_12_w || 
				coalesce(cd_cep_w,'    ') || 
				rpad(coalesce(nm_avalista_w,' '),60,' ') || 
				nr_seq_arquivo_w;
				 
	insert into w_envio_banco(	nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				cd_estabelecimento, 
				ds_conteudo, 
				nr_seq_apres, 
				nr_seq_apres_2) 
		values (	nr_seq_registro_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				cd_estabelecimento_p, 
				ds_conteudo_w, 
				nr_seq_apres_w, 
				nr_seq_apres_w);
				 
	nr_seq_apres_w	:= nr_seq_apres_w + 1;
	 
	qt_registros_w	:= qt_registros_w + 1;
	 
	if (qt_registros_w = 500) then 
		qt_registros_w	:= 0;
		commit;
	end if;
	end;
end loop;
close C01;
 
/* Fim Transação */
 
 
/* Trailler */
 
ds_conteudo_w	:= 	'9' || 
			ds_brancos_393_w || 
			nr_seq_registro_w;	
 
select	nextval('w_envio_banco_seq') 
into STRICT	nr_seq_registro_w
;
		 
insert into w_envio_banco(	nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			cd_estabelecimento, 
			ds_conteudo, 
			nr_seq_apres, 
			nr_seq_apres_2) 
	values (	nr_seq_registro_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_estabelecimento_p, 
			ds_conteudo_w, 
			nr_seq_apres_w, 
			nr_seq_apres_w);
/* Fim Trailler*/
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobr_bradesco_400_de_v09 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

