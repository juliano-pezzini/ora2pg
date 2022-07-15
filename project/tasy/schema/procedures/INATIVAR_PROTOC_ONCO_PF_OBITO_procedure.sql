-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inativar_protoc_onco_pf_obito ( cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
BEGIN

update	paciente_setor
set	ie_status = 'I',
	dt_atualizacao = clock_timestamp(),
	nm_usuario = nm_usuario_p
where	cd_pessoa_fisica = cd_pessoa_fisica_p
and	ie_status = 'A';

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inativar_protoc_onco_pf_obito ( cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;

