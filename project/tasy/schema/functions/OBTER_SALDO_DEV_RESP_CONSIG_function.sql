-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_dev_resp_consig ( nr_seq_item_p bigint) RETURNS bigint AS $body$
DECLARE


qt_material_w		double precision;
qt_saldo_w		double precision;


BEGIN

begin
select	coalesce(sum(a.qt_material),0)
into STRICT	qt_material_w
from	sup_resp_consig_item_dev a
where	a.nr_seq_item = nr_seq_item_p;
exception
	when no_data_found then
		qt_saldo_w := 0;
end;

select	sum(a.qt_material) - qt_material_w
into STRICT	qt_saldo_w
from	sup_resp_consig_item a
where	a.nr_sequencia = nr_seq_item_p;

return	qt_saldo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_dev_resp_consig ( nr_seq_item_p bigint) FROM PUBLIC;
