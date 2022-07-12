-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cm_obter_nome_item_orig ( nr_seq_item_cont_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255);
nr_seq_item_w			bigint;
nr_seq_conjunto_cont_w		bigint;
nr_seq_conjunto_w		bigint;
qt_existe_w			bigint;
nr_seq_item_orig_w		bigint;


BEGIN

select	nr_seq_item,
	nr_seq_conjunto
into STRICT	nr_seq_item_w,
	nr_seq_conjunto_cont_w
from	cm_item_cont
where	nr_sequencia = nr_seq_item_cont_p;

select	nr_seq_conjunto
into STRICT	nr_seq_conjunto_w
from	cm_conjunto_cont
where	nr_sequencia = nr_seq_conjunto_cont_w
and	coalesce(ie_situacao,'A') = 'A';

select	count(*)
into STRICT	qt_existe_w
from	cm_conjunto_item_sub
where	nr_seq_conjunto = nr_seq_conjunto_w
and	nr_seq_item_sub = nr_seq_item_w
and	coalesce(dt_final_vigencia::text, '') = '';

if (qt_existe_w <> 0) then
	begin

	select	max(nr_seq_item)
	into STRICT	nr_seq_item_orig_w
	from	cm_conjunto_item_sub
	where	nr_seq_conjunto = nr_seq_conjunto_w
	and	nr_seq_item_sub = nr_seq_item_w
	and	coalesce(dt_final_vigencia::text, '') = '';

	select	nm_item
	into STRICT	ds_retorno_w
	from	cm_item
	where	nr_sequencia = nr_seq_item_orig_w;

	end;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cm_obter_nome_item_orig ( nr_seq_item_cont_p bigint) FROM PUBLIC;

