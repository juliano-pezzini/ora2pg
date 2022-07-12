-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_marcas_aceitaveis ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_marcas_w	 	varchar(2000);


BEGIN
select  	distinct substr(OBTER_MARCAS(a.CD_MATERIAL,'D','N'),1,255) ds_marcas
into STRICT	ds_marcas_w
from    	cot_compra_forn_item a,
        	cot_compra_forn_item_op b
where   	a.nr_sequencia = b.nr_seq_cot_item_forn
and     	b.nr_seq_cot_item_forn = nr_sequencia_p;

return	ds_marcas_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_marcas_aceitaveis ( nr_sequencia_p bigint) FROM PUBLIC;
