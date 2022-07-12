-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dt_pagam_previ_tit (nr_titulo_p bigint) RETURNS timestamp AS $body$
DECLARE

dt_retorno_w timestamp;

BEGIN
 
if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then 
	begin 
	 
	select max(coalesce(dt_pagamento_previsto, null)) 
	into STRICT  dt_retorno_w 
	from  titulo_receber_v 
	where nr_titulo = nr_titulo_p;
	 
	exception 
		when others then 
			dt_retorno_w	:= null;
	end;
end if;
 
return	to_char(dt_retorno_w,'dd/mm/yyyy');
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dt_pagam_previ_tit (nr_titulo_p bigint) FROM PUBLIC;
