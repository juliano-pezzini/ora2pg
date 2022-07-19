-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verificar_regra_exec_exame ( nr_prescricao_p bigint, ie_valida_p INOUT text) AS $body$
DECLARE




cd_dia_semana_w			varchar(1);
ie_feriado_w			bigint;
dt_liberacao_w			timestamp;
ds_retorno_w			varchar(2) := 'S';

ie_horario_verificacao_w	varchar(2);
hr_inicio_w 			timestamp;
hr_fim_w 			timestamp;
ie_atender_sem_autorizacao_w	varchar(1);
cd_estabelecimento_w		smallint;
dt_referencia_w			timestamp;


C01 CURSOR FOR
	SELECT  coalesce(ie_horario_verificacao, 'L'),
		hr_inicio,
		hr_fim,
		coalesce(ie_atender_sem_autorizacao,'N')
	from    regra_exec_exame a
	where   ie_feriado_w = 0
	and	((coalesce(ie_dia_semana,cd_dia_semana_w) = cd_dia_semana_w) or (ie_dia_semana = 9 and cd_dia_semana_w not in ('7','1')));



BEGIN

select  max(dt_liberacao),
	max(cd_estabelecimento)
into STRICT	dt_liberacao_w,
	cd_estabelecimento_w
from    prescr_medica a
where   a.nr_prescricao = nr_prescricao_p;

cd_dia_semana_w := substr(Obter_Cod_Dia_Semana(dt_liberacao_w),1,1);

ie_feriado_w := coalesce(Obter_Se_Feriado(cd_estabelecimento_w, dt_liberacao_w),0);

open C01;
loop
fetch C01 into
	ie_horario_verificacao_w,
	hr_inicio_w,
	hr_fim_w,
	ie_atender_sem_autorizacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (ie_horario_verificacao_w = 'E') then
		dt_referencia_w := clock_timestamp();
	elsif (ie_horario_verificacao_w = 'L') then
		dt_referencia_w := dt_liberacao_w;
	end if;

	if (dt_referencia_w IS NOT NULL AND dt_referencia_w::text <> '') then

		hr_inicio_w := PKG_DATE_UTILS.get_datetime(dt_referencia_w, coalesce(hr_inicio_w, PKG_DATE_UTILS.get_Time('00:00:00')));
		hr_fim_w := PKG_DATE_UTILS.get_datetime(dt_referencia_w, coalesce(hr_fim_w, PKG_DATE_UTILS.get_Time('00:00:00')));

		if (hr_inicio_w > hr_fim_w) and (hr_fim_w > dt_referencia_w) and (hr_inicio_w > dt_referencia_w) then

			hr_inicio_w := (hr_inicio_w - 1);

		elsif (hr_inicio_w > hr_fim_w) then
			hr_fim_w := (hr_fim_w + 1);
		end if;

		if ( dt_referencia_w between hr_inicio_w and hr_fim_w ) then

			if (ie_atender_sem_autorizacao_w = 'N') then
				ds_retorno_w :=  'N';
			else
				ds_retorno_w :=  'S';
			end if;
		end if;
	else
		ds_retorno_w := 'N';
	end if;

	end;
end loop;
close C01;

ie_valida_p	:= ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verificar_regra_exec_exame ( nr_prescricao_p bigint, ie_valida_p INOUT text) FROM PUBLIC;

