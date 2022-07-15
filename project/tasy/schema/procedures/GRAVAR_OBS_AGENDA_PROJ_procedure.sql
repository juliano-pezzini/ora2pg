-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_obs_agenda_proj ( nm_usuario_p text, ds_observacao_p text, nr_sequencia_p bigint, cd_consultor_p bigint) AS $body$
BEGIN
update	proj_agenda
set	ds_observacao	= ds_observacao_p
where	nr_sequencia	= nr_sequencia_p
and	cd_consultor	= cd_consultor_p
and	nm_usuario	= nm_usuario_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_obs_agenda_proj ( nm_usuario_p text, ds_observacao_p text, nr_sequencia_p bigint, cd_consultor_p bigint) FROM PUBLIC;

