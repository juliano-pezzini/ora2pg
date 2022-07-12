-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION plt_obter_status_solucao ( ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint) RETURNS varchar AS $body$
DECLARE


ie_status_w			varchar(3);
qt_vol_infundido_w		double precision;
qt_vol_desprezado_w		double precision;
nr_sequencia_w			bigint;
ie_liberado_w			varchar(1);


BEGIN
if (ie_tipo_solucao_p IS NOT NULL AND ie_tipo_solucao_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') then

	select	CASE WHEN coalesce(dt_liberacao::text, '') = '' THEN 'N'  ELSE 'S' END
	into STRICT	ie_liberado_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;

	/* obter status conforme tipo solucao */

	if (ie_tipo_solucao_p = 1) then -- solucao
		/* obter se solução suspensa */

		select	coalesce(ie_suspenso,'N')
		into STRICT	ie_status_w
		from	prescr_solucao
		where	nr_prescricao	= nr_prescricao_p
		and	nr_seq_solucao	= nr_seq_solucao_p;

		if (ie_status_w <> 'S') then
			ie_status_w := '';
			/* obter sequência evento */

			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_sequencia_w
			from	prescr_solucao_evento
			where	nr_prescricao	= nr_prescricao_p
			and	nr_seq_solucao	= nr_seq_solucao_p
			and	ie_tipo_solucao	= 1
			and	ie_alteracao	in (1,2,3,4)
			and	ie_evento_valido	= 'S';

			/* obter status solução */

			if (nr_sequencia_w > 0) then
				select	CASE WHEN ie_alteracao=1 THEN  'I' WHEN ie_alteracao=2 THEN  'INT' WHEN ie_alteracao=3 THEN  'R' WHEN ie_alteracao=4 THEN  'T' END
				into STRICT	ie_status_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_sequencia_w;

				/* tratar interromper sobre interromper */

				if (ie_status_w = 'INT') then
					select	coalesce(max(qt_vol_infundido),-1),
						coalesce(max(qt_vol_desprezado),-1)
					into STRICT	qt_vol_infundido_w,
						qt_vol_desprezado_w
					from	prescr_solucao_evento
					where	nr_sequencia = nr_sequencia_w;

					if (qt_vol_infundido_w = -1) and (qt_vol_desprezado_w = -1) then
						ie_status_w := 'II';
					end if;
				end if;
			else
				if (ie_liberado_w = 'N') then
					ie_status_w := 'W';
				else
					ie_status_w := 'N';
				end if;
			end if;
		end if;

	elsif (ie_tipo_solucao_p = 2) then -- suporte nutricional enteral
		/* obter se solução suspensa */

		select	CASE WHEN coalesce(coalesce(dt_liberacao,dt_liberacao_medico)::text, '') = '' THEN 'N'  ELSE 'S' END
		into STRICT	ie_liberado_w
		from	prescr_medica
		where	nr_prescricao = nr_prescricao_p;

		select	coalesce(ie_suspenso,'N')
		into STRICT	ie_status_w
		from	prescr_material
		where	nr_prescricao	= nr_prescricao_p
		and	nr_sequencia	= nr_seq_solucao_p
		and	ie_agrupador	= 8;

		if (ie_status_w <> 'S') then
			ie_status_w := '';
			/* obter sequência evento */

			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_sequencia_w
			from	prescr_solucao_evento
			where	nr_prescricao	= nr_prescricao_p
			and	nr_seq_material	= nr_seq_solucao_p
			and	ie_tipo_solucao	= 2
			and	ie_alteracao	in (1,2,3,4,23)
			and	ie_evento_valido	= 'S';

			/* obter status solução */

			if (nr_sequencia_w > 0) then
				select	CASE WHEN ie_alteracao=1 THEN  'I' WHEN ie_alteracao=2 THEN  'INT' WHEN ie_alteracao=3 THEN  'R' WHEN ie_alteracao=4 THEN  'T' WHEN ie_alteracao=23 THEN 'S' END
				into STRICT	ie_status_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_sequencia_w;

				/* tratar interromper sobre interromper */

				if (ie_status_w = 'INT') then
					select	coalesce(max(qt_vol_infundido),-1),
						coalesce(max(qt_vol_desprezado),-1)
					into STRICT	qt_vol_infundido_w,
						qt_vol_desprezado_w
					from	prescr_solucao_evento
					where	nr_sequencia = nr_sequencia_w;

					if (qt_vol_infundido_w = -1) and (qt_vol_desprezado_w = -1) then
						ie_status_w := 'II';
					end if;
				end if;
			else
				if (ie_liberado_w = 'N') then
					ie_status_w := 'W';
				else
					ie_status_w := 'N';
				end if;
			end if;
		end if;

	elsif (ie_tipo_solucao_p = 3) then -- hemocomponente
		/* obter se solução suspensa */

		select	coalesce(ie_suspenso,'N')
		into STRICT	ie_status_w
		from	prescr_procedimento
		where	nr_prescricao		= nr_prescricao_p
		and	nr_sequencia		= nr_seq_solucao_p
		and	(nr_seq_solic_sangue IS NOT NULL AND nr_seq_solic_sangue::text <> '')
		and	(nr_seq_derivado IS NOT NULL AND nr_seq_derivado::text <> '');

		if (ie_status_w <> 'S') then
			ie_status_w := '';
			/* obter sequência evento */

			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_sequencia_w
			from	prescr_solucao_evento
			where	nr_prescricao		= nr_prescricao_p
			and	nr_seq_procedimento	= nr_seq_solucao_p
			and	ie_tipo_solucao	= 3
			and	ie_alteracao		in (1,2,3,4)
			and	ie_evento_valido	= 'S';

			/* obter status solução */

			if (nr_sequencia_w > 0) then
				select	CASE WHEN ie_alteracao=1 THEN  'I' WHEN ie_alteracao=2 THEN  'INT' WHEN ie_alteracao=3 THEN  'R' WHEN ie_alteracao=4 THEN  'T' END
				into STRICT	ie_status_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_sequencia_w;

				/* tratar interromper sobre interromper */

				if (ie_status_w = 'INT') then
					select	coalesce(max(qt_vol_infundido),-1),
						coalesce(max(qt_vol_desprezado),-1)
					into STRICT	qt_vol_infundido_w,
						qt_vol_desprezado_w
					from	prescr_solucao_evento
					where	nr_sequencia = nr_sequencia_w;

					if (qt_vol_infundido_w = -1) and (qt_vol_desprezado_w = -1) then
						ie_status_w := 'II';
					end if;
				end if;
			else
				if (ie_liberado_w = 'N') then
					ie_status_w := 'W';
				else
					ie_status_w := 'N';
				end if;
			end if;
		end if;

	elsif (ie_tipo_solucao_p = 4) then -- npt adulta
		/* obter se solução suspensa */

		select	coalesce(ie_suspenso,'N')
		into STRICT	ie_status_w
		from	nut_paciente
		where	nr_prescricao	= nr_prescricao_p
		and	nr_sequencia	= nr_seq_solucao_p;

		if (ie_status_w <> 'S') then
			ie_status_w := '';
			/* obter sequência evento */

			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_sequencia_w
			from	prescr_solucao_evento
			where	nr_prescricao		= nr_prescricao_p
			and	nr_seq_nut		= nr_seq_solucao_p
			and	ie_tipo_solucao		= 4
			and	ie_alteracao		in (1,2,3,4)
			and	ie_evento_valido		= 'S';

			/* obter status solução */

			if (nr_sequencia_w > 0) then
				select	CASE WHEN ie_alteracao=1 THEN  'I' WHEN ie_alteracao=2 THEN  'INT' WHEN ie_alteracao=3 THEN  'R' WHEN ie_alteracao=4 THEN  'T' END
				into STRICT	ie_status_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_sequencia_w;

				/* tratar interromper sobre interromper */

				if (ie_status_w = 'INT') then
					select	coalesce(max(qt_vol_infundido),-1),
						coalesce(max(qt_vol_desprezado),-1)
					into STRICT	qt_vol_infundido_w,
						qt_vol_desprezado_w
					from	prescr_solucao_evento
					where	nr_sequencia = nr_sequencia_w;

					if (qt_vol_infundido_w = -1) and (qt_vol_desprezado_w = -1) then
						ie_status_w := 'II';
					end if;
				end if;
			else
				if (ie_liberado_w = 'N') then
					ie_status_w := 'W';
				else
					ie_status_w := 'N';
				end if;
			end if;
		end if;

	elsif (ie_tipo_solucao_p = 5) then -- npt neo
		/* obter se solução suspensa */

		select	coalesce(ie_suspenso,'N')
		into STRICT	ie_status_w
		from	nut_pac
		where	nr_prescricao	= nr_prescricao_p
		and	nr_sequencia	= nr_seq_solucao_p;

		if (ie_status_w <> 'S') then
			ie_status_w := '';
			/* obter sequência evento */

			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_sequencia_w
			from	prescr_solucao_evento
			where	nr_prescricao	= nr_prescricao_p
			and	nr_seq_nut_neo	= nr_seq_solucao_p
			and	ie_tipo_solucao	= 5
			and	ie_alteracao	in (1,2,3,4)
			and	ie_evento_valido	= 'S';

			/* obter status solução */

			if (nr_sequencia_w > 0) then
				select	CASE WHEN ie_alteracao=1 THEN  'I' WHEN ie_alteracao=2 THEN  'INT' WHEN ie_alteracao=3 THEN  'R' WHEN ie_alteracao=4 THEN  'T' END
				into STRICT	ie_status_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_sequencia_w;

				/* tratar interromper sobre interromper */

				if (ie_status_w = 'INT') then
					select	coalesce(max(qt_vol_infundido),-1),
						coalesce(max(qt_vol_desprezado),-1)
					into STRICT	qt_vol_infundido_w,
						qt_vol_desprezado_w
					from	prescr_solucao_evento
					where	nr_sequencia = nr_sequencia_w;

					if (qt_vol_infundido_w = -1) and (qt_vol_desprezado_w = -1) then
						ie_status_w := 'II';
					end if;
				end if;
			else
				if (ie_liberado_w = 'N') then
					ie_status_w := 'W';
				else
					ie_status_w := 'N';
				end if;
			end if;
		end if;
	elsif (ie_tipo_solucao_p = 6) then -- npt Adulta 2
		/* obter se solução suspensa */

		select	coalesce(ie_suspenso,'N')
		into STRICT	ie_status_w
		from	nut_pac
		where	nr_prescricao	= nr_prescricao_p
		and	nr_sequencia	= nr_seq_solucao_p;

		if (ie_status_w <> 'S') then
			ie_status_w := '';
			/* obter sequência evento */

			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_sequencia_w
			from	prescr_solucao_evento
			where	nr_prescricao	= nr_prescricao_p
			and	nr_seq_nut_neo	= nr_seq_solucao_p
			and	ie_tipo_solucao	= 6
			and	ie_alteracao	in (1,2,3,4)
			and	ie_evento_valido	= 'S';

			/* obter status solução */

			if (nr_sequencia_w > 0) then
				select	CASE WHEN ie_alteracao=1 THEN  'I' WHEN ie_alteracao=2 THEN  'INT' WHEN ie_alteracao=3 THEN  'R' WHEN ie_alteracao=4 THEN  'T' END
				into STRICT	ie_status_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_sequencia_w;

				/* tratar interromper sobre interromper */

				if (ie_status_w = 'INT') then
					select	coalesce(max(qt_vol_infundido),-1),
						coalesce(max(qt_vol_desprezado),-1)
					into STRICT	qt_vol_infundido_w,
						qt_vol_desprezado_w
					from	prescr_solucao_evento
					where	nr_sequencia = nr_sequencia_w;

					if (qt_vol_infundido_w = -1) and (qt_vol_desprezado_w = -1) then
						ie_status_w := 'II';
					end if;
				end if;
			else
				if (ie_liberado_w = 'N') then
					ie_status_w := 'W';
				else
					ie_status_w := 'N';
				end if;
			end if;
		end if;
	end if;
end if;

return ie_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION plt_obter_status_solucao ( ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint) FROM PUBLIC;

