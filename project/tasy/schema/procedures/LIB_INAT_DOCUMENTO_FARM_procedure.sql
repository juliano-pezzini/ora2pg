-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lib_inat_documento_farm (nr_sequencia_p bigint, ie_acao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
BEGIN

if (coalesce(nr_sequencia_p,0) > 0) then
	if (ie_acao_p = 'L') then
		update	documento_farmacia
		set	dt_liberacao 		= clock_timestamp(),
			nm_usuario 		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_sequencia 		= nr_sequencia_p;
	elsif (ie_acao_p = 'I') then
		update	documento_farmacia
		set	dt_inativacao 		= clock_timestamp(),
			nm_usuario_inativacao 	= nm_usuario_p,
			ie_situacao		= 'I',
			dt_atualizacao		= clock_timestamp()
		where	nr_sequencia 		= nr_sequencia_p;
	end if;
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lib_inat_documento_farm (nr_sequencia_p bigint, ie_acao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
