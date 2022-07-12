-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_forma_compra_cotacao ( nr_cot_compra_p bigint) RETURNS bigint AS $body$
DECLARE

 
nr_seq_forma_compra_w		bigint;			
			 

BEGIN 
 
select	max(a.nr_seq_forma_compra) 
into STRICT	nr_seq_forma_compra_w 
from	solic_compra a, 
	solic_compra_agrup_v b 
where	a.nr_solic_compra = b.nr_solic_compra 
and	b.nr_cot_compra = nr_cot_compra_p;
 
return	nr_seq_forma_compra_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_forma_compra_cotacao ( nr_cot_compra_p bigint) FROM PUBLIC;

