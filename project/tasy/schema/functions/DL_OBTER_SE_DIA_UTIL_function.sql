-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION dl_obter_se_dia_util (dt_referencia_p timestamp, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


dt_aux_w	timestamp;
ie_dia_semana_w	varchar(01);
ie_feriado_w	varchar(01)	:= 'N';
ie_dia_util_w	varchar(01)	:= 'N';


BEGIN

select	pkg_date_utils.get_WeekDay(dt_referencia_p)
into STRICT	ie_dia_semana_w
;

select	coalesce(max('S'), 'N')
into STRICT	ie_feriado_w
from 	dl_feriado
where 	dt_feriado		= dt_referencia_p
and	cd_estabelecimento	= cd_estabelecimento_p;

if (pkg_date_utils.IS_BUSINESS_DAY(dt_referencia_p) = 1) and (ie_feriado_w = 'N') then
	ie_dia_util_w	:= 'S';
end if;

return ie_dia_util_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dl_obter_se_dia_util (dt_referencia_p timestamp, cd_estabelecimento_p bigint) FROM PUBLIC;

