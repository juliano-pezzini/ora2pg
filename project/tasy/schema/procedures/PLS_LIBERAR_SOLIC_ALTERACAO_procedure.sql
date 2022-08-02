-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_solic_alteracao ( nr_seq_solic_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN
update  tasy_solic_alt_campo
set 	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp(),	
	ie_status		= 'R'
where	nr_seq_solicitacao 	= nr_seq_solic_p
and	ie_status 		<> 'A';

update	tasy_solic_alteracao
set	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp(),
	dt_analise 	= clock_timestamp(),	
	ie_status	= 'L'
where	nr_sequencia	= nr_seq_solic_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_solic_alteracao ( nr_seq_solic_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

