-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_bordero_tit_pag ( nr_titulo_p bigint) RETURNS varchar AS $body$
DECLARE


nr_bordero_w bigint;
ds_retorno_w varchar(4000);

c01 CURSOR FOR
SELECT	a.nr_bordero
from	titulo_pagar a
where	(a.nr_bordero IS NOT NULL AND a.nr_bordero::text <> '')
and	a.nr_titulo	= nr_titulo_p

union

SELECT	a.nr_bordero
from	bordero_tit_pagar a
where	a.nr_titulo	= nr_titulo_p;


BEGIN

open c01;
loop
fetch c01 into
nr_bordero_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

if (nr_bordero_w > 0) then
    case     
    WHEN coalesce(ds_retorno_w::text, '') = ''  THEN 
        ds_retorno_w := nr_bordero_w;
    else  
        ds_retorno_w :=  ds_retorno_w ||','||nr_bordero_w;
    END case;
end if;

end loop;
close c01;

return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_bordero_tit_pag ( nr_titulo_p bigint) FROM PUBLIC;
