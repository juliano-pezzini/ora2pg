-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_titulo_texto_tasy ( nr_seq_texto_p bigint) RETURNS varchar AS $body$
DECLARE


ds_titulo_w	varchar(100);


BEGIN
if (nr_seq_texto_p IS NOT NULL AND nr_seq_texto_p::text <> '') then
	select	max(ds_titulo)
	into STRICT	ds_titulo_w
	from	tasy_texto
	where	nr_sequencia = nr_seq_texto_p;
end if;

return ds_titulo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_titulo_texto_tasy ( nr_seq_texto_p bigint) FROM PUBLIC;
