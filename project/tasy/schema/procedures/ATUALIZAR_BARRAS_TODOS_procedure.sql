-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_barras_todos (ds_lista_p text, ie_selecionado_p text, nm_usuario_p text) AS $body$
BEGIN

if (coalesce(ds_lista_p, 'X') <> 'X') then
	begin
	update	banco_escrit_barras
	set	ie_selecionado	= coalesce(ie_selecionado_p, 'N'),
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia    in (ds_lista_p);

	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_barras_todos (ds_lista_p text, ie_selecionado_p text, nm_usuario_p text) FROM PUBLIC;

