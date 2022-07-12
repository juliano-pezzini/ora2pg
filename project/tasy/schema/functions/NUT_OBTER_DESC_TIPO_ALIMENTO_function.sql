-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_obter_desc_tipo_alimento ( nr_seq_tipo_alimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(80);

BEGIN

if (nr_seq_tipo_alimento_p IS NOT NULL AND nr_seq_tipo_alimento_p::text <> '') then

	select	ds_tipo
	into STRICT	ds_retorno_w
	from	nut_tipo_alimento
	where 	nr_sequencia	= nr_seq_tipo_alimento_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_obter_desc_tipo_alimento ( nr_seq_tipo_alimento_p bigint) FROM PUBLIC;
