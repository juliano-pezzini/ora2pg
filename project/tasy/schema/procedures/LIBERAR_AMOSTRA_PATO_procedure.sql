-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_amostra_pato ( nr_prescricao_p bigint, nr_seq_proced_p bigint, nr_seq_status_p text, nm_usuario_p text) AS $body$
BEGIN

update 	prescr_procedimento
set	nr_seq_status_pato = nr_seq_status_p
where	nr_sequencia = nr_seq_proced_p
and	nr_prescricao = nr_prescricao_p;

update	prescr_proc_peca
set	ie_status	=	'E'
where	nr_prescricao	=	nr_prescricao_p;

insert 	into	prescr_proc_lib_caso(nr_sequencia,
			 dt_atualizacao,
			 nm_usuario,
			 dt_atualizacao_nrec,
			 nm_usuario_nrec,
			 nr_prescricao,
			 nr_seq_prescr)
values (nextval('prescr_proc_lib_caso_seq'),
			 clock_timestamp(),
			 nm_usuario_p,
			 clock_timestamp(),
			 nm_usuario_p,
			 nr_prescricao_p,
			 nr_seq_proced_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_amostra_pato ( nr_prescricao_p bigint, nr_seq_proced_p bigint, nr_seq_status_p text, nm_usuario_p text) FROM PUBLIC;

