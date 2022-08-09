-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_pls_log_scs ( diretorio_p text, diretorio_backup_p text, nm_usuario_p text) AS $body$
BEGIN
if (diretorio_p IS NOT NULL AND diretorio_p::text <> '') and (diretorio_backup_p IS NOT NULL AND diretorio_backup_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	insert	into pls_log_scs(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		ds_diretorio_arquivo,
		ds_diretorio_backup,
		dt_processo,
		ie_backup)
	values (
		nextval('pls_log_scs_seq'),
		'TasySCS',
		clock_timestamp(),
		diretorio_p,
		diretorio_backup_p,
		clock_timestamp(),
		'N');
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_pls_log_scs ( diretorio_p text, diretorio_backup_p text, nm_usuario_p text) FROM PUBLIC;
