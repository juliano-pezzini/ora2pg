-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_hist_agenda ( NM_USUARIO_P text, NR_SEQ_AGENDA_P bigint, DS_HISTORICO_P text, CD_SETOR_ATEND_USUARIO_P bigint, CD_PESSOA_FISICA_P text, NM_TABELA_P text) AS $body$
BEGIN

if (NM_TABELA_P = 'AGENDA_CONS_HIST') then
	insert into AGENDA_CONS_HIST(
		NR_SEQUENCIA, NR_SEQ_AGENDA, DS_HISTORICO,
		DT_ATUALIZACAO, NM_USUARIO, DT_HISTORICO,
		CD_PESSOA_FISICA, DT_LIBERACAO, CD_SETOR_ATEND_USUARIO,
		IE_PRIORIDADE, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC,
		IE_SITUACAO, DT_INATIVACAO, NM_USUARIO_INATIVACAO,
		NR_SEQ_TIPO_HIST)
	values (nextval('agenda_cons_hist_seq'), NR_SEQ_AGENDA_P, DS_HISTORICO_P,
		clock_timestamp(), NM_USUARIO_P, clock_timestamp(), CD_PESSOA_FISICA_P,
		clock_timestamp(), CD_SETOR_ATEND_USUARIO_P, '',
		clock_timestamp(), NM_USUARIO_P, 'A', null, '', null);

elsif (NM_TABELA_P = 'AGENDA_PAC_HIST') then
	insert into AGENDA_PAC_HIST(
		NR_SEQUENCIA, NR_SEQ_AGENDA, DS_HISTORICO_OLD,
		DT_ATUALIZACAO, NM_USUARIO, DT_HISTORICO,
		CD_PESSOA_FISICA, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC,
		DT_LIBERACAO, CD_SETOR_ATEND_USUARIO, IE_PRIORIDADE,
		NR_SEQ_TIPO, DS_HISTORICO, IE_SITUACAO,
		DT_INATIVACAO, NM_USUARIO_INATIVACAO)
	values (nextval('agenda_pac_hist_seq'), NR_SEQ_AGENDA_P,'',
		clock_timestamp(), NM_USUARIO_P, clock_timestamp(),
		CD_PESSOA_FISICA_P, clock_timestamp(), NM_USUARIO_P,
		null, CD_SETOR_ATEND_USUARIO_P, '',
		null, DS_HISTORICO_P, '',
		null, '');

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_hist_agenda ( NM_USUARIO_P text, NR_SEQ_AGENDA_P bigint, DS_HISTORICO_P text, CD_SETOR_ATEND_USUARIO_P bigint, CD_PESSOA_FISICA_P text, NM_TABELA_P text) FROM PUBLIC;

