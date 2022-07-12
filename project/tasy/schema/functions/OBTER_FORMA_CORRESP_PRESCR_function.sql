-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_forma_corresp_prescr ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ie_tipo_corresp_w	varchar(15);


BEGIN

begin
select	max(ie_tipo_corresp)
into STRICT	ie_tipo_corresp_w
from	pessoa_fisica_corresp
where	cd_pessoa_fisica	= cd_pessoa_fisica_p
and	ie_tipo_doc		= 'PM';
exception
when others then
	ie_tipo_corresp_w	:= null;
end;

if (coalesce(ie_tipo_corresp_w::text, '') = '') then
	begin
	select	max(ie_tipo_corresp)
	into STRICT	ie_tipo_corresp_w
	from	pessoa_fisica_corresp
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_tipo_doc		= 'Q';
	exception
	when others then
		ie_tipo_corresp_w	:= null;
	end;

end if;

return ie_tipo_corresp_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_forma_corresp_prescr ( cd_pessoa_fisica_p text) FROM PUBLIC;

