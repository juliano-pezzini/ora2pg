-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cr_obter_valor_liquido_tit (nr_titulo_p bigint, vl_baixa_p bigint) RETURNS bigint AS $body$
DECLARE

 
ds_retorno_w		double precision := 0;			
vl_tributo_tot_w	double precision;
vl_tributo_w		double precision;
qt_baixas_w		bigint;
			

BEGIN 
 
select 	sum(vl_tributo) 
into STRICT	vl_tributo_tot_w 
from	TITULO_RECEBER_TRIB 
where	nr_titulo = nr_titulo_p;
 
 
select 	count(*) 
into STRICT	qt_baixas_w 
from	titulo_receber_liq 
where	nr_titulo = nr_titulo_p;
 
if qt_baixas_w > 0 then 
	ds_retorno_w := vl_baixa_p - (vl_tributo_tot_w/qt_baixas_w);
end if;
	 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cr_obter_valor_liquido_tit (nr_titulo_p bigint, vl_baixa_p bigint) FROM PUBLIC;

