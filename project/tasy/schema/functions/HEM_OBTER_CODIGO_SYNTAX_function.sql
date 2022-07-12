-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hem_obter_codigo_syntax ( nr_seq_lesao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(3);
nr_seq_segmento_w	bigint;


BEGIN
if (coalesce(nr_seq_lesao_p,0) > 0) then
	ds_retorno_w := '';

	select	max(nr_seq_segmento)
	into STRICT	nr_seq_segmento_w
	from	hem_syntax_segmento
	where	nr_seq_lesao = nr_seq_lesao_p
	and	ie_start = 'S';

	if (coalesce(nr_seq_segmento_w,0) > 0) then

		select	max(cd_segmento)
		into STRICT	ds_retorno_w
		from	hem_segmento_princ
		where	nr_sequencia = nr_seq_segmento_w;

	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hem_obter_codigo_syntax ( nr_seq_lesao_p bigint) FROM PUBLIC;

