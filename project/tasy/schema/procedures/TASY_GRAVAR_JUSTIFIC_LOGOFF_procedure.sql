-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_gravar_justific_logoff ( NR_SEQUENCIA_ACESSO_P bigint, NR_SEQ_JUSTIFIC_P bigint, DS_JUSTIFICATIVA_P text) AS $body$
BEGIN
update	tasy_log_acesso
set	nr_seq_justific	= nr_seq_justific_p,
	ds_justificativa = ds_justificativa_p
where	nr_sequencia = nr_sequencia_acesso_p;

commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_gravar_justific_logoff ( NR_SEQUENCIA_ACESSO_P bigint, NR_SEQ_JUSTIFIC_P bigint, DS_JUSTIFICATIVA_P text) FROM PUBLIC;
