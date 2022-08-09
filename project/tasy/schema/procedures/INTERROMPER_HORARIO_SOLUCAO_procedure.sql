-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE interromper_horario_solucao ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_etapa_p bigint, dt_instalacao_p timestamp, nm_usuario_p text, ie_troca_frasco_p text) AS $body$
DECLARE


dt_horario_w	timestamp;		
		

BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (nr_etapa_p IS NOT NULL AND nr_etapa_p::text <> '') and (dt_instalacao_p IS NOT NULL AND dt_instalacao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	update	prescr_mat_hor
	set	dt_interrupcao = clock_timestamp(),
		nm_usuario_inter = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p,
		dt_reinicio  = NULL
	where	nr_etapa_sol = nr_etapa_p
	and	nr_seq_solucao = nr_seq_solucao_p
	and coalesce(ie_horario_especial, 'N') = 'N'
	and	nr_prescricao = nr_prescricao_p
	and	coalesce(dt_suspensao::text, '') = '';
	
	
	if (ie_troca_frasco_p = 'S') then
	
		select	max(dt_horario)
		into STRICT	dt_horario_w
		from	prescr_mat_hor
		where	nr_prescricao = nr_prescricao_p
		and	nr_seq_solucao = nr_seq_solucao_p
		and coalesce(ie_horario_especial, 'N') = 'N'
		and	coalesce(dt_suspensao::text, '') = ''
		and	nr_etapa_sol = nr_etapa_p;
		
		update	prescr_mat_hor a
		set	dt_fim_horario = clock_timestamp(),
			nm_usuario_adm = nm_usuario_p,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	nr_prescricao = nr_prescricao_p
		and	dt_horario	= dt_horario_w
		and	nr_etapa_sol = nr_etapa_p
		and	coalesce(dt_suspensao::text, '') = ''
		and	nr_seq_material in (SELECT	nr_sequencia
									from	prescr_material x
									where	nr_prescricao = nr_prescricao_p
									and		nr_sequencia_solucao = nr_seq_solucao_p);
		
	
	end if;
	
	
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE interromper_horario_solucao ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, nr_etapa_p bigint, dt_instalacao_p timestamp, nm_usuario_p text, ie_troca_frasco_p text) FROM PUBLIC;
