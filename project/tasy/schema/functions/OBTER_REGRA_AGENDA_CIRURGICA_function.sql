-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_agenda_cirurgica ( cd_agenda_p bigint, ie_turno_p text, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	   varchar(2000);
nm_regra_w	      varchar(255);
qt_horas_w	      double precision;
qt_feriado_w	   bigint := 0;
ie_dia_semana_w   varchar(15);

c01 CURSOR FOR
	SELECT  nm_regra
	from 	agenda_regra
	where (ie_turno = ie_turno_p or coalesce(ie_turno::text, '') = '') 
	and (IE_DIA_SEMANA =  ie_dia_semana_w or coalesce(IE_DIA_SEMANA::text, '') = '')
	and (cd_agenda = cd_agenda_p)
	and	((coalesce(qt_horas_ant_agenda,0) = 0) or (qt_horas_w > qt_horas_ant_agenda))
	and	dt_referencia_p between to_date(to_char(dt_referencia_p,'dd/mm/yyyy') || ' ' || coalesce(to_char(HR_INICIO,'hh24:mi:ss'),'00:00:00'),'dd/mm/yyyy hh24:mi:ss') and
					to_date(to_char(dt_referencia_p,'dd/mm/yyyy') || ' ' || coalesce(to_char(HR_FIM,'hh24:mi:ss'),'23:59:59'),'dd/mm/yyyy hh24:mi:ss')
	and	dt_referencia_p	between coalesce(dt_inicio_vigencia,to_date('01/01/1900 00:00:01','dd/mm/yyyy hh24:mi:ss')) and coalesce(dt_fim_vigencia,to_date('01/01/2099 23:59:59','dd/mm/yyyy hh24:mi:ss'))
	and (coalesce(ie_validar_dias_semana,'A') = 'A' 
	or (ie_validar_dias_semana = 'F' and qt_feriado_w > 0)
	or (ie_validar_dias_semana = 'D' and qt_feriado_w = 0) );

BEGIN

nm_regra_w	:= '';
qt_horas_w	:= (dt_referencia_p - clock_timestamp()) * 24;
if (dt_referencia_p IS NOT NULL AND dt_referencia_p::text <> '') then
   ie_dia_semana_w   := substr(obter_cod_dia_semana(dt_referencia_p),1,1);
	qt_feriado_w 	   := obter_se_feriado(obter_estabelecimento_ativo, dt_referencia_p);
end if;

open c01;
loop
fetch c01 into	
	nm_regra_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	if (nm_regra_w IS NOT NULL AND nm_regra_w::text <> '') then
		ds_retorno_w := substr(ds_retorno_w||' '||nm_regra_w,1,2000);	
	end if;
	end;
end loop;
close c01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_agenda_cirurgica ( cd_agenda_p bigint, ie_turno_p text, dt_referencia_p timestamp) FROM PUBLIC;
