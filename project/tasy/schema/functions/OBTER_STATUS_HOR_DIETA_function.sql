-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_hor_dieta (ie_usa_servico_p text, nr_seq_horario_p bigint, dt_inicial_p timestamp, dt_final_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_status_w		varchar(10);
ie_status_horario_w	varchar(10);
ie_status_servico_w	varchar(10);
dt_suspensao_w		timestamp;
ie_suspenso_w		varchar(1);


BEGIN

select	coalesce(max(a.dt_suspensao),max(c.dt_suspensao)),
	coalesce(max(b.ie_suspenso),'N'),
	SUBSTR(plt_obter_status_hor_dieta_lib(max(c.dt_fim_horario),max(c.dt_suspensao),max(c.dt_lib_horario)),1,1),
	Obter_status_servico(max(a.nr_atendimento), max(a.nr_prescricao), max(b.nr_sequencia), max(dt_inicial_p), max(dt_final_p), max(c.dt_horario))
into STRICT	dt_suspensao_w,
	ie_suspenso_w,
	ie_status_horario_w,
	ie_status_servico_w
from	prescr_medica a,
	prescr_dieta b,
	prescr_dieta_hor c
where	a.nr_prescricao	= b.nr_prescricao
and	a.nr_prescricao	= c.nr_prescricao
and	b.nr_prescricao	= c.nr_prescricao
and	b.nr_sequencia	= c.nr_seq_dieta
and	c.nr_sequencia	= nr_seq_horario_p;

if (dt_suspensao_w IS NOT NULL AND dt_suspensao_w::text <> '') or (ie_suspenso_w	= 'S') then
	ie_status_w	:= 'S';
elsif (ie_usa_servico_p	= 'S') and (ie_status_servico_w IS NOT NULL AND ie_status_servico_w::text <> '') and (ie_status_servico_w	in ('N','A','S','W')) then
	ie_status_w	:= ie_status_servico_w;
else
	ie_status_w	:= ie_status_horario_w;
end if;

return	ie_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_hor_dieta (ie_usa_servico_p text, nr_seq_horario_p bigint, dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;
