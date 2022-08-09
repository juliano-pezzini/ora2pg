-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_responsavel_conta ( nr_interno_conta_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
BEGIN
 
update	conta_paciente 
set	cd_responsavel = cd_pessoa_fisica_p, 
	nm_usuario = nm_usuario_p, 
	dt_atualizacao = clock_timestamp() 
where	nr_interno_conta = nr_interno_conta_p 
and 	coalesce(cd_responsavel::text, '') = '';
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_responsavel_conta ( nr_interno_conta_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;
