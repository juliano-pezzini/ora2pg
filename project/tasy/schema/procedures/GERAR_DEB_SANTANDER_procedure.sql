-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_deb_santander ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
ie_tipo_registro_w		varchar(1);
cd_convenio_banco_w		varchar(255);
cd_pessoa_fisica_w		varchar(255);
cd_agencia_bancaria_w		varchar(255);
cd_banco_w			smallint;
cd_movimento_w			bigint;
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
qt_registros_w			bigint := 0;
nr_registro_w			integer;
nm_pagador_w			varchar(80);
ds_cidade_w			varchar(40);
ds_bairro_w			varchar(40);
sg_estado_w			varchar(15);
cd_cep_w			varchar(10);
ie_tipo_pessoa_w		varchar(1);

c01 CURSOR FOR 
SELECT	ie_tipo_registro, 
	cd_convenio_banco, 
	cd_pessoa_fisica, 
	nm_pagador, 
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
	vl_tot_registros, 
	nr_registro, 
	ds_cidade, 
	ds_bairro, 
	sg_estado, 
	cd_cep, 
	ie_tipo_pessoa 
from	( 
SELECT	'A' ie_tipo_registro, 
	coalesce(c.cd_conv_banco_deb,c.cd_convenio_banco) cd_convenio_banco, 
	'' cd_pessoa_fisica, 
	'' nm_pagador, 
	c.cd_agencia_bancaria cd_agencia_bancaria, 
	c.cd_banco, 
	0 cd_movimento, 
	'' cd_conta, 
	clock_timestamp() dt_geracao, 
	null dt_vencimento, 
	substr(obter_nome_banco(a.cd_banco),1,100) ds_banco, 
	'' ds_mensagem_2, 
	'' ds_mensagem_3, 
	substr(obter_razao_social(b.cd_cgc),1,100) nm_empresa, 
	coalesce(a.nr_sequencia,0) nr_seq_envio, 
	0 nr_titulo, 
	0 vl_escritural, 
	0 vl_tot_registros, 
	coalesce(a.nr_remessa,0) nr_registro, 
	'' ds_cidade, 
	'' ds_bairro, 
	'' sg_estado, 
	'' cd_cep, 
	'' ie_tipo_pessoa 
from	estabelecimento b, 
	banco_estabelecimento c, 
	cobranca_escritural a 
where	a.cd_estabelecimento	= b.cd_estabelecimento 
and	a.nr_seq_conta_banco	= c.nr_sequencia 

union
 
select	'B' ie_tipo_registro, 
	'' cd_convenio_banco, 
	b.cd_pessoa_fisica, 
	substr(obter_nome_pf(b.cd_pessoa_fisica),1,80) nm_pagador, 
	c.cd_agencia_bancaria cd_agencia_bancaria, 
	0 cd_banco, 
	0 cd_movimento, 
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
	0 vl_tot_registros, 
	a.nr_remessa nr_registro, 
	'' ds_cidade, 
	'' ds_bairro, 
	'' sg_estado, 
	'' cd_cep, 
	'' ie_tipo_pessoa 
from	cobranca_escrit_pf b, 
	pessoa_fisica_conta c, 
	cobranca_escritural a 
where	a.nr_sequencia		= b.nr_seq_cobranca 
and	c.cd_pessoa_fisica 	= b.cd_pessoa_fisica 
and	c.dt_atualizacao 	= (	select	max(x.dt_atualizacao) 
					from	pessoa_fisica_conta x 
					where	x.cd_pessoa_fisica 	= c.cd_pessoa_fisica) 

union
 
/*select	'C' ie_tipo_registro, 
	'' cd_convenio_banco, 
	b.cd_pessoa_fisica, 
	substr(obter_nome_pf(b.cd_pessoa_fisica),1,80) nm_pagador, 
	c.cd_agencia_bancaria cd_agencia_bancaria, 
	0 cd_banco, 
	0 cd_movimento, 
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
	0 vl_tot_registros, 
	a.nr_remessa nr_registro, 
	'' ds_cidade, 
	'' ds_bairro, 
	'' sg_estado, 
	'' cd_cep, 
	'' ie_tipo_pessoa 
from	cobranca_escrit_pf b, 
	pessoa_fisica_conta c, 
	cobranca_escritural a 
where	a.nr_sequencia		= b.nr_seq_cobranca 
and	c.cd_pessoa_fisica 	= b.cd_pessoa_fisica 
and	c.dt_atualizacao 	= (	select	max(x.dt_atualizacao) 
					from	pessoa_fisica_conta x 
					where	x.cd_pessoa_fisica 	= c.cd_pessoa_fisica) 
union*/
 
select	'D' ie_tipo_registro, 
	'' cd_convenio_banco, 
	b.cd_pessoa_fisica, 
	substr(obter_nome_pf(b.cd_pessoa_fisica),1,80) nm_pagador, 
	c.cd_agencia_bancaria cd_agencia_bancaria, 
	0 cd_banco, 
	CASE WHEN b.ie_acao='A' THEN 0 WHEN b.ie_acao='E' THEN 1 END  cd_movimento, 
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
	0 vl_tot_registros, 
	a.nr_remessa nr_registro, 
	'' ds_cidade, 
	'' ds_bairro, 
	'' sg_estado, 
	'' cd_cep, 
	'' ie_tipo_pessoa 
from	cobranca_escrit_pf b, 
	pessoa_fisica_conta c, 
	cobranca_escritural a 
where	a.nr_sequencia		= b.nr_seq_cobranca 
and	c.cd_pessoa_fisica 	= b.cd_pessoa_fisica 
and	b.ie_acao 		= 'A' 
and	c.dt_atualizacao 	= (	select 	max(x.dt_atualizacao) 
					from	pessoa_fisica_conta x 
					where	x.cd_pessoa_fisica 	= c.cd_pessoa_fisica) 

union
 
select	'E' ie_tipo_registro, 
	'' cd_convenio_banco, 
	to_char(m.nr_seq_pagador) cd_pessoa_fisica, 
	substr(pls_obter_dados_segurado(pls_obter_segurado_pagador(e.nr_seq_pagador),'C'),1,255) nm_pagador, 
	--substr(obter_nome_pf(b.cd_pessoa_fisica),1,80) nm_pagador, 
	e.cd_agencia_bancaria cd_agencia_bancaria, 
	0 cd_banco, 
	0 cd_movimento, 
	lpad(e.cd_conta || e.ie_digito_conta,10,'0') nr_conta, 
	null dt_geracao, 
	b.dt_vencimento, 
	'' ds_banco, 
	'' ds_mensagem_2, 
	'          ' ds_mensagem_3, 
	'' nm_empresa, 
	a.nr_sequencia nr_seq_envio, 
	c.nr_titulo, 
	(replace(replace(campo_mascara_virgula(to_char(c.vl_cobranca)),',',''),'.',''))::numeric  vl_escritural, 
	--to_number(replace(campo_mascara_virgula(to_char(c.vl_cobranca)),',','')) vl_escritural, 
	0 vl_tot_registros, 
	a.nr_remessa nr_registro, 
	'' ds_cidade, 
	'' ds_bairro, 
	'' sg_estado, 
	'' cd_cep, 
	'' ie_tipo_pessoa 
FROM titulo_receber_cobr c, cobranca_escritural a, titulo_receber b
LEFT OUTER JOIN pls_mensalidade m ON (b.nr_seq_mensalidade = m.nr_sequencia)
LEFT OUTER JOIN pls_contrato_pagador_fin e ON (m.nr_seq_pagador = e.nr_seq_pagador)
WHERE a.nr_sequencia		= c.nr_seq_cobranca and c.nr_titulo		= b.nr_titulo   and ((e.dt_inicio_vigencia	= (	select	max(x.dt_inicio_vigencia) 
					from	pls_contrato_pagador_fin x 
					where	x.nr_seq_pagador	= m.nr_seq_pagador 
					and	a.dt_remessa_retorno between coalesce(x.dt_inicio_vigencia,a.dt_remessa_retorno) and 
								coalesce(x.dt_fim_vigencia,a.dt_remessa_retorno))) or (coalesce(b.nr_seq_mensalidade::text, '') = '')) 
 
union
 
select	'Z' ie_tipo_registro, 
	'' cd_convenio_banco, 
	'' cd_pessoa_fisica, 
	'' nm_pagador, 
	'' cd_agencia_bancaria, 
	0 cd_banco, 
	0 cd_movimento, 
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
	(replace(replace(campo_mascara_virgula(to_char(sum(b.vl_cobranca))),',',''),'.',''))::numeric  vl_tot_registros, 
	--sum(b.vl_cobranca) vl_tot_registros, 
	a.nr_remessa nr_registro, 
	'' ds_cidade, 
	'' ds_bairro, 
	'' sg_estado, 
	'' cd_cep, 
	'' ie_tipo_pessoa 
from	titulo_receber_cobr b, 
	cobranca_escritural a 
where	a.nr_sequencia		= b.nr_seq_cobranca 
group by a.nr_sequencia, 
	a.nr_remessa 
) alias40 
where	nr_seq_envio = nr_seq_cobr_escrit_p;


BEGIN 
 
delete	from w_cobranca_banco;
commit;
 
open C01;
loop 
fetch C01 into 
	ie_tipo_registro_w, 
	cd_convenio_banco_w, 
	cd_pessoa_fisica_w, 
	nm_pagador_w, 
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
	nr_registro_w, 
	ds_cidade_w, 
	ds_bairro_w, 
	sg_estado_w, 
	cd_cep_w, 
	ie_tipo_pessoa_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	qt_registros_w := qt_registros_w + 1;
 
	insert	into	w_cobranca_banco(nr_sequencia, 
			nm_usuario, 
			dt_atualizacao, 
			nm_usuario_nrec, 
			dt_atualizacao_nrec, 
			ds_tipo_registro, 
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
			qt_registros, 
			nr_registro, 
			nm_pagador, 
			ds_cidade, 
			ds_bairro, 
			sg_estado, 
			cd_cep, 
			ie_tipo_pessoa) 
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
			rpad(to_char(nr_titulo_w),60,' '), 
			ds_mensagem_3_w, 
			nm_empresa_w, 
			lpad(coalesce(nr_registro_w,'0'),6,'0'), 
			nr_titulo_w, 
			vl_escritural_w, 
			vl_tot_registros_w, 
			qt_registros_w, 
			nr_registro_w, 
			nm_pagador_w, 
			ds_cidade_w, 
			ds_bairro_w, 
			substr(sg_estado_w,1,2), 
			cd_cep_w, 
			ie_tipo_pessoa_w);
		 
	/*if	(ie_tipo_registro_w = 'E') then 
		select	'J' ie_tipo_registro, 
			'' cd_convenio_banco, 
			null cd_pessoa_fisica, 
			'' nm_pagador, 
			'' cd_agencia_bancaria, 
			0 cd_banco, 
			0 cd_movimento, 
			'' nr_conta, 
			sysdate dt_geracao, 
			null dt_vencimento, 
			'' ds_banco, 
			'' ds_mensagem_2, 
			'' ds_mensagem_3, 
			'' nm_empresa, 
			a.nr_sequencia nr_seq_envio, 
			null nr_titulo, 
			0 vl_escritural, 
			sum(b.vl_titulo) vl_tot_registros, 
			null nr_registro, 
			'' ds_cidade, 
			'' ds_bairro, 
			'' sg_estado, 
			'' cd_cep, 
			'' ie_tipo_pessoa 
		into	ie_tipo_registro_w, 
			cd_convenio_banco_w, 
			cd_pessoa_fisica_w, 
			nm_pagador_w, 
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
			nr_registro_w, 
			ds_cidade_w, 
			ds_bairro_w, 
			sg_estado_w, 
			cd_cep_w, 
			ie_tipo_pessoa_w 
		from	pls_contrato_pagador_fin e, 
			pls_mensalidade m, 
			titulo_receber b, 
			titulo_receber_cobr c, 
			cobranca_escritural a 
		where	a.nr_sequencia		= c.nr_seq_cobranca 
		and	c.nr_titulo		= b.nr_titulo 
		and	m.nr_sequencia		= b.nr_seq_mensalidade(+) 
		and	e.nr_seq_pagador(+)	= m.nr_seq_pagador 
		and	b.nr_titulo 		= nr_titulo_w 
		and	a.nr_sequencia		= nr_seq_cobr_escrit_p 
		and	((e.dt_inicio_vigencia	= (	select	max(x.dt_inicio_vigencia) 
							from	pls_contrato_pagador_fin x 
							where	x.nr_seq_pagador	= m.nr_seq_pagador 
							and	a.dt_remessa_retorno between nvl(x.dt_inicio_vigencia,a.dt_remessa_retorno) and 
										nvl(x.dt_fim_vigencia,a.dt_remessa_retorno))) or (b.nr_seq_mensalidade is null)) 
		group by 
			a.nr_sequencia, 
			b.nr_titulo; 
			 
		qt_registros_w := qt_registros_w + 1; 
 
		insert	into	w_cobranca_banco 
				(nr_sequencia, 
				nm_usuario, 
				dt_atualizacao, 
				nm_usuario_nrec, 
				dt_atualizacao_nrec, 
				ds_tipo_registro, 
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
				qt_registros, 
				nr_registro, 
				nm_pagador, 
				ds_cidade, 
				ds_bairro, 
				sg_estado, 
				cd_cep, 
				ie_tipo_pessoa) 
			values	(w_interf_itau_seq.nextval, 
				nm_usuario_p, 
				sysdate, 
				nm_usuario_p, 
				sysdate, 
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
				qt_registros_w, 
				nr_registro_w, 
				nm_pagador_w, 
				ds_cidade_w, 
				ds_bairro_w, 
				sg_estado_w, 
				cd_cep_w, 
				ie_tipo_pessoa_w); 
	end if;*/
 
	end;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_deb_santander ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;

