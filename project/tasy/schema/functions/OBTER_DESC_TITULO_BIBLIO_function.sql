-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_titulo_biblio ( nr_sequencia_p bigint ) RETURNS varchar AS $body$
DECLARE


ds_titulo_w	varchar(80);


BEGIN

select	max(ds_titulo)
into STRICT	ds_titulo_w
from	referencia_bibliografica
where	nr_sequencia	=	nr_sequencia_p;

return 	ds_titulo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_titulo_biblio ( nr_sequencia_p bigint ) FROM PUBLIC;

