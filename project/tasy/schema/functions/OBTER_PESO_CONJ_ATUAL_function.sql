-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_peso_conj_atual (nr_sequencia_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


qt_peso_total_w	        cm_item.qt_peso%type := 0;
qt_peso_w	        cm_item.qt_peso%type := 0;

C01 CURSOR FOR
	SELECT 	nr_seq_item
	from 	CM_ITEM_CONT
	where 	nr_seq_conjunto = nr_sequencia_p;	
	
C02 CURSOR FOR
	SELECT 	nr_seq_item
	from 	CM_CONJUNTO_ITEM
	where 	nr_seq_conjunto = nr_sequencia_p;	
	
BEGIN

if (ie_opcao_p = 'L') then

	for co1_w in C01 loop
			
		select qt_peso
		into STRICT qt_peso_w
		from cm_item
		where nr_sequencia = co1_w.nr_seq_item;
		
		qt_peso_total_w := qt_peso_total_w + coalesce(qt_peso_w,0);
		
	end loop;

elsif (ie_opcao_p = 'C') then

	for co2_w in C02 loop
			
		select qt_peso
		into STRICT qt_peso_w
		from cm_item
		where nr_sequencia = co2_w.nr_seq_item;
		
		qt_peso_total_w := qt_peso_total_w + coalesce(qt_peso_w,0);
		
	end loop;

end if;
	
return	qt_peso_total_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_peso_conj_atual (nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
