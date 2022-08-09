-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_liberacao_aval ( nr_sequencia_p bigint, ie_liberar_p text) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (ie_liberar_p IS NOT NULL AND ie_liberar_p::text <> '')then
	begin
	if (ie_liberar_p = 'S') then
		begin
		update	pessoa_fisica_avaliacao
		set	dt_liberacao = clock_timestamp()
		where	nr_sequencia = nr_sequencia_p;
		end;
	elsif (ie_liberar_p = 'N') then
		begin
		update	pessoa_fisica_avaliacao
		set	dt_liberacao  = NULL
		where	nr_sequencia = nr_sequencia_p;
		end;
	end if;
	commit;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_liberacao_aval ( nr_sequencia_p bigint, ie_liberar_p text) FROM PUBLIC;
