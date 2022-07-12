-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_se_proc_estomia ( cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255) := 'N';
qt_proc_estomia_w		bigint := 0;


BEGIN

select	count(*)
into STRICT	qt_proc_estomia_w
from	sus_regra_proc_estomia
where	cd_procedimento = cd_procedimento_p
and	ie_origem_proced = ie_origem_proced_p
and	ie_situacao = 'A';

if (qt_proc_estomia_w > 0) then
	ds_retorno_w := 'S';
end if;

return	coalesce(ds_retorno_w,'N');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_se_proc_estomia ( cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;

