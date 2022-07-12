-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION plt_obter_se_plano_estend ( nr_atendimento_p bigint, dt_quebra_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_estendido_w	char(1);


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (dt_quebra_p IS NOT NULL AND dt_quebra_p::text <> '') then
	select	coalesce(max('S'),'N')
	into STRICT	ie_estendido_w
	from	prescr_material a,
			prescr_medica b where		a.nr_prescricao		= b.nr_prescricao
	and		b.nr_atendimento	= nr_atendimento_p
	and		b.dt_validade_prescr	> dt_quebra_p LIMIT 1;

	if (ie_estendido_w = 'N') then
		select	coalesce(max('S'),'N')
		into STRICT	ie_estendido_w
		from	prescr_solucao a,
				prescr_medica b where		a.nr_prescricao		= b.nr_prescricao
		and		b.nr_atendimento	= nr_atendimento_p
		and		b.dt_validade_prescr	> dt_quebra_p LIMIT 1;

		if (ie_estendido_w = 'N') then
			select	coalesce(max('S'),'N')
			into STRICT	ie_estendido_w
			from	prescr_dieta a,
					prescr_medica b where		a.nr_prescricao		= b.nr_prescricao
			and		b.nr_atendimento	= nr_atendimento_p
			and		b.dt_validade_prescr	> dt_quebra_p LIMIT 1;

			if (ie_estendido_w = 'N') then
				select	coalesce(max('S'),'N')
				into STRICT	ie_estendido_w
				from	rep_jejum a,
						prescr_medica b where		a.nr_prescricao		= b.nr_prescricao
				and		b.nr_atendimento	= nr_atendimento_p
				and		b.dt_validade_prescr		> dt_quebra_p LIMIT 1;

				if (ie_estendido_w = 'N') then
					select	coalesce(max('S'),'N')
					into STRICT	ie_estendido_w
					from	nut_pac a,
							prescr_medica b where		a.nr_prescricao		= b.nr_prescricao
					and		b.nr_atendimento	= nr_atendimento_p
					and		b.dt_validade_prescr	> dt_quebra_p LIMIT 1;

					if (ie_estendido_w = 'N') then
						select	coalesce(max('S'),'N')
						into STRICT	ie_estendido_w
						from	prescr_procedimento a,
								prescr_medica b where		a.nr_prescricao		= b.nr_prescricao
						and		b.nr_atendimento	= nr_atendimento_p
						and		b.dt_validade_prescr	> dt_quebra_p LIMIT 1;

						if (ie_estendido_w = 'N') then
							select	coalesce(max('S'),'N')
							into STRICT	ie_estendido_w
							from	prescr_recomendacao a,
									prescr_medica b where		a.nr_prescricao		= b.nr_prescricao
							and		b.nr_atendimento	= nr_atendimento_p
							and		b.dt_validade_prescr	> dt_quebra_p LIMIT 1;

							if (ie_estendido_w = 'N') then
								select	coalesce(max('S'),'N')
								into STRICT	ie_estendido_w
								from	prescr_gasoterapia a,
										prescr_medica b where		a.nr_prescricao		= b.nr_prescricao
								and		b.nr_atendimento	= nr_atendimento_p
								and		b.dt_validade_prescr	> dt_quebra_p LIMIT 1;

							end if;
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
end if;

return	ie_estendido_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION plt_obter_se_plano_estend ( nr_atendimento_p bigint, dt_quebra_p timestamp) FROM PUBLIC;
