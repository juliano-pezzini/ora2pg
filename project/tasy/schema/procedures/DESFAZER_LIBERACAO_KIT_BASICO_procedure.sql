-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_liberacao_kit_basico ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN
	if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
		update	kit_estoque_reg
		set	nm_usuario_lib  = NULL,
			dt_liberacao  = NULL
		where	nr_sequencia = nr_sequencia_p;
		commit;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_liberacao_kit_basico ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

