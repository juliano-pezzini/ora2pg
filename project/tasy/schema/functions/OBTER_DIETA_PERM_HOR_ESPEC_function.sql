-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dieta_perm_hor_espec (nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


ie_permite_w		varchar(1);
dt_inicio_prescr_w	timestamp;
nr_atendimento_w	bigint;


BEGIN

select	dt_inicio_prescr,
	nr_atendimento,
	Obter_se_prim_dieta_atend(nr_atendimento)
into STRICT	dt_inicio_prescr_w,
	nr_atendimento_w,
	ie_permite_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

if (ie_permite_w <> 'S') then

	select	coalesce(max('N'),'S')
	into STRICT	ie_permite_w
	from	prescr_dieta
	where	nr_prescricao = nr_prescricao_p;

	if (ie_permite_w = 'S') then

		select	coalesce(max('S'),'N')
		into STRICT	ie_permite_w
		from	prescr_medica b,
			rep_jejum a
		where	b.nr_atendimento	= nr_atendimento_w
		and	b.nr_prescricao		= a.nr_prescricao
		and	dt_inicio_prescr_w between coalesce(a.dt_inicio, b.dt_inicio_prescr) and coalesce(a.dt_fim, b.dt_validade_prescr)
		and	coalesce(b.dt_suspensao::text, '') = ''
		and	coalesce(a.ie_suspenso,'N') <> 'S'
		and	not exists (	SELECT 	distinct 1
					from	prescr_medica c,
						prescr_dieta d
					where	c.nr_atendimento = nr_atendimento_w
					and	c.nr_prescricao = d.nr_prescricao
					and	c.dt_inicio_prescr between coalesce(a.dt_inicio, b.dt_inicio_prescr) and coalesce(a.dt_fim, b.dt_validade_prescr)
					and	coalesce(b.dt_suspensao::text, '') = ''
					and	coalesce(a.ie_suspenso,'N') <> 'S');


	end if;
end if;

return	ie_permite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dieta_perm_hor_espec (nr_prescricao_p bigint) FROM PUBLIC;

