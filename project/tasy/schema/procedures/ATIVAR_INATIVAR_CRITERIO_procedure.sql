-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ativar_inativar_criterio ( ie_tabela_p text, ie_situacao_p text, nm_usuario_p text, nr_sequencia_p bigint) AS $body$
BEGIN

if (ie_tabela_p = 'P') then
	begin

	update	proc_criterio_repasse
	set	ie_situacao	= ie_situacao_p,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_sequencia_p;

	end;
elsif (ie_tabela_p = 'M') then
	begin

	update	mat_criterio_repasse
	set	ie_situacao	= ie_situacao_p,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_sequencia_p;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ativar_inativar_criterio ( ie_tabela_p text, ie_situacao_p text, nm_usuario_p text, nr_sequencia_p bigint) FROM PUBLIC;
