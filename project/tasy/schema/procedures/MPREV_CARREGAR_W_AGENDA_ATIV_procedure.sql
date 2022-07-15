-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprev_carregar_w_agenda_ativ (nr_seq_agendamento_p mprev_agendamento.nr_sequencia%type, nr_seq_w_agendamento_p w_mprev_agendamento.nr_sequencia%type) AS $body$
BEGIN

if (nr_seq_agendamento_p IS NOT NULL AND nr_seq_agendamento_p::text <> '') then
	CALL mprev_agenda_pck.carregar_w_agendamento_ativ(nr_seq_agendamento_p, nr_seq_w_agendamento_p);
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_carregar_w_agenda_ativ (nr_seq_agendamento_p mprev_agendamento.nr_sequencia%type, nr_seq_w_agendamento_p w_mprev_agendamento.nr_sequencia%type) FROM PUBLIC;

