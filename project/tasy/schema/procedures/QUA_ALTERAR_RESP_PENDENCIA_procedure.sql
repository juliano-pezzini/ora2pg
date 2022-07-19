-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_alterar_resp_pendencia ( nm_usuario_p text, nr_sequencia_p bigint, cd_pessoa_p text) AS $body$
BEGIN
update	proj_ata_pendencia 
set	cd_pessoa_resp	= cd_pessoa_p, 
	nm_usuario	= nm_usuario_p, 
	nm_pessoa_resp	= substr(obter_nome_pf(cd_pessoa_p),1,255) 
where	nr_sequencia	= nr_sequencia_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_alterar_resp_pendencia ( nm_usuario_p text, nr_sequencia_p bigint, cd_pessoa_p text) FROM PUBLIC;

