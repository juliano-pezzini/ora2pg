-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_banco_dest (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_resultado_w			varchar(100);

ds_banco_w		varchar(40);
cd_agencia_bancaria_w	varchar(8);
ds_agencia_bancaria_w	varchar(40);
cd_conta_w		banco_estabelecimento.cd_conta%type;
ie_digito_conta_w	varchar(2);
ie_digito_agencia_w	varchar(2);


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	select 	b.ds_banco,
		a.cd_agencia_bancaria,
		a.cd_conta,
		a.ie_digito_conta,
		a.ie_digito_agencia
	into STRICT 	ds_banco_w,
		cd_agencia_bancaria_w,
		cd_conta_w,
		ie_digito_conta_w,
		ie_digito_agencia_w
	FROM banco_estabelecimento_v a
LEFT OUTER JOIN banco b ON (a.cd_banco = b.cd_banco)
WHERE a.nr_sequencia = nr_sequencia_p;

	select	max(a.ds_agencia_bancaria)
	into STRICT	ds_agencia_bancaria_w
	from	agencia_bancaria a
	where	a.cd_agencia_bancaria	= cd_agencia_bancaria_w;

	ds_resultado_w	:= ds_banco_w || ' - ' || cd_agencia_bancaria_w ||'-'|| ie_digito_agencia_w || ' - ' || cd_conta_w||'-'||ie_digito_conta_w;
end if;

return ds_resultado_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_banco_dest (nr_sequencia_p bigint) FROM PUBLIC;

