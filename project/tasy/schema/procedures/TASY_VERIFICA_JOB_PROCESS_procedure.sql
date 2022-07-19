-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_verifica_job_process ( nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
ie_exec_job_w			varchar(1) := 'N';
vl_job_queue_process_w	bigint;
qt_processes_w			bigint;
ie_sucesso_w			varchar(1) := 'S';
ie_status_aplicacao_w	varchar(1);


BEGIN

	select	coalesce(ie_status_aplicacao,'I')
	into STRICT	ie_status_aplicacao_w
	from	aplicacao_tasy
	where	cd_aplicacao_tasy = 'Tasy';

	if (ie_status_aplicacao_w = 'A') then
		begin

		select	nr_sequencia,
				coalesce(ie_exec_job, 'N'),
				vl_job_queue_process
		into STRICT	nr_sequencia_w,
				ie_exec_job_w,
				vl_job_queue_process_w
		from	atualizacao_versao
		where	nr_sequencia = (SELECT	max(nr_sequencia)
								from	atualizacao_versao);

		if (ie_exec_job_w = 'S') then
			begin

			begin
				EXECUTE ' select	nvl(value,-1) from	v$parameter  where	name = :bind_job' INTO STRICT qt_processes_w USING 'job_queue_processes';
			exception
				when others then
					qt_processes_w := -1;
			end;

			if (qt_processes_w > 0) and (qt_processes_w > vl_job_queue_process_w) then
				begin

					vl_job_queue_process_w := qt_processes_w;

				end;
			end if;

			if (vl_job_queue_process_w > 0) then
				begin

					begin
						EXECUTE ' alter system set job_queue_processes='||vl_job_queue_process_w;
						ie_sucesso_w := 'N';

					exception
						when others then
							ie_sucesso_w := 'E';
					end;

				end;
			end if;

			update	atualizacao_versao
			set		ie_exec_job = ie_sucesso_w
			where	nr_sequencia = nr_sequencia_w;

			end;
		end if;

		end;
	end if;
	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_verifica_job_process ( nm_usuario_p text) FROM PUBLIC;

