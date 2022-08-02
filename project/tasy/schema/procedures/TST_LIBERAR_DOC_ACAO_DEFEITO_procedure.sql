-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tst_liberar_doc_acao_defeito ( nr_sequencia_p bigint, ie_operacao_p text, nm_usuario_p text) AS $body$
BEGIN

update	TST_DOC_ACAO_DEFEITO
set	dt_liberacao	= CASE WHEN ie_operacao_p='L' THEN clock_timestamp() WHEN ie_operacao_p='E' THEN null END ,
	nm_usuario_lib	= CASE WHEN ie_operacao_p='L' THEN nm_usuario_p WHEN ie_operacao_p='E' THEN null END ,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tst_liberar_doc_acao_defeito ( nr_sequencia_p bigint, ie_operacao_p text, nm_usuario_p text) FROM PUBLIC;

