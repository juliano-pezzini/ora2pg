-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_nome_grupo (nr_seq_grupo_integrada_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN
if (nr_seq_grupo_integrada_p IS NOT NULL AND nr_seq_grupo_integrada_p::text <> '') then

	select	substr(coalesce(a.nm_curto, a.ds_grupo),1,255)||' "'||b.ds_area||'"'
	into STRICT	ds_retorno_w
	from	agenda_int_grupo a,
			agenda_int_area b
	where	a.nr_seq_area	= b.nr_sequencia
	and		a.nr_sequencia 	= nr_seq_grupo_integrada_p;

end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_nome_grupo (nr_seq_grupo_integrada_p bigint) FROM PUBLIC;
