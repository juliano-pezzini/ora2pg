-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_estab_entrega_med (nr_seq_entrega_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(60);


BEGIN

if (nr_seq_entrega_p IS NOT NULL AND nr_seq_entrega_p::text <> '') then
	select max(cd_estabelecimento)
	into STRICT ds_retorno_w
	from fa_entrega_medicacao
	where nr_sequencia = nr_seq_entrega_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_estab_entrega_med (nr_seq_entrega_p bigint) FROM PUBLIC;
