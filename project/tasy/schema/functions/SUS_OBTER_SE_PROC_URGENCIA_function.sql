-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_se_proc_urgencia ( cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS varchar AS $body$
DECLARE

qt_registro_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_registro_w
from	sus_proced_incremento_origem
where	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p
and	cd_habilitacao		in (2701,2702,2703);

if (qt_registro_w		= 0) then
	return	 'N';
else
	return	 'S';
end if;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_se_proc_urgencia ( cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;

