-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rop_obter_dados_operacao ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(80);
ds_operacao_w			varchar(80);
ie_operacao_w			varchar(15);
ie_avisa_fim_vida_util_w		varchar(1);

/*
D - Descrição
T - Tipo
A - Avisa vencimento vida útil
*/
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	select	ds_operacao,
		ie_operacao,
		coalesce(ie_avisa_fim_vida_util,'N')
	into STRICT	ds_operacao_w,
		ie_operacao_w,
		ie_avisa_fim_vida_util_w
	from	rop_operacao
	where	nr_sequencia	= nr_sequencia_p;

	if (ie_opcao_p = 'D') then
		ds_retorno_w	:= ds_operacao_w;
	elsif (ie_opcao_p = 'T') then
		ds_retorno_w	:= ie_operacao_w;
	elsif (ie_opcao_p = 'A') then
		ds_retorno_w	:= ie_avisa_fim_vida_util_w;
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rop_obter_dados_operacao ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
