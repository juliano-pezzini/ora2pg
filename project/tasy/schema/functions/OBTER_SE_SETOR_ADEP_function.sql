-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_setor_adep (cd_setor_atend_p bigint) RETURNS varchar AS $body$
DECLARE


ie_adep_w	varchar(1);


BEGIN
if (cd_setor_atend_p IS NOT NULL AND cd_setor_atend_p::text <> '') then
	select	coalesce(max(ie_adep),'N')
	into STRICT	ie_adep_w
	from	setor_atendimento
	where	cd_setor_atendimento = cd_setor_atend_p;

	if (ie_adep_w = 'P') then
		ie_adep_w	:= 'N';
	end if;

end if;

return ie_adep_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_setor_adep (cd_setor_atend_p bigint) FROM PUBLIC;

