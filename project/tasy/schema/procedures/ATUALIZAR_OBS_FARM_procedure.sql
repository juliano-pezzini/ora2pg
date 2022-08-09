-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_obs_farm ( ds_observacao_p text, nr_prescr_p bigint, nr_seq_p bigint, ie_gravar_obs_prescr_p text, nr_prescricao_p bigint, nr_sequencia_p bigint, nr_seq_obs_p bigint default 0) AS $body$
BEGIN

if (nr_prescr_p IS NOT NULL AND nr_prescr_p::text <> '') and (nr_seq_p IS NOT NULL AND nr_seq_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin

	update 	prescr_material
	set 	ds_observacao_far 	= ds_observacao_p,
			nr_seq_obs 			= nr_seq_obs_p
	where 	nr_prescricao   	= nr_prescr_p
	and 	nr_sequencia      	= nr_seq_p;

	if (ie_gravar_obs_prescr_p = 'S') then
		begin

		CALL atualizar_obs_medicamentos_rep(nr_prescricao_p, nr_sequencia_p, nr_seq_obs_p);

		end;
	end if;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_obs_farm ( ds_observacao_p text, nr_prescr_p bigint, nr_seq_p bigint, ie_gravar_obs_prescr_p text, nr_prescricao_p bigint, nr_sequencia_p bigint, nr_seq_obs_p bigint default 0) FROM PUBLIC;
