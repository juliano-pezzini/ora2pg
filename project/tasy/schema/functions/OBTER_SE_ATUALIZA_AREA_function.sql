-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atualiza_area ( nr_sequencia_p bigint, nr_prescricao_p bigint, dt_horario_p timestamp, qt_min_inicio_p bigint, qt_max_inicio_p bigint) RETURNS varchar AS $body$
DECLARE



ie_atualiza_w		varchar(1) := 'S';
qt_minuto_w		bigint;
dt_horario_w		timestamp;
dt_liberacao_w		timestamp;


BEGIN

if (coalesce(qt_min_inicio_p::text, '') = '') and (coalesce(qt_max_inicio_p::text, '') = '') then
	ie_atualiza_w := 'S';
else
	select	max(clock_timestamp())
	into STRICT	dt_liberacao_w
	from	prescr_medica
	where	nr_prescricao	=	nr_prescricao_p;

	if (dt_horario_p IS NOT NULL AND dt_horario_p::text <> '') and (dt_liberacao_w IS NOT NULL AND dt_liberacao_w::text <> '') then

		qt_minuto_w := coalesce(Obter_Min_Entre_Datas(dt_liberacao_w,dt_horario_p,1),0);

		select	coalesce(max('S'),'N')
		into STRICT	ie_atualiza_w
		
		where	qt_minuto_w between coalesce(qt_min_inicio_p,-999999999) and coalesce(qt_max_inicio_p,999999999);
	end if;
end if;

return ie_atualiza_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atualiza_area ( nr_sequencia_p bigint, nr_prescricao_p bigint, dt_horario_p timestamp, qt_min_inicio_p bigint, qt_max_inicio_p bigint) FROM PUBLIC;
