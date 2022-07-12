-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_mot_bloq_medico (cd_pessoa_fisica_p text, cd_agenda_p bigint, dt_agenda_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
ie_dia_semana_w		integer;


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	select 	obter_cod_dia_semana(dt_agenda_p)
	into STRICT	ie_dia_semana_w
	;

	select	max(obter_valor_dominio(1007,ie_motivo_bloqueio))
	into STRICT	ds_retorno_w
	from	ageint_bloqueio_medico
	where	cd_pessoa_fisica		= cd_pessoa_fisica_p
	and	coalesce(cd_agenda, cd_agenda_p)	= cd_agenda_p
	and	trunc(dt_agenda_p) between dt_inicial and dt_final
	and (dt_agenda_p between to_date(to_char(dt_agenda_p,'dd/mm/yyyy') ||' '|| to_char(hr_inicial_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
		and 	to_date(to_char(dt_agenda_p,'dd/mm/yyyy') ||' '|| to_char(hr_final_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
	or (coalesce(hr_inicial_bloqueio::text, '') = ''
	and	coalesce(hr_final_bloqueio::text, '') = ''))
	and	((coalesce(ie_dia_semana, ie_dia_semana_w)	= ie_dia_semana_w) or (ie_dia_Semana = 9));

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_mot_bloq_medico (cd_pessoa_fisica_p text, cd_agenda_p bigint, dt_agenda_p timestamp) FROM PUBLIC;
