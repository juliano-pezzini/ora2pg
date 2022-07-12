-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION has_extcall_configuration ( nr_seq_external_call_p bigint) RETURNS varchar AS $body$
DECLARE


qt_records_w	bigint;
ds_return_w	varchar(1) := 'N'; --No
BEGIN


select	sum(amount)
into STRICT	qt_records_w
from (
        SELECT  count(*) amount
        from    obj_schem_estab a,
        	objeto_schematic_param b
        where   a.nr_seq_obj_schem_param = b.nr_sequencia
        and	b.nr_seq_obj_sch = nr_seq_external_call_p

union

        SELECT  count(*) amount
        from    obj_schem_perfil a,
        	objeto_schematic_param b
        where   a.nr_seq_obj_schem_param = b.nr_sequencia
        and	b.nr_seq_obj_sch = nr_seq_external_call_p
        
union

        select  count(*) amount
        from    obj_schem_usuario a,
        	objeto_schematic_param b
        where   a.nr_seq_obj_schem_param = b.nr_sequencia
        and	b.nr_seq_obj_sch = nr_seq_external_call_p
) alias4;

if (qt_records_w > 0) then
	ds_return_w := 'Y'; --Yes
end if;

return ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION has_extcall_configuration ( nr_seq_external_call_p bigint) FROM PUBLIC;
