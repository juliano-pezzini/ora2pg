-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_status ( ie_status_agenda_p text, ie_tipo_agenda_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


/*
ie_tipo_agenda_p
1 - Gestão da Agenda Cirúrgica
*/
ie_exibe_w	varchar(1) := 'S';
qt_regra_w	smallint;


BEGIN

select	count(*)
into STRICT	qt_regra_w
from	regra_status_agenda
where	ie_agenda_cirur	= 'S'
and	ie_tipo_agenda_p = 1;

if (qt_regra_w > 0) then
	begin
	select	coalesce(max('S'),'N')
	into STRICT	ie_exibe_w
	from	regra_status_agenda
	where	ie_status_agenda	= ie_status_agenda_p
	and	ie_agenda_cirur		= 'S';
	end;
end if;

return	ie_exibe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_status ( ie_status_agenda_p text, ie_tipo_agenda_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
