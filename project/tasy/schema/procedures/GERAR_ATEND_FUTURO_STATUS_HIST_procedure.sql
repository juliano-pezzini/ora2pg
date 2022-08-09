-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_atend_futuro_status_hist (nr_seq_atend_futuro_p bigint, nr_seq_status_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_hist_w	bigint;


BEGIN

if (nr_seq_atend_futuro_p IS NOT NULL AND nr_seq_atend_futuro_p::text <> '') and (nr_seq_status_p IS NOT NULL AND nr_seq_status_p::text <> '') then


	select	nextval('atend_futuro_status_hist_seq')
	into STRICT	nr_seq_hist_w
	;

	insert into atend_futuro_status_hist(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_atend_futuro,
		nr_seq_status)
	values (nr_seq_hist_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_atend_futuro_p,
		nr_seq_status_p);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_atend_futuro_status_hist (nr_seq_atend_futuro_p bigint, nr_seq_status_p bigint, nm_usuario_p text) FROM PUBLIC;
