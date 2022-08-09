-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_dados_revisao_pf ( dt_revisao_p timestamp , nm_usuario_p text , cd_pessoa_fisica_p text ) AS $body$
BEGIN

if (dt_revisao_p IS NOT NULL AND dt_revisao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	begin
	update	pessoa_fisica
	set	dt_revisao		= dt_revisao_p ,
		nm_usuario_revisao		= nm_usuario_p
	where	cd_pessoa_fisica		= cd_pessoa_fisica_p;
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_dados_revisao_pf ( dt_revisao_p timestamp , nm_usuario_p text , cd_pessoa_fisica_p text ) FROM PUBLIC;
