-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_order_units_with_one_item (lista_itens_p text) RETURNS varchar AS $body$
DECLARE


lista_itens_w 				varchar(4000);
lista_itens_aux_w 			varchar(4000);
ie_exists_w	                varchar(1);
nr_seq_cpoe_order_unit_w	cpoe_order_unit.nr_sequencia%type;
nr_order_unit_w             cpoe_order_unit.nr_order_unit%type;


BEGIN

if (lista_itens_p IS NOT NULL AND lista_itens_p::text <> '') then
	lista_itens_aux_w := lista_itens_p;
	while(lista_itens_aux_w IS NOT NULL AND lista_itens_aux_w::text <> '') loop
	
		nr_seq_cpoe_order_unit_w := substr( lista_itens_aux_w,1,position(',' in lista_itens_aux_w) - 1);
		lista_itens_aux_w := substr(lista_itens_aux_w, position(',' in lista_itens_aux_w) + 1, length(lista_itens_aux_w) - 1);
		
		select	coalesce(max('S'),'N')
		into STRICT	ie_exists_w
		from   	itens_cpoe_v
		where 	nr_seq_cpoe_order_unit = nr_seq_cpoe_order_unit_w;

		if (ie_exists_w = 'N') then
            select nr_order_unit
            into STRICT nr_order_unit_w
            from cpoe_order_unit
            where nr_sequencia = nr_seq_cpoe_order_unit_w;

			lista_itens_w := lista_itens_w || nr_seq_cpoe_order_unit_w || ';' || nr_order_unit_w || ',';
		end if;	

	end loop;
end if;

return lista_itens_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_order_units_with_one_item (lista_itens_p text) FROM PUBLIC;

