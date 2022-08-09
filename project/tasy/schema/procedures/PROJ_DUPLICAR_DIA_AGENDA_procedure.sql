-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_duplicar_dia_agenda ( nr_seq_agenda_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into proj_agenda(	NR_SEQUENCIA,
				CD_CONSULTOR,
				DT_ATUALIZACAO,
				NM_USUARIO,
				DT_ATUALIZACAO_NREC,
				NM_USUARIO_NREC,
				DT_AGENDA,
				IE_STATUS,
				IE_DIA_TODO,
				CD_HORA_INIC,
				CD_HORA_FIM,
				NR_SEQ_CLIENTE,
				NR_SEQ_CANAL,
				NR_SEQ_MOTIVO,
				NR_SEQ_PROJ,
				DS_OBSERVACAO)
			(SELECT	nextval('proj_agenda_seq'),
				cd_consultor,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				dt_agenda,
				ie_status,
				ie_dia_todo,
				cd_hora_inic,
				cd_hora_fim,
				nr_seq_cliente,
				nr_seq_canal,
				nr_seq_motivo,
				nr_seq_proj,
				ds_observacao
			from	proj_agenda
			where	nr_sequencia	= nr_seq_agenda_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_duplicar_dia_agenda ( nr_seq_agenda_p bigint, nm_usuario_p text) FROM PUBLIC;
