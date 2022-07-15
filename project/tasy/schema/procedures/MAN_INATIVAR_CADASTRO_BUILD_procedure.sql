-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_inativar_cadastro_build ( nr_info_build_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_info_build_p IS NOT NULL AND nr_info_build_p::text <> '')	then

	update	MAN_OS_CTRL_DESC
	set	DT_INATIVACAO = clock_timestamp(),
		nm_usuario_inativ = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_info_build_p;

	commit;

end	if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_inativar_cadastro_build ( nr_info_build_p bigint, nm_usuario_p text) FROM PUBLIC;

