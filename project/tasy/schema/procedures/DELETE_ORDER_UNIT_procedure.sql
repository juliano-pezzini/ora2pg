-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE delete_order_unit (nr_seq_cpoe_order_unit_p bigint) AS $body$
DECLARE


nr_seq_rp_w		dbms_sql.varchar2_table;
nr_seq_prev_order_unit_w  cpoe_order_unit.nr_seq_prev_order_unit%type;
c_rp CURSOR FOR
	SELECT	nr_sequencia
	from    cpoe_rp
	where   nr_seq_cpoe_order_unit = nr_seq_cpoe_order_unit_p;


BEGIN

if (nr_seq_cpoe_order_unit_p IS NOT NULL AND nr_seq_cpoe_order_unit_p::text <> '') then
    
    open c_rp;
    loop
        fetch c_rp bulk collect into nr_seq_rp_w
        limit 100;
        exit when nr_seq_rp_w.count = 0;
        forall i in nr_seq_rp_w.first..nr_seq_rp_w.last
            delete from cpoe_comment_linkage
            where nr_seq_cpoe_rp = nr_seq_rp_w(i);

        forall i in nr_seq_rp_w.first..nr_seq_rp_w.last
            delete from cpoe_rp
            where nr_sequencia = nr_seq_rp_w(i);
    end loop;
    close c_rp;

	select max(nr_seq_prev_order_unit)
	into STRICT nr_seq_prev_order_unit_w
	from cpoe_order_unit a
	where a.nr_sequencia = nr_seq_cpoe_order_unit_p
	and (a.nr_seq_prev_order_unit IS NOT NULL AND a.nr_seq_prev_order_unit::text <> '');

    delete from cpoe_comment_linkage
	where nr_seq_cpoe_order_unit = nr_seq_cpoe_order_unit_p;

    delete from cpoe_dias_proc_order_unit
	where nr_seq_cpoe_order_unit = nr_seq_cpoe_order_unit_p;

    delete from cpoe_weekday_proc
	where nr_seq_cpoe_order_unit = nr_seq_cpoe_order_unit_p;

	delete from medical_guidance_order
	where nr_seq_order_unit = nr_seq_cpoe_order_unit_p;

	delete from proc_interno_doenca
	where nr_seq_order_unit = nr_seq_cpoe_order_unit_p;

	delete from cpoe_order_unit
	where nr_sequencia = nr_seq_cpoe_order_unit_p;

	delete from cpoe_order_unit
	where nr_sequencia = nr_seq_prev_order_unit_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE delete_order_unit (nr_seq_cpoe_order_unit_p bigint) FROM PUBLIC;
