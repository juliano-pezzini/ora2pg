-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_fpo_cbo ( cd_cbo_p text, nr_seq_regra_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(15) := 'N';
qt_cbo_w			bigint := 0;


BEGIN

begin
select	coalesce(count(*),0)
into STRICT	qt_cbo_w
from	sus_fpo_regra_cbo
where	cd_cbo		= cd_cbo_p
and	nr_seq_fpo_regra	= nr_seq_regra_p;
exception
when others then
	qt_cbo_w := 0;
end;

if (coalesce(qt_cbo_w,0) > 0) then
	ds_retorno_w := 'S';
else
	ds_retorno_w := 'N';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_fpo_cbo ( cd_cbo_p text, nr_seq_regra_p bigint) FROM PUBLIC;
