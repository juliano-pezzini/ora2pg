-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_lote_numeracao ( nr_seq_lote_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

qt_retorno_w 	bigint;

/*ie_opcao_p:
S = utilizador
N = Não utilizados
T = Total*/
BEGIN

if (ie_opcao_p = 'S') then
	select 	count(*)
	into STRICT	qt_retorno_w
	from	sus_lote_numeracao_item
	where	nr_seq_lote_numeracao	= nr_seq_lote_p
	and	ie_utilizado		= 'S';
elsif (ie_opcao_p = 'N') then
	select 	count(*)
	into STRICT	qt_retorno_w
	from	sus_lote_numeracao_item
	where	nr_seq_lote_numeracao	= nr_seq_lote_p
	and	ie_utilizado		= 'N';
elsif (ie_opcao_p = 'T') then
	select 	count(*)
	into STRICT	qt_retorno_w
	from	sus_lote_numeracao_item
	where	nr_seq_lote_numeracao	= nr_seq_lote_p;
end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_lote_numeracao ( nr_seq_lote_p bigint, ie_opcao_p text) FROM PUBLIC;

