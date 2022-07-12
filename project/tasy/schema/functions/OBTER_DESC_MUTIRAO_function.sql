-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_mutirao (nr_seq_mutirao_p bigint) RETURNS varchar AS $body$
DECLARE


nm_mutirao_w	mutirao_lista_espera.nm_mutirao%type;


BEGIN

if (nr_seq_mutirao_p IS NOT NULL AND nr_seq_mutirao_p::text <> '')then
	
	select  max(nm_mutirao)
	into STRICT 	nm_mutirao_w
	from    MUTIRAO_LISTA_ESPERA
	where	nr_Sequencia = nr_seq_mutirao_p;
	
end if;


return	nm_mutirao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_mutirao (nr_seq_mutirao_p bigint) FROM PUBLIC;

