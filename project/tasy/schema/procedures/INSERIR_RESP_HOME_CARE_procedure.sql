-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_resp_home_care (nr_seq_profissional_p bigint, nr_seq_agenda_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_agenda_prof_w	bigint;


BEGIN

select	nextval('hc_agenda_prof_seq')
into STRICT	nr_seq_agenda_prof_w
;

insert into hc_agenda_prof(nr_sequencia,
			    dt_atualizacao,
			    nm_usuario,
		            dt_atualizacao_nrec,
		            nm_usuario_nrec,
			    nr_seq_agenda,
			    nr_seq_prof_hc)
		values (nr_seq_agenda_prof_w,
			    clock_timestamp(),
			    nm_usuario_p,
			    clock_timestamp(),
			    nm_usuario_p,
			    nr_seq_agenda_p,
			    nr_seq_profissional_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_resp_home_care (nr_seq_profissional_p bigint, nr_seq_agenda_p bigint, nm_usuario_p text) FROM PUBLIC;
