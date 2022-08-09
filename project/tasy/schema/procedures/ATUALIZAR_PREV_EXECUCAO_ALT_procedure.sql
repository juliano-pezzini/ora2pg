-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_prev_execucao_alt ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, dt_prev_execucao_p timestamp, nm_usuario_p text ) AS $body$
BEGIN
	if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (dt_prev_execucao_p IS NOT NULL AND dt_prev_execucao_p::text <> '') and (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') then

		update prescr_procedimento
			set dt_prev_execucao = dt_prev_execucao_p,
				IE_PREV_EXECUCAO_ALT = 'S',
				dt_atualizacao  = 	clock_timestamp(),
				nm_usuario 	= 	nm_usuario_p
		where nr_prescricao = nr_prescricao_p
		and	  nr_sequencia  = nr_seq_prescr_p;

		update prescr_proc_hor
			set dt_horario		    =    dt_prev_execucao_p,
			      nm_usuario_reaprazamento   =   nm_usuario_p
		where nr_prescricao		    =   nr_prescricao_p
		and     coalesce(nr_seq_proc_origem, nr_seq_procedimento)   =   nr_seq_prescr_p;

		commit;

	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_prev_execucao_alt ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, dt_prev_execucao_p timestamp, nm_usuario_p text ) FROM PUBLIC;
