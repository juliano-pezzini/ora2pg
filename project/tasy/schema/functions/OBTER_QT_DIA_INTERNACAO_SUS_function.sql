-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_dia_internacao_sus ( cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS bigint AS $body$
DECLARE


qt_dia_internacao_sus_w	integer:= 0;


BEGIN

if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') then
	select	coalesce(qt_dia_internacao_sus,0)
	into STRICT	qt_dia_internacao_sus_w
	from	procedimento
	where	cd_procedimento = cd_procedimento_p
	and	ie_origem_proced = ie_origem_proced_p;
end if;

return	qt_dia_internacao_sus_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_dia_internacao_sus ( cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;
