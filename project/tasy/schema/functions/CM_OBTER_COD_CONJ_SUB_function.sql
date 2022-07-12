-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cm_obter_cod_conj_sub ( nr_seq_item_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255);
nr_seq_conjunto_w		bigint;
qt_existe_w			bigint;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	cm_conjunto_item a,
	cm_conjunto b
where	a.nr_seq_item = nr_seq_item_p
and	a.nr_seq_conjunto = b.nr_sequencia
and	coalesce(b.ie_reserva,'N') = 'S';

if (qt_existe_w <> 0) then
	begin

	select	max(b.nr_sequencia)
	into STRICT	nr_seq_conjunto_w
	from	cm_conjunto_item a,
		cm_conjunto b
	where	a.nr_seq_item = nr_seq_item_p
	and	a.nr_seq_conjunto = b.nr_sequencia
	and	coalesce(b.ie_reserva,'N') = 'S';

	select	cd_codigo
	into STRICT	ds_retorno_w
	from	cm_conjunto_item
	where	nr_seq_conjunto = nr_seq_conjunto_w
	and	nr_seq_item = nr_seq_item_p;

	end;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cm_obter_cod_conj_sub ( nr_seq_item_p bigint) FROM PUBLIC;

