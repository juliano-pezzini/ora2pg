-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_atualiza_item_conj ( nr_seq_item_p bigint, nr_seq_conjunto_p bigint, ie_status_item_p text) AS $body$
DECLARE


nr_seq_item_w	bigint;
qt_existe_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	cm_conjunto_item_sub
where	nr_seq_conjunto = nr_seq_conjunto_p
and	nr_seq_item_sub = nr_seq_item_p
and	coalesce(dt_final_vigencia::text, '') = '';

if (qt_existe_w <> 0) then
	begin
	select	nr_seq_item
	into STRICT	nr_seq_item_w
	from	cm_conjunto_item_sub
	where	nr_seq_conjunto = nr_seq_conjunto_p
	and	nr_seq_item_sub = nr_seq_item_p
	and	coalesce(dt_final_vigencia::text, '') = '';

	update	cm_conjunto_item
	set	ie_status_item = ie_status_item_p
	where	nr_seq_conjunto = nr_seq_conjunto_p
	and	nr_seq_item = nr_seq_item_w;

	end;

elsif (qt_existe_w = 0) then

	update	cm_conjunto_item
	set	ie_status_item = ie_status_item_p
	where	nr_seq_conjunto = nr_seq_conjunto_p
	and	nr_seq_item = nr_seq_item_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_atualiza_item_conj ( nr_seq_item_p bigint, nr_seq_conjunto_p bigint, ie_status_item_p text) FROM PUBLIC;
