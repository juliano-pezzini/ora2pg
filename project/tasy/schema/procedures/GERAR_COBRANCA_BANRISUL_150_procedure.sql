-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobranca_banrisul_150 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
ie_tipo_registro_w		bigint;
cd_convenio_banco_w		varchar(255);
cd_pessoa_fisica_w		varchar(255);
cd_agencia_bancaria_w		varchar(255);
cd_banco_w			varchar(255);
cd_movimento_w			varchar(255);
cd_conta_w			varchar(255);
dt_geracao_w			timestamp;
dt_vencimento_w			timestamp;
ds_banco_w			varchar(255);
ds_mensagem_2_w			varchar(255);
ds_mensagem_3_w			varchar(255);
nm_empresa_w			varchar(255);
nr_seq_envio_w			bigint;
nr_titulo_w			bigint;
vl_escritural_w			double precision;
vl_tot_registros_w		double precision;
qt_registros_w			bigint;

c01 CURSOR FOR 
SELECT	ie_tipo_registro, 
	cd_convenio_banco, 
	cd_pessoa_fisica, 
	cd_agencia_bancaria, 
	cd_banco, 
	cd_movimento, 
	cd_conta, 
	dt_geracao, 
	dt_vencimento, 
	ds_banco, 
	ds_mensagem_2, 
	ds_mensagem_3, 
	nm_empresa, 
	nr_seq_envio, 
	nr_titulo, 
	vl_escritural, 
	vl_tot_registros 
from	( 
SELECT	'01' ie_tipo_registro, 
	c.cd_convenio_banco cd_convenio_banco, 
	'' cd_pessoa_fisica, 
	c.cd_agencia_bancaria cd_agencia_bancaria, 
	c.cd_banco, 
	'' cd_movimento, 
	'' cd_conta, 
	clock_timestamp() dt_geracao, 
	null dt_vencimento, 
	substr(obter_nome_banco(a.cd_banco),1,100) ds_banco, 
	'' ds_mensagem_2, 
	'' ds_mensagem_3, 
	substr(obter_razao_social(b.cd_cgc),1,100) nm_empresa, 
	a.nr_sequencia nr_seq_envio, 
	0 nr_titulo, 
	0 vl_escritural, 
	0 vl_tot_registros 
from	estabelecimento b, 
	banco_estabelecimento c, 
	cobranca_escritural a 
where	a.cd_estabelecimento	= b.cd_estabelecimento 
and	a.nr_seq_conta_banco	= c.nr_sequencia 

union
 
select	'10' ie_tipo_registro, 
	'' cd_convenio_banco, 
	 b.cd_pessoa_fisica, 
	c.cd_agencia_bancaria cd_agencia_bancaria, 
	0 cd_banco, 
	'' cd_movimento, 
	c.nr_conta, 
	null dt_geracao, 
	null dt_vencimento, 
	'' ds_banco, 
	'' ds_mensagem_2, 
	'' ds_mensagem_3, 
	'' nm_empresa, 
	a.nr_sequencia nr_seq_envio, 
	0 nr_titulo, 
	0 vl_escritural, 
	0 vl_tot_registros 
from	cobranca_escrit_pf b, 
		pessoa_fisica_conta c, 
	cobranca_escritural a 
where	a.nr_sequencia		= b.nr_seq_cobranca 
and	c.cd_pessoa_fisica 	= b.cd_pessoa_fisica 
and	c.dt_atualizacao 	= (	select	max(x.dt_atualizacao) 
					from	pessoa_fisica_conta x 
					where	x.cd_pessoa_fisica 	= c.cd_pessoa_fisica) 

union
 
select	'15' ie_tipo_registro, 
	'' cd_convenio_banco, 
	 b.cd_pessoa_fisica, 
	c.cd_agencia_bancaria cd_agencia_bancaria, 
	0 cd_banco, 
	CASE WHEN b.ie_acao='A' THEN '0' WHEN b.ie_acao='E' THEN '1' END  cd_movimento, 
	c.nr_conta, 
	null dt_geracao, 
	null dt_vencimento, 
	'' ds_banco, 
	'' ds_mensagem_2, 
	'' ds_mensagem_3, 
	'' nm_empresa, 
	a.nr_sequencia nr_seq_envio, 
	0 nr_titulo, 
	0 vl_escritural, 
	0 vl_tot_registros 
from	cobranca_escrit_pf b, 
	pessoa_fisica_conta c, 
	cobranca_escritural a 
where	a.nr_sequencia		= b.nr_seq_cobranca 
and	c.cd_pessoa_fisica 	= b.cd_pessoa_fisica 
and	b.ie_acao 		<> 'I' 
and	c.dt_atualizacao 	= (	select 	max(x.dt_atualizacao) 
					from	pessoa_fisica_conta x 
					where	x.cd_pessoa_fisica 	= c.cd_pessoa_fisica) 

union
 
select	'20' ie_tipo_registro, 
	'' cd_convenio_banco, 
	 b.cd_pessoa_fisica, 
	c.cd_agencia_bancaria cd_agencia_bancaria, 
	0 cd_banco, 
	'' cd_movimento, 
	lpad(c.nr_conta,10,'0') nr_conta, 
	null dt_geracao, 
	b.dt_vencimento, 
	'' ds_banco, 
	'' ds_mensagem_2, 
	'' ds_mensagem_3, 
	'' nm_empresa, 
	a.nr_sequencia nr_seq_envio, 
	c.nr_titulo, 
	c.vl_cobranca vl_escritural, 
	0 vl_tot_registros 
from	titulo_receber_v b, 
	titulo_receber_cobr c, 
	cobranca_escritural a 
where	a.nr_sequencia		= c.nr_seq_cobranca 
and	c.nr_titulo		= b.nr_titulo 

union
 
select	'25' ie_tipo_registro, 
	'' cd_convenio_banco, 
	'' cd_pessoa_fisica, 
	'' cd_agencia_bancaria, 
	0 cd_banco, 
	'' cd_movimento, 
	'' cd_conta, 
	null dt_geracao, 
	null dt_vencimento, 
	'' ds_banco, 
	'' ds_mensagem_2, 
	'' ds_mensagem_3, 
	'' nm_empresa, 
	a.nr_sequencia nr_seq_envio, 
	0 nr_titulo, 
	0 vl_escritural, 
	sum(b.vl_cobranca) vl_tot_registros 
from	titulo_receber_cobr b, 
	cobranca_escritural a 
where	a.nr_sequencia		= b.nr_seq_cobranca 
group by a.nr_sequencia 
) alias11 
where	nr_seq_envio = nr_seq_cobr_escrit_p;


BEGIN 
 
delete	from w_cobranca_banco;
commit;
 
open c01;
loop 
fetch c01 into 
	ie_tipo_registro_w, 
	cd_convenio_banco_w, 
	cd_pessoa_fisica_w, 
	cd_agencia_bancaria_w, 
	cd_banco_w, 
	cd_movimento_w, 
	cd_conta_w, 
	dt_geracao_w, 
	dt_vencimento_w, 
	ds_banco_w, 
	ds_mensagem_2_w, 
	ds_mensagem_3_w, 
	nm_empresa_w, 
	nr_seq_envio_w, 
	nr_titulo_w, 
	vl_escritural_w, 
	vl_tot_registros_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
qt_registros_w := qt_registros_w + 1;
 
insert	into	w_cobranca_banco(nr_sequencia, 
		nm_usuario, 
		dt_atualizacao, 
		nm_usuario_nrec, 
		dt_atualizacao_nrec, 
		ie_tipo_registro, 
		cd_convenio_banco, 
		ds_cgc_cpf, 
		cd_agencia_bancaria, 
		cd_banco, 
		cd_instrucao, 
		cd_conta, 
		dt_geracao, 
		dt_vencimento, 
		ds_banco, 
		ds_mensagem_2, 
		ds_mensagem_3, 
		nm_empresa, 
		nr_seq_envio, 
		nr_titulo, 
		vl_titulo, 
		vl_tot_registros, 
		qt_registros) 
	values (nextval('w_interf_itau_seq'), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		ie_tipo_registro_w, 
		cd_convenio_banco_w, 
		cd_pessoa_fisica_w, 
		cd_agencia_bancaria_w, 
		cd_banco_w, 
		cd_movimento_w, 
		cd_conta_w, 
		dt_geracao_w, 
		dt_vencimento_w, 
		ds_banco_w, 
		ds_mensagem_2_w, 
		ds_mensagem_3_w, 
		nm_empresa_w, 
		nr_seq_envio_w, 
		nr_titulo_w, 
		vl_escritural_w, 
		vl_tot_registros_w, 
		qt_registros_w);
 
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobranca_banrisul_150 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;

