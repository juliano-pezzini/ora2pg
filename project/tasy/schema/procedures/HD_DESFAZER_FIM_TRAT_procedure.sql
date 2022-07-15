-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_desfazer_fim_trat ( nr_seq_tratamento_p bigint) AS $body$
BEGIN
if (nr_seq_tratamento_p IS NOT NULL AND nr_seq_tratamento_p::text <> '') then
	update	paciente_tratamento
	set	dt_final_tratamento  = NULL,
		nr_seq_motivo_fim    = NULL,
		nr_seq_causa_morte   = NULL,
		ds_observacao        = NULL
	where	nr_sequencia = nr_seq_tratamento_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_desfazer_fim_trat ( nr_seq_tratamento_p bigint) FROM PUBLIC;

