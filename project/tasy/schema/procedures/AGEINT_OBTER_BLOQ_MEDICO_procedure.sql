-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_obter_bloq_medico (cd_pessoa_fisica_p text, cd_agenda_p bigint, dt_agenda_p timestamp, cd_convenio_p bigint, ds_motivo_p INOUT text, qt_Regra_p INOUT bigint) AS $body$
DECLARE


ds_retorno_w		varchar(255);
ie_dia_semana_w		integer;			
qt_regra_w			bigint;
			

BEGIN
 -- caso mexer nesse lugar verificar a function get_ageint_Obter_Bloq_Medico na ageint_sugerir_horarios_pck
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	ie_dia_semana_w := ageint_sugerir_horarios_pck.get_Obter_Cod_Dia_Semana(dt_agenda_p);

	select	max(obter_valor_dominio(1007,ie_motivo_bloqueio)),
			count(*)
	into STRICT	ds_retorno_w,
			qt_regra_w
	from	ageint_bloqueio_medico
	where	cd_pessoa_fisica			= cd_pessoa_fisica_p
	and		coalesce(cd_agenda, cd_agenda_p)	= cd_agenda_p
	and		trunc(dt_agenda_p) between dt_inicial and dt_final
	and (dt_agenda_p between to_date(to_char(dt_agenda_p,'dd/mm/yyyy') ||' '|| to_char(hr_inicial_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') 
	and 	to_date(to_char(dt_agenda_p,'dd/mm/yyyy') ||' '|| to_char(hr_final_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
	or (coalesce(hr_inicial_bloqueio::text, '') = ''
	and		coalesce(hr_final_bloqueio::text, '') = ''))
	and		((coalesce(ie_dia_semana, ie_dia_semana_w)	= ie_dia_semana_w) or (ie_dia_Semana = 9))
	and		coalesce(cd_convenio, cd_convenio_p)	= cd_Convenio_p;
	
end if;

qt_regra_p	:= qt_regra_w;
ds_motivo_p	:= ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_obter_bloq_medico (cd_pessoa_fisica_p text, cd_agenda_p bigint, dt_agenda_p timestamp, cd_convenio_p bigint, ds_motivo_p INOUT text, qt_Regra_p INOUT bigint) FROM PUBLIC;
