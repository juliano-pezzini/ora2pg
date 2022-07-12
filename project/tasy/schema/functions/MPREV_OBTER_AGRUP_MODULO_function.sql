-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_agrup_modulo ( nr_seq_agrupamento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	mprev_agrupamento_modulo.nm_agrupamento%type;


BEGIN

if (coalesce(nr_seq_agrupamento_p,0)	<> 0) then
	select	nm_agrupamento
	into STRICT	ds_retorno_w
	from	mprev_agrupamento_modulo
	where	nr_sequencia = nr_seq_agrupamento_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_agrup_modulo ( nr_seq_agrupamento_p bigint) FROM PUBLIC;

