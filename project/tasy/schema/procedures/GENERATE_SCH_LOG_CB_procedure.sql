-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE generate_sch_log_cb ( nr_seq_schedule_p bigint, ie_status_p text) AS $body$
BEGIN
	insert into schedule_stus_log( nr_sequencia,
					ie_status_change,
					nm_user_change,
					dt_change,
					nr_seq_schedule,
					dt_atualizacao,
					dt_atualizacao_nrec,
					nm_usuario,
					nm_usuario_nrec
					) values (
					nextval('schedule_stus_log_seq'),
					ie_status_p,
					wheb_usuario_pck.get_nm_usuario,
					clock_timestamp(),
					nr_seq_schedule_p,
					clock_timestamp(),
					clock_timestamp(),
					wheb_usuario_pck.get_nm_usuario,
					wheb_usuario_pck.get_nm_usuario);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE generate_sch_log_cb ( nr_seq_schedule_p bigint, ie_status_p text) FROM PUBLIC;

