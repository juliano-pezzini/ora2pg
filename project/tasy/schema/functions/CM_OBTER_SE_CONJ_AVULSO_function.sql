-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cm_obter_se_conj_avulso ( nr_seq_conjunto_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1);
nr_seq_item_w		bigint;
qt_item_w		bigint;


BEGIN

ie_retorno_w	:= 'N';

select	count(*)
into STRICT	qt_item_w
from	cm_conjunto_item
where	nr_seq_conjunto = nr_seq_conjunto_p;

if (qt_item_w = 1) then
	begin

	select	nr_seq_item
	into STRICT	nr_seq_item_w
	from	cm_conjunto_item
	where	nr_seq_conjunto = nr_seq_conjunto_p;

	select	coalesce(max(ie_avulso),'N')
	into STRICT	ie_retorno_w
	from	cm_item
	where	nr_sequencia = nr_seq_item_w;

	end;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cm_obter_se_conj_avulso ( nr_seq_conjunto_p bigint) FROM PUBLIC;
