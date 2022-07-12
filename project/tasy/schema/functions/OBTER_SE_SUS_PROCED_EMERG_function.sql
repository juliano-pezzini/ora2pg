-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_sus_proced_emerg ( cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS varchar AS $body$
DECLARE


cont_w			smallint;
ie_pertence_w		varchar(1);


BEGIN

select	count(*)
into STRICT	cont_w
from	sus_proced_urg_emerg
where	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p;

ie_pertence_w	:= 'N';
if (cont_w > 0) then
	ie_pertence_w	:= 'S';
end if;

return ie_pertence_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_sus_proced_emerg ( cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;

