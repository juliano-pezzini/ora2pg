-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_origem_procedimento_js ( cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_var_origem_proc_p bigint) RETURNS bigint AS $body$
DECLARE


ie_origem_proced_w	bigint;


BEGIN

ie_origem_proced_w := 0;

if (coalesce(cd_procedimento_p,0) > 0) and (coalesce(ie_origem_proced_p, 0) > 0) then
	select	coalesce(max(ie_origem_proced),0)
	into STRICT	ie_origem_proced_w
	from	procedimento
	where	cd_procedimento = cd_procedimento_p
	and	ie_origem_proced = ie_origem_proced_p;
end if;

if (coalesce(ie_origem_proced_w,0) = 0) then
	select	ie_origem_proced
	into STRICT	ie_origem_proced_w
	from	procedimento
	where	cd_procedimento = cd_procedimento_p
	and	ie_origem_proced = ie_var_origem_proc_p;
end if;

if (coalesce(ie_origem_proced_w,0) = 0) then
	select	ie_origem_proced
	into STRICT	ie_origem_proced_w
	from	procedimento
	where	cd_procedimento = cd_procedimento_p;
end if;

return	ie_origem_proced_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_origem_procedimento_js ( cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_var_origem_proc_p bigint) FROM PUBLIC;
