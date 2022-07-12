-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cd_medico_laboratorio ( cd_cgc_laboratorio_p text) RETURNS varchar AS $body$
DECLARE


cd_medico_w	varchar(10);


BEGIN
select	max(cd_medico)
into STRICT	cd_medico_w
from	rep_laboratorio_medico
where	cd_cgc = cd_cgc_laboratorio_p;

if (coalesce(cd_medico_w::text, '') = '') then
	select	max(cd_pessoa_fisica)
	into STRICT	cd_medico_w
	from	medico
	where	cd_cgc = cd_cgc_laboratorio_p
	and	coalesce(ie_situacao,'A') <> 'I';
end if;

return	cd_medico_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cd_medico_laboratorio ( cd_cgc_laboratorio_p text) FROM PUBLIC;

