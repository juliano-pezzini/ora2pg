-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mp_obter_dados_processo (nr_seq_processo_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255)	:= null;
nm_processo_w	varchar(80);

/*
N - Nome do processo
*/
BEGIN

if (nr_seq_processo_p IS NOT NULL AND nr_seq_processo_p::text <> '') then
	select	nm_processo
	into STRICT	nm_processo_w
	from	mp_processo
	where	nr_sequencia	= nr_seq_processo_p;

	if (ie_opcao_p = 'N') then
		ds_retorno_w	:= nm_processo_w;
	end if;
end if;


return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mp_obter_dados_processo (nr_seq_processo_p bigint, ie_opcao_p text) FROM PUBLIC;

