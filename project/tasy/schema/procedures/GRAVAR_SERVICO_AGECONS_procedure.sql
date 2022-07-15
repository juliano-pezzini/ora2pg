-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_servico_agecons ( nr_seq_proc_servico_p bigint, nr_seq_agenda_p bigint, nm_usuario_p text ) AS $body$
BEGIN

insert into agenda_cons_servico(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	nr_seq_proc_servico,
	nr_seq_agenda,
	ie_origem_inf,
	dt_atualizacao_nrec,
	nm_usuario_nrec)
values (
	nextval('agenda_cons_servico_seq'),
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_proc_servico_p,
	nr_seq_agenda_p,
	'I',
	clock_timestamp(),
	nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_servico_agecons ( nr_seq_proc_servico_p bigint, nr_seq_agenda_p bigint, nm_usuario_p text ) FROM PUBLIC;

