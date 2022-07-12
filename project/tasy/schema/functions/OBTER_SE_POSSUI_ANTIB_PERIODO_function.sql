-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_possui_antib_periodo ( nr_atendimento_p bigint, qt_hora_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_prescricao_liberada_p text) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1);


BEGIN

select	coalesce(max('S'),'N')
into STRICT	ie_retorno_w
from	material c,
        prescr_material a,
		prescr_medica b
where	a.nr_prescricao	= b.nr_prescricao
and		a.cd_material	= c.cd_material
and		c.ie_controle_medico > 0
and		b.nr_atendimento = nr_atendimento_p
and		b.dt_prescricao - (CASE WHEN coalesce(c.ie_dias_util_medic,'N')='S' THEN coalesce(a.nr_dia_util-1,0)  ELSE coalesce(a.nr_dia_util,0) END ) between PKG_DATE_UTILS.START_OF(dt_inicial_p,'DD') and PKG_DATE_UTILS.END_OF(dt_final_p,'DAY')
and 	b.dt_prescricao	> clock_timestamp() - (qt_hora_p / 24)
and ((coalesce(b.dt_liberacao, b.dt_liberacao_medico) IS NOT NULL AND (coalesce(b.dt_liberacao, b.dt_liberacao_medico))::text <> '') or ie_prescricao_liberada_p = 'N');

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_possui_antib_periodo ( nr_atendimento_p bigint, qt_hora_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, ie_prescricao_liberada_p text) FROM PUBLIC;
