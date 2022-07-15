-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajustar_liberacao_tiss_anexo ( nr_sequencia_p bigint, ie_opcao_p bigint, nm_usuario_p text) AS $body$
BEGIN

/*
	ie_opcao_p
	1 - Liberar de registro na tiss_anexo_guia
	2 - Liberar de registro na tiss_autor_anexo_diag
	3 - Desfazer liberação de registro na tiss_anexo_guia
	4 - Desfazer liberação de registro na tiss_autor_anexo_diag
*/
if (ie_opcao_p = 1) then
	update	tiss_anexo_guia
	set	dt_liberacao = clock_timestamp()
	where	nr_sequencia = nr_sequencia_p;
elsif (ie_opcao_p = 2) then
	update	tiss_autor_anexo_diag
	set	dt_liberacao = clock_timestamp(),
		nm_usuario_lib = nm_usuario_p
	where	nr_sequencia = nr_sequencia_p;
elsif (ie_opcao_p = 3) then
	update	tiss_anexo_guia
	set	dt_liberacao  = NULL
	where	nr_sequencia = nr_sequencia_p;
elsif (ie_opcao_p = 4) then
	update	tiss_autor_anexo_diag
	set	dt_liberacao  = NULL,
		nm_usuario_lib  = NULL
	where	nr_sequencia = nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajustar_liberacao_tiss_anexo ( nr_sequencia_p bigint, ie_opcao_p bigint, nm_usuario_p text) FROM PUBLIC;

