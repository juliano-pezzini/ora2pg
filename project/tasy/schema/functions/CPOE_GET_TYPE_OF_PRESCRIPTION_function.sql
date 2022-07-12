-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_get_type_of_prescription (nr_seq_cpoe_order_unit_p cpoe_material.nr_seq_cpoe_order_unit%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	cpoe_order_unit.si_type_of_prescription%type;

BEGIN

if (coalesce(nr_seq_cpoe_order_unit_p,0) > 0) then
	
	begin
		select	si_type_of_prescription
		into STRICT	ds_retorno_w
		from	cpoe_order_unit
		where	nr_sequencia = nr_seq_cpoe_order_unit_p;
	exception
	when no_data_found then
		ds_retorno_w := null;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_get_type_of_prescription (nr_seq_cpoe_order_unit_p cpoe_material.nr_seq_cpoe_order_unit%type) FROM PUBLIC;

