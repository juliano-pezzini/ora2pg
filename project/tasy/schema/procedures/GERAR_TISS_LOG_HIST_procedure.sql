-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_tiss_log_hist (NR_SEQUENCIA_p bigint, NR_SEQ_LOG_p bigint, NM_USUARIO_p text, DS_HISTORICO_p text) AS $body$
BEGIN

insert into TISS_LOG_HIST(NR_SEQUENCIA,
	NR_SEQ_LOG,
	DT_ATUALIZACAO,
	NM_USUARIO,
	DT_ATUALIZACAO_NREC,
	NM_USUARIO_NREC,
	DS_HISTORICO)
values (coalesce(NR_SEQUENCIA_p, nextval('tiss_log_hist_seq')),
	NR_SEQ_LOG_p,
	clock_timestamp(),
	NM_USUARIO_p,
	clock_timestamp(),
	NM_USUARIO_p,
	DS_HISTORICO_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_tiss_log_hist (NR_SEQUENCIA_p bigint, NR_SEQ_LOG_p bigint, NM_USUARIO_p text, DS_HISTORICO_p text) FROM PUBLIC;

