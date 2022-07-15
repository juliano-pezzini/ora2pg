-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_documento_perfil (nr_sequencia_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_setor_p bigint) AS $body$
BEGIN

insert into qua_doc_lib(
	nr_sequencia,
	nr_seq_doc,
	dt_atualizacao,
	nm_usuario,
	cd_perfil,
	cd_setor_atendimento,
	nm_usuario_lib,
	ie_atualizacao)
SELECT	nextval('qua_doc_lib_seq'),
	nr_sequencia_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_perfil_p,
	cd_setor_p,
	null,
	'S'
;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_documento_perfil (nr_sequencia_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_setor_p bigint) FROM PUBLIC;

