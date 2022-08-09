-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_estorna_valid_doc ( nr_sequencia_p bigint, ie_status_p text, nm_usuario_p text) AS $body$
BEGIN

update	qua_documento
set	dt_validacao  = NULL,
	ie_status    = ie_status_p
where	nr_sequencia = nr_sequencia_p;
commit;

update	qua_doc_validacao
set	dt_validacao  = NULL,
dt_atualizacao = clock_timestamp(),
nm_usuario = nm_usuario_p
where	nr_seq_doc = nr_sequencia_p
and (cd_pessoa_validacao = obter_pessoa_fisica_usuario(nm_usuario_p,'C')
    or cd_cargo = obter_cargo_pf(nm_usuario_p,'C'));
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_estorna_valid_doc ( nr_sequencia_p bigint, ie_status_p text, nm_usuario_p text) FROM PUBLIC;
