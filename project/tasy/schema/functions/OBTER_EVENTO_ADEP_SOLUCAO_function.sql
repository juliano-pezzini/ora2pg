-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_evento_adep_solucao (ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_evento_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_evento_w	bigint;


BEGIN
if (ie_tipo_solucao_p IS NOT NULL AND ie_tipo_solucao_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (ie_evento_p IS NOT NULL AND ie_evento_p::text <> '') then

	if (ie_tipo_solucao_p = 1)  then -- solucoes
		if (ie_evento_p = 'I') then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_solucao = nr_seq_solucao_p
			and	ie_alteracao = 1
			and	ie_evento_valido = 'S';
		elsif (ie_evento_p = 'T') then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_solucao = nr_seq_solucao_p
			and	ie_alteracao = 4
			and	ie_evento_valido = 'S';
		elsif (ie_evento_p = 'A') then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_solucao = nr_seq_solucao_p
			and	ie_alteracao = 16
			and	ie_evento_valido = 'S';
		end if;


	elsif (ie_tipo_solucao_p = 2) then -- suporte nutricional enteral
		if (ie_evento_p = 'I') then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_material = nr_seq_solucao_p
			and	ie_alteracao = 1
			and	ie_evento_valido = 'S';
		elsif (ie_evento_p = 'T') then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_material = nr_seq_solucao_p
			and	ie_alteracao = 4
			and	ie_evento_valido = 'S';
		end if;


	elsif (ie_tipo_solucao_p = 3) then -- hemocompoente
		if (ie_evento_p = 'I') then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_procedimento = nr_seq_solucao_p
			and	ie_alteracao = 1
			and	ie_evento_valido = 'S';
		elsif (ie_evento_p = 'T') then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_procedimento = nr_seq_solucao_p
			and	ie_alteracao = 4
			and	ie_evento_valido = 'S';
		end if;


	elsif (ie_tipo_solucao_p = 4) then -- npt adulta
		if (ie_evento_p = 'I') then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_nut = nr_seq_solucao_p
			and	ie_alteracao = 1
			and	ie_evento_valido = 'S';
		elsif (ie_evento_p = 'T') then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_nut = nr_seq_solucao_p
			and	ie_alteracao = 4
			and	ie_evento_valido = 'S';
		end if;


	elsif (ie_tipo_solucao_p = 5) then -- npt neonatal
		if (ie_evento_p = 'I') then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_nut_neo = nr_seq_solucao_p
			and	ie_alteracao = 1
			and	ie_evento_valido = 'S';
		elsif (ie_evento_p = 'T') then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_nut_neo = nr_seq_solucao_p
			and	ie_alteracao = 4
			and	ie_evento_valido = 'S';
		end if;


	elsif (ie_tipo_solucao_p = 6) then -- npt adulta2
		if (ie_evento_p = 'I') then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_nut_neo = nr_seq_solucao_p
			and	ie_alteracao = 1
			and	ie_evento_valido = 'S';
		elsif (ie_evento_p = 'T') then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_nut_neo = nr_seq_solucao_p
			and	ie_alteracao = 4
			and	ie_evento_valido = 'S';
		elsif (ie_evento_p = 'INT') then
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_evento_w
			from	prescr_solucao_evento
			where	ie_tipo_solucao = ie_tipo_solucao_p
			and	nr_prescricao = nr_prescricao_p
			and	nr_seq_nut_neo = nr_seq_solucao_p
			and	ie_alteracao = 16
			and	ie_evento_valido = 'S';
		end if;

	end if;
end if;

return nr_seq_evento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_evento_adep_solucao (ie_tipo_solucao_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_evento_p text) FROM PUBLIC;

