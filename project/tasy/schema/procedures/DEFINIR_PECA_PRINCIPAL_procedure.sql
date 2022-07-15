-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE definir_peca_principal (nr_seq_peca_principal_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_peca_principal_p IS NOT NULL AND nr_seq_peca_principal_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') then

	update	prescr_proc_peca
	   set  ie_peca_principal  = 'N',
		nm_usuario	   = nm_usuario_p,
		dt_atualizacao	   = clock_timestamp()
	where	nr_prescricao	   = nr_prescricao_p
	and	nr_seq_prescr	   = nr_seq_prescr_p
	and	ie_peca_principal  = 'S';

	update	prescr_proc_peca
	   set  ie_peca_principal  = 'S',
		nm_usuario	   = nm_usuario_p,
		dt_atualizacao	   = clock_timestamp()
	where	nr_sequencia       =  nr_seq_peca_principal_p
	and	nr_seq_prescr	   = nr_seq_prescr;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE definir_peca_principal (nr_seq_peca_principal_p bigint, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text) FROM PUBLIC;

