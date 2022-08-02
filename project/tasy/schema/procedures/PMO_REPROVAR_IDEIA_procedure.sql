-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pmo_reprovar_ideia ( nr_seq_pmo_proj_ideias_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_pmo_proj_ideias_w 	pmo_proj_ideias.nr_sequencia%type;


BEGIN

	update	pmo_proj_ideias
	set	nm_usuario 		= nm_usuario_p,
		dt_atualizacao 		= clock_timestamp(),
		dt_reprovacao		= clock_timestamp()
	where	nr_sequencia 		= nr_seq_pmo_proj_ideias_p;

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pmo_reprovar_ideia ( nr_seq_pmo_proj_ideias_p bigint, nm_usuario_p text) FROM PUBLIC;

