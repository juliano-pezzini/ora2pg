-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_arquivo_giss ( ds_arquivo_p text, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (coalesce(nr_sequencia_p,0) <> 0) then
	begin
	update	pls_lote_envio_giss
	set	ds_arquivo	= ds_arquivo_p,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_sequencia_p;
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_arquivo_giss ( ds_arquivo_p text, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
