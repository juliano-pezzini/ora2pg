-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE sncm_controle_mat_pck.reabrir_lote ( nr_seq_lote_p controle_mat_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN
	
	update	controle_mat_lote
	set	ie_status	= '9', -- Lote gerado
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		dt_fechamento	 = NULL,
		dt_ini_envio	 = NULL,
		dt_fim_envio	 = NULL
	where	nr_sequencia	= nr_seq_lote_p;
	commit;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sncm_controle_mat_pck.reabrir_lote ( nr_seq_lote_p controle_mat_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
