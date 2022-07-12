-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_grupo_carencia ( nr_seq_grupo_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000);


BEGIN

if (ie_opcao_p = 'N') then
	begin
	select	ds_grupo
	into STRICT	ds_retorno_w
	from	pls_grupo_carencia
	where	nr_sequencia	= nr_seq_grupo_p;
	exception
	when others then
		ds_retorno_w	:= null;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_grupo_carencia ( nr_seq_grupo_p bigint, ie_opcao_p text) FROM PUBLIC;

