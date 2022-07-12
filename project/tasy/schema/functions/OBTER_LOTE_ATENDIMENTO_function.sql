-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lote_atendimento (nr_atendimento_p bigint, cd_estabelecimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(20);

/*
ie_opcao_p
LF	- Lote fabricação (cd_lote_fabricacao)
DT	- Data validade (dt_validade)
*/
BEGIN

if (ie_opcao_p = 'LF') then
	select	max(cd_lote_fabricacao)
	into STRICT	ds_retorno_w
	from	nota_fiscal_item
	where	nr_atendimento = nr_atendimento_p;
elsif (ie_opcao_p = 'LF') then
	select	to_char(min(dt_validade),'dd/mm/yyyy')
	into STRICT	ds_retorno_w
	from	nota_fiscal_item
	where	nr_atendimento = nr_atendimento_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lote_atendimento (nr_atendimento_p bigint, cd_estabelecimento_p bigint, ie_opcao_p text) FROM PUBLIC;

