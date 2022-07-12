-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_tipo_atend_hor ( cd_agenda_p bigint, dt_agenda_p timestamp, ie_tipo_atendimento_p bigint, ie_dia_semana_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE



ie_gerar_w		varchar(1) := 'S';


BEGIN

if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') and (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') and (ie_tipo_atendimento_p IS NOT NULL AND ie_tipo_atendimento_p::text <> '') and (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '')then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_gerar_w
	from	ageint_regra_turno_tipo
	where	cd_agenda 				= cd_agenda_p
	and		ie_tipo_atendimento		= ie_tipo_atendimento_p
	and		coalesce(cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p
	and		((dt_dia_semana = ie_dia_semana_p) or ((dt_dia_semana = 9) and (ie_dia_Semana_p not in (7,1))) or (coalesce(dt_dia_semana::text, '') = ''))
	and		dt_agenda_p between to_date(to_char(coalesce(dt_inicial_vigencia, trunc(dt_agenda_p)), 'dd/mm/yyyy') || ' ' || to_char(hr_inicial, 'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
		and to_date(to_char(coalesce(dt_final_vigencia, trunc(dt_agenda_p)), 'dd/mm/yyyy') || ' ' || to_char(hr_final, 'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');

end if;

return	ie_gerar_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_tipo_atend_hor ( cd_agenda_p bigint, dt_agenda_p timestamp, ie_tipo_atendimento_p bigint, ie_dia_semana_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

