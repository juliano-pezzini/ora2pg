-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_insert_protocol (nr_seq_proc_p bigint, cd_protocolo_p bigint, nr_seq_protocolo_exam_p bigint, nr_sequencia_p bigint, nm_usuario_p text, cd_pessoa_fisica_p text, NR_CONTROL_P bigint) AS $body$
DECLARE


nr_sequencia_w		hd_protocolo_exame.nr_sequencia%type := null;


BEGIN

if (NR_CONTROL_P = 0)then

	insert into hd_protocolo_exame(nr_sequencia,
											nr_seq_protocolo,
											dt_atualizacao,
											nm_usuario,
											dt_atualizacao_nrec,
											nm_usuario_nrec,
											cd_pessoa_fisica)
											values (
											nextval('hd_protocolo_exame_seq'),
											nr_seq_protocolo_exam_p,
											clock_timestamp(),
											nm_usuario_p,
											clock_timestamp(),
											nm_usuario_p,
											cd_pessoa_fisica_p);
											
	commit;
end if;

select 	max(nr_sequencia)
into STRICT 	nr_sequencia_w
from 	hd_protocolo_exame
where	cd_pessoa_fisica = cd_pessoa_fisica_p
order by nr_sequencia desc;


insert into hd_protocolo_medic_proc(nr_sequencia,
												dt_atualizacao,
												nm_usuario,
												dt_atualizacao_nrec,
												nm_usuario_nrec,
												nr_seq_proc,
												cd_protocolo,
												nr_seq_protocolo_exam)
									values (nr_sequencia_p,
											clock_timestamp(),
											nm_usuario_p,
											clock_timestamp(),
											nm_usuario_p,
											nr_seq_proc_p,
											cd_protocolo_p,
											nr_sequencia_w);
											
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_insert_protocol (nr_seq_proc_p bigint, cd_protocolo_p bigint, nr_seq_protocolo_exam_p bigint, nr_sequencia_p bigint, nm_usuario_p text, cd_pessoa_fisica_p text, NR_CONTROL_P bigint) FROM PUBLIC;

