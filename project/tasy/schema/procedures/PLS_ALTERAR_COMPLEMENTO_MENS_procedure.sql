-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_complemento_mens ( nr_seq_mensalidade_p pls_mensalidade.nr_sequencia%type, ds_complemento_p pls_mensalidade.ds_complemento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

update	pls_mensalidade
set	ds_complemento  = substr(ds_complemento_p,1,4000),
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia = nr_seq_mensalidade_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_complemento_mens ( nr_seq_mensalidade_p pls_mensalidade.nr_sequencia%type, ds_complemento_p pls_mensalidade.ds_complemento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
