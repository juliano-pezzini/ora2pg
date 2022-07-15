-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_liberar_cenario ( nr_seq_cenario_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	ctb_orc_cenario
set	dt_liberacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_cenario_p;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_liberar_cenario ( nr_seq_cenario_p bigint, nm_usuario_p text) FROM PUBLIC;

