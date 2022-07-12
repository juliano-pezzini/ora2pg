-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_char_repetido ( nr_char_ascii_p bigint, qt_repeticoes_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000) := null;

BEGIN

for i in 1..qt_repeticoes_p loop
	ds_retorno_w := ds_retorno_w || chr(nr_char_ascii_p);
end loop;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_char_repetido ( nr_char_ascii_p bigint, qt_repeticoes_p bigint) FROM PUBLIC;

