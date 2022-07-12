-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_existe_receita_preparo ( nr_seq_receita_p bigint, nr_seq_tipo_preparo_p bigint) RETURNS varchar AS $body$
DECLARE



ie_retorno_w	varchar(1);

BEGIN

if (nr_seq_receita_p IS NOT NULL AND nr_seq_receita_p::text <> '') then

	select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_retorno_w
	from	nut_receita_comp
	where	nr_seq_receita 		= nr_seq_receita_p
	and	nr_seq_tipo_preparo 	= nr_seq_tipo_preparo_p;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_existe_receita_preparo ( nr_seq_receita_p bigint, nr_seq_tipo_preparo_p bigint) FROM PUBLIC;
