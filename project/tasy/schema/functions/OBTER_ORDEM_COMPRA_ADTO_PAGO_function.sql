-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ordem_compra_adto_pago (nr_adiantamento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(255);			
nr_ordem_compra_w	bigint;

C01 CURSOR FOR 
SELECT  a.nr_ordem_compra 
from   ordem_compra b, 
     ordem_compra_adiant_pago a 
where  a.nr_adiantamento  = nr_adiantamento_p 
and   b.nr_ordem_compra  = a.nr_ordem_compra 
order by 1;
			

BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_ordem_compra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
		if (coalesce(ds_retorno_w::text, '') = '') then 
			ds_retorno_w := nr_ordem_compra_w;
		else 
			ds_retorno_w := ds_retorno_w || ', ' || nr_ordem_compra_w;
		end if;
	end;
end loop;
close C01;
 
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ordem_compra_adto_pago (nr_adiantamento_p bigint) FROM PUBLIC;

