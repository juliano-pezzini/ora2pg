-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_status_descart_intpd ( nr_sequencia_p bigint, ie_status_p text, nm_usuario_p text, ie_commit_p text default 'S') AS $body$
BEGIN
if (coalesce(nr_sequencia_p,0) > 0) then
	update	intpd_fila_transmissao
	set	dt_atualizacao	= clock_timestamp(),
		nm_usuario = nm_usuario_p,
		ie_status = ie_status_p
	where	nr_sequencia	= nr_sequencia_p
	and	ie_status in ('E','D');	
	
end if;

if ('S' = coalesce(ie_commit_p, 'S')) then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_status_descart_intpd ( nr_sequencia_p bigint, ie_status_p text, nm_usuario_p text, ie_commit_p text default 'S') FROM PUBLIC;

