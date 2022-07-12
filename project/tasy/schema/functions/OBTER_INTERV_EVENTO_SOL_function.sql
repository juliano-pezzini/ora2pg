-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_interv_evento_sol (ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_seq_evento_p bigint, dt_evento_p timestamp, ie_evento_p bigint, ie_evento_valido_p text) RETURNS varchar AS $body$
DECLARE


ds_intervalo_w	varchar(100);
nr_seq_evento_w	bigint;
dt_evento_w		timestamp;


BEGIN
if (ie_tipo_solucao_p IS NOT NULL AND ie_tipo_solucao_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (nr_seq_evento_p IS NOT NULL AND nr_seq_evento_p::text <> '') and (dt_evento_p IS NOT NULL AND dt_evento_p::text <> '') and (ie_evento_p IS NOT NULL AND ie_evento_p::text <> '') and (ie_evento_valido_p IS NOT NULL AND ie_evento_valido_p::text <> '') then

	if (ie_tipo_solucao_p = 1) then -- solucoes
		if (ie_evento_p <> 6) and (ie_evento_valido_p = 'S') then

			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_solucao = nr_seq_solucao_p
			and	nr_sequencia < nr_seq_evento_p
			and	ie_alteracao <> 6
			and	ie_evento_valido = 'S';

			if (nr_seq_evento_w > 0) then

				select	dt_alteracao
				into STRICT	dt_evento_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_seq_evento_w;

				if (dt_evento_w IS NOT NULL AND dt_evento_w::text <> '') then

					select	obter_dif_data(dt_evento_w,dt_evento_p,'')
					into STRICT	ds_intervalo_w
					;
				end if;
			end if;
		end if;


	elsif (ie_tipo_solucao_p = 2) then -- sne
		if (ie_evento_p <> 6) and (ie_evento_valido_p = 'S') then

			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_material = nr_seq_solucao_p
			and	nr_sequencia < nr_seq_evento_p
			and	ie_alteracao <> 6
			and	ie_evento_valido = 'S';

			if (nr_seq_evento_w > 0) then

				select	dt_alteracao
				into STRICT	dt_evento_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_seq_evento_w;

				if (dt_evento_w IS NOT NULL AND dt_evento_w::text <> '') then

					select	obter_dif_data(dt_evento_w,dt_evento_p,'')
					into STRICT	ds_intervalo_w
					;
				end if;
			end if;
		end if;


	elsif (ie_tipo_solucao_p = 3) then -- hemocomponentes
		if (ie_evento_p <> 6) and (ie_evento_valido_p = 'S') then

			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_procedimento = nr_seq_solucao_p
			and	nr_sequencia < nr_seq_evento_p
			and	ie_alteracao <> 6
			and	ie_evento_valido = 'S';

			if (nr_seq_evento_w > 0) then

				select	dt_alteracao
				into STRICT	dt_evento_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_seq_evento_w;

				if (dt_evento_w IS NOT NULL AND dt_evento_w::text <> '') then

					select	obter_dif_data(dt_evento_w,dt_evento_p,'')
					into STRICT	ds_intervalo_w
					;
				end if;
			end if;
		end if;


	elsif (ie_tipo_solucao_p = 4) then -- npt adulta
		if (ie_evento_p <> 6) and (ie_evento_valido_p = 'S') then

			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_nut = nr_seq_solucao_p
			and	nr_sequencia < nr_seq_evento_p
			and	ie_alteracao <> 6
			and	ie_evento_valido = 'S';

			if (nr_seq_evento_w > 0) then

				select	dt_alteracao
				into STRICT	dt_evento_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_seq_evento_w;

				if (dt_evento_w IS NOT NULL AND dt_evento_w::text <> '') then

					select	obter_dif_data(dt_evento_w,dt_evento_p,'')
					into STRICT	ds_intervalo_w
					;
				end if;
			end if;
		end if;


	elsif (ie_tipo_solucao_p = 5) then -- npt neo
		if (ie_evento_p <> 6) and (ie_evento_valido_p = 'S') then

			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_nut_neo = nr_seq_solucao_p
			and	nr_sequencia < nr_seq_evento_p
			and	ie_alteracao <> 6
			and	ie_evento_valido = 'S';

			if (nr_seq_evento_w > 0) then

				select	dt_alteracao
				into STRICT	dt_evento_w
				from	prescr_solucao_evento
				where	nr_sequencia = nr_seq_evento_w;

				if (dt_evento_w IS NOT NULL AND dt_evento_w::text <> '') then

					select	obter_dif_data(dt_evento_w,dt_evento_p,'')
					into STRICT	ds_intervalo_w
					;
				end if;
			end if;
		end if;
	end if;
end if;

return ds_intervalo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_interv_evento_sol (ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_seq_evento_p bigint, dt_evento_p timestamp, ie_evento_p bigint, ie_evento_valido_p text) FROM PUBLIC;

