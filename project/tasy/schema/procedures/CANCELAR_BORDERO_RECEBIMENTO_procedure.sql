-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_bordero_recebimento ( nr_bordero_p bigint, ie_opcao_p text, ie_commit_p text, nm_usuario_p text) AS $body$
DECLARE


/*ie_opcao_p
C = Cancelar
D = Desfazer cancelamento
*/
BEGIN

if (ie_opcao_p = 'C') then

	update 	bordero_recebimento
	set		dt_cancelamento 	= trunc(clock_timestamp()),
			dt_atualizacao 		= clock_timestamp(),
			nm_usuario 			= nm_usuario_p
	where 	nr_bordero 			= nr_bordero_p;


elsif (ie_opcao_p = 'D') then

	update 	bordero_recebimento
	set		dt_cancelamento 	 = NULL,
			dt_atualizacao 		= clock_timestamp(),
			nm_usuario 			= nm_usuario_p
	where 	nr_bordero 			= nr_bordero_p;

end if;

if ( coalesce(ie_commit_p,'S') = 'S' ) then

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_bordero_recebimento ( nr_bordero_p bigint, ie_opcao_p text, ie_commit_p text, nm_usuario_p text) FROM PUBLIC;
