-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_cardapio_dia (dt_referencia_p timestamp, ie_semana_p bigint, ie_dia_semana_p bigint) RETURNS varchar AS $body$
DECLARE


ie_liberado_w		varchar(01)	:= 'N';
ie_semana_dia_w		bigint;
ie_dia_semena_w		bigint;
ie_dia_sem_param_w	bigint;


BEGIN

select	somente_numero(pkg_date_utils.get_WeekDay(dt_referencia_p)),
	obter_semana_cardapio(dt_referencia_p)
into STRICT	ie_dia_semena_w,
	ie_semana_dia_w
;

ie_dia_sem_param_w	:= ie_dia_semana_p;

if	((coalesce(ie_dia_sem_param_w, ie_dia_semena_w) = ie_dia_semena_w) or (coalesce(ie_dia_sem_param_w, ie_dia_semena_w) = 9))and (coalesce(ie_semana_p, ie_semana_dia_w) = ie_semana_dia_w) then
	ie_liberado_w	:= 'S';
end if;




return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_cardapio_dia (dt_referencia_p timestamp, ie_semana_p bigint, ie_dia_semana_p bigint) FROM PUBLIC;

