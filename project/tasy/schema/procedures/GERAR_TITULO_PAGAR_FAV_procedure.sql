-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_titulo_pagar_fav (nr_titulo_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_pessoa_fisica_w	titulo_pagar.cd_pessoa_fisica%type;
cd_cgc_w		titulo_pagar.cd_cgc%type;
cd_estabelecimento_w	titulo_pagar.cd_estabelecimento%type;
nr_sequencia_w		titulo_pagar_favorecido.nr_sequencia%type;
cd_banco_w		banco.cd_banco%type;
cd_Banco_externo_w	banco.cd_banco_externo%type;
cd_agencia_bancaria_w	pessoa_fisica_conta.cd_agencia_bancaria%type;
ie_digito_agencia_w	Pessoa_Juridica_Conta.ie_digito_agencia%type;
nr_conta_w		pessoa_fisica_conta.nr_conta%type;
ds_banco_w		banco.ds_banco%type;
nr_digito_conta_w	pessoa_fisica_conta.nr_digito_conta%type;
cd_codigo_identificacao_w	pessoa_juridica_conta.cd_codigo_identificacao%type;
ds_observacao_w		pessoa_juridica_conta.ds_observacao%type;

c01 CURSOR FOR
SELECT substr(a.cd_banco,1,5),
       b.CD_BANCO_EXTERNO,
       a.cd_agencia_bancaria,
       a.ie_digito_agencia,
       a.nr_conta,
       b.ds_banco,
       a.nr_digito_conta,
       a.CD_CODIGO_IDENTIFICACAO,
       substr(a.ds_observacao,1,255) ds_observacao
from   banco b,
       Pessoa_Juridica_Conta a
where a.cd_cgc         = cd_cgc_w
  and a.cd_banco     = b.cd_banco
  and coalesce(a.IE_SITUACAO,'A') = 'A'
and   'S' = verifica_conta_estab( a.cd_banco, a.cd_agencia_bancaria, a.nr_conta, null, a.cd_cgc, cd_estabelecimento_w)

union

SELECT substr(a.cd_banco,1,5),
       b.CD_BANCO_EXTERNO,
       a.cd_agencia_bancaria,
       a.ie_digito_agencia,
       a.nr_conta,
       b.ds_banco,
       a.nr_digito_conta,
       '' CD_CODIGO_IDENTIFICACAO ,
       '' ds_observacao
from   banco b,
       Pessoa_Fisica_Conta a
where  a.cd_pessoa_fisica      = cd_pessoa_fisica_w
  and  a.cd_banco            = b.cd_banco
  and coalesce(a.IE_SITUACAO,'A') = 'A'
and   'S' = verifica_conta_estab( a.cd_banco, a.cd_agencia_bancaria, a.nr_conta, a.cd_pessoa_fisica, null, cd_estabelecimento_w)
order by 1, 2;	
				

BEGIN

select	max(a.cd_pessoa_fisica),
	max(a.cd_cgc),
	max(a.cd_estabelecimento)
into STRICT	cd_pessoa_fisica_w,
	cd_cgc_w,
	cd_estabelecimento_w
from	titulo_pagar a
where	a.nr_titulo	= nr_titulo_p;

open C01;
loop
fetch C01 into	
	cd_banco_w,
	cd_Banco_externo_w,
	cd_agencia_bancaria_w,
	ie_digito_agencia_w,
	nr_conta_w,
	ds_banco_w,
	nr_digito_conta_w,
	cd_codigo_identificacao_w,
	ds_observacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	select	nextval('titulo_pagar_seq')
	into STRICT	nr_sequencia_w
	;
	
	insert	into	titulo_pagar_favorecido(cd_agencia_bancaria,
				cd_cgc,
				cd_codigo_identificacao,
				cd_pessoa_fisica,
				dt_atualizacao,
				dt_atualizacao_nrec,
				ie_digito_agencia,
				nm_usuario,
				nm_usuario_nrec,
				nr_conta,
				nr_digito_conta,
				nr_sequencia,
				nr_titulo,
				cd_banco)
		values (cd_agencia_bancaria_w,
				cd_cgc_w,
				cd_codigo_identificacao_w,
				cd_pessoa_fisica_w,
				clock_timestamp(),
				clock_timestamp(),
				ie_digito_agencia_w,
				nm_usuario_p,
				nm_usuario_p,
				nr_conta_w,
				nr_digito_conta_w,
				nr_sequencia_w,
				nr_titulo_p,
				cd_banco_w);
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_titulo_pagar_fav (nr_titulo_p bigint, nm_usuario_p text) FROM PUBLIC;

