-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION spa_obter_desc_rota_aprov ( nr_seq_rota_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(100);


BEGIN

if (nr_seq_rota_p IS NOT NULL AND nr_seq_rota_p::text <> '') then

	select	max(ds_rota_aprovacao)
	into STRICT	ds_retorno_w
	from	spa_rota_aprovacao
	where	nr_sequencia = nr_seq_rota_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION spa_obter_desc_rota_aprov ( nr_seq_rota_p bigint) FROM PUBLIC;
