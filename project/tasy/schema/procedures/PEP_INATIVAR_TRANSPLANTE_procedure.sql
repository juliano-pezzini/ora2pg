-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_inativar_transplante ( nr_sequencia_p text, nm_usuario_p text) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '' AND nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

		update 	tx_liberacao_lista
		set	NM_USUARIO_INATIVACAO	= nm_usuario_p	,
			IE_SITUACAO		= 'I'		,
			DT_INATIVACAO		= clock_timestamp()
		where	nr_sequencia		= nr_sequencia_p;

end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_inativar_transplante ( nr_sequencia_p text, nm_usuario_p text) FROM PUBLIC;

