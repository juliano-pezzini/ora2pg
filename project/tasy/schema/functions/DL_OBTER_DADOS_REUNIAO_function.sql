-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION dl_obter_dados_reuniao ( nr_seq_reuniao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);

/*	ie_opcao_p
	VL - valor reuniao
*/
BEGIN
ds_retorno_w		:= '';

if (ie_opcao_p = 'VL') then
	select	sum(coalesce(vl_reuniao,0))
	into STRICT	ds_retorno_w
	from	dl_reuniao_socio
	where	nr_seq_reuniao	= nr_seq_reuniao_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dl_obter_dados_reuniao ( nr_seq_reuniao_p bigint, ie_opcao_p text) FROM PUBLIC;

