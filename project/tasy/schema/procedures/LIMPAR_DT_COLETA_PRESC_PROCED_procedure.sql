-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE limpar_dt_coleta_presc_proced ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_status_exame_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') then

	update	prescr_procedimento
	set	dt_coleta      		 = NULL,
		nm_usuario		= nm_usuario_p
	where	nr_prescricao		= nr_prescricao_p
	and	nr_sequencia		= nr_seq_prescr_p
	and	ie_status_exame_p	<= ie_status_atend
	and	ie_status_exame_p	< 20;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE limpar_dt_coleta_presc_proced ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_status_exame_p bigint, nm_usuario_p text) FROM PUBLIC;

