-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vl_bordero_pagar_liq (nr_bordero_p bigint) RETURNS bigint AS $body$
DECLARE

 
vl_bordero_novo_w	double precision;
vl_bordero_antigo_w	double precision;
/*criei essa function para obter o vl liquido, que dava problema em alguns relatórios. A function obter_valor_bordero_pagar traz o vl_titulo da tabela titulo_pagar_w. Não alterei essa ja existente para nao dar problema onde ja utilizam essa function*/
BEGIN 
 
select	coalesce(sum(vl_bordero),0) 
into STRICT	vl_bordero_novo_w 
from	bordero_tit_pagar 
where	nr_bordero	= nr_bordero_p;
 
select	coalesce(sum(vl_liquido_bordero),0) 
into STRICT	vl_bordero_antigo_w 
from	titulo_pagar_v 
where	nr_bordero	= nr_bordero_p;
 
return	vl_bordero_novo_w + vl_bordero_antigo_w;
 
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vl_bordero_pagar_liq (nr_bordero_p bigint) FROM PUBLIC;
