-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reopen_case_reason ( nr_sequencia_p bigint, nr_seq_motivo_p bigint, ds_motivo_reabertura_p text, nm_usuario_p text) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '' AND nr_seq_motivo_p IS NOT NULL AND nr_seq_motivo_p::text <> '') then

	update	episodio_paciente
	set	ds_motivo_reabertura	  = ds_motivo_reabertura_p,
		nm_usuario_reabertura		  = nm_usuario_p,
    nr_seq_motivo_reabertura  = nr_seq_motivo_p,
    dt_reabertura             = clock_timestamp()
	where 	nr_sequencia		= nr_sequencia_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reopen_case_reason ( nr_sequencia_p bigint, nr_seq_motivo_p bigint, ds_motivo_reabertura_p text, nm_usuario_p text) FROM PUBLIC;

