-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE anmat_controle_mat_pck.enviar_arquivo_job ( nr_seq_arquivo_p controle_anmat_arquivo.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, minutes_p bigint) AS $body$
DECLARE


	command_w	varchar(32000);
	job_w		bigint;
	
	
BEGIN
	command_w := 'ANMAT_CONTROLE_MAT_PCK.ENVIAR_ARQUIVO('||nr_seq_arquivo_p||','''||nm_usuario_p||''');';

	job_p => job_w := anmat_controle_mat_pck.gerar_job(	command_p => command_w, nm_procedure_p => 'ANMAT_CONTROLE_MAT_PCK.ENVIAR_ARQUIVO()', minutes_p => minutes_p, job_p => job_w);

	update	controle_anmat_arquivo
	set	ie_status	= '1', -- Aguardando envio
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		nm_id_job	= job_w
	where	nr_sequencia	= nr_seq_arquivo_p;
	commit;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE anmat_controle_mat_pck.enviar_arquivo_job ( nr_seq_arquivo_p controle_anmat_arquivo.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, minutes_p bigint) FROM PUBLIC;