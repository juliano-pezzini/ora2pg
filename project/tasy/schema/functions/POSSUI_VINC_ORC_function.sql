-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION possui_vinc_orc ( ie_tipo_atend_pac_p bigint, ie_tipo_atend_orc_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tipo_atend_w	varchar(1);
qt_regra_w	bigint;


BEGIN

select 	count(*)
into STRICT	qt_regra_w
from 	regra_vinc_tipo_atend_orc
where 	ie_situacao = 'A';

ie_tipo_atend_w:= 'S';

if (qt_regra_w > 0) then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_tipo_atend_w
	from	regra_vinc_tipo_atend_orc
	where	ie_situacao		= 'A'
	and	ie_tipo_atendimento	= ie_tipo_atend_pac_p
	and	coalesce(ie_tipo_atend_orc, coalesce(ie_tipo_atend_orc_p,0)) = coalesce(ie_tipo_atend_orc_p,0);

end if;

return	ie_tipo_atend_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION possui_vinc_orc ( ie_tipo_atend_pac_p bigint, ie_tipo_atend_orc_p bigint) FROM PUBLIC;

