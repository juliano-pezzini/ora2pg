-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_interf_safra (nr_seq_envio_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_ordem_arq_w			bigint;
nr_seq_envio_w			bigint;
ie_forma_pagto_w		varchar(5);
ie_ordem_lote_w			bigint;
tp_registro_w			bigint;
nr_inscricao_w			varchar(20);
cd_agencia_w			varchar(8);
cd_conta_w			varchar(20);
nm_empresa_w			varchar(255);
nm_banco_w			varchar(255);
dt_arquivo_w			timestamp;
hr_arquivo_w			varchar(255);
ie_tipo_servico_w		smallint;
ds_endereco_w			varchar(255);
nr_endereco_w			varchar(255);
ds_complemento_w		varchar(255);
ds_bairro_w			varchar(255);
ds_cidade_w			varchar(255);
cd_cep_w			varchar(255);
sg_estado_w			varchar(255);
cd_banco_w			bigint;
cd_compensacao_w		bigint;
nm_favorecido_w			varchar(255);
nr_documento_w			numeric(20);
dt_lancamento_w			timestamp;
vl_escritural_w			double precision;
qt_registros_w			bigint;
vl_total_pagto_w		integer;
dt_vencimento_w			timestamp;
vl_titulo_w			double precision;
vl_desconto_w			double precision;
vl_acrescimo_w			double precision;
dt_pagamento_w			timestamp;	
qt_moeda_w			double precision;
cd_sacado_w			varchar(20);
qt_lotes_arquivos_w		bigint;
qt_total_registros_w		bigint;
tp_pagamento_w			varchar(10);
vl_mora_w			double precision;
cd_carteira_w			varchar(15);
ds_brancos_w			varchar(255);
ie_registro_w			varchar(255);
nr_barras_w			varchar(100);
ie_forma_lancamento_w		varchar(5);

nr_seq_apres_w			bigint	:= 0;

nr_lote_w			bigint	:= 1;
nr_registro_w			bigint	:= 2;
cd_agencia_fornec_w		varchar(8);
cd_conta_fornec_w		varchar(20);
nr_inscricao_fornec_w		varchar(14);
ie_tipo_inscricao_w		varchar(20);

c01 CURSOR FOR
SELECT	ie_ordem_arq,
	nr_seq_envio,
	ie_forma_pagto,
	ie_ordem_lote,
	tp_registro,
	nr_inscricao,
	cd_agencia,
	cd_conta,
	nm_empresa,
	nm_banco,
	dt_arquivo,
	hr_arquivo,
	ie_tipo_servico,
	ds_endereco,
	nr_endereco,
	ds_complemento,
	ds_bairro,
	ds_cidade,
	cd_cep,
	sg_estado,
	cd_banco,
	cd_compensacao,
	nm_favorecido,
	nr_documento,
	dt_lancamento,
	vl_escritural,
	qt_registros,
	vl_total_pagto,
	dt_vencimento,
	vl_titulo,
	vl_desconto,
	vl_acrescimo,
	dt_pagamento,
	qt_moeda,
	cd_sacado,
	qt_lotes_arquivos,
	qt_total_registros,
	tp_pagamento,
	vl_mora,
	cd_carteira,
	ds_brancos,
	ie_registro,
	nr_barras,
	cd_agencia_fornec,
	cd_conta_fornec,
	nr_inscricao_fornec,
	ie_forma_lancamento,
	ie_tipo_inscricao
from (
SELECT	1						ie_ordem_arq,
	e.nr_sequencia					nr_seq_envio,
	'0'						ie_forma_pagto,
	0 						ie_ordem_lote,
	1						tp_registro,
	a.cd_cgc					nr_inscricao,
	g.cd_agencia_bancaria				cd_agencia,
	substr((g.cd_conta)::numeric  || g.ie_digito_conta,1,15)	cd_conta,
	upper(p.ds_razao_social)			nm_empresa,
	g.ds_banco					nm_banco,
	e.dt_remessa_retorno				dt_arquivo,
	e.dt_remessa_retorno				hr_arquivo,
	0						ie_tipo_servico,
	' '						ds_endereco,
	' '						nr_endereco,
	' '						ds_complemento,
	' '						ds_bairro,
	' '						ds_cidade,
	' '						cd_cep,
	' '						sg_estado,
	0						cd_banco,
	0						cd_compensacao,
	' '						nm_favorecido,
	0						nr_documento,
	clock_timestamp()						dt_lancamento,
	0						vl_escritural,
	0						qt_registros,
	0						vl_total_pagto,
	clock_timestamp()						dt_vencimento,
	0						vl_titulo,
	0						vl_desconto,
	0						vl_acrescimo,
	clock_timestamp()						dt_pagamento,
	0						qt_moeda,
	' '						cd_sacado,
	0						qt_lotes_arquivos,
	0						qt_total_registros,
	' '						tp_pagamento,
	0						vl_mora,
	g.cd_carteira					cd_carteira,
	' '						ds_brancos,
	'0' 						ie_registro,
	'0'						nr_barras,
	'0'						cd_agencia_fornec,
	'0'						cd_conta_fornec,
	'0'						nr_inscricao_fornec,
	'0'						ie_forma_lancamento,
	' '						ie_tipo_inscricao
from	estabelecimento a,
	banco_estabelecimento_v g,
	pessoa_juridica p,
	banco_escritural e
where	e.cd_estabelecimento   	= a.cd_estabelecimento
and	a.cd_cgc		= p.cd_cgc
and	g.nr_sequencia		= e.nr_seq_conta_banco
and	g.ie_tipo_relacao      	in ('EP','ECC')
and	e.nr_sequencia		= nr_seq_envio_p

union

/*	Detalhe - Bloquetos 	*/

select	2						ie_ordem_arq,
	a.nr_sequencia					nr_seq_envio,
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '05' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=399 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' WHEN c.ie_tipo_pagamento='TED' THEN '03' END  ie_forma_pagto,
	c.nr_titulo					ie_ordem_lote,
	2						tp_registro,
	e.cd_cgc					nr_inscricao,
	lpad(b.cd_agencia_bancaria,7,'0')	cd_agencia,
	lpad(b.cd_conta || b.ie_digito_conta,8,'0')		cd_conta,
	' '						nm_empresa,
	' '						nm_banco,
	clock_timestamp()						dt_arquivo,
	clock_timestamp() 					hr_arquivo,
	0						ie_tipo_servico,
	' '						ds_endereco,
	' '						nr_endereco,
	' '						ds_complemento,
	' '						ds_bairro,
	' '						ds_cidade,
	' '						cd_cep,
	' '						sg_estado,
	c.cd_banco					cd_banco,
	c.cd_camara_compensacao				cd_compensacao,
	d.nm_favorecido					nm_favorecido,
	d.nr_titulo					nr_documento,
	to_Date(substr(obter_proximo_dia_util(e.cd_estabelecimento,d.dt_vencimento_atual),1,255),'dd/mm/yy') dt_lancamento,
	coalesce(c.vl_escritural,0)				vl_escritural,
	0						qt_registros,
	0						vl_total_pagto,
	d.dt_vencimento_atual				dt_vencimento,
	0						vl_titulo,
	0						vl_desconto,
	0						vl_acrescimo,
	clock_timestamp()						dt_pagamento,
	0						qt_moeda,
	' '						cd_sacado,
	0						qt_lotes_arquivos,
	0						qt_total_registros,
	CASE WHEN d.ie_tipo_titulo='0' THEN 'NF' WHEN d.ie_tipo_titulo='1' THEN 'BLQ' WHEN d.ie_tipo_titulo='2' THEN 'DUP' WHEN d.ie_tipo_titulo='3' THEN 'NP'  ELSE 'OUT' END  tp_pagamento,
	coalesce(d.vl_saldo_multa,0) + coalesce(d.vl_saldo_juros,0) vl_mora,
	b.cd_carteira					cd_carteira,
	' '						ds_brancos,
	'3' 						ie_registro,
	d.nr_bloqueto					nr_barras,
	lpad(c.cd_agencia_bancaria,7,'0')		cd_agencia_fornec,
	c.nr_conta || c.ie_digito_conta			cd_conta_fornec,
	d.cd_favorecido					nr_inscricao_fornec,
	'0'						ie_forma_lancamento,
	CASE WHEN d.ie_tipo_favorecido='1' THEN '02'  ELSE '01' END 	ie_tipo_inscricao
from	estabelecimento e,
	banco_estabelecimento_v b,
	banco_escritural a,
	titulo_pagar_v2 d,
	titulo_pagar_escrit c
where	c.nr_titulo		= d.nr_titulo
and	a.nr_sequencia		= c.nr_seq_escrit
and	a.cd_estabelecimento	= e.cd_estabelecimento
and 	b.ie_tipo_relacao	in ('EP','ECC')
and	b.nr_sequencia		= a.nr_seq_conta_banco
and 	c.ie_tipo_pagamento	= 'BLQ'
and	a.nr_sequencia		= nr_seq_envio_p

union

/*	Detalhe - DOC/TED/CC	*/

select	3						ie_ordem_arq,
	a.nr_sequencia					nr_seq_envio,
	CASE WHEN c.ie_tipo_pagamento='CC' THEN '01' WHEN c.ie_tipo_pagamento='CCP' THEN '05' WHEN c.ie_tipo_pagamento='BLQ' THEN CASE WHEN c.cd_banco=399 THEN '30'  ELSE '31' END  WHEN c.ie_tipo_pagamento='DOC' THEN '03' WHEN c.ie_tipo_pagamento='TED' THEN '03' END  ie_forma_pagto,
	c.nr_titulo					ie_ordem_lote,
	3						tp_registro,
	e.cd_cgc					nr_inscricao,
	lpad(b.cd_agencia_bancaria,7,'0')	cd_agencia,
	lpad(b.cd_conta || b.ie_digito_conta,8,'0')		cd_conta,
	' '						nm_empresa,
	' '						nm_banco,
	clock_timestamp()						dt_arquivo,
	clock_timestamp() 					hr_arquivo,
	0						ie_tipo_servico,
	' '						ds_endereco,
	' '						nr_endereco,
	' '						ds_complemento,
	' '						ds_bairro,
	' '						ds_cidade,
	' '						cd_cep,
	' '						sg_estado,
	c.cd_banco					cd_banco,
	c.cd_camara_compensacao				cd_compensacao,
	d.nm_favorecido					nm_favorecido,
	d.nr_titulo					nr_documento,
	d.dt_vencimento_atual				dt_lancamento,
	coalesce(c.vl_escritural,0)				vl_escritural,
	0						qt_registros,
	0						vl_total_pagto,
	clock_timestamp()						dt_vencimento,
	0						vl_titulo,
	0						vl_desconto,
	0						vl_acrescimo,
	clock_timestamp()						dt_pagamento,
	0						qt_moeda,
	' '						cd_sacado,
	0						qt_lotes_arquivos,
	0						qt_total_registros,	
	CASE WHEN d.ie_tipo_titulo='0' THEN 'NF' WHEN d.ie_tipo_titulo='1' THEN 'BLQ' WHEN d.ie_tipo_titulo='2' THEN 'DUP' WHEN d.ie_tipo_titulo='3' THEN 'NP'  ELSE 'OUT' END  tp_pagamento,
	0						vl_mora,
	b.cd_carteira					cd_carteira,
	' '						ds_brancos,
	'3' 						ie_registro,
	'0'						nr_barras,
	lpad(c.cd_agencia_bancaria,7,'0')		cd_agencia_fornec,
	lpad(c.nr_conta || c.ie_digito_conta,10,'0')			cd_conta_fornec,
	d.cd_favorecido					nr_inscricao_fornec,
	c.ie_tipo_pagamento				ie_forma_lancamento,
	CASE WHEN d.ie_tipo_favorecido='1' THEN '02'  ELSE '01' END 	ie_tipo_inscricao
from	estabelecimento e,
	banco_estabelecimento_v b,
	banco_escritural a,
	titulo_pagar_v2 d,
	titulo_pagar_escrit c
where	c.nr_titulo		= d.nr_titulo
and	a.nr_sequencia		= c.nr_seq_escrit
and	a.cd_estabelecimento	= e.cd_estabelecimento
and 	b.ie_tipo_relacao	in ('EP','ECC')
and	b.nr_sequencia		= a.nr_seq_conta_banco
and	c.ie_tipo_pagamento	in ('DOC','TED','CCP','CC')
and	a.nr_sequencia		= nr_seq_envio_p

union

/*	Trailler do Arquivo	*/

select	4						ie_ordem_arq,
	e.nr_sequencia					nr_seq_envio,
	'0'						ie_forma_pagto,
	9999999999					ie_ordem_lote,
	4						tp_registro,
	' '						nr_inscricao,
	'0'						cd_agencia,
	'0'						cd_conta,
	' '						nm_empresa,
	' '						nm_banco,
	clock_timestamp()						dt_arquivo,
	clock_timestamp() 					hr_arquivo,
	0						ie_tipo_servico,
	' '						ds_endereco,
	' '						nr_endereco,
	' '						ds_complemento,
	' '						ds_bairro,
	' '						ds_cidade,
	' '						cd_cep,
	' '						sg_estado,
	0						cd_banco,
	0						cd_compensacao,
	' '						nm_favorecido,
	0						nr_documento,
	clock_timestamp()						dt_lancamento,
	sum(coalesce(vl_escritural,0))			vl_escritural,
	0						qt_registros,
	0						vl_total_pagto,
	clock_timestamp()						dt_vencimento,
	0						vl_titulo,
	0						vl_desconto,
	0						vl_acrescimo,
	clock_timestamp()						dt_pagamento,
	0						qt_moeda,
	' '						cd_sacado,
	count(*)					qt_lotes_arquivos,
	count(*)					qt_total_registros,
	' '						tp_pagamento,
	0						vl_mora,
	' '						cd_carteira,
	' '						ds_brancos,
	'9' 						ie_registro,
	'0'						nr_barras,
	'0'						cd_agencia_fornec,
	'0'						cd_conta_fornec,
	'0'						nr_inscricao_fornec,
	'0'						ie_forma_lancamento,
	' '						ie_tipo_inscricao
from	banco_estabelecimento_v b,
	estabelecimento a,
	banco_escritural e,
	titulo_pagar_escrit c
where	e.cd_estabelecimento    = a.cd_estabelecimento
and	e.nr_sequencia		= c.nr_seq_escrit
and	b.ie_tipo_relacao       in ('EP','ECC')
and	b.nr_sequencia		= e.nr_seq_conta_banco
and	e.nr_sequencia		= nr_seq_envio_p
group by e.nr_sequencia
) alias41
order by	ie_ordem_arq,
		nr_seq_envio,
		ie_forma_pagto,
		tp_pagamento,
		ie_ordem_lote,
		tp_registro;


BEGIN

delete	from w_interf_itau;
commit;

open c01;
loop
fetch c01 into
	ie_ordem_arq_w,	
	nr_seq_envio_w,	
	ie_forma_pagto_w,
	ie_ordem_lote_w,
	tp_registro_w,
	nr_inscricao_w,	
	cd_agencia_w,
	cd_conta_w,
	nm_empresa_w,
	nm_banco_w,
	dt_arquivo_w,	
	hr_arquivo_w,
	ie_tipo_servico_w,
	ds_endereco_w,
	nr_endereco_w,
	ds_complemento_w,
	ds_bairro_w,
	ds_cidade_w,
	cd_cep_w,
	sg_estado_w,
	cd_banco_w,
	cd_compensacao_w,
	nm_favorecido_w,
	nr_documento_w,	
	dt_lancamento_w,
	vl_escritural_w,
	qt_registros_w,	
	vl_total_pagto_w,
	dt_vencimento_w,
	vl_titulo_w,
	vl_desconto_w,
	vl_acrescimo_w,	
	dt_pagamento_w,
	qt_moeda_w,
	cd_sacado_w,
	qt_lotes_arquivos_w,
	qt_total_registros_w,
	tp_pagamento_w,
	vl_mora_w,
	cd_carteira_w,
	ds_brancos_w,
	ie_registro_w,
	nr_barras_w,
	cd_agencia_fornec_w,
	cd_conta_fornec_w,
	nr_inscricao_fornec_w,
	ie_forma_lancamento_W,
	ie_tipo_inscricao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	nr_seq_apres_w	:= nr_seq_apres_w + 1;
	
insert	into	w_interf_itau(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nr_seq_apres,
		nr_seq_envio,
		ie_forma_pagto,
		nr_seq_reg_lote,
		ie_tipo_registro,
		nr_inscricao,
		cd_agencia_bancaria,
		cd_conta,
		nm_empresa,
		ds_banco,
		dt_geracao,
		ds_endereco,
		nr_endereco,
		ds_bairro,
		ds_cidade,
		cd_cep,
		sg_estado,
		cd_banco_fornec,
		cd_camara_compensacao,
		nm_fornecedor,
		nr_titulo,
		dt_pagto,
		vl_pagto,
		qt_registros,
		vl_total_pagto,
		cd_barras,
		dt_vencimento,
		vl_titulo,
		vl_desconto,
		vl_acrescimo,
		qt_lote_arquivo,
		qt_tot_reg,
		vl_juros,
		ie_registro,
		ie_tipo_servico,
		ds_complemento,
		qt_moeda,
		ie_forma_lancamento,
		cd_carteira,
		ds_brancos,
		nr_lote,
		nr_registro,
		cd_agencia_fornec,
		nr_conta_fornecedor,
		nr_inscricao_fornec,
		ie_tipo_inscricao)
	values (nextval('w_interf_itau_seq'),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_apres_w,
		nr_seq_envio_w,
		tp_pagamento_w,
		ie_ordem_lote_w,
		tp_registro_w,
		nr_inscricao_w,
		cd_agencia_w,
		cd_conta_w,
		nm_empresa_w,
		nm_banco_w,
		dt_arquivo_w,
		ds_endereco_w,
		nr_endereco_w,
		ds_bairro_w,
		ds_cidade_w,
		cd_cep_w,
		sg_estado_w,
		cd_banco_w,
		cd_compensacao_w,
		nm_favorecido_w,
		nr_documento_w,
		dt_lancamento_w,
		vl_escritural_w,
		qt_registros_w,
		vl_total_pagto_w,
		nr_barras_w,
		dt_vencimento_w,
		vl_titulo_w,
		vl_desconto_w,
		vl_acrescimo_w,
		qt_lotes_arquivos_w,
		qt_total_registros_w,
		vl_mora_w,
		ie_registro_w,
		ie_tipo_servico_w,
		ds_complemento_w,
		qt_moeda_w,
		ie_forma_lancamento_w,
		cd_carteira_w,
		ds_brancos_w,
		nr_lote_w,
		nr_registro_w,
		cd_agencia_fornec_w,
		cd_conta_fornec_w,
		nr_inscricao_fornec_w,
		ie_tipo_inscricao_w);

	/* So incrementar o numero do registro quando detalhe */

	if (tp_registro_w in ('2','3','4')) then
		nr_registro_w	:= nr_registro_w + 1;
	end if;

end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_interf_safra (nr_seq_envio_p bigint, nm_usuario_p text) FROM PUBLIC;

