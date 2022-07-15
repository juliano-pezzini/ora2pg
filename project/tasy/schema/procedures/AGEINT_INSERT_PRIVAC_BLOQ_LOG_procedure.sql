-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_insert_privac_bloq_log (nr_seq_ageint_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_sequencia_w bigint;
dt_atualizacao_w timestamp := clock_timestamp();


BEGIN

	select nextval('ageint_log_bloq_envio_seq')
	  into STRICT nr_sequencia_w
	;

	insert into AGEINT_LOG_BLOQ_ENVIO(nr_sequencia,
									  dt_atualizacao, 
									  nm_usuario,
									  dt_atualizacao_nrec,
									  nm_usuario_nrec,
									  nr_seq_agenda_int)
							 values ( nr_sequencia_w,
									  dt_atualizacao_w,
									  nm_usuario_p,
									  dt_atualizacao_w,
									  nm_usuario_p,
									  nr_seq_ageint_p);
	commit;
												
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_insert_privac_bloq_log (nr_seq_ageint_p bigint, nm_usuario_p text) FROM PUBLIC;

