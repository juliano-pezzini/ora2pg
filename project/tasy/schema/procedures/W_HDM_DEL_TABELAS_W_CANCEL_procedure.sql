-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE w_hdm_del_tabelas_w_cancel (nr_seq_w_agendamento_p w_mprev_agendamento_ativ.nr_sequencia%type, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_w_agendamento_p IS NOT NULL AND nr_seq_w_agendamento_p::text <> '') then

	delete	from w_mprev_ag_ativ_item a
	where	exists (SELECT 1
			from	w_mprev_agendamento x,
				w_mprev_agendamento_ativ y
			where	x.nr_sequencia = y.nr_seq_w_agendamento
			and	y.nr_sequencia = a.nr_seq_w_agendamento_ativ
			and	x.nr_sequencia = nr_seq_w_agendamento_p);

	delete	from w_mprev_agendamento_ativ a
	where	exists (SELECT	1
			from	w_mprev_agendamento x
			where	x.nr_sequencia	= a.nr_seq_w_agendamento
			and	x.nr_sequencia = nr_seq_w_agendamento_p);

	delete	from w_hdm_agendamento_anexo a
	where	exists (SELECT	1
			from	w_mprev_agendamento x
			where	x.nr_sequencia	= a.nr_seq_agendamento
			and	x.nr_sequencia = nr_seq_w_agendamento_p);

	delete	from w_mprev_agendamento_rec a
	where	exists (SELECT	1
			from	w_mprev_agendamento x
			where	x.nr_sequencia	= a.nr_seq_w_agendamento
			and	x.nr_sequencia = nr_seq_w_agendamento_p);

	delete	from w_mprev_sel_partic_agenda a
	where	exists (SELECT	1
			from	w_mprev_agendamento x
			where	x.nr_sequencia	= a.nr_seq_w_agendamento
			and	x.nr_sequencia = nr_seq_w_agendamento_p);

	delete	from w_mprev_agendamento
	where	nr_sequencia = nr_seq_w_agendamento_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE w_hdm_del_tabelas_w_cancel (nr_seq_w_agendamento_p w_mprev_agendamento_ativ.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;

