-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE w_mprev_deletar_ag_ativ ( nr_seq_w_agendamento_ativ_p w_mprev_agendamento_ativ.nr_sequencia%type, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_w_agendamento_ativ_p IS NOT NULL AND nr_seq_w_agendamento_ativ_p::text <> '') then

	delete 	from W_MPREV_AGENDAMENTO_ATIV
	where	nr_sequencia = nr_seq_w_agendamento_ativ_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE w_mprev_deletar_ag_ativ ( nr_seq_w_agendamento_ativ_p w_mprev_agendamento_ativ.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;
