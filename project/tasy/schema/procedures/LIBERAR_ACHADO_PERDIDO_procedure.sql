-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_achado_perdido ( nr_sequencia_p bigint, nm_usuario_p text, ie_opcao_p text) AS $body$
BEGIN

if (nr_sequencia_p > 0) then
	begin
	update	atend_achado_perdido
	set	dt_liberacao = CASE WHEN ie_opcao_p='L' THEN  clock_timestamp() WHEN ie_opcao_p='D' THEN  null END ,
		nm_usuario_lib = CASE WHEN ie_opcao_p='L' THEN  nm_usuario_p WHEN ie_opcao_p='D' THEN  '' END ,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_sequencia_p;

	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_achado_perdido ( nr_sequencia_p bigint, nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;
