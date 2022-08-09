-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_doc_estornar_validacoes ( nm_usuario_p text, nr_seq_doc_p bigint) AS $body$
BEGIN

update	qua_doc_validacao
set		dt_validacao  = NULL,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
where	nr_seq_doc = nr_seq_doc_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_doc_estornar_validacoes ( nm_usuario_p text, nr_seq_doc_p bigint) FROM PUBLIC;
