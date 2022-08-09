-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_criar_lote ( cd_setor_atendimento_p bigint, nm_usuario_p text, nr_seq_lote_p INOUT bigint ) AS $body$
DECLARE


nr_seq_lote_w	lab_lote_exame.nr_sequencia%type;


BEGIN

select	nextval('lab_lote_exame_seq')
into STRICT	nr_seq_lote_w
;

insert into lab_lote_exame(
		NR_SEQUENCIA, 		DT_LOTE,
		DT_ATUALIZACAO, 	NM_USUARIO,
		NR_SEQ_GRUPO,		NR_SEQ_EXAME,
		DT_INICIAL,		DT_FINAL,
		NR_SEQ_GRUPO_IMP,	IE_TIPO_ATENDIMENTO,
		DT_GERACAO,		DS_LOTE,
		IE_LOTE,		IE_STATUS,
		DT_ATUALIZACAO_NREC,	NM_USUARIO_NREC,
		CD_SETOR_ATENDIMENTO,	NR_SEQ_MATERIAL)
values (	nr_seq_lote_w, 		clock_timestamp(),
		clock_timestamp(),		nm_usuario_p,
		null,			null,
		clock_timestamp(),		clock_timestamp(),
		null,			null,
		clock_timestamp(),		'Lote - ' || nr_seq_lote_w,
		'N',			'I',
		clock_timestamp(),		nm_usuario_p,
		cd_setor_atendimento_p,	null);

nr_seq_lote_p	:= nr_seq_lote_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_criar_lote ( cd_setor_atendimento_p bigint, nm_usuario_p text, nr_seq_lote_p INOUT bigint ) FROM PUBLIC;
