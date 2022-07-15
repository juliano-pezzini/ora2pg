-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobranca_hsbc_150 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

	 
/* Geral */
 
ds_conteudo_w			varchar(150);
nr_seq_registro_w			bigint	:= 0;
nr_seq_apres_w			bigint	:= 0;
qt_registros_w			bigint	:= 0;
vl_total_w			double precision	:= 0;
ie_tp_identif_pess_cobr_w		varchar(1)	:= 'I';

/* Header A*/
 
nm_empresa_w			varchar(20);
dt_geracao_w			varchar(8);
nr_seq_arquivo_w			varchar(6);
nm_banco_w			varchar(20);
cd_convenio_w			varchar(20);
ds_conta_comprom_w		varchar(16);
cd_banco_w			varchar(3);

/* Transações C - D - E */
 
cd_agencia_bancaria_w		varchar(4);
ds_ocorrencia_1_w			varchar(40);
ds_ocorrencia_2_w			varchar(40);
ds_ocorrencia_w			varchar(60);
dt_vencimento_w			varchar(8);
vl_titulo_w			double precision;
cd_moeda_w			varchar(2);
ds_mensagen_w			varchar(26);
ds_uso_empresa_w			varchar(60);
ds_ident_cliente_emp_w		varchar(25);
ds_ident_cliente_emp_atual_w	varchar(25);
ds_ident_cliente_banco_w		varchar(7);
ds_tipo_de_debito_w		varchar(20);
nr_sequencia_w			pls_mensalidade.nr_sequencia%type;

/* Brancos */
 
ds_brancos_27_w			varchar(27);
ds_brancos_119_w			varchar(119);
ds_brancos_19_w			varchar(19);
ds_brancos_8_w			varchar(8);
ds_brancos_1_w			varchar(1);
ds_brancos_14_w			varchar(14);
ds_brancos_52_w			varchar(52);
ds_brancos_25_w			varchar(25);
ds_brancos_20_w			varchar(20);
ds_brancos_126_w			varchar(126);
ds_brancos_18_w			varchar(18);

C01 CURSOR FOR 
	SELECT	lpad(substr(CASE WHEN coalesce(g.cd_agencia_bancaria::text, '') = '' THEN f.cd_agencia_bancaria  ELSE g.cd_agencia_bancaria END ,1,4),4,'0') cd_agencia_bancaria, 
		lpad(' ',40,' ') ds_ocorrencia_1, 
		lpad(' ',40,' ') ds_ocorrencia_2, 
		lpad(' ',60,' ') ds_ocorrencia, 
		substr(to_char(b.dt_vencimento,'YYYYMMDD'),1,8) dt_vencimento, 
		b.vl_titulo vl_titulo, 
		rpad(coalesce(b.cd_moeda,0),2,' ') cd_moeda, 
		rpad(b.nr_titulo,49,' ') || lpad(' ',11,' ') ds_uso_empresa, 
		lpad(' ',26,' ') ds_mensagen, 
		CASE WHEN pls_obter_carteira_segurado(pls_obter_segurado_pagador(f.nr_sequencia)) IS NULL THEN  		rpad(rpad(coalesce('0026' || pls_obter_dados_contrato(f.nr_seq_contrato, 'CE'),'0'),17,'0'),25,' ')  ELSE rpad(coalesce(substr(pls_obter_carteira_segurado(pls_obter_segurado_pagador(f.nr_sequencia)),1,25),' '),25,' ') END  ds_ident_cliente_emp,		 
		lpad(' ',25,' ') ds_ident_cliente_emp_atual, 
		CASE WHEN coalesce(d.nr_seq_pagador::text, '') = '' THEN  				lpad(coalesce(coalesce(substr(OBTER_BANCO_PF_PJ(b.cd_pessoa_fisica,b.cd_cgc,'AC'),1,6),'0') || 				substr(OBTER_BANCO_PF_PJ(b.cd_pessoa_fisica,b.cd_cgc,'ADC'),1,1),'0'),7,'0')  ELSE lpad(coalesce(coalesce(substr(pls_obter_dados_pagador_fin(d.nr_seq_pagador,'C'),1,6),'0') || 				substr(pls_obter_dados_pagador_fin(d.nr_seq_pagador,'DC'),1,1),'0'),7,'0') END  ds_ident_cliente_banco,	 
		d.nr_sequencia 
	FROM banco_estabelecimento x, titulo_receber_cobr c, cobranca_escritural a, titulo_receber_v b
LEFT OUTER JOIN pls_mensalidade d ON (b.nr_seq_mensalidade = d.nr_sequencia)
LEFT OUTER JOIN banco_carteira e ON (b.nr_seq_carteira_cobr = e.nr_sequencia)
LEFT OUTER JOIN pls_contrato_pagador f ON (d.nr_seq_pagador = f.nr_sequencia)
LEFT OUTER JOIN pls_contrato_pagador_fin g ON (d.nr_seq_pagador = g.nr_seq_pagador)
WHERE a.nr_sequencia		= c.nr_seq_cobranca and c.nr_titulo			= b.nr_titulo and a.nr_seq_conta_banco	= x.nr_sequencia     and a.nr_sequencia		= nr_seq_cobr_escrit_p;


BEGIN 
delete from w_envio_banco where nm_usuario = nm_usuario_p;
 
ie_tp_identif_pess_cobr_w := coalesce(Obter_Valor_Param_Usuario(815, 44, Obter_perfil_Ativo, nm_usuario_p, 0), 'I');
 
select	lpad(' ',27,' '), 
	lpad(' ',1,' '), 
	lpad(' ',19,' '), 
	lpad(' ',14,' '), 
	lpad(' ',8,' '), 
	lpad(' ',119,' '), 
	lpad(' ',52,' '), 
	lpad(' ',25,' '), 
	lpad(' ',20,' '), 
	lpad(' ',126,' '), 
	lpad(' ',18,' ') 
into STRICT	ds_brancos_27_w, 
	ds_brancos_1_w, 
	ds_brancos_19_w, 
	ds_brancos_14_w, 
	ds_brancos_8_w, 
	ds_brancos_119_w, 
	ds_brancos_52_w, 
	ds_brancos_25_w, 
	ds_brancos_20_w, 
	ds_brancos_126_w, 
	ds_brancos_18_w
;
 
/* Header */
 
select	rpad(upper(elimina_acentuacao(substr(obter_nome_pf_pj(null, b.cd_cgc),1,20))),20,' '), 
	to_char(clock_timestamp(),'YYYYMMDD'), 
	lpad(to_char(coalesce(a.nr_remessa,a.nr_sequencia)),6,'0'), 
	rpad(substr(obter_nome_banco(a.cd_banco),1,20),20,' ') nm_banco, 
	rpad(substr(coalesce(c.cd_conv_banco_deb,' '),1,20),20,' ') cd_convenio, 
	substr(c.cd_agencia_bancaria,1,4) || ' ' || substr(c.cd_conta,1,8) || substr(c.ie_digito_conta,1,1), 
	lpad(substr(a.cd_banco,1,3),3,'0') cd_banco 
into STRICT	nm_empresa_w, 
	dt_geracao_w, 
	nr_seq_arquivo_w, 
	nm_banco_w, 
	cd_convenio_w, 
	ds_conta_comprom_w, 
	cd_banco_w 
from	estabelecimento		b, 
	cobranca_escritural	a, 
	banco_estabelecimento	c 
where	a.cd_estabelecimento	= b.cd_estabelecimento 
and	a.nr_seq_conta_banco	= c.nr_sequencia 
and	a.nr_sequencia		= nr_seq_cobr_escrit_p;
 
ds_conteudo_w	:= 	'A'|| '1' || cd_convenio_w || upper(nm_empresa_w) || cd_banco_w || upper(nm_banco_w) || dt_geracao_w || 
			lpad(nr_seq_arquivo_w,6,'0') || '04' ||	rpad('DEBITO AUTOMATICO',17,' ') || ds_brancos_52_w;
			 
qt_registros_w	:= qt_registros_w + 1;
									 
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
	1);
nr_seq_apres_w	:= nr_seq_apres_w + 1;
/* Fim Header */
 
 
/* Transação */
 
 
open C01;
loop 
fetch C01 into	 
	cd_agencia_bancaria_w, 
	ds_ocorrencia_1_w, 
	ds_ocorrencia_2_w, 
	ds_ocorrencia_w, 
	dt_vencimento_w, 
	vl_titulo_w, 
	cd_moeda_w, 
	ds_uso_empresa_w, 
	ds_mensagen_w, 
	ds_ident_cliente_emp_w, 
	ds_ident_cliente_emp_atual_w, 
	ds_ident_cliente_banco_w, 
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	/*nr_seq_apres_w	:= nr_seq_apres_w + 1; 
	 
	--TIPO C 
	ds_conteudo_w	:= 	'C' || ds_ident_cliente_emp_w || cd_agencia_bancaria_w || ds_ident_cliente_banco_w || ds_ocorrencia_1_w || 
				ds_ocorrencia_2_w || ds_brancos_25_w || '2'; 
	 
	insert into w_envio_banco 
		(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_estabelecimento, 
		ds_conteudo, 
		nr_seq_apres) 
	values	(w_envio_banco_seq.nextval, 
		sysdate, 
		nm_usuario_p, 
		sysdate, 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		ds_conteudo_w, 
		nr_seq_apres_w); 
	--FIM TIPO C 
	 
	nr_seq_apres_w	:= nr_seq_apres_w + 1; 
	 
	--TIPO D 
	ds_conteudo_w	:= 	'D' || ds_ident_cliente_emp_w || cd_agencia_bancaria_w || ds_ident_cliente_banco_w || ds_ident_cliente_emp_atual_w || 
				ds_ocorrencia_w || ds_brancos_20_w || '0' ; 
	 
	insert into w_envio_banco 
		(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		cd_estabelecimento, 
		ds_conteudo, 
		nr_seq_apres) 
	values	(w_envio_banco_seq.nextval, 
		sysdate, 
		nm_usuario_p, 
		sysdate, 
		nm_usuario_p, 
		cd_estabelecimento_p, 
		ds_conteudo_w, 
		nr_seq_apres_w); 
	--FIM TIPO D */ 
	 
	nr_seq_apres_w	:= nr_seq_apres_w + 1; 
	qt_registros_w	:= qt_registros_w + 1; 
	vl_total_w	:= vl_total_w + vl_titulo_w; 
	 
	/* TIPO E */
 
	ds_conteudo_w	:= 	'E' || -- 01 01 
				ds_ident_cliente_emp_w || -- 02 26 
				cd_agencia_bancaria_w || -- 27 30 
				'399' || -- 31-33 
				cd_agencia_bancaria_w || -- 34-37 
				ds_ident_cliente_banco_w || -- 38-44 
				dt_vencimento_w || 
				lpad(replace(to_char(vl_titulo_w, 'fm00000000000.00'),'.',''),15,'0') || '03' || 
				ds_uso_empresa_w;
				 
	if coalesce(nr_sequencia_w, 0) > 0 then 
		ds_conteudo_w := ds_conteudo_w || '11' || ds_brancos_18_w ||'0';
	else 
		ds_conteudo_w := ds_conteudo_w || ds_brancos_20_w ||'0';
	end if;	
	 
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
		nr_seq_apres_w);
	/* FIM TIPO E */
 
	end;				
end loop;
close C01;
/* Fim Transação */
 
 
/* Trailler */
 
select	nextval('w_envio_banco_seq') 
into STRICT	nr_seq_registro_w
;
 
nr_seq_apres_w	:= nr_seq_apres_w + 1;
qt_registros_w	:= qt_registros_w + 1;
 
ds_conteudo_w	:= 	'Z' || lpad(qt_registros_w,6,'0') || lpad(replace(to_char(vl_total_w, 'fm00000000000.00'),'.',''),17,'0') || 
			ds_brancos_126_w;
 
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
	nr_seq_apres_w);
/* Fim Trailler*/
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobranca_hsbc_150 ( nr_seq_cobr_escrit_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

