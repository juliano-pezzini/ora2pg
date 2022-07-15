-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_auditoria_situacao ( nr_prescricao_p bigint, nr_seq_prescricao_p bigint, nm_usuario_p text, nr_seq_situacao_p text ) AS $body$
DECLARE


nr_sequencia_w bigint;


BEGIN

select nextval('situacao_procedimento_log_seq')
into STRICT nr_sequencia_w
;
insert into SITUACAO_PROCEDIMENTO_LOG(
	NR_SEQUENCIA,
	DT_ATUALIZACAO,
	DT_ATUALIZACAO_NREC,
	NM_USUARIO,
	NM_USUARIO_NREC,
	NR_PRESCRICAO,
	NR_SEQ_PRESCRICAO,
	NR_SEQ_SITUACAO
)
values (
	nextval('situacao_procedimento_log_seq'),
	clock_timestamp(),
	clock_timestamp(),
	nm_usuario_p,
	nm_usuario_p,
	nr_prescricao_p,
	nr_seq_prescricao_p,
	nr_seq_situacao_p
);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_auditoria_situacao ( nr_prescricao_p bigint, nr_seq_prescricao_p bigint, nm_usuario_p text, nr_seq_situacao_p text ) FROM PUBLIC;

