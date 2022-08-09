-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pcs_liberar_lista_tasy (nr_seq_lista_p bigint, ie_estornar_p text default 'N', nm_usuario_p text DEFAULT NULL) AS $body$
BEGIN
if (ie_estornar_p = 'N') then
	update	pcs_listas
	set 	dt_liberacao = clock_timestamp(),
		dt_atualizacao = clock_timestamp(),
		nm_usuario_lib = nm_usuario_p,
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_lista_p;
elsif (ie_estornar_p = 'S') then
	update	pcs_listas
	set 	dt_liberacao  = NULL,
		dt_atualizacao = clock_timestamp(),
		nm_usuario_lib  = NULL,
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_lista_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pcs_liberar_lista_tasy (nr_seq_lista_p bigint, ie_estornar_p text default 'N', nm_usuario_p text DEFAULT NULL) FROM PUBLIC;
