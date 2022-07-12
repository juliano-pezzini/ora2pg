-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_contrato_lib_estab ( nr_seq_contrato_p bigint, cd_estab_adic_p bigint) RETURNS varchar AS $body$
DECLARE


qt_existe_w		bigint;
ie_existe_w		varchar(1) := 'N';


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	contrato_estab_adic
where	cd_estab_adic = cd_estab_adic_p
and	nr_seq_contrato = nr_seq_contrato_p;

if (qt_existe_w > 0) then
	ie_existe_w := 'S';
end if;

return	ie_existe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_contrato_lib_estab ( nr_seq_contrato_p bigint, cd_estab_adic_p bigint) FROM PUBLIC;

