-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_tipo_hemodialise (ie_categoria_p text, ie_tipo_dialise_p text) RETURNS varchar AS $body$
DECLARE


ie_liberado_w	varchar(1) := 'S';
cont_w		bigint;


BEGIN

select	count(*)
into STRICT	cont_w
from	hd_hemodialise_categ
where	ie_tipo_hemodialise	= ie_tipo_dialise_p;

if (cont_w	> 0) then
	select	count(*)
	into STRICT	cont_w
	from	hd_hemodialise_categ
	where	ie_tipo_hemodialise	= ie_tipo_dialise_p
	and	ie_categoria		= ie_categoria_p;

	if (cont_w = 0) then
		ie_liberado_w	:= 'N';
	end if;
end if;

return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_tipo_hemodialise (ie_categoria_p text, ie_tipo_dialise_p text) FROM PUBLIC;

