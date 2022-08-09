-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_verifica_job_exec ( nm_usuario_p text) AS $body$
DECLARE


nr_seq_atualizacao_w	bigint;
ie_exec_job_w			varchar(1);
vl_job_queue_process_w	bigint;
qt_min_total_geral_w	varchar(30);
job_w					bigint;
comando_w				varchar(255);
dt_atualizacao_w		timestamp;

c01 CURSOR FOR
	SELECT	distinct(job),
			comando
	from	job_v
	where	prox_exec 	between to_char(dt_atualizacao_w, 'dd/mm/yy hh24:mi:ss') and to_char(clock_timestamp(), 'dd/mm/yy hh24:mi:ss');


BEGIN

	select	max(nr_sequencia)
	into STRICT	nr_seq_atualizacao_w
	from	atualizacao_versao;

	select	ie_exec_job,
			vl_job_queue_process
	into STRICT	ie_exec_job_w,
			vl_job_queue_process_w
	from	atualizacao_versao
	where	nr_sequencia = nr_seq_atualizacao_w;

	select	dt_atualizacao
	into STRICT	dt_atualizacao_w
	from 	atualizacao_versao
	where	nr_sequencia = nr_seq_atualizacao_w;

	if (ie_exec_job_w = 'S') then
		begin

		open c01;
		loop
		fetch c01 into
			job_w,
			comando_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			insert	into tasy_jobs_atualizacao(	nr_sequencia,
												nr_job,
												dt_atualizacao,
												nm_usuario,
												dt_atualizacao_nrec,
												nm_usuario_nrec,
												ds_comando,
												nr_seq_atualizacao,
												ie_executado)
										values (	nr_seq_atualizacao_w + 1,
												job_w,
												clock_timestamp(),
												nm_usuario_p,
												clock_timestamp(),
												nm_usuario_p,
												comando_w,
												nr_seq_atualizacao_w,
												'N');
			end;
		end loop;
		end;
	end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_verifica_job_exec ( nm_usuario_p text) FROM PUBLIC;
