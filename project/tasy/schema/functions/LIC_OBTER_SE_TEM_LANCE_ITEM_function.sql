-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_se_tem_lance_item ( nr_seq_fornec_p bigint, nr_seq_lic_item_p bigint) RETURNS varchar AS $body$
DECLARE


qt_existe_w		bigint;
ie_possui_w		varchar(1) := 'N';


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	reg_lic_fornec_lance
where	nr_seq_fornec = nr_seq_fornec_p
and	nr_seq_lic_item = nr_seq_lic_item_p;

if (qt_existe_w > 0) then
	ie_possui_w := 'S';
end if;

return	ie_possui_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_se_tem_lance_item ( nr_seq_fornec_p bigint, nr_seq_lic_item_p bigint) FROM PUBLIC;

