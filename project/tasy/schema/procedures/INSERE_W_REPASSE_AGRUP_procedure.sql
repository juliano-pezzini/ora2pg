-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insere_w_repasse_agrup ( ie_proc_mat_p text, nr_seq_p text, nm_usuario_p text) AS $body$
BEGIN

if (ie_proc_mat_p	= 'P') then

	insert	into w_repasse_agrup(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_proc_repasse,
		nr_seq_mat_repasse)
	values (nextval('w_repasse_agrup_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_p,
		null);
end if;

if (ie_proc_mat_p	= 'M') then

	insert	into w_repasse_agrup(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_proc_repasse,
		nr_seq_mat_repasse)
	values (nextval('w_repasse_agrup_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		null,
		nr_seq_p);
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insere_w_repasse_agrup ( ie_proc_mat_p text, nr_seq_p text, nm_usuario_p text) FROM PUBLIC;

